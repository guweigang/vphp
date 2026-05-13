module vphp

fn call_with_zval_args(args []ZVal, ownership OwnershipKind, run fn (&C.zval, int, &&C.zval) int) ZVal {
	unsafe {
		retval := zend_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}
		res := run(retval, args.len, p_args)
		if res == -1 {
			zend_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, ownership)
	}
}

fn call_method_zval(receiver ZVal, method string, args []ZVal, ownership OwnershipKind) ZVal {
	if receiver.raw == 0 || !receiver.is_object() {
		return invalid_zval()
	}
	return call_with_zval_args(args, ownership, fn [receiver, method] (retval &C.zval, count int, params &&C.zval) int {
		return zend_call_method(receiver, method, retval, count, params)
	})
}

fn call_callable_zval(callable ZVal, args []ZVal, ownership OwnershipKind) ZVal {
	if callable.raw == 0 {
		return invalid_zval()
	}
	return call_with_zval_args(args, ownership, fn [callable] (retval &C.zval, count int, params &&C.zval) int {
		return zend_call_callable(callable, retval, count, params)
	})
}

pub fn (v ZVal) method_owned_request(method string, args []ZVal) ZVal {
	return call_method_zval(v, method, args, .owned_request)
}

pub fn (v ZVal) method_owned_persistent(method string, args []ZVal) ZVal {
	return call_method_zval(v, method, args, .owned_persistent)
}

pub fn (v ZVal) method(method string, args []ZVal) ZVal {
	return v.method_owned_request(method, args)
}

pub fn (v ZVal) call_owned_request(args []ZVal) ZVal {
	if v.raw == 0 {
		framework_debug_log('zval.call_owned_request skip raw=0 args=${args.len}')
		return invalid_zval()
	}
	framework_debug_log('zval.call_owned_request enter raw=${usize(v.raw)} valid=${v.is_valid()} type=${v.type_name()} class=${v.class_name()} args=${args.len}')
	for idx, arg in args {
		framework_debug_log('zval.call_owned_request arg idx=${idx} raw=${usize(arg.raw)} valid=${arg.is_valid()} type=${arg.type_name()} class=${arg.class_name()}')
	}

	result := call_callable_zval(v, args, .owned_request)
	if !result.is_valid() {
		framework_debug_log('zval.call_owned_request failure raw=${usize(v.raw)}')
		return invalid_zval()
	}
	framework_debug_log('zval.call_owned_request exit raw=${usize(v.raw)} retval=${usize(result.raw)} valid=${result.is_valid()} type=${result.type_name()} class=${result.class_name()}')
	return result
}

pub fn (v ZVal) call_owned_persistent(args []ZVal) ZVal {
	return call_callable_zval(v, args, .owned_persistent)
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
