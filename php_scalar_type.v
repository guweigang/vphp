module vphp

pub struct PhpScalar {
mut:
	value PhpValueZBox
}

pub fn PhpScalar.from_zval(z ZVal) ?PhpScalar {
	if !z.is_valid() || z.is_undef() || z.is_null() || z.is_bool() || z.is_long() || z.is_double()
		|| z.is_string() {
		return PhpScalar{
			value: PhpValueZBox.from_zval(z)
		}
	}
	return none
}

pub fn PhpScalar.must_from_zval(z ZVal) !PhpScalar {
	value := PhpScalar.from_zval(z) or { return error('zval is not scalar') }
	return value
}

pub fn PhpScalar.from_request_owned_zbox(value RequestOwnedZBox) ?PhpScalar {
	if PhpScalar.is_zval_scalar(value.to_zval()) {
		return PhpScalar{
			value: PhpValueZBox.request_owned(value)
		}
	}
	return none
}

pub fn PhpScalar.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpScalar {
	z := value.to_zval()
	if PhpScalar.is_zval_scalar(z) {
		return PhpScalar{
			value: PhpValueZBox.persistent_owned(value)
		}
	}
	return none
}

fn PhpScalar.is_zval_scalar(z ZVal) bool {
	return !z.is_valid() || z.is_undef() || z.is_null() || z.is_bool() || z.is_long()
		|| z.is_double() || z.is_string()
}

pub fn PhpScalar.from_persistent_zval(z ZVal) ?PhpScalar {
	return PhpScalar.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (v PhpScalar) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpScalar) to_borrowed() PhpScalar {
	return PhpScalar.from_zval(v.value.to_borrowed_zbox().to_zval()) or { v }
}

pub fn (v PhpScalar) to_borrowed_zbox() RequestBorrowedZBox {
	return v.value.to_borrowed_zbox()
}

pub fn (v PhpScalar) to_request_owned() PhpScalar {
	return PhpScalar.from_request_owned_zbox(v.value.to_request_owned_zbox()) or {
		PhpScalar.from_zval(ZVal.new_null()) or { panic('null is scalar') }
	}
}

pub fn (v PhpScalar) to_request_owned_zbox() RequestOwnedZBox {
	return v.value.to_request_owned_zbox()
}

pub fn (mut v PhpScalar) take_zval() ZVal {
	return v.value.take_zval()
}

pub fn (mut v PhpScalar) release() {
	v.value.release()
}

pub fn (v PhpScalar) to_persistent_owned() PhpScalar {
	return PhpScalar.from_persistent_owned_zbox(v.value.to_persistent_owned_zbox()) or {
		PhpScalar.from_zval(ZVal.new_null()) or { panic('null is scalar') }
	}
}

pub fn (v PhpScalar) to_persistent_owned_zbox() PersistentOwnedZBox {
	return v.value.to_persistent_owned_zbox()
}

pub fn (v PhpScalar) type_name() string {
	return v.to_zval().type_name()
}

pub fn (v PhpScalar) is_null() bool {
	return v.to_zval().is_null() || v.to_zval().is_undef()
}

pub fn (v PhpScalar) is_bool() bool {
	return v.to_zval().is_bool()
}

pub fn (v PhpScalar) is_int() bool {
	return v.to_zval().is_long()
}

pub fn (v PhpScalar) is_double() bool {
	return v.to_zval().is_double()
}

pub fn (v PhpScalar) is_string() bool {
	return v.to_zval().is_string()
}

pub fn (v PhpScalar) to_bool() bool {
	return PhpBool.coerce(v.to_zval()).value()
}

pub fn (v PhpScalar) to_i64() i64 {
	return PhpInt.coerce(v.to_zval()).value()
}

pub fn (v PhpScalar) to_int() int {
	return int(v.to_i64())
}

pub fn (v PhpScalar) to_f64() f64 {
	return PhpDouble.coerce(v.to_zval()).value()
}

pub fn (v PhpScalar) to_string() string {
	return v.to_zval().to_string()
}

pub fn (v PhpScalar) to_dyn_value() DynValue {
	z := v.to_zval()
	if !z.is_valid() || z.is_undef() || z.is_null() {
		return DynValue.null()
	}
	if z.is_bool() {
		return DynValue.of_bool(z.to_bool())
	}
	if z.is_long() {
		return DynValue.of_int(z.to_i64())
	}
	if z.is_double() {
		return DynValue.of_float(z.to_f64())
	}
	return DynValue.of_string(z.to_string())
}
