module object

import vphp.zend
import vphp.zval

pub fn (handle Handle) read_property_ptr(name string, rv voidptr) voidptr {
	return zend.read_property_ptr(handle.raw_ptr(), name, rv)
}

pub fn (handle Handle) read_property(name string) zval.ReadResult {
	rv := zval.new_request()
	if !rv.is_valid() {
		return zval.ReadResult{}
	}
	res := handle.read_property_ptr(name, rv.raw_ptr())
	return zval.ReadResult{
		rv:  rv
		res: zval.Handle.from_ptr(res)
	}
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
