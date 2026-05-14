module zend

pub fn call_method(receiver &C.zval, method string, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_method(receiver, &char(method.str), method.len, retval, count, params)
}

pub fn call_callable(callable &C.zval, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_callable(callable, retval, count, params)
}

pub fn new_instance(class_name &char, class_name_len int, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_new_instance(class_name, class_name_len, retval, count, params)
}

pub fn call_static_method(class_name &char, class_name_len int, method string, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_static_method(class_name, class_name_len, &char(method.str), method.len,
		retval, count, params)
}

pub fn read_static_property(class_name &char, class_name_len int, name string, rv &C.zval) &C.zval {
	return C.vphp_read_static_property_compat(class_name, class_name_len, &char(name.str),
		name.len, rv)
}

pub fn read_class_constant(class_name &char, class_name_len int, name string, rv &C.zval) &C.zval {
	return C.vphp_read_class_constant_compat(class_name, class_name_len, &char(name.str), name.len,
		rv)
}

pub fn write_static_property(class_name &char, class_name_len int, name string, value &C.zval) {
	C.vphp_write_static_property_compat(class_name, class_name_len, &char(name.str), name.len,
		value)
}
