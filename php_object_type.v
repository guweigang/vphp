module vphp

pub struct PhpObject {
mut:
	value PhpValueZBox
}

pub fn PhpObject.from_zval(z ZVal) ?PhpObject {
	if !z.is_object() {
		return none
	}
	return PhpObject{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpObject.borrowed(z ZVal) PhpObject {
	return PhpObject{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpObject.borrowed_zbox(value RequestBorrowedZBox) PhpObject {
	return PhpObject{
		value: PhpValueZBox.borrowed(value)
	}
}

pub fn PhpObject.must_from_zval(z ZVal) !PhpObject {
	obj := PhpObject.from_zval(z) or { return error('zval is not object') }
	return obj
}

pub fn PhpObject.from_request_borrowed_zbox(value RequestBorrowedZBox) ?PhpObject {
	if !value.is_object() {
		return none
	}
	return PhpObject{
		value: PhpValueZBox.borrowed(value)
	}
}

pub fn PhpObject.from_request_owned_zbox(value RequestOwnedZBox) ?PhpObject {
	if !value.is_object() {
		return none
	}
	return PhpObject{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpObject.current() ?PhpObject {
	z := PhpObject.current_request_owned_zval()
	if !z.is_valid() {
		return none
	}
	return PhpObject.from_zval(z)
}

pub fn PhpObject.current_request_owned_zval() ZVal {
	return ZendObject.current().to_request_owned_zval()
}

pub fn (o PhpObject) to_zval() ZVal {
	return o.value.to_zval()
}

pub fn (o PhpObject) borrowed_view() PhpObject {
	return o.to_borrowed()
}

pub fn (o PhpObject) to_borrowed() PhpObject {
	return PhpObject{
		value: o.value.borrowed()
	}
}

pub fn (o PhpObject) to_borrowed_zbox() RequestBorrowedZBox {
	return o.value.to_borrowed_zbox()
}

pub fn (o PhpObject) to_request_owned() PhpObject {
	return PhpObject.from_request_owned_zbox(o.value.to_request_owned_zbox()) or { o.to_borrowed() }
}

pub fn (o PhpObject) to_request_owned_zbox() RequestOwnedZBox {
	return o.value.to_request_owned_zbox()
}

pub fn (mut o PhpObject) take_zval() ZVal {
	return o.value.take_zval()
}

pub fn PhpObject.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpObject {
	if !value.is_object() {
		return none
	}
	return PhpObject{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpObject.from_persistent_zval(z ZVal) ?PhpObject {
	return PhpObject.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (o PhpObject) to_persistent_owned() PhpObject {
	return PhpObject.from_persistent_owned_zbox(o.value.to_persistent_owned_zbox()) or {
		o.to_borrowed()
	}
}

pub fn (o PhpObject) to_persistent_owned_zbox() PersistentOwnedZBox {
	return o.value.to_persistent_owned_zbox()
}

pub fn (o PhpObject) kind_name() string {
	return o.value.kind_name()
}

pub fn (o PhpObject) is_valid() bool {
	return o.value.is_valid()
}

pub fn (o PhpObject) clone() PhpObject {
	return PhpObject{
		value: o.value.clone()
	}
}

pub fn (o PhpObject) clone_request_owned() RequestOwnedZBox {
	return o.to_request_owned_zbox()
}

pub fn (o PhpObject) with_object[T](run fn (PhpObject) T) T {
	mut temp := o.clone_request_owned()
	defer {
		temp.release()
	}
	obj := PhpObject{
		value: PhpValueZBox.borrowed(temp.borrowed())
	}
	return run(obj)
}

pub fn (mut o PhpObject) release() {
	o.value.release()
}
