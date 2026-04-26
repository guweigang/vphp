module vphp

pub struct PhpIterable {
	value RequestBorrowedZBox
}

pub fn PhpIterable.from_zval(z ZVal) ?PhpIterable {
	if z.is_array() || (z.is_object() && z.is_instance_of('Traversable')) {
		return PhpIterable{
			value: RequestBorrowedZBox.from_zval(z)
		}
	}
	return none
}

pub fn PhpIterable.must_from_zval(z ZVal) !PhpIterable {
	iter := PhpIterable.from_zval(z) or { return error('zval is not iterable') }
	return iter
}

pub fn (i PhpIterable) to_zval() ZVal {
	return i.value.to_zval()
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

pub fn (i PhpIterable) to_dyn() !DynValue {
	return DynValue.from_zval(i.to_zval())
}
