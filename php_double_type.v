module vphp

pub struct PhpDouble {
mut:
	value PhpValueZBox
}

pub fn PhpDouble.from_zval(z ZVal) ?PhpDouble {
	if !z.is_double() {
		return none
	}
	return PhpDouble{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpDouble.must_from_zval(z ZVal) !PhpDouble {
	value := PhpDouble.from_zval(z) or { return error('zval is not double') }
	return value
}

pub fn PhpDouble.from_request_owned_zbox(value RequestOwnedZBox) ?PhpDouble {
	if !value.to_zval().is_double() {
		return none
	}
	return PhpDouble{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpDouble.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpDouble {
	if !value.to_zval().is_double() {
		return none
	}
	return PhpDouble{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpDouble.from_persistent_zval(z ZVal) ?PhpDouble {
	return PhpDouble.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn PhpDouble.coerce(z ZVal) PhpDouble {
	result := php_fn('floatval').call([z])
	return PhpDouble{
		value: PhpValueZBox.adopt_zval(result)
	}
}

pub fn PhpDouble.of(value f64) PhpDouble {
	return PhpDouble{
		value: PhpValueZBox.request_owned(RequestOwnedZBox.new_float(value))
	}
}

pub fn PhpDouble.zero() PhpDouble {
	return PhpDouble.of(0.0)
}

pub fn (v PhpDouble) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpDouble) to_borrowed() PhpDouble {
	return PhpDouble.from_zval(v.value.to_borrowed_zbox().to_zval()) or { v }
}

pub fn (v PhpDouble) to_borrowed_zbox() RequestBorrowedZBox {
	return v.value.to_borrowed_zbox()
}

pub fn (v PhpDouble) to_request_owned() PhpDouble {
	return PhpDouble.from_request_owned_zbox(v.value.to_request_owned_zbox()) or {
		PhpDouble.zero()
	}
}

pub fn (v PhpDouble) to_request_owned_zbox() RequestOwnedZBox {
	return v.value.to_request_owned_zbox()
}

pub fn (mut v PhpDouble) take_zval() ZVal {
	return v.value.take_zval()
}

pub fn (mut v PhpDouble) release() {
	v.value.release()
}

pub fn (v PhpDouble) to_persistent_owned() PhpDouble {
	return PhpDouble.from_persistent_owned_zbox(v.value.to_persistent_owned_zbox()) or {
		PhpDouble.zero()
	}
}

pub fn (v PhpDouble) to_persistent_owned_zbox() PersistentOwnedZBox {
	return v.value.to_persistent_owned_zbox()
}

pub fn (v PhpDouble) value() f64 {
	return v.to_zval().to_f64()
}

pub fn (v PhpDouble) to_dyn_value() DynValue {
	return DynValue.of_float(v.value())
}
