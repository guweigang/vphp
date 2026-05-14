module vphp

import vphp.zend

fn zend_allocate_contiguous_object(ce voidptr, v_size usize) voidptr {
	return zend.allocate_contiguous_object(ce, v_size)
}

fn zend_object_add_ref(obj ZendObject) {
	obj.data.add_ref()
}

fn zend_object_release(obj ZendObject) {
	obj.data.release()
}

fn zend_object_bind_handlers(obj ZendObject, handlers voidptr, ownership OwnershipKind) {
	match ownership {
		.borrowed {
			obj.data.bind_borrowed_handlers(handlers)
		}
		.owned_request, .owned_persistent {
			obj.data.bind_owned_handlers(handlers)
		}
	}
}

fn zend_object_ensure_binding(obj ZendObject, handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {
	ptr := match ownership {
		.borrowed {
			obj.data.ensure_borrowed_instance_binding_ptr(handlers)
		}
		.owned_request, .owned_persistent {
			obj.data.ensure_owned_instance_binding_ptr(handlers)
		}
	}

	return unsafe { &C.vphp_object_wrapper(ptr) }
}

fn zend_object_init_owned_instance(obj ZendObject, handlers voidptr) {
	obj.data.init_owned_instance(handlers)
}

fn zend_object_wrapper(obj ZendObject) &C.vphp_object_wrapper {
	return unsafe { &C.vphp_object_wrapper(obj.data.wrapper_ptr()) }
}

fn zend_wrap_existing_object(out &C.zval, obj ZendObject) {
	zend.wrap_existing_object(out, obj.raw_object())
}

pub fn (obj ZendObject) add_ref() {
	if !obj.is_valid() {
		return
	}
	zend_object_add_ref(obj)
}

pub fn (obj ZendObject) release() {
	if !obj.is_valid() {
		return
	}
	zend_object_release(obj)
}

pub fn (obj ZendObject) bind_handlers(handlers voidptr, ownership OwnershipKind) {
	if !obj.is_valid() {
		return
	}
	zend_object_bind_handlers(obj, handlers, ownership)
}

pub fn (obj ZendObject) ensure_binding(handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {
	if !obj.is_valid() {
		return unsafe { nil }
	}
	return zend_object_ensure_binding(obj, handlers, ownership)
}

pub fn (obj ZendObject) init_owned_instance(handlers voidptr) {
	if !obj.is_valid() {
		return
	}
	zend_object_init_owned_instance(obj, handlers)
}

pub fn (obj ZendObject) bound_v_ptr() voidptr {
	if !obj.is_valid() {
		return unsafe { nil }
	}
	wrapper := zend_object_wrapper(obj)
	if isnil(wrapper) {
		return unsafe { nil }
	}
	return wrapper.v_ptr
}

pub fn (obj ZendObject) to_request_owned_zval() ZVal {
	if !obj.is_valid() {
		return invalid_zval()
	}
	unsafe {
		mut out := zend_new_zval()
		if out == 0 {
			return invalid_zval()
		}
		zend_wrap_existing_object(out, obj)
		return adopt_raw_with_ownership(out, .owned_request)
	}
}
