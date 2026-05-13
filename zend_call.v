module vphp

import vphp.zend as _

fn zend_call_method(receiver ZVal, method string, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_method(receiver.raw, &char(method.str), method.len, retval, count, params)
}

fn zend_call_callable(callable ZVal, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_callable(callable.raw, retval, count, params)
}

fn zend_new_instance(class_name ZVal, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_new_instance(class_name.string_ptr(), class_name.string_len(), retval, count,
		params)
}

fn zend_call_static_method(class_name ZVal, method string, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_static_method(class_name.string_ptr(), class_name.string_len(), &char(method.str),
		method.len, retval, count, params)
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
