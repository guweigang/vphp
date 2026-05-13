module vphp

pub fn (o PhpObject) method_zval(method string, args []vphp.ZVal) ZVal {
	return o.value.with_request_object[ZVal](fn [method, args] (obj PhpObject) ZVal {
		return obj.to_zval().method(method, args)
	}) or { invalid_zval() }
}

pub fn (o PhpObject) method_owned_request(method string, args []vphp.ZVal) ZVal {
	return o.value.with_request_object[ZVal](fn [method, args] (obj PhpObject) ZVal {
		return obj.to_zval().method_owned_request(method, args)
	}) or { invalid_zval() }
}

pub fn (o PhpObject) method_owned_persistent(method string, args []vphp.ZVal) ZVal {
	return o.value.with_request_object[ZVal](fn [method, args] (obj PhpObject) ZVal {
		return obj.to_zval().method_owned_persistent(method, args)
	}) or { invalid_zval() }
}

pub fn (o PhpObject) method_request_owned_zval(method string, args []vphp.ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(o.method_owned_request(method, args))
}

pub fn (o PhpObject) method_request_owned(method string, args ...PhpArgInput) RequestOwnedZBox {
	return o.method_request_owned_zval(method, php_arg_inputs_to_zvals(args))
}

pub fn (o PhpObject) method[T](method string, args ...PhpArgInput) !T {
	mut result := o.method_owned_request(method, php_arg_inputs_to_zvals(args))
	defer {
		result.release()
	}
	return php_call_copied_result_as[T](result)
}

pub fn (o PhpObject) with_method_result[T, R](method string, run fn (T) R, args ...PhpArgInput) !R {
	mut result := o.method_owned_request(method, php_arg_inputs_to_zvals(args))
	defer {
		result.release()
	}
	value := php_call_result_as[T](result)!
	return run(value)
}

pub fn (o PhpObject) with_method_result_zval[T](method string, run fn (ZVal) T, args ...ZVal) T {
	mut result := o.method_owned_request(method, args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn (o PhpObject) method_v[T](method string, args []vphp.ZVal) !T {
	return o.method_zval(method, args).to_v[T]()
}
