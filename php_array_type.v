module vphp

pub struct PhpArray {
	value RequestBorrowedZBox
}

pub struct PersistentPhpArray {
mut:
	value PersistentOwnedZBox
}

pub fn PhpArray.from_zval(z ZVal) ?PhpArray {
	if !z.is_array() {
		return none
	}
	return PhpArray{
		value: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpArray.must_from_zval(z ZVal) !PhpArray {
	arr := PhpArray.from_zval(z) or { return error('zval is not array') }
	return arr
}

pub fn PhpArray.empty() PhpArray {
	mut z := ZVal.new_null()
	z.array_init()
	return PhpArray{
		value: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PersistentPhpArray.from_zval(z ZVal) ?PersistentPhpArray {
	if !z.is_array() {
		return none
	}
	return PersistentPhpArray{
		value: PersistentOwnedZBox.of(z)
	}
}

pub fn PersistentPhpArray.must_from_zval(z ZVal) !PersistentPhpArray {
	arr := PersistentPhpArray.from_zval(z) or { return error('zval is not array') }
	return arr
}

pub fn PersistentPhpArray.empty() PersistentPhpArray {
	return PhpArray.empty().to_persistent()
}

pub fn (a PhpArray) to_zval() ZVal {
	return a.value.to_zval()
}

pub fn (a PhpArray) to_persistent() PersistentPhpArray {
	return PersistentPhpArray{
		value: PersistentOwnedZBox.of(a.to_zval())
	}
}

pub fn (a PhpArray) to_dyn() !DynValue {
	return DynValue.from_zval(a.to_zval())
}

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

pub fn (a PersistentPhpArray) kind_name() string {
	return a.value.kind_name()
}

pub fn (a PersistentPhpArray) is_valid() bool {
	return a.value.is_valid()
}

pub fn (a PersistentPhpArray) clone() PersistentPhpArray {
	return PersistentPhpArray{
		value: a.value.clone()
	}
}

pub fn (a PersistentPhpArray) clone_request_owned() RequestOwnedZBox {
	return a.value.clone_request_owned()
}

pub fn (a PersistentPhpArray) with_array[T](run fn (PhpArray) T) T {
	mut temp := a.clone_request_owned()
	defer {
		temp.release()
	}
	arr := PhpArray{
		value: temp.borrowed()
	}
	return run(arr)
}

pub fn (a PersistentPhpArray) to_dyn() !DynValue {
	mut temp := a.clone_request_owned()
	defer {
		temp.release()
	}
	return DynValue.from_zval(temp.to_zval())
}

pub fn (mut a PersistentPhpArray) release() {
	a.value.release()
}
