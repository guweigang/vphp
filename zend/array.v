module zend

pub fn array_init(v &C.zval) {
	unsafe { C.vphp_return_array_start(v) }
}

pub fn array_add_assoc_string(v &C.zval, key string, val string) {
	unsafe { C.vphp_array_add_assoc_string(v, &char(key.str), &char(val.str)) }
}

pub fn array_add_assoc_long(v &C.zval, key string, val i64) {
	unsafe { C.vphp_array_add_assoc_long(v, &char(key.str), val) }
}

pub fn array_add_assoc_double(v &C.zval, key string, val f64) {
	unsafe { C.vphp_array_add_assoc_double(v, &char(key.str), val) }
}

pub fn array_add_assoc_bool(v &C.zval, key string, val bool) {
	b_val := if val { 1 } else { 0 }
	unsafe { C.vphp_array_add_assoc_bool(v, &char(key.str), b_val) }
}

pub fn array_add_assoc_zval(v &C.zval, key string, val &C.zval) {
	unsafe { C.vphp_array_add_assoc_zval(v, &char(key.str), val) }
}

pub fn array_push_string(v &C.zval, s string) {
	unsafe { C.vphp_array_push_stringl(v, &char(s.str), s.len) }
}

pub fn array_push_long(v &C.zval, val i64) {
	unsafe { C.vphp_array_push_long(v, val) }
}

pub fn array_push_double(v &C.zval, val f64) {
	unsafe { C.vphp_array_push_double(v, val) }
}

pub fn array_push_bool(v &C.zval, val bool) {
	b_val := if val { 1 } else { 0 }
	unsafe { C.vphp_array_push_long(v, b_val) }
}

pub fn array_add_next_zval(v &C.zval, val &C.zval) {
	unsafe { C.vphp_array_add_next_zval(v, val) }
}

pub fn array_count(v &C.zval) int {
	return C.vphp_array_count(v)
}

pub fn array_get_index(v &C.zval, index int) &C.zval {
	return C.vphp_array_get_index(v, u32(index))
}

pub fn array_get_key(v &C.zval, key string) &C.zval {
	return C.vphp_array_get_key(v, &char(key.str), key.len)
}
