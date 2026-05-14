module vphp

pub fn (ret PhpReturn) zval(val ZVal) {
	ret.to_zval().copy_from(val)
}

pub fn (ret PhpReturn) value(value PhpValue) {
	ret.zval(value.to_zval())
}

pub fn (ret PhpReturn) null_value(value PhpNull) {
	ret.zval(value.to_zval())
}

pub fn (ret PhpReturn) dyn_value(value DynValue) {
	mut owned := value.request_owned()
	defer {
		owned.release()
	}
	ret.zval(owned.to_zval())
}

pub fn (ret PhpReturn) request_owned(value RequestOwnedZBox) {
	ret.zval(value.to_zval())
}

pub fn (ret PhpReturn) request_borrowed(value RequestBorrowedZBox) {
	ret.zval(value.to_zval())
}

pub fn (ret PhpReturn) persistent_owned(value PersistentOwnedZBox) {
	value.with_request_zval(fn [ret] (z ZVal) bool {
		ret.zval(z)
		return true
	})
}
