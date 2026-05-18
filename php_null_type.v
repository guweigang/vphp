module vphp

pub struct PhpNull {
mut:
	value PhpValueZBox
}

pub fn PhpNull.from_zval(z ZVal) ?PhpNull {
	if !z.is_null() && !z.is_undef() {
		return none
	}
	return PhpNull{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpNull.must_from_zval(z ZVal) !PhpNull {
	value := PhpNull.from_zval(z) or { return error('zval is not null') }
	return value
}

pub fn PhpNull.from_request_owned_zbox(value RequestOwnedZBox) ?PhpNull {
	if !value.is_null() && !value.is_undef() {
		return none
	}
	return PhpNull{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpNull.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpNull {
	if !value.is_null() && !value.is_undef() {
		return none
	}
	return PhpNull{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpNull.from_persistent_zval(z ZVal) ?PhpNull {
	return PhpNull.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn PhpNull.value() PhpNull {
	return PhpNull{
		value: PhpValueZBox.request_owned(RequestOwnedZBox.new_null())
	}
}

pub fn (v PhpNull) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpNull) to_value() PhpValue {
	return PhpValue{
		value: v.value.clone()
	}
}

pub fn (v PhpNull) is_null() bool {
	return true
}

pub fn (mut v PhpNull) take_value() PhpValue {
	return PhpValue.adopt_zval(v.take_zval())
}

pub fn (v PhpNull) to_borrowed() PhpNull {
	return PhpNull.from_zval(v.value.to_borrowed_zbox().to_zval()) or { v }
}

pub fn (v PhpNull) borrowed() PhpNull {
	return v.to_borrowed()
}

pub fn (v PhpNull) borrow() PhpNull {
	return v.to_borrowed()
}

pub fn (v PhpNull) to_borrowed_zbox() RequestBorrowedZBox {
	return v.value.to_borrowed_zbox()
}

pub fn (v PhpNull) to_request_owned() PhpNull {
	return PhpNull.from_request_owned_zbox(v.value.to_request_owned_zbox()) or { PhpNull.value() }
}

pub fn (v PhpNull) owned() PhpNull {
	return v.to_request_owned()
}

pub fn (v PhpNull) to_request_owned_zbox() RequestOwnedZBox {
	return v.value.to_request_owned_zbox()
}

pub fn (mut v PhpNull) take_zval() ZVal {
	return v.value.take_zval()
}

pub fn (mut v PhpNull) release() {
	v.value.release()
}

pub fn (v PhpNull) to_persistent_owned() PhpValue {
	return PhpValue.from_persistent_owned_zbox(PersistentOwnedZBox.new_null())
}

pub fn (v PhpNull) retain() PhpValue {
	return v.to_persistent_owned()
}

pub fn (v PhpNull) retained() PhpValue {
	return v.to_persistent_owned()
}

pub fn (v PhpNull) to_persistent_owned_zbox() PersistentOwnedZBox {
	return PersistentOwnedZBox.new_null()
}

pub fn (v PhpNull) is_borrowed() bool {
	return v.value.is_borrowed()
}

pub fn (v PhpNull) is_owned() bool {
	return v.value.is_request_owned()
}

pub fn (v PhpNull) is_retained() bool {
	return v.value.is_retained()
}

pub fn (v PhpNull) to_dyn_value() DynValue {
	return DynValue.null()
}
