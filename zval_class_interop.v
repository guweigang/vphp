module vphp

pub fn (v ZVal) construct(args []ZVal) ZVal {
	return v.construct_owned_request(args)
}

fn construct_zval(class_name ZVal, args []ZVal, ownership OwnershipKind) ZVal {
	if class_name.raw == 0 || !class_name.is_string() {
		return invalid_zval()
	}
	return call_with_zval_args(args, ownership, fn [class_name] (retval &C.zval, count int, params &&C.zval) int {
		return C.vphp_new_instance(C.VPHP_Z_STRVAL(class_name.raw),
			C.VPHP_Z_STRLEN(class_name.raw), retval, count, params)
	})
}

fn call_static_method_zval(class_name ZVal, method string, args []ZVal, ownership OwnershipKind) ZVal {
	if class_name.raw == 0 || !class_name.is_string() {
		return invalid_zval()
	}
	return call_with_zval_args(args, ownership, fn [class_name, method] (retval &C.zval, count int, params &&C.zval) int {
		return C.vphp_call_static_method(C.VPHP_Z_STRVAL(class_name.raw),
			C.VPHP_Z_STRLEN(class_name.raw), &char(method.str), method.len, retval, count, params)
	})
}

pub fn (v ZVal) construct_owned_request(args []ZVal) ZVal {
	return construct_zval(v, args, .owned_request)
}

pub fn (v ZVal) construct_owned_persistent(args []ZVal) ZVal {
	return construct_zval(v, args, .owned_persistent)
}

pub fn (v ZVal) static_method_owned_request(method string, args []ZVal) ZVal {
	return call_static_method_zval(v, method, args, .owned_request)
}

pub fn (v ZVal) static_method_owned_persistent(method string, args []ZVal) ZVal {
	return call_static_method_zval(v, method, args, .owned_persistent)
}

pub fn (v ZVal) static_method(method string, args []ZVal) ZVal {
	return v.static_method_owned_request(method, args)
}

fn (v ZVal) read_static_prop_with_ownership(name string, ownership OwnershipKind) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
	res := C.vphp_read_static_property_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, ownership)
}

fn (v ZVal) read_const_with_ownership(name string, ownership OwnershipKind) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
	res := C.vphp_read_class_constant_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, ownership)
}

pub fn (v ZVal) static_prop_borrowed(name string) ZVal {
	return v.read_static_prop_with_ownership(name, .borrowed)
}

pub fn (v ZVal) static_prop_owned_request(name string) ZVal {
	return v.read_static_prop_with_ownership(name, .owned_request)
}

pub fn (v ZVal) static_prop_owned_persistent(name string) ZVal {
	return v.read_static_prop_with_ownership(name, .owned_persistent)
}

pub fn (v ZVal) static_prop(name string) ZVal {
	return v.static_prop_owned_request(name)
}

pub fn (v ZVal) const_borrowed(name string) ZVal {
	return v.read_const_with_ownership(name, .borrowed)
}

pub fn (v ZVal) const_owned_request(name string) ZVal {
	return v.read_const_with_ownership(name, .owned_request)
}

pub fn (v ZVal) const_owned_persistent(name string) ZVal {
	return v.read_const_with_ownership(name, .owned_persistent)
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
