module vphp

pub fn (a PhpArray) assoc(key string, value PhpArgInput) {
	raw := value.to_zval()
	a.to_zval().add_assoc_zval(key, raw)
}

pub fn (a PhpArray) assoc_zval(key string, value ZVal) {
	a.to_zval().add_assoc_zval(key, value)
}

pub fn (a PhpArray) set(key string, value PhpArgInput) {
	a.assoc(key, value)
}

pub fn (a PhpArray) set_value(key string, value PhpValue) {
	mut owned := value.owned()
	a.assoc_zval(key, owned.take_zval())
}

pub fn (a PhpArray) set_zval(key string, value ZVal) {
	a.assoc_zval(key, value)
}

pub fn (a PhpArray) set_request_owned_zbox(key string, value RequestOwnedZBox) {
	mut wrapped := PhpValue.from_request_owned_zbox(value)
	a.set(key, wrapped)
	wrapped.release()
}

pub fn (a PhpArray) string(key string, value string) {
	a.to_zval().add_assoc_string(key, value)
}

pub fn (a PhpArray) int(key string, value i64) {
	a.to_zval().add_assoc_long(key, value)
}

pub fn (a PhpArray) double(key string, value f64) {
	a.to_zval().add_assoc_double(key, value)
}

pub fn (a PhpArray) bool(key string, value bool) {
	a.to_zval().add_assoc_bool(key, value)
}

pub fn (a PhpArray) null_value(key string) {
	a.assoc(key, PhpNull.value())
}

pub fn (a PhpArray) next(value PhpArgInput) {
	a.to_zval().add_next_val(value.to_zval())
}

pub fn (a PhpArray) next_zval(value ZVal) {
	a.to_zval().add_next_val(value)
}

pub fn (a PhpArray) push(value PhpArgInput) {
	a.next(value)
}

pub fn (a PhpArray) push_value(value PhpValue) {
	mut owned := value.owned()
	a.next_zval(owned.take_zval())
}

pub fn (a PhpArray) push_zval(value ZVal) {
	a.next_zval(value)
}

pub fn (a PhpArray) push_string(value string) {
	a.to_zval().push_string(value)
}
