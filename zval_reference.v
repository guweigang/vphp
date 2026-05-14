module vphp

import vphp.zval

fn zend_reference_value(v ZVal) zval.Handle {
	return zval.reference_value(zval.Handle.from_ptr(v.raw))
}

fn zend_reference_set_zval(v ZVal, value ZVal) {
	zval.set_reference_value(zval.Handle.from_ptr(v.raw), zval.Handle.from_ptr(value.raw))
}

pub fn (v ZVal) reference_value() ZVal {
	if !v.is_valid() {
		return invalid_zval()
	}
	handle := zend_reference_value(v)
	if !handle.is_valid() {
		return invalid_zval()
	}
	return unsafe { ZVal.from_raw(&C.zval(handle.raw_ptr())) }
}

pub fn (v ZVal) set_reference_value(value ZVal) {
	if !v.is_valid() || !value.is_valid() {
		return
	}
	zend_reference_set_zval(v, value)
}
