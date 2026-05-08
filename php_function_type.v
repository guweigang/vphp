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

pub fn (f PhpFunction) call_zval(args []vphp.ZVal) ZVal {
	return f.to_zval().call(args)
}

pub fn (f PhpFunction) call_owned_request_zval(args []vphp.ZVal) ZVal {
	return f.to_zval().call_owned_request(args)
}

pub fn (f PhpFunction) call_owned_persistent_zval(args []vphp.ZVal) ZVal {
	return f.to_zval().call_owned_persistent(args)
}

pub fn (f PhpFunction) request_owned_zval(args []vphp.ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(f.call_owned_request_zval(args))
}

pub fn (f PhpFunction) request_owned(args ...PhpArgInput) RequestOwnedZBox {
	return f.request_owned_zval(php_arg_inputs_to_zvals(args))
}

pub fn (f PhpFunction) call[T](args ...PhpArgInput) !T {
	mut result := f.call_owned_request_zval(php_arg_inputs_to_zvals(args))
	defer {
		result.release()
	}
	return php_call_copied_result_as[T](result)
}

pub fn (f PhpFunction) with_result[T, R](run fn (T) R, args ...PhpArgInput) !R {
	mut result := f.call_owned_request_zval(php_arg_inputs_to_zvals(args))
	defer {
		result.release()
	}
	value := php_call_result_as[T](result)!
	return run(value)
}

pub fn (f PhpFunction) with_result_zval[T](run fn (ZVal) T, args ...ZVal) T {
	mut result := f.call_owned_request_zval(args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn (f PhpFunction) result_string(args ...PhpArgInput) string {
	return f.with_result_zval(fn (z ZVal) string {
		return z.to_string()
	}, ...php_arg_inputs_to_zvals(args))
}

pub fn (f PhpFunction) result_bool(args ...PhpArgInput) bool {
	return f.with_result_zval(fn (z ZVal) bool {
		return z.to_bool()
	}, ...php_arg_inputs_to_zvals(args))
}

pub fn (f PhpFunction) result_i64(args ...PhpArgInput) i64 {
	return f.with_result_zval(fn (z ZVal) i64 {
		return z.to_i64()
	}, ...php_arg_inputs_to_zvals(args))
}

pub fn (f PhpFunction) result_double(args ...PhpArgInput) f64 {
	return f.with_result_zval(fn (z ZVal) f64 {
		return z.to_f64()
	}, ...php_arg_inputs_to_zvals(args))
}
