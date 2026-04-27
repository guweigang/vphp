module parser

import v.ast
import compiler.repr

pub fn parse_function_decl(stmt ast.Stmt, table &ast.Table, params_structs map[string]repr.PhpParamsStruct) ?&repr.PhpFuncRepr {
	if stmt !is ast.FnDecl {
		return none
	}
	fn_decl := stmt as ast.FnDecl
	if fn_decl.attrs.any(it.name == 'php_ignore') {
		return none
	}
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
	func.args = build_php_args(fn_decl.params, table, 0, attrs.php_arg_types, attrs.php_arg_names,
		attrs.php_arg_optional, attrs.php_arg_defaults, params_structs)
	func.uses_context = func.args.len == 1 && is_context_type(func.args[0].v_type)

	ret_type := strip_module(table.type_to_str(fn_decl.return_type))
	v_return_type := if is_context_type(ret_type) || ret_type == '' || ret_type == 'void' {
		'void'
	} else {
		ret_type
	}
	func.return_spec = repr.new_return_repr(v_return_type, attrs.php_return_type)
	func.has_export = attrs.has_export

	return func
}
