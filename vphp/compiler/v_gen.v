module compiler

import strings

pub struct VGenerator {
pub:
    ext_name string
}

fn (g VGenerator) generate(mut elements []PhpRepr) string {
    mut out := strings.new_builder(2048)
    out.write_string('module main\n\nimport vphp\nimport time\nimport json\n\n')
    
    mut task_registrations := []string{}
    // 生成每个 repr 的 V 胶水
    for mut el in elements {
        if mut el is PhpFuncRepr {
            out.write_string(g.gen_func_glue(el).join('\n') + '\n\n')
        } else if mut el is PhpClassRepr {
            out.write_string(g.gen_class_glue(el).join('\n') + '\n\n')
        } else if mut el is PhpTaskRepr {
            task_registrations << g.gen_task_registration(el)
        }
    }

    // 如果捕获到任何 Task，自动生成全局初始化注册函数
    if task_registrations.len > 0 {
        out.write_string("@[export: 'vphp_ext_startup']\n")
        out.write_string("fn vphp_ext_startup() {\n")
        out.write_string(task_registrations.join('\n\n'))
        out.write_string("\n}\n")
    }
    
    return out.str()
}

// ---- Func V Glue ----
fn (g VGenerator) gen_func_glue(f &PhpFuncRepr) []string {
    mut out := []string{}
    
    // 基础包装器
    out << "@[export: 'vphp_wrap_${f.name}']"
    out << "fn vphp_wrap_${f.name}(ctx vphp.Context) {"
    
    mut arg_names := []string{}
    for i, arg in f.args {
        var_name := 'arg_${i}'
        // 如果是 Context 类型，直接传递
        if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
            out << "    ${var_name} := ctx"
        } else {
            out << "    ${var_name} := ctx.arg[${arg.v_type}](${i})"
        }
        arg_names << var_name
    }
    
    call_args := arg_names.join(', ')
    // 注意：如果是导出到 PHP 的函数，其原始名可能由 r.name (符号名) 或 r.original_name (V 名) 提供
    // 这里统一使用原始 V 名来调用
    v_func_name := if f.original_name != '' { f.original_name } else { f.name }
    v_call_name := if is_v_keyword(v_func_name) { '@' + v_func_name } else { v_func_name }
    
    if f.return_type == 'void' {
        out << "    ${v_call_name}(${call_args})"
    } else {
        out << "    res := ${v_call_name}(${call_args})"
        out << "    ctx.return_val[${f.return_type}](res)"
    }
    out << "}"
    
    return out
}

// ---- Class V Glue ----
fn (g VGenerator) gen_class_glue(r &PhpClassRepr) []string {
    mut out := []string{}
    lower_name := r.name.to_lower()

    // A. 堆分配器
    out << "@[export: '${r.name}_new_raw']"
    out << "pub fn ${lower_name}_new_raw() voidptr {"
    out << "    return vphp.generic_new_raw[${r.name}]()"
    out << "}"

    // B. 属性读取
    out << "@[export: '${r.name}_get_prop']"
    out << "pub fn ${lower_name}_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {"
    out << "    vphp.generic_get_prop[${r.name}](ptr, name_ptr, name_len, rv)"
    out << "}"

    // C. 属性写入
    out << "@[export: '${r.name}_set_prop']"
    out << "pub fn ${lower_name}_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {"
    out << "    vphp.generic_set_prop[${r.name}](ptr, name_ptr, name_len, value)"
    out << "}"

    // D. 同步器
    out << "@[export: '${r.name}_sync_props']"
    out << "pub fn ${lower_name}_sync_props(ptr voidptr, zv &C.zval) {"
    out << "    vphp.generic_sync_props[${r.name}](ptr, zv)"
    out << "}"

    // E. 方法的胶水包装
    for m in r.methods {
        if m.has_export { continue }

        out << "@[export: 'vphp_wrap_${r.name}_${m.name}']"
        
        is_factory := m.name == 'init' || (m.is_static && m.return_type.ends_with(r.name))
        ret_decl := if is_factory { "voidptr" } else { "" }
        
        if m.is_static {
            out << "pub fn vphp_wrap_${lower_name}_${m.name}(ctx vphp.Context) ${ret_decl} {"
        } else {
            out << "pub fn vphp_wrap_${lower_name}_${m.name}(ptr voidptr, ctx vphp.Context) ${ret_decl} {"
            out << "    mut recv := unsafe { &${r.name}(ptr) }"
        }

        mut arg_names := []string{}
        for i, arg in m.args {
            var_name := 'arg_${i}'
            if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
                out << "    ${var_name} := ctx"
            } else {
                out << "    ${var_name} := ctx.arg[${arg.v_type}](${i})"
            }
            arg_names << var_name
        }

        call_args := arg_names.join(', ')
        v_name := if m.v_name != '' { m.v_name } else { m.name }
        v_call_name := if is_v_keyword(v_name) { '@' + v_name } else { v_name }

        call_str := if m.is_static {
            "${r.name}.${v_call_name}(${call_args})"
        } else {
            "recv.${v_call_name}(${call_args})"
        }

        if m.return_type == 'void' {
            out << "    ${call_str}"
        } else {
            out << "    res := ${call_str}"
            if !is_factory {
                out << "    ctx.return_val[${m.return_type}](res)"
            }
        }
        
        if is_factory {
            if m.return_type == 'void' {
                 out << "    return voidptr(recv)"
            } else {
                 out << "    return voidptr(res)"
            }
        }
        out << "}"
    }

    // F. Handlers 导出
    out << "@[export: '${r.name}_handlers']"
    out << "pub fn ${lower_name}_handlers() voidptr {"
    out << "    return unsafe { &C.vphp_class_handlers{"
    out << "        prop_handler:  voidptr(${lower_name}_get_prop)"
    out << "        write_handler: voidptr(${lower_name}_set_prop)"
    out << "        sync_handler:  voidptr(${lower_name}_sync_props)"
    out << "        new_raw:       voidptr(${lower_name}_new_raw)"
    out << "    } }"
    out << "}"

    return out
}

// 检查是否为 V 关键字，如果是，则调用时需要加 @ 前缀
fn is_v_keyword(name string) bool {
	keywords := [
		'as', 'asm', 'assert', 'atomic', 'break', 'chan', 'const', 'continue',
		'defer', 'else', 'enum', 'false', 'fn', 'for', 'go', 'goto', 'if',
		'import', 'in', 'interface', 'is', 'isreftype', 'lock', 'match',
		'module', 'mut', 'nil', 'none', 'or', 'pub', 'return', 'rlock',
		'select', 'shared', 'sizeof', 'struct', 'true', 'type', 'typeof',
		'union', 'unsafe', 'volatile', '__global', '__offsetof', 'spawn'
	]
	return name in keywords
}

// ---- Task Auto-Registration Glue ----
fn (g VGenerator) gen_task_registration(t &PhpTaskRepr) string {
    mut out := []string{}
    
    out << "    vphp.ITask.register('${t.task_name}', fn (ctx vphp.Context) vphp.ITask {"
    out << "        return ${t.v_name}{"
    
    for i, param in t.parameters {
        // 参数索引从 1 开始，因为 ctx.arg[0] 被占用来传任务名称了
        arg_index := i + 1
        out << "            ${param.name}: ctx.arg[${param.v_type}](${arg_index})"
    }
    
    out << "        }"
    out << "    })"
    return out.join('\n')
}
