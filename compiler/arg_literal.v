module compiler

import compiler.repr

fn v_single_quote(s string) string {
	return "'" + s.replace('\\', '\\\\').replace("'", "\\'") + "'"
}

fn php_attribute_arg_literal(arg repr.PhpAttributeArg) string {
	if arg.name != '' {
		return php_named_attribute_arg_literal(arg)
	}
	return php_positional_attribute_arg_literal(arg)
}

fn php_positional_attribute_arg_literal(arg repr.PhpAttributeArg) string {
	return match arg.kind {
		'string' { 'string(${v_single_quote(arg.value)})' }
		'bool' { 'bool_value(${arg.value})' }
		'null' { 'null_value()' }
		'float' { 'f64(${arg.value})' }
		'int' { 'i64(${arg.value})' }
		else { 'string(${v_single_quote(arg.value)})' }
	}
}

fn php_named_attribute_arg_literal(arg repr.PhpAttributeArg) string {
	return match arg.kind {
		'string' { 'named_string(${v_single_quote(arg.name)}, ${v_single_quote(arg.value)})' }
		'bool' { 'named_bool(${v_single_quote(arg.name)}, ${arg.value})' }
		'null' { 'named_null(${v_single_quote(arg.name)})' }
		'float' { 'named_f64(${v_single_quote(arg.name)}, ${arg.value})' }
		'int' { 'named_i64(${v_single_quote(arg.name)}, ${arg.value})' }
		else { 'named_string(${v_single_quote(arg.name)}, ${v_single_quote(arg.value)})' }
	}
}

fn php_attribute_literal(attr repr.PhpAttributeRepr) string {
	mut out := 'vphp.PhpAttribute.named(${v_single_quote(attr.name)}).for_parameter()'
	for arg in attr.args {
		out += '.${php_attribute_arg_literal(arg)}'
	}
	return out
}

fn php_attributes_literal(attrs []repr.PhpAttributeRepr) string {
	if attrs.len == 0 {
		return '[]vphp.PhpAttribute{}'
	}
	return '[' + attrs.map(php_attribute_literal(it)).join(', ') + ']'
}
