module object

import vphp.zend
import vphp.zval

pub fn from_zval(handle zval.Handle) Handle {
	if !handle.is_valid() {
		return Handle.invalid()
	}
	return Handle.from_ptr(zend.object_from_zval_ptr(handle.raw_ptr()))
}
