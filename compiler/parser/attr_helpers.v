module parser

import os
import compiler.repr

pub struct MethodBorrowProfile {
pub:
	receiver_type           string
	method_name             string
	return_type             string
	direct_borrowed         bool
	delegated_target_type   string
	delegated_target_method string
}

fn compiler_notes_enabled() bool {
	flag := os.getenv('VPHP_COMPILER_NOTES').trim_space()
	return flag != '' && flag != '0' && flag.to_lower() != 'false'
}

fn normalize_attr_value(raw string) string {
	return raw.trim_space().trim('\'"')
}

fn parse_attr_list(raw string) []string {
	mut out := []string{}
	for part in raw.split(',') {
		name := normalize_attr_value(part)
		if name != '' {
			out << name
		}
	}
	return out
}

fn parse_php_arg_types(raw string) map[string]string {
	mut out := map[string]string{}
	for part in raw.split(',') {
		entry := part.trim_space()
		if entry == '' {
			continue
		}
		if idx := entry.index('=') {
			arg_name := entry[..idx].trim_space()
			arg_type := entry[idx + 1..].trim_space()
			if arg_name != '' && arg_type != '' {
				out[arg_name] = arg_type
			}
		}
	}
	return out
}

fn parse_php_prop_map(raw string) map[string]string {
	mut out := map[string]string{}
	for part in raw.split(',') {
		entry := part.trim_space()
		if entry == '' {
			continue
		}
		if idx := entry.index('=') {
			v_field_name := entry[..idx].trim_space()
			php_prop_name := normalize_attr_value(entry[idx + 1..])
			if v_field_name != '' && php_prop_name != '' {
				out[v_field_name] = php_prop_name
			}
		}
	}
	return out
}

fn parse_php_prop_attr(raw string) ?repr.PhpClassPropRepr {
	value := normalize_attr_value(raw)
	if value == '' {
		return none
	}
	mut name := value
	mut v_type := 'mixed'
	if value.contains(':') {
		name = value.all_before(':').trim_space()
		v_type = value.all_after(':').trim_space()
	}
	if name == '' {
		return none
	}
	return repr.PhpClassPropRepr{
		name:             name
		v_field_name:     name
		v_type:           if v_type == '' { 'mixed' } else { v_type }
		visibility:       'public'
		is_static:        false
		is_mut:           true
		is_property_only: true
	}
}

fn parse_attr_args(raw string) []repr.PhpAttributeArg {
	mut out := []repr.PhpAttributeArg{}
	mut current := []rune{}
	mut quote := rune(0)
	mut escaped := false
	for ch in raw.runes() {
		if escaped {
			current << ch
			escaped = false
			continue
		}
		if quote != rune(0) {
			if ch == `\\` {
				escaped = true
				current << ch
				continue
			}
			current << ch
			if ch == quote {
				quote = rune(0)
			}
			continue
		}
		if ch == `"` || ch == `'` {
			quote = ch
			current << ch
			continue
		}
		if ch == `,` {
			token := current.string().trim_space()
			if token != '' {
				out << parse_attr_arg(token)
			}
			current = []rune{}
			continue
		}
		current << ch
	}
	token := current.string().trim_space()
	if token != '' {
		out << parse_attr_arg(token)
	}
	return out
}

fn decode_attr_string(raw string) string {
	if raw.len < 2 {
		return raw
	}
	quote := raw[0]
	if (quote != `'` && quote != `"`) || raw[raw.len - 1] != quote {
		return raw
	}
	mut out := []rune{}
	mut escaped := false
	for ch in raw[1..raw.len - 1].runes() {
		if escaped {
			out << match ch {
				`n` { `\n` }
				`t` { `\t` }
				`r` { `\r` }
				`\\` { `\\` }
				`'` { `'` }
				`"` { `"` }
				else { ch }
			}

			escaped = false
			continue
		}
		if ch == `\\` {
			escaped = true
			continue
		}
		out << ch
	}
	return out.string()
}

fn is_attr_arg_name(value string) bool {
	if value == '' {
		return false
	}
	for ch in value {
		if !ch.is_letter() && !ch.is_digit() && ch != `_` {
			return false
		}
	}
	return true
}

fn parse_attr_arg(token string) repr.PhpAttributeArg {
	raw := token.trim_space()
	mut name := ''
	mut value := raw
	if raw.contains(':') {
		parts := raw.split_nth(':', 2)
		candidate := parts[0].trim_space()
		if is_attr_arg_name(candidate) {
			name = candidate
			value = parts[1].trim_space()
		}
	}
	lower := value.to_lower()
	if (value.starts_with("'") && value.ends_with("'"))
		|| (value.starts_with('"') && value.ends_with('"')) {
		return repr.PhpAttributeArg{
			kind:  'string'
			name:  name
			value: decode_attr_string(value)
		}
	}
	if lower == 'true' || lower == 'false' {
		return repr.PhpAttributeArg{
			kind:  'bool'
			name:  name
			value: lower
		}
	}
	if lower == 'null' {
		return repr.PhpAttributeArg{
			kind:  'null'
			name:  name
			value: ''
		}
	}
	if value.contains('.') && (value.f64() != 0.0 || value == '0.0' || value == '-0.0') {
		return repr.PhpAttributeArg{
			kind:  'float'
			name:  name
			value: value
		}
	}
	if value.i64() != 0 || value == '0' || value == '-0' {
		return repr.PhpAttributeArg{
			kind:  'int'
			name:  name
			value: value
		}
	}
	return repr.PhpAttributeArg{
		kind:  'string'
		name:  name
		value: value
	}
}

fn parse_php_attr(raw string) ?repr.PhpAttributeRepr {
	normalized := normalize_attr_value(raw)
	if normalized == '' {
		return none
	}
	if !normalized.contains('(') {
		return repr.PhpAttributeRepr{
			name: normalized
			args: []repr.PhpAttributeArg{}
		}
	}
	open := normalized.index_after('(', 0) or { return none }
	if !normalized.ends_with(')') || open <= 0 {
		return none
	}
	name := normalized[..open].trim_space()
	if name == '' {
		return none
	}
	args_raw := normalized[open + 1..normalized.len - 1]
	return repr.PhpAttributeRepr{
		name: name
		args: parse_attr_args(args_raw)
	}
}
