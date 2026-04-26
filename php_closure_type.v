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

pub fn (c PhpClosure) call(args []ZVal) ZVal {
	return c.callable.to_zval().call(args)
}

pub fn (c PhpClosure) call_owned_request(args []ZVal) ZVal {
	return c.callable.to_zval().call_owned_request(args)
}

pub fn (c PhpClosure) call_owned_persistent(args []ZVal) ZVal {
	return c.callable.to_zval().call_owned_persistent(args)
}

pub fn (c PhpClosure) invoke(args []ZVal) ZVal {
	return c.call(args)
}

pub fn (c PhpClosure) call_v[T](args []ZVal) !T {
	return c.call(args).to_v[T]()
}

pub fn (c PhpClosure) call_owned_request_v[T](args []ZVal) !T {
	return c.call_owned_request(args).to_v[T]()
}

pub fn (c PhpClosure) call_owned_persistent_v[T](args []ZVal) !T {
	return c.call_owned_persistent(args).to_v[T]()
}

pub fn (c PhpClosure) invoke_v[T](args []ZVal) !T {
	return c.call_v[T](args)
}

pub fn (c PhpClosure) call_object[T](args []ZVal) ?&T {
	return c.call(args).to_object[T]()
}

pub fn (c PhpClosure) call_owned_request_object[T](args []ZVal) ?&T {
	return c.call_owned_request(args).to_object[T]()
}

pub fn (c PhpClosure) call_owned_persistent_object[T](args []ZVal) ?&T {
	return c.call_owned_persistent(args).to_object[T]()
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

pub fn (c PersistentPhpClosure) call_request_owned(args []ZVal) RequestOwnedZBox {
	return c.callable.call_request_owned(args)
}

pub fn (c PersistentPhpClosure) with_call_result[T](args []ZVal, run fn (ZVal) T) T {
	mut result := c.call_request_owned(args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

pub fn (c PersistentPhpClosure) call(args []ZVal) ZVal {
	mut result := c.call_request_owned(args)
	return result.take_zval()
}

pub fn (c PersistentPhpClosure) call_owned_request(args []ZVal) ZVal {
	return c.call(args)
}

pub fn (c PersistentPhpClosure) invoke(args []ZVal) ZVal {
	return c.call(args)
}

pub fn (c PersistentPhpClosure) call_v[T](args []ZVal) !T {
	mut result := c.call_request_owned(args)
	defer {
		result.release()
	}
	return result.to_zval().to_v[T]()
}

pub fn (c PersistentPhpClosure) invoke_v[T](args []ZVal) !T {
	return c.call_v[T](args)
}

pub fn (c PersistentPhpClosure) call_object[T](args []ZVal) ?&T {
	return c.call(args).to_object[T]()
}

pub fn (mut c PersistentPhpClosure) release() {
	c.callable.release()
}
