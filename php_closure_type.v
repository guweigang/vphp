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

pub fn PhpClosure.from_request_borrowed_zbox(value RequestBorrowedZBox) ?PhpClosure {
	if !value.is_callable() {
		return none
	}
	return PhpClosure{
		callable: PhpValueZBox.borrowed(value)
	}
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

pub fn (c PhpClosure) retain() PhpClosure {
	return c.to_persistent_owned()
}

pub fn (c PhpClosure) retained() PhpClosure {
	return c.to_persistent_owned()
}

pub fn (c PhpClosure) to_persistent_owned_zbox() PersistentOwnedZBox {
	return PersistentOwnedZBox.of_callable(c.callable.to_zval())
}

pub fn (c PhpClosure) to_borrowed() PhpClosure {
	return PhpClosure{
		callable: c.callable.borrowed()
	}
}

pub fn (c PhpClosure) borrowed() PhpClosure {
	return c.to_borrowed()
}

pub fn (c PhpClosure) borrow() PhpClosure {
	return c.to_borrowed()
}

pub fn (c PhpClosure) to_borrowed_zbox() RequestBorrowedZBox {
	return c.callable.to_borrowed_zbox()
}

pub fn (c PhpClosure) to_request_owned() PhpClosure {
	return PhpClosure.from_request_owned_zbox(c.callable.to_request_owned_zbox()) or {
		c.to_borrowed()
	}
}

pub fn (c PhpClosure) owned() PhpClosure {
	return c.to_request_owned()
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

fn (c PhpClosure) request_owned_zval(args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(c.call_owned_request_zval(args))
}

fn (c PhpClosure) request_owned(args ...PhpArgInput) RequestOwnedZBox {
	return c.request_owned_zval(php_arg_inputs_to_zvals(args))
}

pub fn (c PhpClosure) invoke(args ...PhpArgInput) PhpValue {
	mut result := c.request_owned(args)
	return result.take_value()
}

pub fn (c PhpClosure) call[T](args ...PhpArgInput) !T {
	mut result := c.request_owned(args)
	defer {
		result.release()
	}
	return php_call_copied_result_as[T](result.to_zval())
}

pub fn (c PhpClosure) with_result[T, R](run fn (T) R, args ...PhpArgInput) !R {
	mut result := c.request_owned(args)
	defer {
		result.release()
	}
	value := php_call_result_as[T](result.to_zval())!
	return run(value)
}

pub fn (c PhpClosure) with_result_zval[T](run fn (ZVal) T, args ...ZVal) T {
	mut result := c.request_owned_zval(args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

pub fn (c PhpClosure) kind_name() string {
	return c.callable.kind_name()
}

pub fn (c PhpClosure) is_borrowed() bool {
	return c.callable.is_borrowed()
}

pub fn (c PhpClosure) is_owned() bool {
	return c.callable.is_request_owned()
}

pub fn (c PhpClosure) is_retained() bool {
	return c.callable.is_retained()
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
	mut result := c.request_owned_zval(args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

pub fn (mut c PhpClosure) release() {
	c.callable.release()
}
