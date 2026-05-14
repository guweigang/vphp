module object

import vphp.zend
import vphp.zval

pub fn from_zval(handle zval.Handle) Handle {
	if !handle.is_valid() {
		return Handle.invalid()
	}
	return Handle.from_ptr(zend.object_from_zval_ptr(handle.raw_ptr()))
}

pub fn wrap_existing_zval(out zval.Handle, obj Handle) {
	if !out.is_valid() || !obj.is_valid() {
		return
	}
	zend.wrap_existing_object_ptr(out.raw_ptr(), obj.raw_ptr())
}
