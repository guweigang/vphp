module vphp

pub fn (o PhpObject) method_zval(method string, args []ZVal) ZVal {
	return o.value.with_request_object[ZVal](fn [method, args] (obj PhpObject) ZVal {
		return obj.to_zval().method(method, args)
	}) or { invalid_zval() }
}

pub fn (o PhpObject) method_owned_request(method string, args []ZVal) ZVal {
	return o.value.with_request_object[ZVal](fn [method, args] (obj PhpObject) ZVal {
		return obj.to_zval().method_owned_request(method, args)
	}) or { invalid_zval() }
}

pub fn (o PhpObject) method_owned_persistent(method string, args []ZVal) ZVal {
	return o.value.with_request_object[ZVal](fn [method, args] (obj PhpObject) ZVal {
		return obj.to_zval().method_owned_persistent(method, args)
	}) or { invalid_zval() }
}

fn (o PhpObject) method_request_owned_zval(method string, args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(o.method_owned_request(method, args))
}

fn (o PhpObject) method_request_owned(method string, args ...PhpArgInput) RequestOwnedZBox {
	return o.method_request_owned_zval(method, php_arg_inputs_to_zvals(args))
}

pub fn (o PhpObject) call_method(method string, args ...PhpArgInput) PhpValue {
	mut result := o.method_request_owned(method, ...args)
	return result.take_value()
}

pub fn (o PhpObject) with_attribute(name string, value PhpArgInput) PhpObject {
	if !o.is_valid() || !o.method_exists('withAttribute') {
		return o.to_request_owned()
	}
	mut name_arg := PhpString.of(name)
	defer {
		name_arg.release()
	}
	mut result := o.call_method('withAttribute', name_arg, value)
	return result.as_object() or {
		result.release()
		o.to_request_owned()
	}
}

pub fn (o PhpObject) method[T](method string, args ...PhpArgInput) !T {
	mut result := o.method_request_owned(method, args)
	defer {
		result.release()
	}
	return php_call_copied_result_as[T](result.to_zval())
}

pub fn (o PhpObject) with_method_result[T, R](method string, run fn (T) R, args ...PhpArgInput) !R {
	mut result := o.method_request_owned(method, args)
	defer {
		result.release()
	}
	value := php_call_result_as[T](result.to_zval())!
	return run(value)
}

pub fn (o PhpObject) with_method_result_zval[T](method string, run fn (ZVal) T, args ...ZVal) T {
	mut result := o.method_request_owned_zval(method, args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

pub fn (o PhpObject) method_v[T](method string, args []ZVal) !T {
	return o.method_zval(method, args).to_v[T]()
}
