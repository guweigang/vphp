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


