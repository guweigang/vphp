module vphp

import vphp.zval

pub fn (v ZVal) make_resource(ptr voidptr, label string) {
	if !v.is_valid() {
		return
	}
	zval.make_resource(v.handle(), ptr, label)
}

pub fn (v ZVal) resource_ptr() voidptr {
	if !v.is_valid() || !v.is_resource() {
		return unsafe { nil }
	}
	return zval.resource_ptr(v.handle())
}
