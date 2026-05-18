module vphp

pub struct PhpString {
mut:
	value PhpValueZBox
}

pub fn PhpString.from_zval(z ZVal) ?PhpString {
	if !z.is_string() {
		return none
	}
	return PhpString{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpString.must_from_zval(z ZVal) !PhpString {
	value := PhpString.from_zval(z) or { return error('zval is not string') }
	return value
}

pub fn PhpString.from_request_owned_zbox(value RequestOwnedZBox) ?PhpString {
	if !value.is_string() {
		return none
	}
	return PhpString{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpString.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpString {
	if !value.is_string() {
		return none
	}
	return PhpString{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpString.from_persistent_zval(z ZVal) ?PhpString {
	return PhpString.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn PhpString.coerce(z ZVal) PhpString {
	return PhpString{
		value: PhpValueZBox.request_owned(RequestOwnedZBox.new_string(z.to_string()))
	}
}

pub fn PhpString.of(value string) PhpString {
	return PhpString{
		value: PhpValueZBox.request_owned(RequestOwnedZBox.new_string(value))
	}
}

pub fn PhpString.empty() PhpString {
	return PhpString.of('')
}

pub fn (v PhpString) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpString) to_value() PhpValue {
	return PhpValue{
		value: v.value.clone()
	}
}

pub fn (v PhpString) to_json() string {
	return v.to_json_with_flags(0)
}

pub fn (v PhpString) to_json_with_flags(flags int) string {
	return v.value.with_request_zval[string](fn [flags] (z ZVal) string {
		return PhpJson.encode_with_flags(z, flags)
	})
}

pub fn (mut v PhpString) take_value() PhpValue {
	return PhpValue.adopt_zval(v.take_zval())
}

pub fn (v PhpString) to_borrowed() PhpString {
	return PhpString.from_zval(v.value.to_borrowed_zbox().to_zval()) or { v }
}

pub fn (v PhpString) borrowed() PhpString {
	return v.to_borrowed()
}

pub fn (v PhpString) borrow() PhpString {
	return v.to_borrowed()
}

pub fn (v PhpString) to_borrowed_zbox() RequestBorrowedZBox {
	return v.value.to_borrowed_zbox()
}

pub fn (v PhpString) to_request_owned() PhpString {
	return PhpString.from_request_owned_zbox(v.value.to_request_owned_zbox()) or {
		PhpString.empty()
	}
}

pub fn (v PhpString) owned() PhpString {
	return v.to_request_owned()
}

pub fn (v PhpString) to_request_owned_zbox() RequestOwnedZBox {
	return v.value.to_request_owned_zbox()
}

pub fn (mut v PhpString) take_zval() ZVal {
	return v.value.take_zval()
}

pub fn (mut v PhpString) release() {
	v.value.release()
}

pub fn (v PhpString) to_persistent_owned() PhpString {
	return PhpString.from_persistent_owned_zbox(v.value.to_persistent_owned_zbox()) or {
		PhpString.empty()
	}
}

pub fn (v PhpString) retain() PhpString {
	return v.to_persistent_owned()
}

pub fn (v PhpString) retained() PhpString {
	return v.to_persistent_owned()
}

pub fn (v PhpString) to_persistent_owned_zbox() PersistentOwnedZBox {
	return v.value.to_persistent_owned_zbox()
}

pub fn (v PhpString) is_borrowed() bool {
	return v.value.is_borrowed()
}

pub fn (v PhpString) is_owned() bool {
	return v.value.is_request_owned()
}

pub fn (v PhpString) is_retained() bool {
	return v.value.is_retained()
}

pub fn (v PhpString) value() string {
	return v.to_zval().to_string()
}

pub fn (v PhpString) len() int {
	return v.value().len
}

pub fn (v PhpString) to_dyn_value() DynValue {
	return DynValue.of_string(v.value())
}
