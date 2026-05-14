module vphp

import vphp.zend

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
			zend.call_method(target.receiver.raw, target.method, retval, count, params)
		}
		ZendCallableCall {
			zend.call_callable(target.callable.raw, retval, count, params)
		}
		ZendConstructCall {
			zend.new_instance(target.class_name.string_ptr(), target.class_name.string_len(),
				retval, count, params)
		}
		ZendStaticMethodCall {
			zend.call_static_method(target.class_name.string_ptr(), target.class_name.string_len(),
				target.method, retval, count, params)
		}
	}
}

fn zend_read_static_property(class_name ZVal, name string, rv &C.zval) &C.zval {
	return zend.read_static_property(class_name.string_ptr(), class_name.string_len(), name, rv)
}

fn zend_read_class_constant(class_name ZVal, name string, rv &C.zval) &C.zval {
	return zend.read_class_constant(class_name.string_ptr(), class_name.string_len(), name, rv)
}

fn zend_write_static_property(class_name ZVal, name string, value ZVal) {
	zend.write_static_property(class_name.string_ptr(), class_name.string_len(), name, value.raw)
}
