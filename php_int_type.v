module vphp

pub struct PhpInt {
mut:
	value PhpValueZBox
}

pub fn PhpInt.from_zval(z ZVal) ?PhpInt {
	if !z.is_long() {
		return none
	}
	return PhpInt{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpInt.must_from_zval(z ZVal) !PhpInt {
	value := PhpInt.from_zval(z) or { return error('zval is not int') }
	return value
}

pub fn PhpInt.from_request_owned_zbox(value RequestOwnedZBox) ?PhpInt {
	if !value.to_zval().is_long() {
		return none
	}
	return PhpInt{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpInt.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpInt {
	if !value.to_zval().is_long() {
		return none
	}
	return PhpInt{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpInt.from_persistent_zval(z ZVal) ?PhpInt {
	return PhpInt.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn PhpInt.coerce(z ZVal) PhpInt {
	result := php_fn('intval').call([z])
	return PhpInt{
		value: PhpValueZBox.adopt_zval(result)
	}
}

pub fn PhpInt.of(value i64) PhpInt {
	return PhpInt{
		value: PhpValueZBox.request_owned(RequestOwnedZBox.new_int(value))
	}
}

pub fn PhpInt.zero() PhpInt {
	return PhpInt.of(0)
}

pub fn (v PhpInt) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpInt) to_value() PhpValue {
	return PhpValue{
		value: v.value.clone()
	}
}

pub fn (mut v PhpInt) take_value() PhpValue {
	return PhpValue.adopt_zval(v.take_zval())
}

pub fn (v PhpInt) to_borrowed() PhpInt {
	return PhpInt.from_zval(v.value.to_borrowed_zbox().to_zval()) or { v }
}

pub fn (v PhpInt) borrowed() PhpInt {
	return v.to_borrowed()
}

pub fn (v PhpInt) borrow() PhpInt {
	return v.to_borrowed()
}

pub fn (v PhpInt) to_borrowed_zbox() RequestBorrowedZBox {
	return v.value.to_borrowed_zbox()
}

pub fn (v PhpInt) to_request_owned() PhpInt {
	return PhpInt.from_request_owned_zbox(v.value.to_request_owned_zbox()) or { PhpInt.zero() }
}

pub fn (v PhpInt) owned() PhpInt {
	return v.to_request_owned()
}

pub fn (v PhpInt) to_request_owned_zbox() RequestOwnedZBox {
	return v.value.to_request_owned_zbox()
}

pub fn (mut v PhpInt) take_zval() ZVal {
	return v.value.take_zval()
}

pub fn (mut v PhpInt) release() {
	v.value.release()
}

pub fn (v PhpInt) to_persistent_owned() PhpInt {
	return PhpInt.from_persistent_owned_zbox(v.value.to_persistent_owned_zbox()) or {
		PhpInt.zero()
	}
}

pub fn (v PhpInt) retain() PhpInt {
	return v.to_persistent_owned()
}

pub fn (v PhpInt) retained() PhpInt {
	return v.to_persistent_owned()
}

pub fn (v PhpInt) to_persistent_owned_zbox() PersistentOwnedZBox {
	return v.value.to_persistent_owned_zbox()
}

pub fn (v PhpInt) is_borrowed() bool {
	return v.value.is_borrowed()
}

pub fn (v PhpInt) is_owned() bool {
	return v.value.is_request_owned()
}

pub fn (v PhpInt) is_retained() bool {
	return v.value.is_retained()
}

pub fn (v PhpInt) value() i64 {
	return v.to_zval().to_i64()
}

pub fn (v PhpInt) to_int() int {
	return v.to_zval().to_int()
}

pub fn (v PhpInt) to_dyn_value() DynValue {
	return DynValue.of_int(v.value())
}
