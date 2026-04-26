module vphp

pub struct PhpClosure {
	callable ZVal
}

pub fn PhpClosure.from_zval(z ZVal) ?PhpClosure {
	if !z.is_callable() {
		return none
	}
	return PhpClosure{
		callable: z
	}
}

pub fn PhpClosure.must_from_zval(z ZVal) !PhpClosure {
	closure := PhpClosure.from_zval(z) or { return error('zval is not callable') }
	return closure
}

pub fn (c PhpClosure) to_zval() ZVal {
	return c.callable
}

pub fn (c PhpClosure) is_callable() bool {
	return c.callable.is_callable()
}

pub fn (c PhpClosure) call(args []ZVal) ZVal {
	return c.callable.call(args)
}

pub fn (c PhpClosure) call_owned_request(args []ZVal) ZVal {
	return c.callable.call_owned_request(args)
}

pub fn (c PhpClosure) call_owned_persistent(args []ZVal) ZVal {
	return c.callable.call_owned_persistent(args)
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
