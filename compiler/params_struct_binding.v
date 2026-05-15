module compiler

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
	read := binding.read()
	value_expr := read.direct_expr() or { read.v_expr() }
	default_expr := binding.arg.source.params_v_default
	if semantic_lines := read.semantic_or_default_lines(binding.var_name, default_expr, returns_voidptr) {
		return semantic_lines
	}
	return [
		'    ${binding.var_name} := if ${read.has_arg_expr()} { ${value_expr} } else { ${default_expr} }',
	]
}

fn (binding ParamsStructFieldBinding) read() PhpArgRead {
	return PhpArgRead.new(binding.arg, binding.index)
}
