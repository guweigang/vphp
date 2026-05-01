module compiler

import compiler.php_types
import compiler.repr

struct ParamsStructBinding {
	var_name    string
	params_type string
	fields      []repr.PhpArgRepr
	php_index   int
}

struct ParamsStructFieldBinding {
	arg      repr.PhpArgRepr
	var_name string
	index    int
}

fn ParamsStructBinding.new(var_name string, params_type string, fields []repr.PhpArgRepr, php_index int) ParamsStructBinding {
	return ParamsStructBinding{
		var_name:    var_name
		params_type: params_type
		fields:      fields
		php_index:   php_index
	}
}

fn (binding ParamsStructBinding) call_name() string {
	return binding.var_name
}

fn (binding ParamsStructBinding) render_lines(returns_voidptr bool) []string {
	mut lines := []string{}
	mut field_vars := []string{}
	for offset, field_arg in binding.fields {
		php_index := binding.php_index + offset
		field_var := '${binding.var_name}_${field_arg.source.params_field}'
		field_binding := ParamsStructFieldBinding.new(field_arg, field_var, php_index)
		field_vars << field_var
		lines << field_binding.render_lines(returns_voidptr)
	}
	lines << '    ${binding.var_name} := ${binding.params_type}{'
	for offset, field_arg in binding.fields {
		lines << '        ${field_arg.source.params_field}: ${field_vars[offset]}'
	}
	lines << '    }'
	return lines
}

fn ParamsStructFieldBinding.new(arg repr.PhpArgRepr, var_name string, index int) ParamsStructFieldBinding {
	return ParamsStructFieldBinding{
		arg:      arg
		var_name: var_name
		index:    index
	}
}

fn (binding ParamsStructFieldBinding) render_lines(returns_voidptr bool) []string {
	value_expr := binding.value_expr()
	default_expr := binding.arg.source.params_v_default
	if semantic_lines := binding.render_semantic_lines(default_expr, returns_voidptr) {
		return semantic_lines
	}
	return [
		'    ${binding.var_name} := if php_args.has_named_or_index(${binding.index}, ${binding.arg_name_literal()}) { ${value_expr} } else { ${default_expr} }',
	]
}

fn (binding ParamsStructFieldBinding) render_semantic_lines(default_expr string, returns_voidptr bool) ?[]string {
	spec := php_types.PhpTypeSpec.semantic_wrapper_for(binding.arg.v_type) or { return none }
	if spec.is_total_arg {
		return none
	}
	mut lines := []string{}
	lines << '    ${binding.var_name} := if php_args.has_named_or_index(${binding.index}, ${binding.arg_name_literal()}) {'
	lines << '        ${binding.arg_expr()}.${spec.arg_method}() or {'
	lines << "            vphp.throw_exception('argument ${binding.index} must be ${spec.arg_label}', 0)"
	lines << '            ${arg_return_stmt(returns_voidptr)}'
	lines << '        }'
	lines << '    } else {'
	lines << '        ${default_expr}'
	lines << '    }'
	return lines
}

fn (binding ParamsStructFieldBinding) arg_name_literal() string {
	return v_single_quote(binding.arg.name)
}

fn (binding ParamsStructFieldBinding) arg_expr() string {
	return 'php_args.at_named_or_index(${binding.index}, ${binding.arg_name_literal()})'
}

fn (binding ParamsStructFieldBinding) value_expr() string {
	arg_expr := binding.arg_expr()
	if binding.arg.v_type == 'vphp.ZVal' || binding.arg.v_type == 'ZVal' {
		return '${arg_expr}.zval()'
	}
	if binding.arg.v_type == 'RequestBorrowedZBox'
		|| binding.arg.v_type == 'vphp.RequestBorrowedZBox' {
		return '${arg_expr}.zbox()'
	}
	if binding.arg.v_type == 'RequestOwnedZBox' || binding.arg.v_type == 'vphp.RequestOwnedZBox' {
		return '${arg_expr}.request_owned_zbox()'
	}
	if binding.arg.v_type == '?RequestBorrowedZBox'
		|| binding.arg.v_type == '?vphp.RequestBorrowedZBox' {
		return '${arg_expr}.zbox_opt()'
	}
	if binding.arg.v_type.starts_with('?') {
		return '${arg_expr}.as_v_opt[${binding.arg.v_type[1..]}]()'
	}
	return '${arg_expr}.as_v[${binding.arg.v_type}]()'
}
