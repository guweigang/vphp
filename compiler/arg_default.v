module compiler

import compiler.php_types
import compiler.repr

struct PhpArgDefaultValue {
	raw    string
	v_type string
}

fn PhpArgDefaultValue.from_arg(arg repr.PhpArgRepr) ?PhpArgDefaultValue {
	if !arg.is_optional || arg.php_default == '' {
		return none
	}
	return PhpArgDefaultValue{
		raw:    arg.php_default.trim_space()
		v_type: arg.v_type
	}
}

fn (default_value PhpArgDefaultValue) string_value() string {
	trimmed := default_value.raw
	if trimmed.len >= 2 {
		if trimmed[0] == `"` && trimmed[trimmed.len - 1] == `"` {
			return trimmed[1..trimmed.len - 1]
		}
		if trimmed[0] == `'` && trimmed[trimmed.len - 1] == `'` {
			return trimmed[1..trimmed.len - 1]
		}
	}
	return trimmed
}

fn (default_value PhpArgDefaultValue) is_numeric_literal() bool {
	if default_value.raw == '' {
		return false
	}
	first := default_value.raw[0]
	return (first >= `0` && first <= `9`) || first == `-`
}

fn (default_value PhpArgDefaultValue) zval_expr() ?string {
	if default_value.raw == '' {
		return none
	}
	return match default_value.raw {
		'null' {
			'vphp.ZVal.new_null()'
		}
		'true' {
			'vphp.ZVal.new_bool(true)'
		}
		'false' {
			'vphp.ZVal.new_bool(false)'
		}
		'[]' {
			'vphp.PhpArray.empty().to_zval()'
		}
		else {
			if (default_value.raw.starts_with('"') && default_value.raw.ends_with('"'))
				|| (default_value.raw.starts_with("'") && default_value.raw.ends_with("'")) {
				return 'vphp.ZVal.new_string(${v_single_quote(default_value.string_value())})'
			}
			if default_value.raw.contains('.') {
				return 'vphp.ZVal.new_float(${default_value.raw})'
			}
			if default_value.is_numeric_literal() {
				return 'vphp.ZVal.new_int(i64(${default_value.raw}))'
			}
			return 'vphp.php_const(${v_single_quote(default_value.raw)})'
		}
	}
}

fn (default_value PhpArgDefaultValue) arg_expr() ?string {
	clean := php_types.normalize_export_type_key(default_value.v_type)
	if default_value.v_type.starts_with('?') {
		if default_value.raw == 'null' {
			return 'none'
		}
	}
	return match clean {
		'RequestBorrowedZBox' {
			zexpr := default_value.zval_expr() or { return none }
			'vphp.RequestBorrowedZBox.from_zval(${zexpr})'
		}
		'RequestOwnedZBox' {
			zexpr := default_value.zval_expr() or { return none }
			'vphp.RequestOwnedZBox.from_zval(${zexpr})'
		}
		'PersistentOwnedZBox' {
			zexpr := default_value.zval_expr() or { return none }
			'vphp.PersistentOwnedZBox.from_zval(${zexpr})'
		}
		'ZVal' {
			default_value.zval_expr() or { return none }
		}
		'string' {
			v_single_quote(default_value.string_value())
		}
		'int', 'i64', 'f64', 'bool' {
			default_value.raw
		}
		else {
			none
		}
	}
}
