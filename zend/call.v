module zend

pub fn call_method(receiver &C.zval, method string, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_method(receiver, &char(method.str), method.len, retval, count, params)
}

pub fn call_method_ptr(receiver voidptr, method string, retval voidptr, count int, params voidptr) int {
	return call_method(unsafe { &C.zval(receiver) }, method, unsafe { &C.zval(retval) }, count,
		unsafe { &&C.zval(params) })
}

pub fn call_callable(callable &C.zval, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_callable(callable, retval, count, params)
}

pub fn call_callable_ptr(callable voidptr, retval voidptr, count int, params voidptr) int {
	return call_callable(unsafe { &C.zval(callable) }, unsafe { &C.zval(retval) }, count,
		unsafe { &&C.zval(params) })
}

pub fn new_instance(class_name &char, class_name_len int, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_new_instance(class_name, class_name_len, retval, count, params)
}

pub fn new_instance_named(class_name string, retval voidptr, count int, params voidptr) int {
	return new_instance(&char(class_name.str), class_name.len, unsafe { &C.zval(retval) }, count,
		unsafe { &&C.zval(params) })
}

pub fn call_static_method(class_name &char, class_name_len int, method string, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_static_method(class_name, class_name_len, &char(method.str), method.len,
		retval, count, params)
}

pub fn call_static_method_named(class_name string, method string, retval voidptr, count int, params voidptr) int {
	return call_static_method(&char(class_name.str), class_name.len, method,
		unsafe { &C.zval(retval) }, count, unsafe { &&C.zval(params) })
}

pub fn with_arg_ptrs[T](args []voidptr, run fn (int, voidptr) T) T {
	unsafe {
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << &C.zval(arg)
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}
		return run(args.len, p_args)
	}
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
