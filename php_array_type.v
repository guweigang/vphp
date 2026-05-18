module vphp

pub struct PhpArray {
mut:
	value PhpValueZBox
}

pub fn PhpArray.from_zval(z ZVal) ?PhpArray {
	if !z.is_array() {
		return none
	}
	return PhpArray{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpArray.adopt_zval(z ZVal) ?PhpArray {
	if !z.is_array() {
		mut invalid := z
		invalid.release()
		return none
	}
	return PhpArray{
		value: PhpValueZBox.adopt_zval(z)
	}
}

pub fn PhpArray.must_from_zval(z ZVal) !PhpArray {
	arr := PhpArray.from_zval(z) or { return error('zval is not array') }
	return arr
}

pub fn PhpArray.new() PhpArray {
	value := RequestOwnedZBox.new_array()
	return PhpArray{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpArray.new_persistent() PhpArray {
	value := PersistentOwnedZBox.new_array()
	return PhpArray{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpArray.empty() PhpArray {
	return PhpArray.new()
}

pub fn PhpArray.from_request_owned_zbox(value RequestOwnedZBox) ?PhpArray {
	if !value.is_array() {
		return none
	}
	return PhpArray{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpArray.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpArray {
	if !value.is_array() {
		return none
	}
	return PhpArray{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpArray.from_persistent_zval(z ZVal) ?PhpArray {
	return PhpArray.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (a PhpArray) to_zval() ZVal {
	return a.value.to_zval()
}

pub fn (a PhpArray) to_value() PhpValue {
	return PhpValue{
		value: a.value.clone()
	}
}

pub fn (a PhpArray) to_iterable() PhpIterable {
	return PhpIterable{
		value: a.value.clone()
	}
}

pub fn (mut a PhpArray) take_value() PhpValue {
	return PhpValue.adopt_zval(a.take_zval())
}

pub fn (a PhpArray) borrowed() PhpArray {
	return a.to_borrowed()
}

pub fn (a PhpArray) borrow() PhpArray {
	return a.to_borrowed()
}

pub fn (a PhpArray) to_borrowed() PhpArray {
	return PhpArray{
		value: a.value.borrowed()
	}
}

pub fn (a PhpArray) to_borrowed_zbox() RequestBorrowedZBox {
	return a.value.to_borrowed_zbox()
}

pub fn (a PhpArray) to_request_owned() PhpArray {
	return PhpArray.from_request_owned_zbox(a.value.to_request_owned_zbox()) or { PhpArray.empty() }
}

pub fn (a PhpArray) owned() PhpArray {
	return a.to_request_owned()
}

pub fn (a PhpArray) to_request_owned_zbox() RequestOwnedZBox {
	return a.value.to_request_owned_zbox()
}

pub fn (mut a PhpArray) take_zval() ZVal {
	return a.value.take_zval()
}

pub fn (a PhpArray) to_persistent_owned() PhpArray {
	return PhpArray.from_persistent_owned_zbox(a.value.to_persistent_owned_zbox()) or {
		PhpArray.empty()
	}
}

pub fn (a PhpArray) retain() PhpArray {
	return a.to_persistent_owned()
}

pub fn (a PhpArray) retained() PhpArray {
	return a.to_persistent_owned()
}

pub fn (a PhpArray) to_persistent_owned_zbox() PersistentOwnedZBox {
	return a.value.to_persistent_owned_zbox()
}

pub fn (a PhpArray) is_borrowed() bool {
	return a.value.is_borrowed()
}

pub fn (a PhpArray) is_owned() bool {
	return a.value.is_request_owned()
}

pub fn (a PhpArray) is_retained() bool {
	return a.value.is_retained()
}

pub fn (a PhpArray) to_dyn_value() !DynValue {
	mut temp := a.clone_request_owned()
	defer {
		temp.release()
	}
	return DynValue.from_zval(temp.to_zval())
}

pub fn (a PhpArray) to_json() string {
	return PhpJson.encode(a.to_zval())
}

pub fn (a PhpArray) to_json_with_flags(flags int) string {
	return PhpJson.encode_with_flags(a.to_zval(), flags)
}

pub fn (a PhpArray) kind_name() string {
	return a.value.kind_name()
}

pub fn (a PhpArray) is_valid() bool {
	return a.value.is_valid()
}

pub fn (a PhpArray) clone() PhpArray {
	return PhpArray{
		value: a.value.clone()
	}
}

pub fn (a PhpArray) clone_request_owned() RequestOwnedZBox {
	return a.to_request_owned_zbox()
}

pub fn (a PhpArray) with_array[T](run fn (PhpArray) T) T {
	return a.value.with_request_array[T](fn [run] [T](arr PhpArray) T {
		return run(arr)
	}) or { run(a) }
}

pub fn (mut a PhpArray) release() {
	a.value.release()
}
