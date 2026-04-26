module vphp

import vphp.zend as _

pub struct PhpReference {
	value RequestBorrowedZBox
}

pub fn PhpReference.from_zval(z ZVal) ?PhpReference {
	if z.type_id() != .reference {
		return none
	}
	return PhpReference{
		value: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpReference.must_from_zval(z ZVal) !PhpReference {
	ref := PhpReference.from_zval(z) or { return error('zval is not reference') }
	return ref
}

pub fn (r PhpReference) to_zval() ZVal {
	return r.value.to_zval()
}

pub fn (r PhpReference) deref() PhpValue {
	raw := C.vphp_reference_value(r.to_zval().raw)
	if raw == 0 {
		return PhpValue.from_zval(invalid_zval())
	}
	return PhpValue.from_zval(ZVal{
		raw: raw
	})
}

pub fn (r PhpReference) set(value ZVal) {
	C.vphp_reference_set_zval(r.to_zval().raw, value.raw)
}

pub fn (r PhpReference) set_value(value PhpValue) {
	r.set(value.to_zval())
}
