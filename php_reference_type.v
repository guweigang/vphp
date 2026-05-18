module vphp

pub struct PhpReference {
mut:
	value PhpValueZBox
}

pub fn PhpReference.from_zval(z ZVal) ?PhpReference {
	if z.type_id() != .reference {
		return none
	}
	return PhpReference{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpReference.must_from_zval(z ZVal) !PhpReference {
	ref := PhpReference.from_zval(z) or { return error('zval is not reference') }
	return ref
}

pub fn PhpReference.from_request_owned_zbox(value RequestOwnedZBox) ?PhpReference {
	if value.to_zval().type_id() != .reference {
		return none
	}
	return PhpReference{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpReference.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpReference {
	if value.to_zval().type_id() != .reference {
		return none
	}
	return PhpReference{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpReference.from_persistent_zval(z ZVal) ?PhpReference {
	return PhpReference.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (r PhpReference) to_zval() ZVal {
	return r.value.to_zval()
}

pub fn (r PhpReference) to_borrowed() PhpReference {
	return PhpReference.from_zval(r.value.to_borrowed_zbox().to_zval()) or { r }
}

pub fn (r PhpReference) borrowed() PhpReference {
	return r.to_borrowed()
}

pub fn (r PhpReference) borrow() PhpReference {
	return r.to_borrowed()
}

pub fn (r PhpReference) to_borrowed_zbox() RequestBorrowedZBox {
	return r.value.to_borrowed_zbox()
}

pub fn (r PhpReference) to_request_owned() PhpReference {
	return PhpReference.from_request_owned_zbox(r.value.to_request_owned_zbox()) or {
		r.to_borrowed()
	}
}

pub fn (r PhpReference) owned() PhpReference {
	return r.to_request_owned()
}

pub fn (r PhpReference) to_request_owned_zbox() RequestOwnedZBox {
	return r.value.to_request_owned_zbox()
}

pub fn (r PhpReference) to_persistent_owned() PhpReference {
	return PhpReference.from_persistent_owned_zbox(r.value.to_persistent_owned_zbox()) or {
		r.to_borrowed()
	}
}

pub fn (r PhpReference) retain() PhpReference {
	return r.to_persistent_owned()
}

pub fn (r PhpReference) retained() PhpReference {
	return r.to_persistent_owned()
}

pub fn (r PhpReference) to_persistent_owned_zbox() PersistentOwnedZBox {
	return r.value.to_persistent_owned_zbox()
}

pub fn (r PhpReference) is_borrowed() bool {
	return r.value.is_borrowed()
}

pub fn (r PhpReference) is_owned() bool {
	return r.value.is_request_owned()
}

pub fn (r PhpReference) is_retained() bool {
	return r.value.is_retained()
}

pub fn (mut r PhpReference) take_zval() ZVal {
	return r.value.take_zval()
}

pub fn (mut r PhpReference) release() {
	r.value.release()
}

pub fn (r PhpReference) deref() PhpValue {
	value := r.to_zval().reference_value()
	if !value.is_valid() {
		return PhpValue.from_zval(invalid_zval())
	}
	return PhpValue.from_zval(value)
}

pub fn (r PhpReference) set(value ZVal) {
	r.to_zval().set_reference_value(value)
}

pub fn (r PhpReference) set_value(value PhpValue) {
	r.set(value.to_zval())
}
