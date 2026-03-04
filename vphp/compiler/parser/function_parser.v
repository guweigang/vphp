module parser

import v.ast
import compiler.repr

pub fn parse_function_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpFuncRepr {
	if stmt !is ast.FnDecl {
		return none
	}
	fn_decl := stmt as ast.FnDecl
	mut func := repr.new_func_repr()
	if fn_decl.is_method {
		return none
	}

	mut has_php_func := false
	mut php_name := ''

	for attr in fn_decl.attrs {
		if attr.name == 'php_function' {
			has_php_func = true
			if attr.arg != '' {
				php_name = attr.arg
			}
		}
	}

	if !has_php_func {
		return none
	}
	if php_name.starts_with('vphp_') || php_name.starts_with('zm_') {
		return none
	}

	func.name = if php_name != '' { php_name } else { fn_decl.name.all_after('.') }
	func.original_name = fn_decl.name.all_after('.')

	for param in fn_decl.params {
		mut typ_name := table.get_type_name(param.typ)
		if typ_name.contains('.') {
			typ_name = typ_name.all_after('.')
		}
		func.args << repr.PhpArg{
			name: param.name
			v_type: typ_name
		}
	}

	ret_type := table.get_type_name(fn_decl.return_type)
	clean := if ret_type.contains('.') { ret_type.all_after('.') } else { ret_type }
	func.return_type = if clean == 'Context' || clean == '' || clean == 'void' { 'void' } else { clean }

	return func
}
