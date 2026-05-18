module vphp

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
	if !v.is_array() {
		return none
	}
	return PhpArray{
		value: v.value.clone()
	}
}

pub fn (v PhpValue) as_object() ?PhpObject {
	if !v.is_object() {
		return none
	}
	return PhpObject{
		value: v.value.clone()
	}
}

pub fn (v PhpValue) to_v_object[T]() ?&T {
	obj := v.as_object() or { return none }
	return obj.to_v_object[T]()
}

pub fn (v PhpValue) as_callable() ?PhpCallable {
	if !v.is_callable() {
		return none
	}
	return PhpCallable{
		callable: v.value.clone()
	}
}

pub fn (v PhpValue) as_resource() ?PhpResource {
	return PhpResource.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_iterable() ?PhpIterable {
	return PhpIterable.from_zval(v.to_zval())
}

pub fn (v PhpValue) as_iterator() ?PhpIterator {
	return PhpIterator.from_zval(v.to_zval())
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

pub fn (v PhpValue) require_iterator() !PhpIterator {
	return PhpIterator.must_from_zval(v.to_zval())
}
