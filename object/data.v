module object

import vphp.zend

pub struct Data {
	raw voidptr
}

pub fn Data.invalid() Data {
	return Data{}
}

pub fn Data.from_ptr(raw voidptr) Data {
	return Data{
		raw: raw
	}
}

pub fn (obj Data) is_valid() bool {
	return obj.raw != 0
}

pub fn (obj Data) raw_ptr() voidptr {
	return obj.raw
}

pub fn (obj Data) add_ref() {
	zend.object_add_ref_ptr(obj.raw)
}

pub fn (obj Data) release() {
	zend.object_release_ptr(obj.raw)
}

pub fn (obj Data) bind_borrowed_handlers(handlers voidptr) {
	zend.bind_borrowed_handlers_ptr(obj.raw, handlers)
}

pub fn (obj Data) bind_owned_handlers(handlers voidptr) {
	zend.bind_owned_handlers_ptr(obj.raw, handlers)
}

pub fn (obj Data) ensure_borrowed_instance_binding_ptr(handlers voidptr) voidptr {
	return zend.ensure_borrowed_instance_binding_ptr(obj.raw, handlers)
}

pub fn (obj Data) ensure_owned_instance_binding_ptr(handlers voidptr) voidptr {
	return zend.ensure_owned_instance_binding_ptr(obj.raw, handlers)
}

pub fn (obj Data) init_owned_instance(handlers voidptr) {
	zend.init_owned_instance_ptr(obj.raw, handlers)
}

pub fn (obj Data) wrapper_ptr() voidptr {
	return zend.object_wrapper_ptr(obj.raw)
}
