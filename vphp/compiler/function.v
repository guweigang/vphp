module compiler

import v.ast

pub struct PhpFuncRepr {
pub mut:
	name            string
	original_name   string // 如果用了 @[php_function]，这是原有的 v 函数名
	return_type     string // V 返回类型：'void', 'int', 'i64', 'bool', 'string', 'f64', 'map[string]string' 等
	args            []PhpArg
	is_internal     bool
	uses_php_function bool // 如果是纯业务逻辑 (使用了 @[php_function])
}

pub fn new_func_repr() &PhpFuncRepr {
	return &PhpFuncRepr{}
}

// 实现接口
fn (mut r PhpFuncRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.FnDecl {
		if stmt.is_method {
			return false
		}

		mut has_export := false
		mut exp_name := ''
		mut has_php_func := false

		for attr in stmt.attrs {
			if attr.name == 'export' && attr.arg != '' {
				has_export = true
				exp_name = attr.arg
			} else if attr.name == 'php_function' {
				has_php_func = true
			}
		}

		if !has_export && !has_php_func {
			return false
		}

		if exp_name.starts_with('vphp_') || exp_name.starts_with('zm_') {
			return false
		}

		r.name = if exp_name != '' { exp_name } else { stmt.name.all_after('.') }
		r.original_name = stmt.name.all_after('.')
		r.uses_php_function = has_php_func

		// 解析参数
		for param in stmt.params {
			mut typ_name := table.get_type_name(param.typ)
			if typ_name.contains('.') { typ_name = typ_name.all_after('.') }
			r.args << PhpArg{
				name: param.name
				v_type: typ_name
			}
		}

		// 解析返回类型
		ret_type := table.get_type_name(stmt.return_type)
		clean := if ret_type.contains('.') { ret_type.all_after('.') } else { ret_type }
		
		if clean == 'Context' || clean == '' || clean == 'void' {
			r.return_type = 'void'
		} else {
			r.return_type = clean
		}

		return true
	}
	return false
}

fn (r PhpFuncRepr) gen_h() []string {
    return [
        'PHP_FUNCTION(${r.name});'
    ]
}

fn (f PhpFuncRepr) gen_c() []string {
    mut r := []string{}
    r << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${f.name}, 0, 0, 0)'
    r << 'ZEND_END_ARG_INFO()'

    tm := TypeMap.get_type(f.return_type)
    
    // 如果使用了纯业务逻辑 @[php_function]，我们调用的是编译器生成的包装函数
    target_func := if f.uses_php_function { 'vphp_wrap_${f.name}' } else { f.name }

    if tm.v_type == 'void' {
        // void 函数：用户通过 ctx.return_xxx() 手动设置返回值
        r << 'extern void ${target_func}(vphp_context_internal ctx);'
        r << 'PHP_FUNCTION(${f.name}) {'
        r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
        r << '    ${target_func}(ctx);'
        r << '}'
    } else if !f.uses_php_function && tm.v_type == 'string' {
        // string 特殊处理：V 返回 v_string 结构体，用 RETVAL_STRINGL 转为 PHP 字符串
        r << 'extern v_string ${target_func}(vphp_context_internal ctx);'
        r << 'PHP_FUNCTION(${f.name}) {'
        r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
        r << '    v_string res = ${target_func}(ctx);'
        r << '    RETVAL_STRINGL((char*)res.str, res.len);'
        r << '}'
    } else if !f.uses_php_function {
        // 标量类型：C 包装器接收返回值并自动转换
        r << 'extern ${tm.c_type} ${target_func}(vphp_context_internal ctx);'
        r << 'PHP_FUNCTION(${f.name}) {'
        r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
        r << '    ${tm.c_type} res = ${target_func}(ctx);'
        r << '    ${tm.php_return}(res);'
        r << '}'
    } else {
        // 如果是 uses_php_function 且带返回值（包括复合类型），统一在 v_glue 侧通过 ctx 处理，所以 C 侧视其为 void 处理！
        r << 'extern void ${target_func}(vphp_context_internal ctx);'
        r << 'PHP_FUNCTION(${f.name}) {'
        r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
        r << '    ${target_func}(ctx);'
        r << '}'
    }
    return r
}

fn (r PhpFuncRepr) gen_minit() []string {
	return []string{}
}

fn (f PhpFuncRepr) gen_v_glue() []string {
    if !f.uses_php_function {
        return []string{}
    }

	mut v := []string{}
    v << '@[export: "vphp_wrap_${f.name}"]'
    v << 'fn vphp_wrap_${f.name}(ctx vphp.Context) {'
    
    mut arg_names := []string{}
    // 解包参数
    for i, arg in f.args {
        var_name := 'arg_${i}'
        // 对 Context 透明放行
        if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
            v << '    ${var_name} := ctx'
        } else {
            v << '    ${var_name} := ctx.arg[${arg.v_type}](${i})'
        }
        arg_names << var_name
    }
    
    // 调用原始函数
    call_str := '${f.original_name}(${arg_names.join(', ')})'
    
    if f.return_type == 'void' {
        v << '    ${call_str}'
    } else {
        v << '    res := ${call_str}'
        // 利用泛型装箱返回值
        v << '    ctx.return_val[${f.return_type}](res)'
    }
    
    v << '}'
    return v
}
