module parser

import v.ast
import compiler.repr

struct ParsedCallableAttrs {
mut:
	has_export        bool
	has_php_callable  bool
	php_name          string
	php_arg_types     map[string]string
	php_return_type   string
	php_optional_args map[string]bool
	borrowed_return   bool
	is_abstract       bool
}

fn parse_callable_attrs(attrs []ast.Attr, callable_attr_name string, default_name string) ParsedCallableAttrs {
	mut parsed := ParsedCallableAttrs{
		php_name: default_name
	}
	for attr in attrs {
		if attr.name == callable_attr_name {
			parsed.has_php_callable = true
			if attr.arg != '' {
				parsed.php_name = attr.arg
			}
			continue
		}
		if attr.name == 'export' && attr.arg != '' {
			parsed.has_export = true
			continue
		}
		if attr.name == 'php_return_type' && attr.arg != '' {
			parsed.php_return_type = normalize_attr_value(attr.arg)
			continue
		}
		if attr.name == 'php_arg_type' && attr.arg != '' {
			for arg_name, arg_type in parse_php_arg_types(attr.arg) {
				parsed.php_arg_types[arg_name] = arg_type
			}
			continue
		}
		if attr.name == 'php_optional_args' && attr.arg != '' {
			for arg_name in parse_attr_list(attr.arg) {
				parsed.php_optional_args[arg_name] = true
			}
			continue
		}
		if attr.name == 'php_borrowed_return' {
			parsed.borrowed_return = true
			continue
		}
		if attr.name == 'php_abstract' {
			parsed.is_abstract = true
		}
	}
	return parsed
}

fn build_php_args(params []ast.Param, table &ast.Table, start_idx int, overrides map[string]string, optional map[string]bool) []repr.PhpArg {
	mut args := []repr.PhpArg{}
	for i := start_idx; i < params.len; i++ {
		param := params[i]
		args << repr.PhpArg{
			name:        param.name
			v_type:      strip_module(table.type_to_str(param.typ))
			php_type:    overrides[param.name] or { '' }
			is_optional: param.name in optional
		}
	}
	return args
}
