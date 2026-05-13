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
