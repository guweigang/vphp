module vphp

pub struct PhpValue {
mut:
	value PhpValueZBox
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
	return PhpJson.encode(v.to_zval())
}

pub fn (v PhpValue) to_json_with_flags(flags int) string {
	return PhpJson.encode_with_flags(v.to_zval(), flags)
}

pub fn (v PhpValue) borrowed() PhpValue {
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

pub fn (v PhpValue) to_persistent_owned_zbox() PersistentOwnedZBox {
	return v.value.to_persistent_owned_zbox()
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

pub fn (v PhpValue) with_callable[T](run fn (PhpCallable) T) ?T {
	return v.value.with_request_callable[T](fn [run] [T](callable PhpCallable) T {
		return run(callable)
	})
}

pub fn (mut v PhpValue) release() {
	v.value.release()
}
