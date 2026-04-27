module vphp

pub struct PhpFunction {
	fn_name string
}

pub fn PhpFunction.named(name string) PhpFunction {
	return PhpFunction{
		fn_name: name
	}
}

pub fn PhpFunction.find(name string) ?PhpFunction {
	if !function_exists(name) {
		return none
	}
	return PhpFunction.named(name)
}

pub fn (f PhpFunction) name() string {
	return f.fn_name
}

pub fn (f PhpFunction) to_zval() ZVal {
	return ZVal.new_string(f.fn_name)
}

pub fn (f PhpFunction) exists() bool {
	res := ZVal.new_string('function_exists').call([ZVal.new_string(f.fn_name)])
	return res.is_valid() && res.to_bool()
}

pub fn (f PhpFunction) call(args []ZVal) ZVal {
	return f.to_zval().call(args)
}

pub fn (f PhpFunction) call_owned_request(args []ZVal) ZVal {
	return f.to_zval().call_owned_request(args)
}

pub fn (f PhpFunction) call_owned_persistent(args []ZVal) ZVal {
	return f.to_zval().call_owned_persistent(args)
}

pub fn (f PhpFunction) request_owned_box(args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(f.call_owned_request(args))
}

pub fn (f PhpFunction) invoke(args []ZVal) ZVal {
	return f.call(args)
}

pub fn (f PhpFunction) with_result_zval[T](args []ZVal, run fn (ZVal) T) T {
	mut result := f.call_owned_request(args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn (f PhpFunction) call_v[T](args []ZVal) !T {
	return f.call(args).to_v[T]()
}

pub fn (f PhpFunction) call_owned_request_v[T](args []ZVal) !T {
	return f.call_owned_request(args).to_v[T]()
}

pub fn (f PhpFunction) call_owned_persistent_v[T](args []ZVal) !T {
	return f.call_owned_persistent(args).to_v[T]()
}

pub fn (f PhpFunction) invoke_v[T](args []ZVal) !T {
	return f.call_v[T](args)
}

pub fn (f PhpFunction) call_object[T](args []ZVal) ?&T {
	return f.call(args).to_object[T]()
}

pub fn (f PhpFunction) call_owned_request_object[T](args []ZVal) ?&T {
	return f.call_owned_request(args).to_object[T]()
}

pub fn (f PhpFunction) call_owned_persistent_object[T](args []ZVal) ?&T {
	return f.call_owned_persistent(args).to_object[T]()
}
