module vphp

pub fn php_call_result_string(name string, args []ZVal) string {
	return PhpFunction.named(name).result_string(args)
}

pub fn (f PhpFunction) result_string(args []ZVal) string {
	return f.with_result_zval(args, fn (z ZVal) string {
		return z.to_string()
	})
}

pub fn php_call_result_bool(name string, args []ZVal) bool {
	return PhpFunction.named(name).result_bool(args)
}

pub fn (f PhpFunction) result_bool(args []ZVal) bool {
	return f.with_result_zval(args, fn (z ZVal) bool {
		return z.to_bool()
	})
}

pub fn php_call_result_i64(name string, args []ZVal) i64 {
	return PhpFunction.named(name).result_i64(args)
}

pub fn (f PhpFunction) result_i64(args []ZVal) i64 {
	return f.with_result_zval(args, fn (z ZVal) i64 {
		return z.to_i64()
	})
}

pub fn php_call_result_double(name string, args []ZVal) f64 {
	return PhpFunction.named(name).result_double(args)
}

pub fn (f PhpFunction) result_double(args []ZVal) f64 {
	return f.with_result_zval(args, fn (z ZVal) f64 {
		return z.to_f64()
	})
}

pub fn (v RequestBorrowedZBox) clone_request_owned() RequestOwnedZBox {
	return RequestOwnedZBox.from_raw_zval(v.z)
}

pub fn (v RequestBorrowedZBox) clone() PersistentOwnedZBox {
	return PersistentOwnedZBox.from_raw_zval(v.z)
}

pub fn (v RequestOwnedZBox) borrowed() RequestBorrowedZBox {
	return RequestBorrowedZBox.from_raw_zval(v.z)
}

pub fn (v RequestOwnedZBox) clone() PersistentOwnedZBox {
	return PersistentOwnedZBox.from_raw_zval(v.z)
}

pub fn (v RequestOwnedZBox) to_persistent() PersistentOwnedZBox {
	return v.clone()
}

pub fn (v RequestOwnedZBox) clone_request_owned() RequestOwnedZBox {
	return RequestOwnedZBox.from_raw_zval(v.z)
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
