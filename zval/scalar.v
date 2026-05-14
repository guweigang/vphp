module zval

import vphp.zend

pub fn get_long(handle Handle) i64 {
	if !handle.is_valid() {
		return 0
	}
	return zend.zval_get_long_ptr(handle.raw_ptr())
}

pub fn get_int(handle Handle) i64 {
	if !handle.is_valid() {
		return 0
	}
	return zend.zval_get_int_ptr(handle.raw_ptr())
}

pub fn get_lval(handle Handle) i64 {
	if !handle.is_valid() {
		return 0
	}
	return zend.zval_get_lval_ptr(handle.raw_ptr())
}

pub fn get_double(handle Handle) f64 {
	if !handle.is_valid() {
		return 0.0
	}
	return zend.zval_get_double_ptr(handle.raw_ptr())
}

pub fn string_value(handle Handle) string {
	if !handle.is_valid() {
		return ''
	}
	return zend.zval_string_value_ptr(handle.raw_ptr())
}

pub fn set_null(handle Handle) {
	if !handle.is_valid() {
		return
	}
	zend.zval_set_null_ptr(handle.raw_ptr())
}

pub fn set_bool(handle Handle, b bool) {
	if !handle.is_valid() {
		return
	}
	zend.zval_set_bool_ptr(handle.raw_ptr(), b)
}

pub fn set_lval(handle Handle, val i64) {
	if !handle.is_valid() {
		return
	}
	zend.zval_set_lval_ptr(handle.raw_ptr(), val)
}

pub fn set_double(handle Handle, val f64) {
	if !handle.is_valid() {
		return
	}
	zend.zval_set_double_ptr(handle.raw_ptr(), val)
}

pub fn set_string(handle Handle, s string) {
	if !handle.is_valid() {
		return
	}
	zend.zval_set_string_ptr(handle.raw_ptr(), s)
}
