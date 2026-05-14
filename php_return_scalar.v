module vphp

pub fn (ret PhpReturn) null() {
	ret.to_zval().set_null()
}

pub fn (ret PhpReturn) bool_value(val bool) {
	ret.to_zval().set_bool(val)
}

pub fn (ret PhpReturn) int_value(val i64) {
	ret.to_zval().set_int(val)
}

pub fn (ret PhpReturn) double_value(val f64) {
	ret.to_zval().set_double(val)
}

pub fn (ret PhpReturn) string_value(val string) {
	ret.to_zval().set_string(val)
}
