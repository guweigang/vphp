module vphp

pub struct PhpValue {
mut:
	value PhpValueZBox
}

pub fn PhpValue.invalid() PhpValue {
	return PhpValue.from_zval(invalid_zval())
}

pub fn PhpValue.from_zval(z ZVal) PhpValue {
	return PhpValue{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpValue.of(z ZVal) PhpValue {
	return PhpValue{
		value: PhpValueZBox.request_owned(RequestOwnedZBox.of(z))
	}
}

pub fn PhpValue.from_v[T](value T) !PhpValue {
	return PhpValue.adopt_zval(new_zval_from[T](value)!)
}

pub fn PhpValue.adopt_zval(z ZVal) PhpValue {
	return PhpValue{
		value: PhpValueZBox.adopt_zval(z)
	}
}

pub fn PhpValue.empty_array() PhpValue {
	mut arr := PhpArray.empty()
	return arr.take_value()
}

pub fn PhpValue.null() PhpValue {
	return PhpValue.adopt_zval(ZVal.new_null())
}

pub fn PhpValue.bool(value bool) PhpValue {
	return PhpValue.from_request_owned_zbox(RequestOwnedZBox.new_bool(value))
}

pub fn PhpValue.int(value i64) PhpValue {
	return PhpValue.from_request_owned_zbox(RequestOwnedZBox.new_int(value))
}

pub fn PhpValue.double(value f64) PhpValue {
	return PhpValue.from_request_owned_zbox(RequestOwnedZBox.new_float(value))
}

pub fn PhpValue.string(value string) PhpValue {
	return PhpValue.from_request_owned_zbox(RequestOwnedZBox.new_string(value))
}

pub fn PhpValue.persistent_null() PhpValue {
	return PhpValue.from_persistent_owned_zbox(PersistentOwnedZBox.new_null())
}

pub fn PhpValue.from_request_borrowed_zbox(value RequestBorrowedZBox) PhpValue {
	return PhpValue{
		value: PhpValueZBox.borrowed(value)
	}
}

pub fn PhpValue.from_request_owned_zbox(value RequestOwnedZBox) PhpValue {
	return PhpValue{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpValue.from_persistent_owned_zbox(value PersistentOwnedZBox) PhpValue {
	return PhpValue{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpValue.from_persistent_zval(z ZVal) PhpValue {
	return PhpValue.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (v PhpValue) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpValue) to_json() string {
	return v.to_json_with_flags(0)
}

pub fn (v PhpValue) to_json_with_flags(flags int) string {
	return v.value.with_request_zval[string](fn [flags] (z ZVal) string {
		return PhpJson.encode_with_flags(z, flags)
	})
}

pub fn (v PhpValue) borrowed() PhpValue {
	return v.to_borrowed()
}

pub fn (v PhpValue) borrow() PhpValue {
	return v.to_borrowed()
}

pub fn (v PhpValue) to_borrowed() PhpValue {
	return PhpValue{
		value: v.value.borrowed()
	}
}

pub fn (v PhpValue) to_borrowed_zbox() RequestBorrowedZBox {
	return v.value.to_borrowed_zbox()
}

pub fn (v PhpValue) to_request_owned() PhpValue {
	return PhpValue{
		value: PhpValueZBox.request_owned(v.value.to_request_owned_zbox())
	}
}

pub fn (v PhpValue) owned() PhpValue {
	return v.to_request_owned()
}

pub fn (v PhpValue) to_request_owned_zbox() RequestOwnedZBox {
	return v.value.to_request_owned_zbox()
}

pub fn (mut v PhpValue) take_zval() ZVal {
	return v.value.take_zval()
}

pub fn (v PhpValue) to_persistent_owned() PhpValue {
	return PhpValue{
		value: PhpValueZBox.persistent_owned(v.value.to_persistent_owned_zbox())
	}
}

pub fn (v PhpValue) retain() PhpValue {
	return v.to_persistent_owned()
}

pub fn (v PhpValue) retained() PhpValue {
	return v.to_persistent_owned()
}

pub fn (v PhpValue) to_persistent_owned_zbox() PersistentOwnedZBox {
	return v.value.to_persistent_owned_zbox()
}

pub fn (v PhpValue) is_borrowed() bool {
	return v.value.is_borrowed()
}

pub fn (v PhpValue) is_owned() bool {
	return v.value.is_request_owned()
}

pub fn (v PhpValue) is_retained() bool {
	return v.value.is_retained()
}

pub fn (v PhpValue) kind_name() string {
	return v.value.kind_name()
}

pub fn (v PhpValue) clone() PhpValue {
	return PhpValue{
		value: v.value.clone()
	}
}

pub fn (v PhpValue) clone_request_owned() RequestOwnedZBox {
	return v.to_request_owned_zbox()
}

pub fn (v PhpValue) to_bool() bool {
	return v.to_zval().to_bool()
}

pub fn (v PhpValue) to_int() int {
	return v.to_zval().to_int()
}

pub fn (v PhpValue) to_i64() i64 {
	return v.to_zval().to_i64()
}

pub fn (v PhpValue) to_f64() f64 {
	return v.to_zval().to_f64()
}

pub fn (v PhpValue) to_string() string {
	return v.to_zval().to_string()
}

pub fn (v PhpValue) to_v[T]() !T {
	return v.to_zval().to_v[T]()
}

pub fn (v PhpValue) to_dyn_value() !DynValue {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return DynValue.from_zval(temp.to_zval())
}

pub fn (v PhpValue) with_value[T](run fn (PhpValue) T) T {
	return v.value.with_request_value[T](fn [run] [T](value PhpValue) T {
		return run(value)
	})
}

pub fn (v PhpValue) with_array[T](run fn (PhpArray) T) ?T {
	return v.value.with_request_array[T](fn [run] [T](arr PhpArray) T {
		return run(arr)
	})
}

pub fn (v PhpValue) with_object[T](run fn (PhpObject) T) ?T {
	return v.value.with_request_object[T](fn [run] [T](obj PhpObject) T {
		return run(obj)
	})
}

pub fn (v PhpValue) method_exists(name string) bool {
	return v.with_object[bool](fn [name] (obj PhpObject) bool {
		return obj.method_exists(name)
	}) or { false }
}

pub fn (v PhpValue) is_instance_of(class_name string) bool {
	return v.with_object[bool](fn [class_name] (obj PhpObject) bool {
		return obj.is_instance_of(class_name)
	}) or { false }
}

pub fn (v PhpValue) class_name() string {
	return v.with_object[string](fn (obj PhpObject) string {
		return obj.class_name()
	}) or { '' }
}

pub fn (v PhpValue) resource_type() ?string {
	return v.to_zval().resource_type()
}

pub fn (v PhpValue) with_callable[T](run fn (PhpCallable) T) ?T {
	return v.value.with_request_callable[T](fn [run] [T](callable PhpCallable) T {
		return run(callable)
	})
}

pub fn (mut v PhpValue) release() {
	v.value.release()
}
