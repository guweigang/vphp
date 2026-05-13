module vphp

pub fn (z ZVal) bind_object(handlers voidptr, ownership OwnershipKind) {
	ZendObject.from_zval(z).bind_handlers(handlers, ownership)
}

pub fn (z ZVal) bind_owned_object(handlers voidptr) {
	z.bind_object(handlers, .owned_request)
}

pub fn (z ZVal) bind_borrowed_object(handlers voidptr) {
	z.bind_object(handlers, .borrowed)
}

fn zend_return_unbound_object(ret PhpReturn, v_ptr voidptr, ce voidptr) {
	C.vphp_return_obj(ret.raw_zval(), v_ptr, ce)
}

fn zend_return_borrowed_object(ret PhpReturn, v_ptr voidptr, ce voidptr, handlers voidptr) {
	C.vphp_return_borrowed_object(ret.raw_zval(), v_ptr, ce, handlers)
}

fn zend_return_owned_object(ret PhpReturn, v_ptr voidptr, ce voidptr, handlers voidptr) {
	C.vphp_return_owned_object(ret.raw_zval(), v_ptr, ce, handlers)
}

fn return_unbound_object_to(ret PhpReturn, v_ptr voidptr, ce voidptr) {
	zend_return_unbound_object(ret, v_ptr, ce)
}

fn return_bound_object_to(ret PhpReturn, v_ptr voidptr, ce voidptr, handlers voidptr, ownership OwnershipKind) {
	match ownership {
		.borrowed {
			zend_return_borrowed_object(ret, v_ptr, ce, handlers)
		}
		.owned_request, .owned_persistent {
			register_vptr_root(v_ptr)
			zend_return_owned_object(ret, v_ptr, ce, handlers)
		}
	}
}
