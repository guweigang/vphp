module zend

pub fn zval_type(v &C.zval) int {
	return C.vphp_get_type(v)
}

pub fn zval_is_null(v &C.zval) bool {
	return C.vphp_is_null(v)
}

pub fn zval_is_callable(v &C.zval) bool {
	return C.vphp_is_callable(v) == 1
}

pub fn zval_get_long(v &C.zval) i64 {
	return unsafe { C.zval_get_long(v) }
}

pub fn zval_get_int(v &C.zval) i64 {
	return C.vphp_get_int(v)
}

pub fn zval_get_lval(v &C.zval) i64 {
	return C.vphp_get_lval(v)
}

pub fn zval_get_double(v &C.zval) f64 {
	return C.vphp_get_double(v)
}

pub fn zval_string_ptr(v &C.zval) &char {
	return C.VPHP_Z_STRVAL(v)
}

pub fn zval_string_len(v &C.zval) int {
	return C.VPHP_Z_STRLEN(v)
}

pub fn zval_set_null(v &C.zval) {
	unsafe { C.vphp_set_null(v) }
}

pub fn zval_set_bool(v &C.zval, b bool) {
	unsafe { C.vphp_set_bool(v, b) }
}

pub fn zval_set_lval(v &C.zval, val i64) {
	unsafe { C.vphp_set_lval(v, val) }
}

pub fn zval_set_double(v &C.zval, val f64) {
	unsafe { C.vphp_set_double(v, val) }
}

pub fn zval_set_string(v &C.zval, s string) {
	unsafe { C.vphp_set_strval(v, &char(s.str), s.len) }
}

pub fn new_string_zval(s string) &C.zval {
	return C.vphp_new_strl(&char(s.str), s.len)
}

pub fn foreach_zval(v &C.zval, ctx voidptr, wrapper voidptr) {
	C.vphp_zval_foreach(v, ctx, wrapper)
}
