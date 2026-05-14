module zval

import vphp.zend

pub fn foreach(handle Handle, ctx voidptr, wrapper voidptr) {
	if !handle.is_valid() {
		return
	}
	zend.foreach_zval_ptr(handle.raw_ptr(), ctx, wrapper)
}
