module vphp

pub struct PhpIterable {
mut:
	value PhpValueZBox
}

pub fn PhpIterable.from_zval(z ZVal) ?PhpIterable {
	if z.is_array() || (z.is_object() && z.is_instance_of('Traversable')) {
		return PhpIterable{
			value: PhpValueZBox.from_zval(z)
		}
	}
	return none
}

pub fn PhpIterable.must_from_zval(z ZVal) !PhpIterable {
	iter := PhpIterable.from_zval(z) or { return error('zval is not iterable') }
	return iter
}

pub fn PhpIterable.from_request_owned_zbox(value RequestOwnedZBox) ?PhpIterable {
	z := value.to_zval()
	if z.is_array() || (z.is_object() && z.is_instance_of('Traversable')) {
		return PhpIterable{
			value: PhpValueZBox.request_owned(value)
		}
	}
	return none
}

pub fn PhpIterable.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpIterable {
	z := value.to_zval()
	if z.is_array() || (z.is_object() && z.is_instance_of('Traversable')) {
		return PhpIterable{
			value: PhpValueZBox.persistent_owned(value)
		}
	}
	return none
}

pub fn PhpIterable.from_persistent_zval(z ZVal) ?PhpIterable {
	return PhpIterable.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (i PhpIterable) to_zval() ZVal {
	return i.value.to_zval()
}

pub fn (i PhpIterable) to_borrowed() PhpIterable {
	return PhpIterable.from_zval(i.value.to_borrowed_zbox().to_zval()) or { i }
}

pub fn (i PhpIterable) to_borrowed_zbox() RequestBorrowedZBox {
	return i.value.to_borrowed_zbox()
}

pub fn (i PhpIterable) to_request_owned() PhpIterable {
	return PhpIterable.from_request_owned_zbox(i.value.to_request_owned_zbox()) or { i.to_borrowed() }
}

pub fn (i PhpIterable) to_request_owned_zbox() RequestOwnedZBox {
	return i.value.to_request_owned_zbox()
}

pub fn (i PhpIterable) to_persistent_owned() PhpIterable {
	return PhpIterable.from_persistent_owned_zbox(i.value.to_persistent_owned_zbox()) or {
		i.to_borrowed()
	}
}

pub fn (i PhpIterable) to_persistent_owned_zbox() PersistentOwnedZBox {
	return i.value.to_persistent_owned_zbox()
}

pub fn (mut i PhpIterable) take_zval() ZVal {
	return i.value.take_zval()
}

pub fn (mut i PhpIterable) release() {
	i.value.release()
}

pub fn (i PhpIterable) is_array() bool {
	return i.to_zval().is_array()
}

pub fn (i PhpIterable) is_traversable() bool {
	return i.to_zval().is_object() && i.to_zval().is_instance_of('Traversable')
}

pub fn (i PhpIterable) count() int {
	return i.key_strings().len
}

pub fn (i PhpIterable) fold[T](init T, cb ForeachWithCtxCb[T]) T {
	return i.to_zval().foreach_with_ctx[T](init, cb)
}

pub fn (i PhpIterable) key_strings() []string {
	return i.to_zval().foreach_with_ctx[[]string]([]string{}, fn (key ZVal, _ ZVal, mut acc []string) {
		acc << key.to_string()
	})
}

pub fn (i PhpIterable) to_dyn_value() !DynValue {
	mut temp := i.to_request_owned_zbox()
	defer {
		temp.release()
	}
	return DynValue.from_zval(temp.to_zval())
}
