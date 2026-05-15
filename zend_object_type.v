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

pub fn ZendObject.current() ZendObject {
	obj_raw := zend.current_this_object()
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
		handle: object.from_zval(v.handle())
	}
}

pub fn (obj ZendObject) is_valid() bool {
	return obj.handle.is_valid()
}

pub fn (obj ZendObject) raw_ptr() voidptr {
	return obj.handle.raw_ptr()
}
