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

	attrs := parse_callable_attrs(fn_decl.attrs, 'php_function', '')

	if !attrs.has_php_callable {
		return none
	}
	if attrs.php_name.starts_with('vphp_') || attrs.php_name.starts_with('zm_') {
		return none
	}

	func.name = if attrs.php_name != '' { attrs.php_name } else { fn_decl.name.all_after('.') }
	func.original_name = fn_decl.name.all_after('.')
	func.args = build_php_args(fn_decl.params, table, 0, attrs.php_arg_types, attrs.php_optional_args)

	ret_type := strip_module(table.type_to_str(fn_decl.return_type))
	v_return_type := if ret_type == 'Context' || ret_type == '' || ret_type == 'void' {
		'void'
	} else {
		ret_type
	}
	func.return_spec = repr.new_return_spec(v_return_type, attrs.php_return_type)
	func.has_export = attrs.has_export

	return func
}
