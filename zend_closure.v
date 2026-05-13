module vphp

import vphp.zend as _

fn zend_create_closure_with_arity(ret PhpReturn, thunk voidptr, bridge voidptr, num_args int, required_args int) {
	C.vphp_create_closure_with_arity(ret.raw_zval(), thunk, bridge, num_args, required_args)
}

fn zend_create_variadic_closure(ret PhpReturn, thunk voidptr, bridge voidptr) {
	C.vphp_create_variadic_closure(ret.raw_zval(), thunk, bridge)
}
