module vphp

pub struct PhpClosure {
	callable RequestBorrowedZBox
}

pub struct PersistentPhpClosure {
mut:
	callable PersistentOwnedZBox
}

pub fn PhpClosure.from_zval(z ZVal) ?PhpClosure {
	if !z.is_callable() {
		return none
	}
	return PhpClosure{
		callable: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PersistentPhpClosure.from_zval(z ZVal) ?PersistentPhpClosure {
	if !z.is_callable() {
		return none
	}
	return PersistentPhpClosure{
		callable: PersistentOwnedZBox.of_callable(z)
	}
}

pub fn PersistentPhpClosure.must_from_zval(z ZVal) !PersistentPhpClosure {
	closure := PersistentPhpClosure.from_zval(z) or { return error('zval is not callable') }
	return closure
}

pub fn PhpClosure.must_from_zval(z ZVal) !PhpClosure {
	closure := PhpClosure.from_zval(z) or { return error('zval is not callable') }
	return closure
}

pub fn (c PhpClosure) to_persistent() PersistentPhpClosure {
	return PersistentPhpClosure{
		callable: PersistentOwnedZBox.of_callable(c.callable.to_zval())
	}
}

pub fn (c PhpClosure) to_zval() ZVal {
	return c.callable.to_zval()
}

pub fn (c PhpClosure) is_callable() bool {
	return c.callable.is_callable()
}

pub fn (c PhpClosure) call_zval(args []ZVal) ZVal {
	return c.callable.to_zval().call(args)
}

pub fn (c PhpClosure) call_owned_request_zval(args []ZVal) ZVal {
	return c.callable.to_zval().call_owned_request(args)
}

pub fn (c PhpClosure) call_owned_persistent_zval(args []ZVal) ZVal {
	return c.callable.to_zval().call_owned_persistent(args)
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

pub fn (c PersistentPhpClosure) kind_name() string {
	return c.callable.kind_name()
}

pub fn (c PersistentPhpClosure) is_callable() bool {
	return c.callable.is_callable()
}

pub fn (c PersistentPhpClosure) clone() PersistentPhpClosure {
	return PersistentPhpClosure{
		callable: c.callable.clone()
	}
}

pub fn (c PersistentPhpClosure) clone_request_owned() RequestOwnedZBox {
	return c.callable.clone_request_owned()
}

pub fn (mut c PersistentPhpClosure) take_owned_box() PersistentOwnedZBox {
	box := c.callable
	c.callable = PersistentOwnedZBox.new_null()
	return box
}

pub fn (c PersistentPhpClosure) fn_request_owned_zval(args []ZVal) RequestOwnedZBox {
	return c.callable.fn_request_owned_zval(args)
}

pub fn (c PersistentPhpClosure) fn_request_owned(args ...PhpFnArg) RequestOwnedZBox {
	return c.fn_request_owned_zval(php_fn_args_to_zvals(args))
}

pub fn (c PersistentPhpClosure) with_fn_result_zval[T](run fn (ZVal) T, args ...ZVal) T {
	mut result := c.fn_request_owned_zval(args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

pub fn (c PersistentPhpClosure) call[T](args ...PhpFnArg) !T {
	mut result := c.fn_request_owned_zval(php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	return php_fn_copied_result_as[T](result.to_zval())
}

pub fn (c PersistentPhpClosure) with_result[T, R](run fn (T) R, args ...PhpFnArg) !R {
	mut result := c.fn_request_owned_zval(php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	value := php_fn_result_as[T](result.to_zval())!
	return run(value)
}

pub fn (c PersistentPhpClosure) call_zval(args []ZVal) ZVal {
	mut result := c.fn_request_owned_zval(args)
	return result.take_zval()
}

pub fn (c PersistentPhpClosure) call_owned_request_zval(args []ZVal) ZVal {
	return c.call_zval(args)
}

pub fn (mut c PersistentPhpClosure) release() {
	c.callable.release()
}
