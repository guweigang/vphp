module zend

pub fn create_closure_with_arity(ret &C.zval, thunk voidptr, bridge voidptr, num_args int, required_args int) {
	C.vphp_create_closure_with_arity(ret, thunk, bridge, num_args, required_args)
}

pub fn create_variadic_closure(ret &C.zval, thunk voidptr, bridge voidptr) {
	C.vphp_create_variadic_closure(ret, thunk, bridge)
}
