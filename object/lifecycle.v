module object

import vphp.zend

pub fn allocate_contiguous(ce voidptr, v_size usize) voidptr {
	return zend.allocate_contiguous_object(ce, v_size)
}

pub fn runtime_free(ptr voidptr) {
	zend.v_runtime_free(ptr)
}

pub fn (handle Handle) add_ref() {
	zend.object_add_ref_ptr(handle.raw_ptr())
}

pub fn (handle Handle) release() {
	zend.object_release_ptr(handle.raw_ptr())
}

pub fn (handle Handle) bind_borrowed_handlers(handlers voidptr) {
	zend.bind_borrowed_handlers_ptr(handle.raw_ptr(), handlers)
}

pub fn (handle Handle) bind_owned_handlers(handlers voidptr) {
	zend.bind_owned_handlers_ptr(handle.raw_ptr(), handlers)
}

pub fn (handle Handle) ensure_borrowed_instance_binding_ptr(handlers voidptr) voidptr {
	return zend.ensure_borrowed_instance_binding_ptr(handle.raw_ptr(), handlers)
}

pub fn (handle Handle) ensure_owned_instance_binding_ptr(handlers voidptr) voidptr {
	return zend.ensure_owned_instance_binding_ptr(handle.raw_ptr(), handlers)
}

pub fn (handle Handle) init_owned_instance(handlers voidptr) {
	zend.init_owned_instance_ptr(handle.raw_ptr(), handlers)
}

pub fn (handle Handle) wrapper_ptr() voidptr {
	return zend.object_wrapper_ptr(handle.raw_ptr())
}
