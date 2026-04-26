module vphp

fn object_from_zval_or_nil(z ZVal) &C.zend_object {
	if !z.is_valid() || !z.is_object() {
		return unsafe { nil }
	}
	return C.vphp_get_obj_from_zval(z.raw)
}

pub fn bind_object_with_ownership(z ZVal, handlers voidptr, ownership OwnershipKind) {
	obj := object_from_zval_or_nil(z)
	if isnil(obj) {
		return
	}
	match ownership {
		.borrowed {
			C.vphp_bind_borrowed_handlers(obj, handlers)
		}
		.owned_request, .owned_persistent {
			C.vphp_bind_owned_handlers(obj, handlers)
		}
	}
}

pub fn bind_owned_object(z ZVal, handlers voidptr) {
	bind_object_with_ownership(z, handlers, .owned_request)
}

pub fn bind_borrowed_object(z ZVal, handlers voidptr) {
	bind_object_with_ownership(z, handlers, .borrowed)
}

pub fn ensure_object_binding(z ZVal, handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {
	obj := object_from_zval_or_nil(z)
	if isnil(obj) {
		return unsafe { nil }
	}
	return match ownership {
		.borrowed {
			C.vphp_ensure_borrowed_instance_binding(obj, handlers)
		}
		.owned_request, .owned_persistent {
			C.vphp_ensure_owned_instance_binding(obj, handlers)
		}
	}
}

pub fn ensure_owned_object_binding(z ZVal, handlers voidptr) &C.vphp_object_wrapper {
	return ensure_object_binding(z, handlers, .owned_request)
}

pub fn ensure_borrowed_object_binding(z ZVal, handlers voidptr) &C.vphp_object_wrapper {
	return ensure_object_binding(z, handlers, .borrowed)
}

pub fn init_owned_object(z ZVal, handlers voidptr) {
	obj := object_from_zval_or_nil(z)
	if isnil(obj) {
		return
	}
	C.vphp_init_owned_instance(obj, handlers)
}

pub fn return_bound_object_raw(ret &C.zval, v_ptr voidptr, ce voidptr, handlers voidptr, ownership OwnershipKind) {
	match ownership {
		.borrowed {
			C.vphp_return_borrowed_object(ret, v_ptr, ce, handlers)
		}
		.owned_request, .owned_persistent {
			register_vptr_root(v_ptr)
			C.vphp_return_owned_object(ret, v_ptr, ce, handlers)
		}
	}
}

pub fn return_owned_object_raw(ret &C.zval, v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_bound_object_raw(ret, v_ptr, ce, handlers, .owned_request)
}

pub fn return_borrowed_object_raw(ret &C.zval, v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_bound_object_raw(ret, v_ptr, ce, handlers, .borrowed)
}
