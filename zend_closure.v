module vphp

import vphp.zend

fn zend_create_closure_with_arity(ret PhpReturn, thunk voidptr, bridge voidptr, num_args int, required_args int) {
	zend.create_closure_with_arity_ptr(ret.raw_ptr(), thunk, bridge, num_args, required_args)
}

fn zend_create_variadic_closure(ret PhpReturn, thunk voidptr, bridge voidptr) {
	zend.create_variadic_closure_ptr(ret.raw_ptr(), thunk, bridge)
}
