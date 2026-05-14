module vphp

import vphp.zval

fn zend_reference_value(v ZVal) zval.Handle {
	return zval.reference_value(v.handle())
}

fn zend_reference_set_zval(v ZVal, value ZVal) {
	zval.set_reference_value(v.handle(), value.handle())
}

pub fn (v ZVal) reference_value() ZVal {
	if !v.is_valid() {
		return invalid_zval()
	}
	handle := zend_reference_value(v)
	if !handle.is_valid() {
		return invalid_zval()
	}
	return ZVal.from_handle(handle)
}

pub fn (v ZVal) set_reference_value(value ZVal) {
	if !v.is_valid() || !value.is_valid() {
		return
	}
	zend_reference_set_zval(v, value)
}
