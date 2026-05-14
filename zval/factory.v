module zval

import vphp.zend

pub fn new_null() Handle {
	return Handle.from_ptr(zend.new_null_zval_ptr())
}

pub fn new_int(n i64) Handle {
	return Handle.from_ptr(zend.new_int_zval_ptr(n))
}

pub fn new_float(f f64) Handle {
	return Handle.from_ptr(zend.new_float_zval_ptr(f))
}

pub fn new_bool(b bool) Handle {
	return Handle.from_ptr(zend.new_bool_zval_ptr(b))
}

pub fn new_string(s string) Handle {
	return Handle.from_ptr(zend.new_string_zval_ptr(s))
}
