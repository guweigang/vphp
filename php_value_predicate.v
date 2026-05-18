module vphp

pub fn (v PhpValue) type_id() PHPType {
	return v.value.with_request_zval[PHPType](fn (z ZVal) PHPType {
		return z.type_id()
	})
}

pub fn (v PhpValue) type_name() string {
	return v.value.with_request_zval[string](fn (z ZVal) string {
		return z.type_name()
	})
}

pub fn (v PhpValue) is_valid() bool {
	return v.value.is_valid()
}

pub fn (v PhpValue) is_null() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_null()
	})
}

pub fn (v PhpValue) is_undef() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_undef()
	})
}

pub fn (v PhpValue) is_bool() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_bool()
	})
}

pub fn (v PhpValue) is_int() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_long()
	})
}

pub fn (v PhpValue) is_long() bool {
	return v.is_int()
}

pub fn (v PhpValue) is_float() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_double()
	})
}

pub fn (v PhpValue) is_double() bool {
	return v.is_float()
}

pub fn (v PhpValue) is_numeric() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_numeric()
	})
}

pub fn (v PhpValue) is_scalar() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return PhpScalar.from_zval(z) != none
	})
}

pub fn (v PhpValue) is_string() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_string()
	})
}

pub fn (v PhpValue) is_array() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_array()
	})
}

pub fn (v PhpValue) is_list() bool {
	if arr := v.as_array() {
		return arr.is_list()
	}
	return false
}

pub fn (v PhpValue) is_object() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_object()
	})
}

pub fn (v PhpValue) is_resource() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_resource()
	})
}

pub fn (v PhpValue) is_reference() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.type_id() == .reference
	})
}

pub fn (v PhpValue) is_callable() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_callable()
	})
}

pub fn (v PhpValue) is_iterable() bool {
	return v.value.with_request_zval[bool](fn (z ZVal) bool {
		return z.is_array() || (z.is_object() && z.is_instance_of('Traversable'))
	})
}
