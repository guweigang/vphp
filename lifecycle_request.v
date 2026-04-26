module vphp

pub fn with_call_result_zval[T](callable ZVal, args []ZVal, run fn (ZVal) T) T {
	mut result := callable.call_owned_request(args)
	defer {
		result.release()
	}
	return run(result)
}

// with_php_call_result_zval mirrors with_call_result_zval for global PHP
// functions. Callers inspect the transient result inside the callback instead
// of carrying a bare request-owned ZVal through outer scopes.
pub fn with_php_call_result_zval[T](name string, args []ZVal, run fn (ZVal) T) T {
	return with_call_result_zval(php_fn(name), args, run)
}

pub fn php_call_result_string(name string, args []ZVal) string {
	return with_php_call_result_zval(name, args, fn (z ZVal) string {
		return z.to_string()
	})
}

pub fn php_call_result_bool(name string, args []ZVal) bool {
	return with_php_call_result_zval(name, args, fn (z ZVal) bool {
		return z.to_bool()
	})
}

pub fn php_call_result_i64(name string, args []ZVal) i64 {
	return with_php_call_result_zval(name, args, fn (z ZVal) i64 {
		return z.to_i64()
	})
}

pub fn call_request_owned_box(callable ZVal, args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(callable.call_owned_request(args))
}

// php_call_request_owned_box is the global-function counterpart to
// call_request_owned_box. Prefer this or with_php_call_result_zval over
// exposing a bare request-owned ZVal to callers.
pub fn php_call_request_owned_box(name string, args []ZVal) RequestOwnedZBox {
	return call_request_owned_box(php_fn(name), args)
}

pub fn with_method_result_zval[T](receiver ZVal, method string, args []ZVal, run fn (ZVal) T) T {
	mut result := receiver.method_owned_request(method, args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn method_request_owned_box(receiver ZVal, method string, args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(receiver.method_owned_request(method, args))
}

pub fn (v RequestBorrowedZBox) clone_request_owned() RequestOwnedZBox {
	return own_request_zbox_raw(v.z)
}

pub fn (v RequestBorrowedZBox) clone() PersistentOwnedZBox {
	return own_persistent_zbox_raw(v.z)
}

pub fn (v RequestOwnedZBox) borrowed() RequestBorrowedZBox {
	return borrow_zbox_raw(v.z)
}

pub fn (v RequestOwnedZBox) clone() PersistentOwnedZBox {
	return own_persistent_zbox_raw(v.z)
}

pub fn (v RequestOwnedZBox) to_persistent() PersistentOwnedZBox {
	return v.clone()
}

pub fn (v RequestOwnedZBox) clone_request_owned() RequestOwnedZBox {
	return own_request_zbox_raw(v.z)
}

pub fn (v RequestOwnedZBox) with_zval[T](run fn (ZVal) T) T {
	return run(v.z)
}

pub fn (mut v RequestOwnedZBox) take_zval() ZVal {
	out := v.z
	v.z = invalid_zval()
	return out
}

pub fn (mut v RequestOwnedZBox) release() {
	v.z.release()
}
