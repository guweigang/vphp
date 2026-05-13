module vphp

pub fn bind_object_with_ownership(z ZVal, handlers voidptr, ownership OwnershipKind) {
	z.bind_object(handlers, ownership)
}

pub fn (z ZVal) bind_object(handlers voidptr, ownership OwnershipKind) {
	ZendObject.from_zval(z).bind_handlers(handlers, ownership)
}

pub fn (z ZVal) bind_owned_object(handlers voidptr) {
	z.bind_object(handlers, .owned_request)
}

pub fn (z ZVal) bind_borrowed_object(handlers voidptr) {
	z.bind_object(handlers, .borrowed)
}

pub fn bind_owned_object(z ZVal, handlers voidptr) {
	z.bind_owned_object(handlers)
}

pub fn bind_borrowed_object(z ZVal, handlers voidptr) {
	z.bind_borrowed_object(handlers)
}

pub fn ensure_object_binding(z ZVal, handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {
	return z.ensure_object_binding(handlers, ownership)
}

pub fn (z ZVal) ensure_object_binding(handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {
	return ZendObject.from_zval(z).ensure_binding(handlers, ownership)
}

pub fn (z ZVal) ensure_owned_object_binding(handlers voidptr) &C.vphp_object_wrapper {
	return z.ensure_object_binding(handlers, .owned_request)
}

pub fn (z ZVal) ensure_borrowed_object_binding(handlers voidptr) &C.vphp_object_wrapper {
	return z.ensure_object_binding(handlers, .borrowed)
}

pub fn ensure_owned_object_binding(z ZVal, handlers voidptr) &C.vphp_object_wrapper {
	return z.ensure_owned_object_binding(handlers)
}

pub fn ensure_borrowed_object_binding(z ZVal, handlers voidptr) &C.vphp_object_wrapper {
	return z.ensure_borrowed_object_binding(handlers)
}

pub fn init_owned_object(z ZVal, handlers voidptr) {
	z.init_owned_object(handlers)
}

pub fn (z ZVal) init_owned_object(handlers voidptr) {
	ZendObject.from_zval(z).init_owned_instance(handlers)
}

pub fn return_bound_object_raw(ret &C.zval, v_ptr voidptr, ce voidptr, handlers voidptr, ownership OwnershipKind) {
	PhpReturn.new(ret).bound_object(v_ptr, ce, handlers, ownership)
}

fn return_bound_object_to(ret &C.zval, v_ptr voidptr, ce voidptr, handlers voidptr, ownership OwnershipKind) {
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
