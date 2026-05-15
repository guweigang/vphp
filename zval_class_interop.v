module vphp

import vphp.zval

pub fn (v ZVal) construct(args []ZVal) ZVal {
	return v.construct_owned_request(args)
}

fn construct_zval(class_name ZVal, args []ZVal, ownership OwnershipKind) ZVal {
	if !class_name.is_valid() || !class_name.is_string() {
		return invalid_zval()
	}
	return call_zval_target(ZendConstructCall{
		class_name: class_name
	}, args, ownership)
}

fn call_static_method_zval(class_name ZVal, method string, args []ZVal, ownership OwnershipKind) ZVal {
	if !class_name.is_valid() || !class_name.is_string() {
		return invalid_zval()
	}
	return call_zval_target(ZendStaticMethodCall{
		class_name: class_name
		method:     method
	}, args, ownership)
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
	if !v.is_valid() || !v.is_string() {
		return invalid_zval()
	}
	return adopt_read_result_handles(zval.read_static_property(v.get_string(), name), ownership)
}

fn (v ZVal) read_const_with_ownership(name string, ownership OwnershipKind) ZVal {
	if !v.is_valid() || !v.is_string() {
		return invalid_zval()
	}
	return adopt_read_result_handles(zval.read_class_constant(v.get_string(), name), ownership)
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

pub fn (v ZVal) set_static_prop(name string, value ZVal) {
	if !v.is_valid() || !v.is_string() || !value.is_valid() {
		return
	}
	zval.write_static_property(v.get_string(), name, value.handle())
}
