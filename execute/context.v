module execute

import vphp.zend

pub fn (handle Handle) active_class_ptr() voidptr {
	return zend.execute_active_class_ptr(handle.raw_ptr())
}

pub fn (handle Handle) this_object_ptr() voidptr {
	return zend.execute_this_object_ptr(handle.raw_ptr())
}
