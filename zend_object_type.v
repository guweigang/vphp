module vphp

import vphp.object
import vphp.zend

pub struct ZendObject {
	handle object.Handle
}

pub fn ZendObject.invalid() ZendObject {
	return ZendObject{
		handle: object.Handle.invalid()
	}
}

pub fn ZendObject.from_ptr(ptr voidptr) ZendObject {
	return ZendObject{
		handle: object.Handle.from_ptr(ptr)
	}
}

fn zend_current_this_object() voidptr {
	return zend.current_this_object()
}

fn zend_object_from_zval(v ZVal) object.Handle {
	return object.from_zval(v.handle())
}

pub fn ZendObject.current() ZendObject {
	obj_raw := zend_current_this_object()
	if obj_raw == 0 {
		return ZendObject.invalid()
	}
	return ZendObject.from_ptr(obj_raw)
}

pub fn ZendObject.from_zval(v ZVal) ZendObject {
	if !v.is_valid() || !v.is_object() {
		return ZendObject.invalid()
	}
	return ZendObject{
		handle: zend_object_from_zval(v)
	}
}

pub fn (obj ZendObject) is_valid() bool {
	return obj.handle.is_valid()
}

pub fn (obj ZendObject) raw_ptr() voidptr {
	return obj.handle.raw_ptr()
}
