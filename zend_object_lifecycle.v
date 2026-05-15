module vphp

import vphp.object
import vphp.zval

fn object_binding_ownership(ownership OwnershipKind) object.BindingOwnership {
	return match ownership {
		.borrowed {
			.borrowed
		}
		.owned_request, .owned_persistent {
			.owned
		}
	}
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

pub fn (obj ZendObject) ensure_binding_ptr(handlers voidptr, ownership OwnershipKind) voidptr {
	if !obj.is_valid() {
		return unsafe { nil }
	}
	return obj.handle.ensure_binding_ptr(handlers, object_binding_ownership(ownership))
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
	return obj.handle.bound_v_ptr()
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
