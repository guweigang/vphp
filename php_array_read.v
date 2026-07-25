module vphp

pub fn (a PhpArray) count() int {
	return a.to_zval().array_count()
}

pub fn (a PhpArray) is_empty() bool {
	return a.count() == 0
}

pub fn (a PhpArray) is_list() bool {
	return a.to_zval().is_list()
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

pub fn (a PhpArray) value_at(key string) PhpValue {
	return PhpValue.from_zval(a.to_zval().value_at(key))
}

pub fn (a PhpArray) [] (key string) PhpValue {
	return a.value_at(key)
}

pub fn (a PhpArray) string_at(key string, default_value string) string {
	return a.to_zval().string_at(key, default_value)
}

pub fn (a PhpArray) raw_string_at(key string, default_value string) string {
	return a.to_zval().raw_string_at(key, default_value)
}

pub fn (a PhpArray) int_at(key string, default_value int) int {
	return a.to_zval().int_at(key, default_value)
}

pub fn (a PhpArray) bool_at(key string, default_value bool) bool {
	return a.to_zval().bool_at(key, default_value)
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

pub fn (a PhpArray) key_array() PhpArray {
	return PhpArray.adopt_zval(a.keys()) or { PhpArray.new() }
}

pub fn (a PhpArray) value_array() PhpArray {
	return PhpArray.adopt_zval(a.values()) or { PhpArray.new() }
}

pub fn (a PhpArray) key_strings() []string {
	return a.to_zval().keys_string()
}

pub fn (a PhpArray) assoc_keys() []string {
	return a.to_zval().assoc_keys()
}

pub fn (a PhpArray) to_string_map() map[string]string {
	return a.to_zval().to_string_map()
}

pub fn (a PhpArray) to_scalar_string_map() map[string]string {
	return a.fold[map[string]string](map[string]string{}, fn (key ZVal, child ZVal, mut acc map[string]string) {
		acc[key.to_string()] = child.stringify()
	})
}

pub fn (a PhpArray) to_string_list() []string {
	return a.to_zval().to_string_list()
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

pub type PhpArrayValueFoldCb[T] = fn (key PhpValue, value PhpValue, mut ctx T)

pub fn (a PhpArray) fold_values[T](init T, cb PhpArrayValueFoldCb[T]) T {
	return a.fold[T](init, fn [cb] [T](key ZVal, value ZVal, mut acc T) {
		cb(PhpValue.from_zval(key), PhpValue.from_zval(value), mut acc)
	})
}

pub type PhpArrayEntryCb = fn (key PhpValue, value PhpValue)

pub fn (a PhpArray) each_entry(cb PhpArrayEntryCb) {
	mut keys := a.key_array()
	defer {
		keys.release()
	}
	mut values := a.value_array()
	defer {
		values.release()
	}
	for idx := 0; idx < keys.count(); idx++ {
		cb(keys.index_value(idx), values.index_value(idx))
	}
}

pub fn (a PhpArray) items() []ZVal {
	return a.fold[[]ZVal]([]ZVal{}, fn (_ ZVal, item ZVal, mut acc []ZVal) {
		acc << item
	})
}

pub fn (a PhpArray) value_items() []PhpValue {
	mut out := []PhpValue{}
	for item in a.items() {
		out << PhpValue.from_zval(item)
	}
	return out
}
