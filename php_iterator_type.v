module vphp

pub struct PhpIterator {
mut:
	object PhpObject
}

pub fn PhpIterator.from_zval(z ZVal) ?PhpIterator {
	if !z.is_object() || !z.is_instance_of('Traversable') {
		return none
	}
	object := PhpObject.from_zval(z) or { return none }
	return PhpIterator{
		object: object
	}
}

pub fn PhpIterator.must_from_zval(z ZVal) !PhpIterator {
	iter := PhpIterator.from_zval(z) or { return error('zval is not Traversable object') }
	return iter
}

pub fn PhpIterator.from_request_owned_zbox(value RequestOwnedZBox) ?PhpIterator {
	object := PhpObject.from_request_owned_zbox(value) or { return none }
	if !object.to_zval().is_instance_of('Traversable') {
		return none
	}
	return PhpIterator{
		object: object
	}
}

pub fn PhpIterator.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpIterator {
	object := PhpObject.from_persistent_owned_zbox(value) or { return none }
	if !object.to_zval().is_instance_of('Traversable') {
		return none
	}
	return PhpIterator{
		object: object
	}
}

pub fn PhpIterator.from_persistent_zval(z ZVal) ?PhpIterator {
	return PhpIterator.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (i PhpIterator) to_zval() ZVal {
	return i.object.to_zval()
}

pub fn (i PhpIterator) to_value() PhpValue {
	return i.object.to_value()
}

pub fn (i PhpIterator) to_object() PhpObject {
	return i.object
}

pub fn (i PhpIterator) to_iterable() PhpIterable {
	return PhpIterable{
		value: i.object.value.clone()
	}
}

pub fn (i PhpIterator) to_array() !PhpArray {
	return i.to_iterable().to_array()
}

pub fn (i PhpIterator) to_borrowed() PhpIterator {
	return PhpIterator{
		object: i.object.to_borrowed()
	}
}

pub fn (i PhpIterator) borrowed() PhpIterator {
	return i.to_borrowed()
}

pub fn (i PhpIterator) borrow() PhpIterator {
	return i.to_borrowed()
}

pub fn (i PhpIterator) to_borrowed_zbox() RequestBorrowedZBox {
	return i.object.to_borrowed_zbox()
}

pub fn (i PhpIterator) to_request_owned() PhpIterator {
	return PhpIterator.from_request_owned_zbox(i.object.to_request_owned_zbox()) or {
		i.to_borrowed()
	}
}

pub fn (i PhpIterator) owned() PhpIterator {
	return i.to_request_owned()
}

pub fn (i PhpIterator) to_request_owned_zbox() RequestOwnedZBox {
	return i.object.to_request_owned_zbox()
}

pub fn (i PhpIterator) to_persistent_owned() PhpIterator {
	return PhpIterator.from_persistent_owned_zbox(i.object.to_persistent_owned_zbox()) or {
		i.to_borrowed()
	}
}

pub fn (i PhpIterator) retain() PhpIterator {
	return i.to_persistent_owned()
}

pub fn (i PhpIterator) retained() PhpIterator {
	return i.to_persistent_owned()
}

pub fn (i PhpIterator) to_persistent_owned_zbox() PersistentOwnedZBox {
	return i.object.to_persistent_owned_zbox()
}

pub fn (i PhpIterator) is_borrowed() bool {
	return i.object.is_borrowed()
}

pub fn (i PhpIterator) is_owned() bool {
	return i.object.is_owned()
}

pub fn (i PhpIterator) is_retained() bool {
	return i.object.is_retained()
}

pub fn (mut i PhpIterator) release() {
	i.object.release()
}

pub fn (i PhpIterator) class_name() string {
	return i.object.class_name()
}

pub fn (i PhpIterator) count() int {
	return i.to_iterable().count()
}

pub fn (i PhpIterator) fold[T](init T, cb ForeachWithCtxCb[T]) T {
	return i.to_iterable().fold[T](init, cb)
}

pub fn (i PhpIterator) key_strings() []string {
	return i.to_iterable().key_strings()
}

pub fn (i PhpIterator) to_dyn_value() !DynValue {
	return i.to_iterable().to_dyn_value()
}
