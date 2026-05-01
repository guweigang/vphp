module vphp

pub struct PhpCallable {
mut:
	callable PhpValueZBox
}

pub fn PhpCallable.from_zval(z ZVal) ?PhpCallable {
	if !z.is_callable() {
		return none
	}
	return PhpCallable{
		callable: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpCallable.borrowed(z ZVal) PhpCallable {
	return PhpCallable{
		callable: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpCallable.must_from_zval(z ZVal) !PhpCallable {
	callable := PhpCallable.from_zval(z) or { return error('zval is not callable') }
	return callable
}

pub fn PhpCallable.from_request_owned_zbox(value RequestOwnedZBox) ?PhpCallable {
	if !value.is_callable() {
		return none
	}
	return PhpCallable{
		callable: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpCallable.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpCallable {
	if !value.is_callable() {
		return none
	}
	return PhpCallable{
		callable: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpCallable.from_persistent_zval(z ZVal) ?PhpCallable {
	return PhpCallable.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (c PhpCallable) to_zval() ZVal {
	return c.callable.to_zval()
}

pub fn (c PhpCallable) to_closure() PhpClosure {
	return PhpClosure{
		callable: c.callable.borrowed()
	}
}

pub fn (c PhpCallable) to_borrowed() PhpCallable {
	return PhpCallable{
		callable: c.callable.borrowed()
	}
}

pub fn (c PhpCallable) to_borrowed_zbox() RequestBorrowedZBox {
	return c.callable.to_borrowed_zbox()
}

pub fn (c PhpCallable) to_persistent_closure() PhpClosure {
	return PhpClosure{
		callable: PhpValueZBox.persistent_owned(PersistentOwnedZBox.of_callable(c.to_zval()))
	}
}

pub fn (c PhpCallable) to_persistent_owned() PhpCallable {
	return PhpCallable.from_persistent_owned_zbox(PersistentOwnedZBox.of_callable(c.to_zval())) or {
		c.to_borrowed()
	}
}

pub fn (c PhpCallable) to_persistent_owned_zbox() PersistentOwnedZBox {
	return PersistentOwnedZBox.of_callable(c.to_zval())
}

pub fn (c PhpCallable) to_request_owned() PhpCallable {
	return PhpCallable.from_request_owned_zbox(c.callable.to_request_owned_zbox()) or { c.to_borrowed() }
}

pub fn (c PhpCallable) to_request_owned_zbox() RequestOwnedZBox {
	return c.callable.to_request_owned_zbox()
}

pub fn (mut c PhpCallable) take_zval() ZVal {
	return c.callable.take_zval()
}

pub fn (mut c PhpCallable) release() {
	c.callable.release()
}

pub fn (c PhpCallable) kind_name() string {
	return c.callable.kind_name()
}

pub fn (c PhpCallable) is_callable() bool {
	return c.to_zval().is_callable()
}

pub fn (c PhpCallable) call_zval(args []ZVal) ZVal {
	return c.to_zval().call(args)
}

pub fn (c PhpCallable) call_owned_request_zval(args []ZVal) ZVal {
	return c.to_zval().call_owned_request(args)
}

pub fn (c PhpCallable) call_owned_persistent_zval(args []ZVal) ZVal {
	return c.to_zval().call_owned_persistent(args)
}

pub fn (c PhpCallable) fn_request_owned_zval(args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(c.call_owned_request_zval(args))
}

pub fn (c PhpCallable) fn_request_owned(args ...PhpFnArg) RequestOwnedZBox {
	return c.fn_request_owned_zval(php_fn_args_to_zvals(args))
}

pub fn (c PhpCallable) call[T](args ...PhpFnArg) !T {
	mut result := c.call_owned_request_zval(php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	return php_fn_copied_result_as[T](result)
}

pub fn (c PhpCallable) with_result[T, R](run fn (T) R, args ...PhpFnArg) !R {
	mut result := c.call_owned_request_zval(php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	value := php_fn_result_as[T](result)!
	return run(value)
}

pub fn (c PhpCallable) with_result_zval[T](run fn (ZVal) T, args ...ZVal) T {
	mut result := c.call_owned_request_zval(args)
	defer {
		result.release()
	}
	return run(result)
}
