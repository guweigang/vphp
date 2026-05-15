module vphp

import vphp.zval as zvalmod

fn call_zval_target(target ZendCallTarget, args []vphp.ZVal, ownership OwnershipKind) ZVal {
	mut handles := []zvalmod.Handle{cap: args.len}
	for arg in args {
		handles << arg.handle()
	}
	return zvalmod.with_call_args[ZVal](handles, fn [target, ownership] (count int, params voidptr) ZVal {
		retval := request_raw_zval()
		res := invoke_zval_call_target(target, retval, count, params)
		if res == -1 {
			release_request_raw_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, ownership)
	})
}

fn call_method_zval(receiver ZVal, method string, args []vphp.ZVal, ownership OwnershipKind) ZVal {
	if !receiver.is_valid() || !receiver.is_object() {
		return invalid_zval()
	}
	return call_zval_target(ZendMethodCall{
		receiver: receiver
		method:   method
	}, args, ownership)
}

fn call_callable_zval(callable ZVal, args []vphp.ZVal, ownership OwnershipKind) ZVal {
	if !callable.is_valid() {
		return invalid_zval()
	}
	return call_zval_target(ZendCallableCall{
		callable: callable
	}, args, ownership)
}

pub fn (v ZVal) method_owned_request(method string, args []vphp.ZVal) ZVal {
	return call_method_zval(v, method, args, .owned_request)
}

pub fn (v ZVal) method_owned_persistent(method string, args []vphp.ZVal) ZVal {
	return call_method_zval(v, method, args, .owned_persistent)
}

pub fn (v ZVal) method(method string, args []vphp.ZVal) ZVal {
	return v.method_owned_request(method, args)
}

pub fn (v ZVal) call_owned_request(args []vphp.ZVal) ZVal {
	if !v.is_valid() {
		framework_debug_log('zval.call_owned_request skip raw=0 args=${args.len}')
		return invalid_zval()
	}
	framework_debug_log('zval.call_owned_request enter raw=${usize(v.raw_ptr())} valid=${v.is_valid()} type=${v.type_name()} class=${v.class_name()} args=${args.len}')
	for idx, arg in args {
		framework_debug_log('zval.call_owned_request arg idx=${idx} raw=${usize(arg.raw_ptr())} valid=${arg.is_valid()} type=${arg.type_name()} class=${arg.class_name()}')
	}

	result := call_callable_zval(v, args, .owned_request)
	if !result.is_valid() {
		framework_debug_log('zval.call_owned_request failure raw=${usize(v.raw_ptr())}')
		return invalid_zval()
	}
	framework_debug_log('zval.call_owned_request exit raw=${usize(v.raw_ptr())} retval=${usize(result.raw_ptr())} valid=${result.is_valid()} type=${result.type_name()} class=${result.class_name()}')
	return result
}

pub fn (v ZVal) call_owned_persistent(args []vphp.ZVal) ZVal {
	return call_callable_zval(v, args, .owned_persistent)
}

pub fn (v ZVal) call(args []vphp.ZVal) ZVal {
	return v.call_owned_request(args)
}

pub fn (v ZVal) must_call(args []vphp.ZVal) !ZVal {
	callable := v.must_callable()!
	res := callable.call(args)
	if !res.is_valid() {
		return error('callable invocation failed')
	}
	return res
}
