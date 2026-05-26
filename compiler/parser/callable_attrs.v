module parser

import v.ast
import compiler.repr

struct ParsedCallableAttrs {
mut:
	has_export       bool
	has_php_callable bool
	php_name         string
	php_arg_types    map[string]string
	php_arg_names    map[string]string
	php_arg_defaults map[string]string
	php_param_attrs  map[string][]repr.PhpAttributeRepr
	php_return_type  string
	php_arg_optional map[string]bool
	borrowed_return  bool
	is_abstract      bool
}

fn split_attr_entries(raw string) []string {
	mut out := []string{}
	mut current := []rune{}
	mut quote := rune(0)
	mut escaped := false
	mut bracket_depth := 0
	mut brace_depth := 0
	mut paren_depth := 0
	for ch in raw.runes() {
		if escaped {
			current << ch
			escaped = false
			continue
		}
		if quote != rune(0) {
			current << ch
			if ch == `\\` {
				escaped = true
				continue
			}
			if ch == quote {
				quote = rune(0)
			}
			continue
		}
		match ch {
			`'`, `"` {
				quote = ch
				current << ch
			}
			`[` {
				bracket_depth++
				current << ch
			}
			`]` {
				if bracket_depth > 0 {
					bracket_depth--
				}
				current << ch
			}
			`{` {
				brace_depth++
				current << ch
			}
			`}` {
				if brace_depth > 0 {
					brace_depth--
				}
				current << ch
			}
			`(` {
				paren_depth++
				current << ch
			}
			`)` {
				if paren_depth > 0 {
					paren_depth--
				}
				current << ch
			}
			`,` {
				if quote == rune(0) && bracket_depth == 0 && brace_depth == 0 && paren_depth == 0 {
					entry := current.string().trim_space()
					if entry != '' {
						out << entry
					}
					current = []rune{}
				} else {
					current << ch
				}
			}
			else {
				current << ch
			}
		}
	}
	entry := current.string().trim_space()
	if entry != '' {
		out << entry
	}
	return out
}

fn parse_callable_attrs(attrs []ast.Attr, callable_attr_name string, default_name string) ParsedCallableAttrs {
	mut parsed := ParsedCallableAttrs{
		php_name: default_name
	}
	for attr in attrs {
		if attr.name == 'php_ignore' {
			return ParsedCallableAttrs{
				php_name: default_name
			}
		}
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
		if is_call_style_attr_arg(attr, 'php_arg_type') {
			parsed.php_arg_types[attr.call_arg_name] = normalize_attr_value(attr.arg)
			continue
		}
		if attr.name == 'php_arg_type' && attr.arg != '' {
			for arg_name, arg_type in parse_php_arg_name_values(attr.arg) {
				parsed.php_arg_types[arg_name] = arg_type
			}
			continue
		}
		if is_call_style_attr_arg(attr, 'php_arg_name') {
			parsed.php_arg_names[attr.call_arg_name] = normalize_attr_value(attr.arg)
			continue
		}
		if attr.name == 'php_arg_name' && attr.arg != '' {
			for arg_name, php_arg_name in parse_php_arg_name_values(attr.arg) {
				parsed.php_arg_names[arg_name] = normalize_attr_value(php_arg_name)
			}
			continue
		}
		if is_call_style_attr_arg(attr, 'php_arg_default') {
			parsed.php_arg_defaults[attr.call_arg_name] = attr.arg.trim_space()
			continue
		}
		if attr.name == 'php_arg_default' && attr.arg != '' {
			for arg_name, default_value in parse_php_arg_name_values(attr.arg) {
				parsed.php_arg_defaults[arg_name] = default_value
			}
			continue
		}
		if is_call_style_attr_arg(attr, 'php_arg_optional') {
			value := normalize_attr_value(attr.arg).to_lower()
			if value != 'false' && value != '0' {
				parsed.php_arg_optional[attr.call_arg_name] = true
			}
			continue
		}
		if is_call_style_attr_arg(attr, 'php_param_attr') {
			parsed.php_param_attrs[attr.call_arg_name] << parse_php_attr_list(attr.arg)
			continue
		}
		if attr.name == 'php_arg_optional' && attr.arg != '' {
			for arg_name in parse_attr_list(attr.arg) {
				parsed.php_arg_optional[arg_name] = true
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

fn is_call_style_attr_arg(attr ast.Attr, call_name string) bool {
	return attr.call_name == call_name && attr.call_arg_name != '' && attr.has_arg
}

fn parse_php_attr_list(raw string) []repr.PhpAttributeRepr {
	mut out := []repr.PhpAttributeRepr{}
	for entry in split_attr_entries(raw) {
		if php_attr := parse_php_attr(entry) {
			out << php_attr
		}
	}
	return out
}

fn parse_php_arg_name_values(raw string) map[string]string {
	mut out := map[string]string{}
	for part in split_attr_entries(raw) {
		entry := part.trim_space()
		if entry == '' {
			continue
		}
		if idx := entry.index('=') {
			arg_name := entry[..idx].trim_space()
			arg_value := entry[idx + 1..].trim_space()
			if arg_name != '' && arg_value != '' {
				out[arg_name] = arg_value
			}
		}
	}
	return out
}

fn build_php_args(params []ast.Param, table &ast.Table, start_idx int, is_fn_variadic bool, overrides map[string]string, names map[string]string, optional map[string]bool, defaults map[string]string, param_attrs map[string][]repr.PhpAttributeRepr, params_structs map[string]repr.PhpParamsStruct) []repr.PhpArgRepr {
	mut args := []repr.PhpArgRepr{}
	for i := start_idx; i < params.len; i++ {
		param := params[i]
		v_type := strip_module(table.type_to_str(param.typ))
		if i == params.len - 1 {
			if params_struct := params_structs[v_type] {
				for field in params_struct.fields {
					args << repr.PhpArgRepr{
						name:        names[field.name] or { snake_to_camel(field.name) }
						v_type:      field.v_type
						php_type:    overrides[field.name] or { '' }
						is_optional: true
						php_default: defaults[field.name] or { field.php_default }
						attributes:  param_attrs[field.name]
						source:      repr.PhpArgSource{
							kind:             .params_field
							params_arg_name:  param.name
							params_type:      params_struct.type_ref()
							params_field:     field.name
							params_v_default: field.v_default
						}
					}
				}
				continue
			}
		}
		inferred_optional := v_type.starts_with('?')
		args << repr.PhpArgRepr{
			name:        names[param.name] or { snake_to_camel(param.name) }
			v_type:      v_type
			php_type:    overrides[param.name] or { '' }
			is_optional: param.name in optional || inferred_optional
			is_variadic: is_fn_variadic && i == params.len - 1
			php_default: defaults[param.name] or {
				if inferred_optional { 'null' } else { '' }
			}
			attributes:  param_attrs[param.name]
			source:      repr.PhpArgSource{
				kind:        .direct
				direct_name: param.name
			}
		}
	}
	return args
}

fn snake_to_camel(name string) string {
	parts := name.split('_')
	if parts.len <= 1 {
		return name
	}
	mut out := parts[0]
	for part in parts[1..] {
		if part == '' {
			continue
		}
		out += part[..1].to_upper() + part[1..]
	}
	return out
}
