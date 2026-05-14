module zval

import vphp.zend

pub fn reference_value(handle Handle) Handle {
	if !handle.is_valid() {
		return Handle.invalid()
	}
	return Handle.from_ptr(zend.reference_value_ptr(handle.raw_ptr()))
}

pub fn set_reference_value(handle Handle, value Handle) {
	if !handle.is_valid() || !value.is_valid() {
		return
	}
	zend.reference_set_zval_ptr(handle.raw_ptr(), value.raw_ptr())
}
