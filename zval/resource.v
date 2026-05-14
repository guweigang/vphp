module zval

import vphp.zend

pub fn make_resource(handle Handle, ptr voidptr, label string) {
	if !handle.is_valid() {
		return
	}
	zend.make_resource_ptr(handle.raw_ptr(), ptr, label)
}

pub fn resource_ptr(handle Handle) voidptr {
	if !handle.is_valid() {
		return unsafe { nil }
	}
	return zend.fetch_resource_ptr(handle.raw_ptr())
}
