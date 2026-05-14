module zval

import vphp.zend

pub fn read_static_property(class_name string, name string) ReadResult {
	rv := new_request()
	if !rv.is_valid() {
		return ReadResult{}
	}
	res := zend.read_static_property_named(class_name, name, rv.raw_ptr())
	return ReadResult{
		rv:  rv
		res: Handle.from_ptr(res)
	}
}

pub fn read_class_constant(class_name string, name string) ReadResult {
	rv := new_request()
	if !rv.is_valid() {
		return ReadResult{}
	}
	res := zend.read_class_constant_named(class_name, name, rv.raw_ptr())
	return ReadResult{
		rv:  rv
		res: Handle.from_ptr(res)
	}
}

pub fn write_static_property(class_name string, name string, value Handle) {
	if !value.is_valid() {
		return
	}
	zend.write_static_property_named(class_name, name, value.raw_ptr())
}
