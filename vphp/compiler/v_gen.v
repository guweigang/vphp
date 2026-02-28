module compiler

pub struct VGenerator {
pub:
    ext_name string
}

pub fn (g VGenerator) generate(mut elements []PhpRepr) string {
    mut v := []string{}
    v << 'module main\nimport vphp\n'
    v << '@[export: "vphp_task_auto_startup"]\nfn vphp_task_auto_startup() {'
    
    // 1. Task register
    for mut el in elements {
        if mut el is PhpTaskRepr {
            task := el
            v << g.gen_task_glue(task)
        }
    }
    v << '}'

    // 2. Class, Func wrapper
    for mut el in elements {
        if mut el is PhpClassRepr {
            cls := el
            glue_lines := g.gen_class_glue(cls)
            if glue_lines.len > 0 {
                v << glue_lines.join('\n')
                v << ''
            }
        } else if mut el is PhpFuncRepr {
            func := el
            glue_lines := g.gen_func_glue(func)
            if glue_lines.len > 0 {
                v << glue_lines.join('\n')
                v << ''
            }
        }
    }
    return v.join('\n')
}

// ---- Task V Glue ----
fn (g VGenerator) gen_task_glue(r &PhpTaskRepr) string {
    return "    vphp.ITask.register('${r.task_name}', fn(s string) vphp.ITask { return ${r.task_name}{ json_data: s } })"
}

// ---- Func V Glue ----
fn (g VGenerator) gen_func_glue(f &PhpFuncRepr) []string {
    if !f.uses_php_function {
        return []string{}
    }

    mut v := []string{}
    v << '@[export: "vphp_wrap_${f.name}"]'
    v << 'fn vphp_wrap_${f.name}(ctx vphp.Context) {'
    
    mut arg_names := []string{}
    for i, arg in f.args {
        var_name := 'arg_${i}'
        if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
            v << '    ${var_name} := ctx'
        } else {
            v << '    ${var_name} := ctx.arg[${arg.v_type}](${i})'
        }
        arg_names << var_name
    }
    
    call_str := '${f.original_name}(${arg_names.join(', ')})'
    
    if f.return_type == 'void' {
        v << '    ${call_str}'
    } else {
        v << '    res := ${call_str}'
        v << '    ctx.return_val[${f.return_type}](res)'
    }
    
    v << '}'
    return v
}

// ---- Class V Glue ----
fn (g VGenerator) gen_class_glue(r &PhpClassRepr) []string {
    mut out := []string{}
    lower_name := r.name.to_lower()

    // A. 堆分配器 — 单行泛型转发
    out << "@[export: '${r.name}_new_raw']"
    out << "pub fn ${lower_name}_new_raw() voidptr {"
    out << "    return vphp.generic_new_raw[${r.name}]()"
    out << "}"

    // B. 属性读取 — 单行泛型转发
    out << "@[export: '${r.name}_get_prop']"
    out << "pub fn ${lower_name}_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {"
    out << "    vphp.generic_get_prop[${r.name}](ptr, name_ptr, name_len, rv)"
    out << "}"

    // C. 属性写入 — 单行泛型转发
    out << "@[export: '${r.name}_set_prop']"
    out << "pub fn ${lower_name}_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {"
    out << "    vphp.generic_set_prop[${r.name}](ptr, name_ptr, name_len, value)"
    out << "}"

    // D. 同步器 — 单行泛型转发
    out << "@[export: '${r.name}_sync_props']"
    out << "pub fn ${lower_name}_sync_props(ptr voidptr, zv &C.zval) {"
    out << "    vphp.generic_sync_props[${r.name}](ptr, zv)"
    out << "}"

    // E. 方法的胶水包装 (纯业务方法)
    for m in r.methods {
        if m.has_export { continue } // 如果带了 export 走原始路线

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
        call_str := if m.is_static {
            "${r.name}.${m.name}(${call_args})"
        } else {
            "recv.${m.name}(${call_args})"
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

    // F. Handler 聚合器 — 供 C 侧一次性获取所有 handler
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
