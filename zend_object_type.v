module vphp

import vphp.object
import vphp.zend

pub struct ZendObject {
	data object.Data
}

pub fn ZendObject.invalid() ZendObject {
	return ZendObject{
		data: object.Data.invalid()
	}
}

pub fn ZendObject.from_raw(raw &C.zend_object) ZendObject {
	return ZendObject{
		data: object.Data.from_ptr(raw)
	}
}

pub fn ZendObject.from_ptr(ptr voidptr) ZendObject {
	return ZendObject{
		data: object.Data.from_ptr(ptr)
	}
}

fn zend_current_this_object() voidptr {
	return zend.current_this_object()
}

fn zend_object_from_zval(v ZVal) &C.zend_object {
	return zend.object_from_zval(v.raw)
}

pub fn ZendObject.current() ZendObject {
	obj_raw := zend_current_this_object()
	if obj_raw == 0 {
		return ZendObject.invalid()
	}
	return ZendObject.from_ptr(obj_raw)
}

pub fn ZendObject.from_zval(v ZVal) ZendObject {
	if v.raw == 0 || !v.is_object() {
		return ZendObject.invalid()
	}
	return ZendObject.from_raw(zend_object_from_zval(v))
}

pub fn (obj ZendObject) is_valid() bool {
	return obj.data.is_valid()
}

pub fn (obj ZendObject) raw_ptr() voidptr {
	return obj.data.raw_ptr()
}

fn (obj ZendObject) raw_object() &C.zend_object {
	return unsafe { &C.zend_object(obj.raw_ptr()) }
}
