module vphp

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
