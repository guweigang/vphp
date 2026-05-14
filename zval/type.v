module zval

import vphp.zend

pub fn type_raw(handle Handle) int {
	if !handle.is_valid() {
		return zend.is_undef
	}
	return zend.zval_type_ptr(handle.raw_ptr())
}

pub fn is_callable(handle Handle) bool {
	if !handle.is_valid() {
		return false
	}
	return zend.zval_is_callable_ptr(handle.raw_ptr())
}
