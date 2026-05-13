module vphp

import vphp.zend as _

fn C.vphp_allocate_contiguous_object(ce voidptr, v_size usize) voidptr

fn zend_allocate_contiguous_object(ce voidptr, v_size usize) voidptr {
	return C.vphp_allocate_contiguous_object(ce, v_size)
}

fn zend_object_add_ref(obj ZendObject) {
	C.vphp_object_addref(obj.raw)
}

fn zend_object_release(obj ZendObject) {
	C.vphp_object_release(obj.raw)
}

fn zend_object_bind_handlers(obj ZendObject, handlers voidptr, ownership OwnershipKind) {
	match ownership {
		.borrowed {
			C.vphp_bind_borrowed_handlers(obj.raw, handlers)
		}
		.owned_request, .owned_persistent {
			C.vphp_bind_owned_handlers(obj.raw, handlers)
		}
	}
}

fn zend_object_ensure_binding(obj ZendObject, handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {
	return match ownership {
		.borrowed {
			C.vphp_ensure_borrowed_instance_binding(obj.raw, handlers)
		}
		.owned_request, .owned_persistent {
			C.vphp_ensure_owned_instance_binding(obj.raw, handlers)
		}
	}
}

fn zend_object_init_owned_instance(obj ZendObject, handlers voidptr) {
	C.vphp_init_owned_instance(obj.raw, handlers)
}

fn zend_object_wrapper(obj ZendObject) &C.vphp_object_wrapper {
	return C.vphp_obj_from_obj(obj.raw)
}

fn zend_wrap_existing_object(out &C.zval, obj ZendObject) {
	C.vphp_wrap_existing_object(out, obj.raw)
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
