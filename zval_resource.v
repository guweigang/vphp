module vphp

import vphp.zval

fn zend_make_resource(v ZVal, ptr voidptr, label string) {
	zval.make_resource(zval.Handle.from_ptr(v.raw), ptr, label)
}

fn zend_fetch_resource(v ZVal) voidptr {
	return zval.resource_ptr(zval.Handle.from_ptr(v.raw))
}

pub fn (v ZVal) make_resource(ptr voidptr, label string) {
	if !v.is_valid() {
		return
	}
	zend_make_resource(v, ptr, label)
}

pub fn (v ZVal) resource_ptr() voidptr {
	if !v.is_valid() || !v.is_resource() {
		return unsafe { nil }
	}
	return zend_fetch_resource(v)
}

// Compatibility alias. Prefer `resource_ptr()` in new code.
pub fn (v ZVal) to_res() voidptr {
	return v.resource_ptr()
}
