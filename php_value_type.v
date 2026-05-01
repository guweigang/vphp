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

pub fn (v PhpValue) type_id() PHPType {
	return v.to_zval().type_id()
}

pub fn (v PhpValue) type_name() string {
	return v.to_zval().type_name()
}

pub fn (v PhpValue) is_valid() bool {
	return v.to_zval().is_valid()
}

pub fn (v PhpValue) is_null() bool {
	return v.to_zval().is_null()
}

pub fn (v PhpValue) is_undef() bool {
	return v.to_zval().is_undef()
}

pub fn (v PhpValue) is_bool() bool {
	return v.to_zval().is_bool()
}

pub fn (v PhpValue) is_int() bool {
	return v.to_zval().is_long()
}

pub fn (v PhpValue) is_long() bool {
	return v.is_int()
}

pub fn (v PhpValue) is_float() bool {
	return v.to_zval().is_double()
}

pub fn (v PhpValue) is_double() bool {
	return v.is_float()
}

pub fn (v PhpValue) is_numeric() bool {
	return v.to_zval().is_numeric()
}

pub fn (v PhpValue) is_scalar() bool {
	return PhpScalar.from_zval(v.to_zval()) != none
}

pub fn (v PhpValue) is_string() bool {
	return v.to_zval().is_string()
}

pub fn (v PhpValue) is_array() bool {
	return v.to_zval().is_array()
}

pub fn (v PhpValue) is_object() bool {
	return v.to_zval().is_object()
}

pub fn (v PhpValue) is_resource() bool {
	return v.to_zval().is_resource()
}

pub fn (v PhpValue) is_reference() bool {
	return v.to_zval().type_id() == .reference
}

pub fn (v PhpValue) is_callable() bool {
	return v.to_zval().is_callable()
}

pub fn (v PhpValue) is_iterable() bool {
	return v.to_zval().is_array()
		|| (v.to_zval().is_object() && v.to_zval().is_instance_of('Traversable'))
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

pub fn (v PhpValue) as_null() ?PhpNull {
	return PhpNull.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_bool() ?PhpBool {
	return PhpBool.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_int() ?PhpInt {
	return PhpInt.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_double() ?PhpDouble {
	return PhpDouble.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_string() ?PhpString {
	return PhpString.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_scalar() ?PhpScalar {
	return PhpScalar.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_array() ?PhpArray {
	return PhpArray.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_object() ?PhpObject {
	return PhpObject.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_callable() ?PhpCallable {
	return PhpCallable.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_resource() ?PhpResource {
	return PhpResource.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_iterable() ?PhpIterable {
	return PhpIterable.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_reference() ?PhpReference {
	return PhpReference.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_throwable() ?PhpThrowable {
	return PhpThrowable.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_enum_case() ?PhpEnumCase {
	return PhpEnumCase.from_zval(v.to_zval())
}

pub fn (v PhpValue) require_null() !PhpNull {
	return PhpNull.must_from_zval(v.to_zval())
}

pub fn (v PhpValue) require_bool() !PhpBool {
	return PhpBool.must_from_zval(v.to_zval())
}

pub fn (v PhpValue) require_int() !PhpInt {
	return PhpInt.must_from_zval(v.to_zval())
}

pub fn (v PhpValue) require_double() !PhpDouble {
	return PhpDouble.must_from_zval(v.to_zval())
}

pub fn (v PhpValue) require_string() !PhpString {
	return PhpString.must_from_zval(v.to_zval())
}

pub fn (v PhpValue) require_scalar() !PhpScalar {
	return PhpScalar.must_from_zval(v.to_zval())
}

pub fn (v PhpValue) require_array() !PhpArray {
	return PhpArray.must_from_zval(v.to_zval())
}

pub fn (v PhpValue) require_object() !PhpObject {
	return PhpObject.must_from_zval(v.to_zval())
}

pub fn (v PhpValue) require_callable() !PhpCallable {
	return PhpCallable.must_from_zval(v.to_zval())
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
