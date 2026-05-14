module vphp

pub fn (a PhpArray) count() int {
	return a.to_zval().array_count()
}

pub fn (a PhpArray) is_empty() bool {
	return a.count() == 0
}

pub fn (a PhpArray) get(key string) !ZVal {
	return a.to_zval().get(key)
}

pub fn (a PhpArray) has(key string) bool {
	a.get(key) or { return false }
	return true
}

pub fn (a PhpArray) value(key string) !PhpValue {
	return PhpValue.from_zval(a.get(key)!)
}

pub fn (a PhpArray) get_key(key ZVal) !ZVal {
	return a.to_zval().get_key(key)
}

pub fn (a PhpArray) get_index(index int) ZVal {
	return a.to_zval().array_get(index)
}

pub fn (a PhpArray) index_value(index int) PhpValue {
	return PhpValue.from_zval(a.get_index(index))
}

pub fn (a PhpArray) keys() ZVal {
	return a.to_zval().keys()
}

pub fn (a PhpArray) values() ZVal {
	return a.to_zval().values()
}

pub fn (a PhpArray) key_strings() []string {
	return a.to_zval().keys_string()
}

pub fn (a PhpArray) assoc_keys() []string {
	return a.to_zval().assoc_keys()
}

pub fn (a PhpArray) get_v[T](key string) !T {
	return a.get(key)!.to_v[T]()
}

pub fn (a PhpArray) string_value(key string) !PhpString {
	return PhpString.must_from_zval(a.get(key)!)
}

pub fn (a PhpArray) int_value(key string) !PhpInt {
	return PhpInt.must_from_zval(a.get(key)!)
}

pub fn (a PhpArray) bool_value(key string) !PhpBool {
	return PhpBool.must_from_zval(a.get(key)!)
}

pub fn (a PhpArray) double_value(key string) !PhpDouble {
	return PhpDouble.must_from_zval(a.get(key)!)
}

pub fn (a PhpArray) array_value(key string) !PhpArray {
	return PhpArray.must_from_zval(a.get(key)!)
}

pub fn (a PhpArray) object_value(key string) !PhpObject {
	return PhpObject.must_from_zval(a.get(key)!)
}

pub fn (a PhpArray) callable_value(key string) !PhpCallable {
	return PhpCallable.must_from_zval(a.get(key)!)
}

pub fn (a PhpArray) fold[T](init T, cb ForeachWithCtxCb[T]) T {
	return a.to_zval().foreach_with_ctx[T](init, cb)
}

pub fn (a PhpArray) items() []ZVal {
	return a.fold[[]ZVal]([]ZVal{}, fn (_ ZVal, item ZVal, mut acc []ZVal) {
		acc << item
	})
}
