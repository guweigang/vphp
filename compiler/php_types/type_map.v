module php_types

pub struct TypeMap {
pub:
	v_type     string // V original type: "int", "string", "!bool", "?int"
	c_type     string // C extern declaration type: "int", "v_string", "v_res_bool"
	php_return string // PHP return macro: "RETURN_LONG", "VPHP_RETURN_STRING"
	is_result  bool
	is_option  bool
}

pub fn normalize_export_type_key(v_type string) string {
	return normalize_v_type_key(v_type)
}

pub fn TypeMap.get_type(v_type string) TypeMap {
	clean_type := normalize_export_type_key(v_type)

	return match clean_type {
		'int' {
			TypeMap{'int', 'int', 'RETURN_LONG', false, false}
		}
		'i64' {
			TypeMap{'i64', 'long long', 'RETURN_LONG', false, false}
		}
		'f32' {
			TypeMap{'f32', 'double', 'RETURN_DOUBLE', false, false}
		}
		'f64' {
			TypeMap{'f64', 'double', 'RETURN_DOUBLE', false, false}
		}
		'bool' {
			TypeMap{'bool', 'bool', 'RETURN_BOOL', false, false}
		}
		'string' {
			TypeMap{'string', 'v_string', 'VPHP_RETURN_STRING', false, false}
		}
		'ZVal', 'RequestBorrowedZBox', 'RequestOwnedZBox', 'PersistentOwnedZBox' {
			TypeMap{clean_type, 'zval', 'RETURN_NULL', false, false}
		}
		'[]string', '[]int', '[]i64', '[]bool', '[]f64', '[]f32', '[]', '[]ZVal' {
			TypeMap{clean_type, 'zval', 'RETURN_NULL', false, false}
		}
		'map[string]string', 'map[string]int', 'map[string]i64', 'map[string]bool',
		'map[string]f64', 'map[string][]string', 'map[string]ZVal' {
			TypeMap{clean_type, 'zval', 'RETURN_NULL', false, false}
		}
		'!bool' {
			TypeMap{'!bool', 'void', 'RETURN_NULL', true, false}
		}
		'!int' {
			TypeMap{'!int', 'void', 'RETURN_NULL', true, false}
		}
		'!i64' {
			TypeMap{'!i64', 'void', 'RETURN_NULL', true, false}
		}
		'!f32' {
			TypeMap{'!f32', 'void', 'RETURN_NULL', true, false}
		}
		'!f64' {
			TypeMap{'!f64', 'void', 'RETURN_NULL', true, false}
		}
		'!string' {
			TypeMap{'!string', 'void', 'RETURN_NULL', true, false}
		}
		'?bool' {
			TypeMap{'?bool', 'void', 'RETURN_NULL', false, true}
		}
		'?int' {
			TypeMap{'?int', 'void', 'RETURN_NULL', false, true}
		}
		'?i64' {
			TypeMap{'?i64', 'void', 'RETURN_NULL', false, true}
		}
		'?f32' {
			TypeMap{'?f32', 'void', 'RETURN_NULL', false, true}
		}
		'?f64' {
			TypeMap{'?f64', 'void', 'RETURN_NULL', false, true}
		}
		'?string' {
			TypeMap{'?string', 'void', 'RETURN_NULL', false, true}
		}
		'void', '' {
			TypeMap{'void', 'void', 'RETURN_NULL', false, false}
		}
		else {
			if clean_type.starts_with('!') {
				TypeMap{v_type, 'void', 'RETURN_NULL', true, false}
			} else if clean_type.starts_with('?') {
				TypeMap{v_type, 'void', 'RETURN_NULL', false, true}
			} else {
				TypeMap{v_type, 'void*', 'RETURN_NULL', false, false}
			}
		}
	}
}
