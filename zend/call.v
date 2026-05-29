module zend

pub fn call_method(receiver &C.zval, method string, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_method(receiver, &char(method.str), method.len, retval, count, params)
}

pub fn call_method_ptr(receiver voidptr, method string, retval voidptr, count int, params voidptr) int {
	return call_method( // SAFETY: receiver is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(receiver) }, method, // SAFETY: retval is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(retval) }, count, // SAFETY: C interop block with valid pointer arguments
	 unsafe { &&C.zval(params) })
}

pub fn call_callable(callable &C.zval, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_callable(callable, retval, count, params)
}

pub fn call_callable_ptr(callable voidptr, retval voidptr, count int, params voidptr) int {
	return call_callable( // SAFETY: callable is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(callable) }, // SAFETY: retval is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(retval) }, count, // SAFETY: C interop block with valid pointer arguments
	 unsafe { &&C.zval(params) })
}

pub fn new_instance(class_name &char, class_name_len int, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_new_instance(class_name, class_name_len, retval, count, params)
}

pub fn new_instance_named(class_name string, retval voidptr, count int, params voidptr) int {
	return new_instance(&char(class_name.str), class_name.len, // SAFETY: retval is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(retval) }, count, // SAFETY: C interop block with valid pointer arguments
	 unsafe { &&C.zval(params) })
}

pub fn call_static_method(class_name &char, class_name_len int, method string, retval &C.zval, count int, params &&C.zval) int {
	return C.vphp_call_static_method(class_name, class_name_len, &char(method.str), method.len,
		retval, count, params)
}

pub fn call_static_method_named(class_name string, method string, retval voidptr, count int, params voidptr) int {
	return call_static_method(&char(class_name.str), class_name.len, method, // SAFETY: retval is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(retval) }, count, unsafe { &&C.zval(params) })
}

pub fn with_arg_ptrs[T](args []voidptr, run fn (int, voidptr) T) T {
	// SAFETY: C interop block with valid pointer arguments
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

pub fn read_static_property_named(class_name string, name string, rv voidptr) voidptr {
	return read_static_property(&char(class_name.str), class_name.len, name, // SAFETY: rv is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(rv) })
}

pub fn read_class_constant(class_name &char, class_name_len int, name string, rv &C.zval) &C.zval {
	return C.vphp_read_class_constant_compat(class_name, class_name_len, &char(name.str), name.len,
		rv)
}

pub fn read_class_constant_named(class_name string, name string, rv voidptr) voidptr {
	return read_class_constant(&char(class_name.str), class_name.len, name, // SAFETY: rv is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(rv) })
}

pub fn write_static_property(class_name &char, class_name_len int, name string, value &C.zval) {
	C.vphp_write_static_property_compat(class_name, class_name_len, &char(name.str), name.len,
		value)
}

pub fn write_static_property_named(class_name string, name string, value voidptr) {
	write_static_property(&char(class_name.str), class_name.len, name, // SAFETY: value is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(value) })
}
