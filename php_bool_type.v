module vphp

pub struct PhpBool {
mut:
	value PhpValueZBox
}

pub fn PhpBool.from_zval(z ZVal) ?PhpBool {
	if !z.is_bool() {
		return none
	}
	return PhpBool{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpBool.must_from_zval(z ZVal) !PhpBool {
	value := PhpBool.from_zval(z) or { return error('zval is not bool') }
	return value
}

pub fn PhpBool.from_request_owned_zbox(value RequestOwnedZBox) ?PhpBool {
	if !value.to_zval().is_bool() {
		return none
	}
	return PhpBool{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpBool.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpBool {
	if !value.to_zval().is_bool() {
		return none
	}
	return PhpBool{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpBool.from_persistent_zval(z ZVal) ?PhpBool {
	return PhpBool.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn PhpBool.coerce(z ZVal) PhpBool {
	result := php_fn('boolval').call([z])
	return PhpBool{
		value: PhpValueZBox.adopt_zval(result)
	}
}

pub fn PhpBool.of(value bool) PhpBool {
	return PhpBool{
		value: PhpValueZBox.request_owned(RequestOwnedZBox.new_bool(value))
	}
}

pub fn PhpBool.true_value() PhpBool {
	return PhpBool.of(true)
}

pub fn PhpBool.false_value() PhpBool {
	return PhpBool.of(false)
}

pub fn (v PhpBool) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpBool) to_value() PhpValue {
	return PhpValue{
		value: v.value.clone()
	}
}

pub fn (mut v PhpBool) take_value() PhpValue {
	return PhpValue.adopt_zval(v.take_zval())
}

pub fn (v PhpBool) to_borrowed() PhpBool {
	return PhpBool.from_zval(v.value.to_borrowed_zbox().to_zval()) or { v }
}

pub fn (v PhpBool) borrowed() PhpBool {
	return v.to_borrowed()
}

pub fn (v PhpBool) borrow() PhpBool {
	return v.to_borrowed()
}

pub fn (v PhpBool) to_borrowed_zbox() RequestBorrowedZBox {
	return v.value.to_borrowed_zbox()
}

pub fn (v PhpBool) to_request_owned() PhpBool {
	return PhpBool.from_request_owned_zbox(v.value.to_request_owned_zbox()) or {
		PhpBool.false_value()
	}
}

pub fn (v PhpBool) owned() PhpBool {
	return v.to_request_owned()
}

pub fn (v PhpBool) to_request_owned_zbox() RequestOwnedZBox {
	return v.value.to_request_owned_zbox()
}

pub fn (mut v PhpBool) take_zval() ZVal {
	return v.value.take_zval()
}

pub fn (mut v PhpBool) release() {
	v.value.release()
}

pub fn (v PhpBool) to_persistent_owned() PhpBool {
	return PhpBool.from_persistent_owned_zbox(v.value.to_persistent_owned_zbox()) or {
		PhpBool.false_value()
	}
}

pub fn (v PhpBool) retain() PhpBool {
	return v.to_persistent_owned()
}

pub fn (v PhpBool) retained() PhpBool {
	return v.to_persistent_owned()
}

pub fn (v PhpBool) to_persistent_owned_zbox() PersistentOwnedZBox {
	return v.value.to_persistent_owned_zbox()
}

pub fn (v PhpBool) is_borrowed() bool {
	return v.value.is_borrowed()
}

pub fn (v PhpBool) is_owned() bool {
	return v.value.is_request_owned()
}

pub fn (v PhpBool) is_retained() bool {
	return v.value.is_retained()
}

pub fn (v PhpBool) value() bool {
	return v.to_zval().to_bool()
}

pub fn (v PhpBool) to_dyn_value() DynValue {
	return DynValue.of_bool(v.value())
}
