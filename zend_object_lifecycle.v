module vphp

import vphp.object
import vphp.zval

fn object_binding_wrapper(obj ZendObject, handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {
	ptr := match ownership {
		.borrowed {
			obj.handle.ensure_borrowed_instance_binding_ptr(handlers)
		}
		.owned_request, .owned_persistent {
			obj.handle.ensure_owned_instance_binding_ptr(handlers)
		}
	}

	return unsafe { &C.vphp_object_wrapper(ptr) }
}

fn object_wrapper(obj ZendObject) &C.vphp_object_wrapper {
	return unsafe { &C.vphp_object_wrapper(obj.handle.wrapper_ptr()) }
}

fn wrap_existing_object(out zval.Handle, obj ZendObject) {
	object.wrap_existing_zval(out, obj.handle)
}

pub fn (obj ZendObject) add_ref() {
	if !obj.is_valid() {
		return
	}
	obj.handle.add_ref()
}

pub fn (obj ZendObject) release() {
	if !obj.is_valid() {
		return
	}
	obj.handle.release()
}

pub fn (obj ZendObject) bind_handlers(handlers voidptr, ownership OwnershipKind) {
	if !obj.is_valid() {
		return
	}
	match ownership {
		.borrowed {
			obj.handle.bind_borrowed_handlers(handlers)
		}
		.owned_request, .owned_persistent {
			obj.handle.bind_owned_handlers(handlers)
		}
	}
}

pub fn (obj ZendObject) ensure_binding(handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {
	if !obj.is_valid() {
		return unsafe { nil }
	}
	return object_binding_wrapper(obj, handlers, ownership)
}

pub fn (obj ZendObject) init_owned_instance(handlers voidptr) {
	if !obj.is_valid() {
		return
	}
	obj.handle.init_owned_instance(handlers)
}

pub fn (obj ZendObject) bound_v_ptr() voidptr {
	if !obj.is_valid() {
		return unsafe { nil }
	}
	wrapper := object_wrapper(obj)
	if isnil(wrapper) {
		return unsafe { nil }
	}
	return wrapper.v_ptr
}

pub fn (obj ZendObject) to_request_owned_zval() ZVal {
	if !obj.is_valid() {
		return invalid_zval()
	}
	out := zval.new_request()
	if !out.is_valid() {
		return invalid_zval()
	}
	wrap_existing_object(out, obj)
	return adopt_handle_with_ownership(out, .owned_request)
}
