module vphp

pub struct PhpCallable {
	callable RequestBorrowedZBox
}

pub fn PhpCallable.from_zval(z ZVal) ?PhpCallable {
	if !z.is_callable() {
		return none
	}
	return PhpCallable{
		callable: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpCallable.borrowed(z ZVal) PhpCallable {
	return PhpCallable{
		callable: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpCallable.must_from_zval(z ZVal) !PhpCallable {
	callable := PhpCallable.from_zval(z) or { return error('zval is not callable') }
	return callable
}

pub fn (c PhpCallable) to_zval() ZVal {
	return c.callable.to_zval()
}

pub fn (c PhpCallable) to_closure() PhpClosure {
	return PhpClosure{
		callable: RequestBorrowedZBox.from_zval(c.to_zval())
	}
}

pub fn (c PhpCallable) to_persistent() PersistentPhpClosure {
	return PersistentPhpClosure{
		callable: PersistentOwnedZBox.of_callable(c.to_zval())
	}
}

pub fn (c PhpCallable) is_callable() bool {
	return c.callable.is_callable()
}

pub fn (c PhpCallable) call(args []ZVal) ZVal {
	return c.to_zval().call(args)
}

pub fn (c PhpCallable) call_owned_request(args []ZVal) ZVal {
	return c.to_zval().call_owned_request(args)
}

pub fn (c PhpCallable) call_owned_persistent(args []ZVal) ZVal {
	return c.to_zval().call_owned_persistent(args)
}

pub fn (c PhpCallable) request_owned_box(args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(c.call_owned_request(args))
}

pub fn (c PhpCallable) invoke(args []ZVal) ZVal {
	return c.call(args)
}

pub fn (c PhpCallable) with_result_zval[T](args []ZVal, run fn (ZVal) T) T {
	mut result := c.call_owned_request(args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn (c PhpCallable) call_v[T](args []ZVal) !T {
	return c.call(args).to_v[T]()
}

pub fn (c PhpCallable) invoke_v[T](args []ZVal) !T {
	return c.call_v[T](args)
}
