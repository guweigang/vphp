module parser

import v.ast
import compiler.repr

struct ParsedCallableAttrs {
mut:
	has_export        bool
	has_php_callable  bool
	php_name          string
	php_arg_types     map[string]string
	php_arg_defaults  map[string]string
	php_return_type   string
	php_optional_args map[string]bool
	borrowed_return   bool
	is_abstract       bool
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
			for arg_name, arg_type in parse_php_arg_name_values(attr.arg) {
				parsed.php_arg_types[arg_name] = arg_type
			}
			continue
		}
		if attr.name == 'php_arg_default' && attr.arg != '' {
			for arg_name, default_value in parse_php_arg_name_values(attr.arg) {
				parsed.php_arg_defaults[arg_name] = default_value
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

fn build_php_args(params []ast.Param, table &ast.Table, start_idx int, overrides map[string]string, optional map[string]bool, defaults map[string]string) []repr.PhpArg {
	mut args := []repr.PhpArg{}
	for i := start_idx; i < params.len; i++ {
		param := params[i]
		args << repr.PhpArg{
			name:        param.name
			v_type:      strip_module(table.type_to_str(param.typ))
			php_type:    overrides[param.name] or { '' }
			is_optional: param.name in optional
			php_default: defaults[param.name] or { '' }
		}
	}
	return args
}
