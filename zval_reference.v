module vphp

import vphp.zval

pub fn (v ZVal) reference_value() ZVal {
	if !v.is_valid() {
		return invalid_zval()
	}
	handle := zval.reference_value(v.handle())
	if !handle.is_valid() {
		return invalid_zval()
	}
	return ZVal.from_handle(handle)
}

pub fn (v ZVal) set_reference_value(value ZVal) {
	if !v.is_valid() || !value.is_valid() {
		return
	}
	zval.set_reference_value(v.handle(), value.handle())
}
