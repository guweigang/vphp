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

pub fn PhpArray.must_from_zval(z ZVal) !PhpArray {
	arr := PhpArray.from_zval(z) or { return error('zval is not array') }
	return arr
}

pub fn PhpArray.empty() PhpArray {
	mut value := RequestOwnedZBox.new_null()
	value.to_zval().array_init()
	return PhpArray{
		value: PhpValueZBox.request_owned(value)
	}
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

pub fn (a PhpArray) borrowed() PhpArray {
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

pub fn (a PhpArray) to_persistent_owned_zbox() PersistentOwnedZBox {
	return a.value.to_persistent_owned_zbox()
}

pub fn (a PhpArray) to_dyn_value() !DynValue {
	mut temp := a.clone_request_owned()
	defer {
		temp.release()
	}
	return DynValue.from_zval(temp.to_zval())
}

pub fn (a PhpArray) assoc(key string, value PhpFnArg) {
	raw := value.to_zval()
	unsafe { C.vphp_array_add_assoc_zval(a.to_zval().raw, &char(key.str), raw.raw) }
}

pub fn (a PhpArray) assoc_zval(key string, value ZVal) {
	unsafe { C.vphp_array_add_assoc_zval(a.to_zval().raw, &char(key.str), value.raw) }
}

pub fn (a PhpArray) set(key string, value PhpFnArg) {
	a.assoc(key, value)
}

pub fn (a PhpArray) set_zval(key string, value ZVal) {
	a.assoc_zval(key, value)
}

pub fn (a PhpArray) set_request_owned_zbox(key string, value RequestOwnedZBox) {
	mut wrapped := PhpValue.from_request_owned_zbox(value)
	a.set(key, wrapped)
	wrapped.release()
}

pub fn (a PhpArray) string(key string, value string) {
	a.to_zval().add_assoc_string(key, value)
}

pub fn (a PhpArray) int(key string, value i64) {
	a.to_zval().add_assoc_long(key, value)
}

pub fn (a PhpArray) double(key string, value f64) {
	a.to_zval().add_assoc_double(key, value)
}

pub fn (a PhpArray) bool(key string, value bool) {
	a.to_zval().add_assoc_bool(key, value)
}

pub fn (a PhpArray) null_value(key string) {
	a.assoc(key, PhpNull.value())
}

pub fn (a PhpArray) next(value PhpFnArg) {
	a.to_zval().add_next_val(value.to_zval())
}

pub fn (a PhpArray) next_zval(value ZVal) {
	a.to_zval().add_next_val(value)
}

pub fn (a PhpArray) push(value PhpFnArg) {
	a.next(value)
}

pub fn (a PhpArray) push_zval(value ZVal) {
	a.next_zval(value)
}

pub fn (a PhpArray) push_string(value string) {
	a.to_zval().push_string(value)
}

pub fn (a PhpArray) to_json() string {
	return PhpJson.encode(a.to_zval())
}

pub fn (a PhpArray) to_json_with_flags(flags int) string {
	return PhpJson.encode_with_flags(a.to_zval(), flags)
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

pub fn (a PhpArray) kind_name() string {
	return a.value.kind_name()
}

pub fn (a PhpArray) is_valid() bool {
	return a.value.is_valid() && a.to_zval().is_array()
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
