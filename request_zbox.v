module vphp

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

pub fn (v RequestOwnedZBox) to_persistent_owned_zbox() PersistentOwnedZBox {
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
