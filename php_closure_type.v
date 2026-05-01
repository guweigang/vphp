module vphp

pub struct PhpClosure {
mut:
	callable PhpValueZBox
}

pub fn PhpClosure.from_zval(z ZVal) ?PhpClosure {
	if !z.is_callable() {
		return none
	}
	return PhpClosure{
		callable: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpClosure.must_from_zval(z ZVal) !PhpClosure {
	closure := PhpClosure.from_zval(z) or { return error('zval is not callable') }
	return closure
}

pub fn PhpClosure.from_request_owned_zbox(value RequestOwnedZBox) ?PhpClosure {
	if !value.is_callable() {
		return none
	}
	return PhpClosure{
		callable: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpClosure.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpClosure {
	if !value.is_callable() {
		return none
	}
	return PhpClosure{
		callable: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpClosure.from_persistent_zval(z ZVal) ?PhpClosure {
	return PhpClosure.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (c PhpClosure) to_persistent_owned() PhpClosure {
	return PhpClosure{
		callable: PhpValueZBox.persistent_owned(PersistentOwnedZBox.of_callable(c.callable.to_zval()))
	}
}

pub fn (c PhpClosure) to_persistent_owned_zbox() PersistentOwnedZBox {
	return PersistentOwnedZBox.of_callable(c.callable.to_zval())
}

pub fn (c PhpClosure) to_borrowed() PhpClosure {
	return PhpClosure{
		callable: c.callable.borrowed()
	}
}

pub fn (c PhpClosure) to_borrowed_zbox() RequestBorrowedZBox {
	return c.callable.to_borrowed_zbox()
}

pub fn (c PhpClosure) to_request_owned() PhpClosure {
	return PhpClosure.from_request_owned_zbox(c.callable.to_request_owned_zbox()) or { c.to_borrowed() }
}

pub fn (c PhpClosure) to_request_owned_zbox() RequestOwnedZBox {
	return c.callable.to_request_owned_zbox()
}

pub fn (mut c PhpClosure) take_zval() ZVal {
	return c.callable.take_zval()
}

pub fn (c PhpClosure) to_zval() ZVal {
	return c.callable.to_zval()
}

pub fn (c PhpClosure) is_callable() bool {
	return c.to_zval().is_callable()
}

pub fn (c PhpClosure) call_zval(args []ZVal) ZVal {
	return c.callable.with_request_callable[ZVal](fn [args] (callable PhpCallable) ZVal {
		return callable.to_zval().call(args)
	}) or { invalid_zval() }
}

pub fn (c PhpClosure) call_owned_request_zval(args []ZVal) ZVal {
	return c.callable.with_request_callable[ZVal](fn [args] (callable PhpCallable) ZVal {
		return callable.to_zval().call_owned_request(args)
	}) or { invalid_zval() }
}

pub fn (c PhpClosure) call_owned_persistent_zval(args []ZVal) ZVal {
	return c.callable.with_request_callable[ZVal](fn [args] (callable PhpCallable) ZVal {
		return callable.to_zval().call_owned_persistent(args)
	}) or { invalid_zval() }
}

pub fn (c PhpClosure) fn_request_owned_zval(args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(c.call_owned_request_zval(args))
}

pub fn (c PhpClosure) fn_request_owned(args ...PhpFnArg) RequestOwnedZBox {
	return c.fn_request_owned_zval(php_fn_args_to_zvals(args))
}

pub fn (c PhpClosure) call[T](args ...PhpFnArg) !T {
	mut result := c.call_owned_request_zval(php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	return php_fn_copied_result_as[T](result)
}

pub fn (c PhpClosure) with_result[T, R](run fn (T) R, args ...PhpFnArg) !R {
	mut result := c.call_owned_request_zval(php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	value := php_fn_result_as[T](result)!
	return run(value)
}

pub fn (c PhpClosure) with_result_zval[T](run fn (ZVal) T, args ...ZVal) T {
	mut result := c.call_owned_request_zval(args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn (c PhpClosure) kind_name() string {
	return c.callable.kind_name()
}

pub fn (c PhpClosure) clone() PhpClosure {
	return PhpClosure{
		callable: c.callable.clone()
	}
}

pub fn (c PhpClosure) clone_request_owned() RequestOwnedZBox {
	return c.to_request_owned_zbox()
}

pub fn (c PhpClosure) with_fn_result_zval[T](run fn (ZVal) T, args ...ZVal) T {
	mut result := c.call_owned_request_zval(args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn (mut c PhpClosure) release() {
	c.callable.release()
}
