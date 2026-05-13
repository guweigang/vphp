module vphp

import vphp.zend as _

struct ZendMethodCall {
	receiver ZVal
	method   string
}

struct ZendCallableCall {
	callable ZVal
}

struct ZendConstructCall {
	class_name ZVal
}

struct ZendStaticMethodCall {
	class_name ZVal
	method     string
}

type ZendCallTarget = ZendCallableCall
	| ZendConstructCall
	| ZendMethodCall
	| ZendStaticMethodCall

fn zend_invoke_call_target(target ZendCallTarget, retval &C.zval, count int, params &&C.zval) int {
	return match target {
		ZendMethodCall {
			C.vphp_call_method(target.receiver.raw, &char(target.method.str), target.method.len,
				retval, count, params)
		}
		ZendCallableCall {
			C.vphp_call_callable(target.callable.raw, retval, count, params)
		}
		ZendConstructCall {
			C.vphp_new_instance(target.class_name.string_ptr(), target.class_name.string_len(),
				retval, count, params)
		}
		ZendStaticMethodCall {
			C.vphp_call_static_method(target.class_name.string_ptr(),
				target.class_name.string_len(), &char(target.method.str), target.method.len,
				retval, count, params)
		}
	}
}

fn zend_read_static_property(class_name ZVal, name string, rv &C.zval) &C.zval {
	return C.vphp_read_static_property_compat(class_name.string_ptr(), class_name.string_len(),
		&char(name.str), name.len, rv)
}

fn zend_read_class_constant(class_name ZVal, name string, rv &C.zval) &C.zval {
	return C.vphp_read_class_constant_compat(class_name.string_ptr(), class_name.string_len(),
		&char(name.str), name.len, rv)
}

fn zend_write_static_property(class_name ZVal, name string, value ZVal) {
	C.vphp_write_static_property_compat(class_name.string_ptr(), class_name.string_len(),
		&char(name.str), name.len, value.raw)
}
