module vphp

pub struct PhpThrowable {
mut:
	object PhpObject
}

pub fn PhpThrowable.from_zval(z ZVal) ?PhpThrowable {
	if !z.is_object() || !z.is_instance_of('Throwable') {
		return none
	}
	return PhpThrowable{
		object: PhpObject.must_from_zval(z) or { return none }
	}
}

pub fn PhpThrowable.must_from_zval(z ZVal) !PhpThrowable {
	t := PhpThrowable.from_zval(z) or { return error('zval is not Throwable') }
	return t
}

pub fn PhpThrowable.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpThrowable {
	if !value.is_object() || !value.to_zval().is_instance_of('Throwable') {
		return none
	}
	object := PhpObject.from_persistent_owned_zbox(value) or { return none }
	return PhpThrowable{
		object: object
	}
}

pub fn PhpThrowable.from_persistent_zval(z ZVal) ?PhpThrowable {
	return PhpThrowable.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn PhpThrowable.from_request_owned_zbox(value RequestOwnedZBox) ?PhpThrowable {
	object := PhpObject.from_request_owned_zbox(value) or { return none }
	if !object.to_zval().is_instance_of('Throwable') {
		return none
	}
	return PhpThrowable{
		object: object
	}
}

pub fn (t PhpThrowable) to_zval() ZVal {
	return t.object.to_zval()
}

pub fn (t PhpThrowable) to_object() PhpObject {
	return t.object
}

pub fn (t PhpThrowable) to_borrowed() PhpThrowable {
	return PhpThrowable{
		object: t.object.to_borrowed()
	}
}

pub fn (t PhpThrowable) to_borrowed_zbox() RequestBorrowedZBox {
	return t.object.to_borrowed_zbox()
}

pub fn (t PhpThrowable) to_request_owned() PhpThrowable {
	return PhpThrowable.from_request_owned_zbox(t.object.to_request_owned_zbox()) or { t.to_borrowed() }
}

pub fn (t PhpThrowable) to_request_owned_zbox() RequestOwnedZBox {
	return t.object.to_request_owned_zbox()
}

pub fn (t PhpThrowable) to_persistent_owned() PhpThrowable {
	return PhpThrowable.from_persistent_owned_zbox(t.object.to_persistent_owned_zbox()) or {
		t.to_borrowed()
	}
}

pub fn (t PhpThrowable) to_persistent_owned_zbox() PersistentOwnedZBox {
	return t.object.to_persistent_owned_zbox()
}

pub fn (mut t PhpThrowable) release() {
	t.object.release()
}

pub fn (t PhpThrowable) class_name() string {
	return t.object.class_name()
}

pub fn (t PhpThrowable) message() string {
	return t.object.method_v[string]('getMessage', []) or { '' }
}

pub fn (t PhpThrowable) code() int {
	return t.object.method_v[int]('getCode', []) or { 0 }
}

pub fn (t PhpThrowable) file() string {
	return t.object.method_v[string]('getFile', []) or { '' }
}

pub fn (t PhpThrowable) line() int {
	return t.object.method_v[int]('getLine', []) or { 0 }
}

pub fn (t PhpThrowable) trace_as_string() string {
	return t.object.method_v[string]('getTraceAsString', []) or { '' }
}

pub fn (t PhpThrowable) throw() {
	mut z := t.to_zval().dup()
	throw_exception_object(mut z)
}
