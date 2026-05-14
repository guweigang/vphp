module vphp

pub fn (ret PhpReturn) resource(ptr voidptr, label string) {
	ret.to_zval().make_resource(ptr, label)
}

pub fn (ret PhpReturn) object(v_ptr voidptr, ce voidptr) {
	return_unbound_object_to(ret, v_ptr, ce)
}

pub fn (ret PhpReturn) bound_object(v_ptr voidptr, ce voidptr, handlers voidptr, ownership OwnershipKind) {
	return_bound_object_to(ret, v_ptr, ce, handlers, ownership)
}

pub fn (ret PhpReturn) owned_object(v_ptr voidptr, ce voidptr, handlers voidptr) {
	ret.bound_object(v_ptr, ce, handlers, .owned_request)
}

pub fn (ret PhpReturn) borrowed_object(v_ptr voidptr, ce voidptr, handlers voidptr) {
	ret.bound_object(v_ptr, ce, handlers, .borrowed)
}
