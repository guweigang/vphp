module vphp

// -------- Typed value helpers --------
// 本质上是 `base action + to_v[T]()` 的语法糖。

pub fn (v ZVal) call_v[T](args []ZVal) !T {
	return v.call(args).to_v[T]()
}

pub fn (v ZVal) call_owned_request_v[T](args []ZVal) !T {
	return v.call_owned_request(args).to_v[T]()
}

pub fn (v ZVal) call_owned_persistent_v[T](args []ZVal) !T {
	return v.call_owned_persistent(args).to_v[T]()
}

pub fn (v ZVal) invoke_v[T](args []ZVal) !T {
	return v.invoke(args).to_v[T]()
}

pub fn (v ZVal) invoke_owned_request_v[T](args []ZVal) !T {
	return v.call_owned_request_v[T](args)
}

pub fn (v ZVal) invoke_owned_persistent_v[T](args []ZVal) !T {
	return v.call_owned_persistent_v[T](args)
}

pub fn (v ZVal) construct_v[T](args []ZVal) !T {
	return v.construct(args).to_v[T]()
}

pub fn (v ZVal) construct_owned_request_v[T](args []ZVal) !T {
	return v.construct_owned_request(args).to_v[T]()
}

pub fn (v ZVal) construct_owned_persistent_v[T](args []ZVal) !T {
	return v.construct_owned_persistent(args).to_v[T]()
}

pub fn (v ZVal) method_v[T](method string, args []ZVal) !T {
	return v.method(method, args).to_v[T]()
}

pub fn (v ZVal) method_owned_request_v[T](method string, args []ZVal) !T {
	return v.method_owned_request(method, args).to_v[T]()
}

pub fn (v ZVal) method_owned_persistent_v[T](method string, args []ZVal) !T {
	return v.method_owned_persistent(method, args).to_v[T]()
}

pub fn (v ZVal) prop_v[T](name string) !T {
	return v.prop(name).to_v[T]()
}

pub fn (v ZVal) prop_borrowed_v[T](name string) !T {
	return v.prop_borrowed(name).to_v[T]()
}

pub fn (v ZVal) prop_owned_request_v[T](name string) !T {
	return v.prop_owned_request(name).to_v[T]()
}

pub fn (v ZVal) prop_owned_persistent_v[T](name string) !T {
	return v.prop_owned_persistent(name).to_v[T]()
}

pub fn (v ZVal) static_prop_v[T](name string) !T {
	return v.static_prop(name).to_v[T]()
}

pub fn (v ZVal) static_prop_borrowed_v[T](name string) !T {
	return v.static_prop_borrowed(name).to_v[T]()
}

pub fn (v ZVal) static_prop_owned_request_v[T](name string) !T {
	return v.static_prop_owned_request(name).to_v[T]()
}

pub fn (v ZVal) static_prop_owned_persistent_v[T](name string) !T {
	return v.static_prop_owned_persistent(name).to_v[T]()
}

pub fn (v ZVal) const_v[T](name string) !T {
	return v.@const(name).to_v[T]()
}

pub fn (v ZVal) const_borrowed_v[T](name string) !T {
	return v.const_borrowed(name).to_v[T]()
}

pub fn (v ZVal) const_owned_request_v[T](name string) !T {
	return v.const_owned_request(name).to_v[T]()
}

pub fn (v ZVal) const_owned_persistent_v[T](name string) !T {
	return v.const_owned_persistent(name).to_v[T]()
}

pub fn (v ZVal) static_method_v[T](method string, args []ZVal) !T {
	return v.static_method(method, args).to_v[T]()
}

pub fn (v ZVal) static_method_owned_request_v[T](method string, args []ZVal) !T {
	return v.static_method_owned_request(method, args).to_v[T]()
}

pub fn (v ZVal) static_method_owned_persistent_v[T](method string, args []ZVal) !T {
	return v.static_method_owned_persistent(method, args).to_v[T]()
}

// -------- Typed object helpers --------
// 只对 `vphp` 导出的对象有意义，
// 本质上是 `base action + to_object[T]()` 的语法糖。

pub fn (v ZVal) call_object[T](args []ZVal) ?&T {
	return v.call(args).to_object[T]()
}

pub fn (v ZVal) call_owned_request_object[T](args []ZVal) ?&T {
	return v.call_owned_request(args).to_object[T]()
}

pub fn (v ZVal) call_owned_persistent_object[T](args []ZVal) ?&T {
	return v.call_owned_persistent(args).to_object[T]()
}

pub fn (v ZVal) method_object[T](method string, args []ZVal) ?&T {
	return v.method(method, args).to_object[T]()
}

pub fn (v ZVal) method_owned_request_object[T](method string, args []ZVal) ?&T {
	return v.method_owned_request(method, args).to_object[T]()
}

pub fn (v ZVal) method_owned_persistent_object[T](method string, args []ZVal) ?&T {
	return v.method_owned_persistent(method, args).to_object[T]()
}

pub fn (v ZVal) prop_object[T](name string) ?&T {
	return v.prop(name).to_object[T]()
}

pub fn (v ZVal) prop_borrowed_object[T](name string) ?&T {
	return v.prop_borrowed(name).to_object[T]()
}

pub fn (v ZVal) prop_owned_request_object[T](name string) ?&T {
	return v.prop_owned_request(name).to_object[T]()
}

pub fn (v ZVal) prop_owned_persistent_object[T](name string) ?&T {
	return v.prop_owned_persistent(name).to_object[T]()
}

pub fn (v ZVal) construct_object[T](args []ZVal) ?&T {
	return v.construct(args).to_object[T]()
}

pub fn (v ZVal) construct_owned_request_object[T](args []ZVal) ?&T {
	return v.construct_owned_request(args).to_object[T]()
}

pub fn (v ZVal) construct_owned_persistent_object[T](args []ZVal) ?&T {
	return v.construct_owned_persistent(args).to_object[T]()
}

pub fn (v ZVal) static_method_object[T](method string, args []ZVal) ?&T {
	return v.static_method(method, args).to_object[T]()
}

pub fn (v ZVal) static_method_owned_request_object[T](method string, args []ZVal) ?&T {
	return v.static_method_owned_request(method, args).to_object[T]()
}

pub fn (v ZVal) static_method_owned_persistent_object[T](method string, args []ZVal) ?&T {
	return v.static_method_owned_persistent(method, args).to_object[T]()
}

// 兼容旧命名：建议改用 `.const_v[T](...)`
pub fn (v ZVal) constant_v[T](name string) !T {
	return v.const_v[T](name)
}

// -------- Compatibility aliases --------

// 兼容旧 API：对象方法调用
pub fn (v ZVal) call_method(method string, args []ZVal) ZVal {
	return v.method(method, args)
}

// 兼容旧 API：callable 调用
pub fn (v ZVal) invoke(args []ZVal) ZVal {
	return v.call(args)
}
