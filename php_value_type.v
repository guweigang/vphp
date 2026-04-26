module vphp

pub struct PhpValue {
	value RequestBorrowedZBox
}

pub struct PersistentPhpValue {
mut:
	value PersistentOwnedZBox
}

pub fn PhpValue.from_zval(z ZVal) PhpValue {
	return PhpValue{
		value: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpValue.of(z ZVal) PhpValue {
	return PhpValue.from_zval(z)
}

pub fn PersistentPhpValue.from_zval(z ZVal) PersistentPhpValue {
	return PersistentPhpValue{
		value: PersistentOwnedZBox.of_mixed(z)
	}
}

pub fn PersistentPhpValue.of(z ZVal) PersistentPhpValue {
	return PersistentPhpValue.from_zval(z)
}

pub fn PersistentPhpValue.from_dyn(value DynValue) PersistentPhpValue {
	return PersistentPhpValue{
		value: PersistentOwnedZBox.of_data(value)
	}
}

pub fn (v PhpValue) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpValue) to_persistent() PersistentPhpValue {
	return PersistentPhpValue{
		value: PersistentOwnedZBox.of_mixed(v.to_zval())
	}
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

pub fn (v PhpValue) is_float() bool {
	return v.to_zval().is_double()
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

pub fn (v PhpValue) to_dyn() !DynValue {
	return decode_dyn_value(v.to_zval())
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

pub fn (v PersistentPhpValue) kind_name() string {
	return v.value.kind_name()
}

pub fn (v PersistentPhpValue) is_valid() bool {
	return v.value.is_valid()
}

pub fn (v PersistentPhpValue) clone() PersistentPhpValue {
	return PersistentPhpValue{
		value: v.value.clone()
	}
}

pub fn (v PersistentPhpValue) clone_request_owned() RequestOwnedZBox {
	return v.value.clone_request_owned()
}

pub fn (v PersistentPhpValue) with_value[T](run fn (PhpValue) T) T {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return run(PhpValue.from_zval(temp.to_zval()))
}

pub fn (v PersistentPhpValue) to_dyn() !DynValue {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return decode_dyn_value(temp.to_zval())
}

pub fn (v PersistentPhpValue) with_array[T](run fn (PhpArray) T) ?T {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	arr := PhpArray.from_zval(temp.to_zval()) or { return none }
	return run(arr)
}

pub fn (v PersistentPhpValue) with_object[T](run fn (PhpObject) T) ?T {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	obj := PhpObject.from_zval(temp.to_zval()) or { return none }
	return run(obj)
}

pub fn (v PersistentPhpValue) with_callable[T](run fn (PhpCallable) T) ?T {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	callable := PhpCallable.from_zval(temp.to_zval()) or { return none }
	return run(callable)
}

pub fn (mut v PersistentPhpValue) release() {
	v.value.release()
}
