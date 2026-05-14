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

fn zend_invoke_call_target(target ZendCallTarget, retval voidptr, count int, params voidptr) int {
	return match target {
		ZendMethodCall {
			zend.call_method_ptr(target.receiver.raw, target.method, retval, count, params)
		}
		ZendCallableCall {
			zend.call_callable_ptr(target.callable.raw, retval, count, params)
		}
		ZendConstructCall {
			class_name := target.class_name.get_string()
			zend.new_instance_named(class_name, retval, count, params)
		}
		ZendStaticMethodCall {
			class_name := target.class_name.get_string()
			zend.call_static_method_named(class_name, target.method, retval, count, params)
		}
	}
}

fn zend_read_static_property(class_name ZVal, name string, rv &C.zval) &C.zval {
	class_name_text := class_name.get_string()
	return zend.read_static_property(&char(class_name_text.str), class_name_text.len, name, rv)
}

fn zend_read_class_constant(class_name ZVal, name string, rv &C.zval) &C.zval {
	class_name_text := class_name.get_string()
	return zend.read_class_constant(&char(class_name_text.str), class_name_text.len, name, rv)
}

fn zend_write_static_property(class_name ZVal, name string, value ZVal) {
	class_name_text := class_name.get_string()
	zend.write_static_property(&char(class_name_text.str), class_name_text.len, name, value.raw)
}
