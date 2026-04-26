module vphp

// ======== PHP interop ========
// 和 `docs/interop.md` 保持一致的分层：
// 1. base actions
// 2. typed value helpers
// 3. typed object helpers
// 4. compatibility aliases

// -------- Base actions --------

// 调用对象方法：$obj->method(args...)
pub fn (v ZVal) method_owned_request(method string, args []ZVal) ZVal {
	if v.raw == 0 || !v.is_object() {
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

		res := C.vphp_call_method(v.raw, &char(method.str), method.len, retval, args.len,
			p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		mut result := adopt_raw_with_ownership(retval, .owned_request)
		if result.is_object() {
			autorelease_forget(result.raw)
		}
		return result
	}
}

pub fn (v ZVal) method_owned_persistent(method string, args []ZVal) ZVal {
	if v.raw == 0 || !v.is_object() {
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
		res := C.vphp_call_method(v.raw, &char(method.str), method.len, retval, args.len,
			p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_persistent)
	}
}

pub fn (v ZVal) method(method string, args []ZVal) ZVal {
	return v.method_owned_request(method, args)
}

// 调用 callable（闭包、匿名函数、函数名字符串等）
pub fn (v ZVal) call_owned_request(args []ZVal) ZVal {
	if v.raw == 0 {
		framework_debug_log('zval.call_owned_request skip raw=0 args=${args.len}')
		return invalid_zval()
	}
	framework_debug_log('zval.call_owned_request enter raw=${usize(v.raw)} valid=${v.is_valid()} type=${v.type_name()} class=${v.class_name()} args=${args.len}')
	for idx, arg in args {
		framework_debug_log('zval.call_owned_request arg idx=${idx} raw=${usize(arg.raw)} valid=${arg.is_valid()} type=${arg.type_name()} class=${arg.class_name()}')
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

		res := C.vphp_call_callable(v.raw, retval, args.len, p_args)
		if res == -1 {
			framework_debug_log('zval.call_owned_request failure raw=${usize(v.raw)} retval=${usize(retval)}')
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		mut result := adopt_raw_with_ownership(retval, .owned_request)
		if result.is_object() {
			autorelease_forget(result.raw)
		}
		framework_debug_log('zval.call_owned_request exit raw=${usize(v.raw)} retval=${usize(result.raw)} valid=${result.is_valid()} type=${result.type_name()} class=${result.class_name()}')
		return result
	}
}

pub fn (v ZVal) call_owned_persistent(args []ZVal) ZVal {
	if v.raw == 0 {
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
		res := C.vphp_call_callable(v.raw, retval, args.len, p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_persistent)
	}
}

pub fn (v ZVal) call(args []ZVal) ZVal {
	return v.call_owned_request(args)
}

pub fn (v ZVal) must_call(args []ZVal) !ZVal {
	callable := v.must_callable()!
	res := callable.call(args)
	if !res.is_valid() {
		return error('callable invocation failed')
	}
	return res
}

pub fn (v ZVal) dup() ZVal {
	if v.raw == 0 {
		return invalid_zval()
	}
	return clone_raw_with_ownership(v.raw, .owned_request)
}

pub fn (mut v ZVal) release() {
	if v.raw == 0 || !v.owned {
		return
	}
	autorelease_forget(v.raw)
	unsafe {
		if v.is_persistent {
			C.vphp_release_zval_persistent(v.raw)
		} else {
			C.vphp_release_zval(v.raw)
		}
	}
	v.raw = unsafe { nil }
	v.owned = false
	v.is_persistent = false
}

pub fn (v ZVal) dup_persistent() ZVal {
	if v.raw == 0 {
		return invalid_zval()
	}
	return clone_raw_with_ownership(v.raw, .owned_persistent)
}

// Duplicate and keep beyond current autorelease scope.
// dup_escaped creates an emalloc'd copy that escapes the current autorelease
// scope. The zval is still request-scoped memory — it will NOT survive across
// PHP requests. Use dup_persistent() for truly long-lived storage.
pub fn (v ZVal) dup_escaped() ZVal {
	mut out := v.dup()
	autorelease_forget(out.raw)
	return out
}

// current_this_owned_request captures the current PHP `$this` object as a
// request-owned ZVal so framework code can safely re-enter user-visible
// methods without hand-constructing object wrappers.
pub fn current_this_owned_request() ZVal {
	unsafe {
		obj_raw := C.vphp_get_current_this_object()
		if obj_raw == 0 {
			return invalid_zval()
		}
		mut out := C.vphp_new_zval()
		if out == 0 {
			return invalid_zval()
		}
		C.vphp_wrap_existing_object(out, &C.zend_object(obj_raw))
		return adopt_raw_with_ownership(out, .owned_request)
	}
}

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
			autorelease_forget(result.raw)
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
			autorelease_forget(result.raw)
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

// 兼容旧命名：建议改用 `.@const(...)`
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
