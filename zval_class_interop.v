module vphp

pub fn (v ZVal) construct(args []ZVal) ZVal {
	return v.construct_owned_request(args)
}

pub fn (v ZVal) construct_owned_request(args []ZVal) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}

	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}

		res := C.vphp_new_instance(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw), retval,
			args.len, p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		mut result := adopt_raw_with_ownership(retval, .owned_request)
		if result.is_object() {
			RequestScope.autorelease_forget(result.raw)
		}
		return result
	}
}

pub fn (v ZVal) construct_owned_persistent(args []ZVal) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}
		res := C.vphp_new_instance(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw), retval,
			args.len, p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_persistent)
	}
}

pub fn (v ZVal) static_method_owned_request(method string, args []ZVal) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}

	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}

		res := C.vphp_call_static_method(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
			&char(method.str), method.len, retval, args.len, p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		mut result := adopt_raw_with_ownership(retval, .owned_request)
		if result.is_object() {
			RequestScope.autorelease_forget(result.raw)
		}
		return result
	}
}

pub fn (v ZVal) static_method_owned_persistent(method string, args []ZVal) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}
		res := C.vphp_call_static_method(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
			&char(method.str), method.len, retval, args.len, p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_persistent)
	}
}

pub fn (v ZVal) static_method(method string, args []ZVal) ZVal {
	return v.static_method_owned_request(method, args)
}

pub fn (v ZVal) static_prop_borrowed(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}

	rv := C.vphp_new_zval()
	res := C.vphp_read_static_property_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .borrowed)
}

pub fn (v ZVal) static_prop_owned_request(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
	res := C.vphp_read_static_property_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_request)
}

pub fn (v ZVal) static_prop_owned_persistent(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
	res := C.vphp_read_static_property_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_persistent)
}

pub fn (v ZVal) static_prop(name string) ZVal {
	return v.static_prop_owned_request(name)
}

pub fn (v ZVal) const_borrowed(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}

	rv := C.vphp_new_zval()
	res := C.vphp_read_class_constant_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .borrowed)
}

pub fn (v ZVal) const_owned_request(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
	res := C.vphp_read_class_constant_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_request)
}

pub fn (v ZVal) const_owned_persistent(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
	res := C.vphp_read_class_constant_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_persistent)
}

pub fn (v ZVal) @const(name string) ZVal {
	return v.const_owned_request(name)
}

// Compatibility alias. Prefer `.@const(...)` in new code.
pub fn (v ZVal) constant(name string) ZVal {
	return v.@const(name)
}

pub fn (v ZVal) set_static_prop(name string, value ZVal) {
	if v.raw == 0 || !v.is_string() || value.raw == 0 {
		return
	}
	C.vphp_write_static_property_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, value.raw)
}
