module vphp

fn zend_reference_value(v ZVal) &C.zval {
	return C.vphp_reference_value(v.raw)
}

fn zend_reference_set_zval(v ZVal, value ZVal) {
	C.vphp_reference_set_zval(v.raw, value.raw)
}

pub fn (v ZVal) reference_value() ZVal {
	if !v.is_valid() {
		return invalid_zval()
	}
	raw := zend_reference_value(v)
	if raw == 0 {
		return invalid_zval()
	}
	return ZVal.from_raw(raw)
}

pub fn (v ZVal) set_reference_value(value ZVal) {
	if !v.is_valid() || !value.is_valid() {
		return
	}
	zend_reference_set_zval(v, value)
}
