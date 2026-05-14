module vphp

import vphp.zend

pub struct ZendObject {
	raw &C.zend_object = unsafe { nil }
}

pub fn ZendObject.invalid() ZendObject {
	return unsafe {
		ZendObject{
			raw: nil
		}
	}
}

pub fn ZendObject.from_raw(raw &C.zend_object) ZendObject {
	return unsafe {
		ZendObject{
			raw: raw
		}
	}
}

pub fn ZendObject.from_ptr(ptr voidptr) ZendObject {
	return unsafe {
		ZendObject{
			raw: &C.zend_object(ptr)
		}
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
	return obj.raw != 0
}

pub fn (obj ZendObject) raw_ptr() voidptr {
	return obj.raw
}
