module object

import vphp.zend

pub fn (handle Handle) read_property_ptr(name string, rv voidptr) voidptr {
	return zend.read_property_ptr(handle.raw_ptr(), name, rv)
}

pub fn (handle Handle) write_property_ptr(name string, value voidptr) {
	zend.write_property_ptr(handle.raw_ptr(), name, value)
}

pub fn (handle Handle) has_property(name string) bool {
	return zend.has_property_ptr(handle.raw_ptr(), name)
}

pub fn (handle Handle) isset_property(name string) bool {
	return zend.isset_property_ptr(handle.raw_ptr(), name)
}

pub fn (handle Handle) unset_property(name string) {
	zend.unset_property_ptr(handle.raw_ptr(), name)
}
