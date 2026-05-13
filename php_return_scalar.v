module vphp

pub fn (ret PhpReturn) null() {
	ZVal.from_raw(ret.raw).set_null()
}

pub fn (ret PhpReturn) bool_value(val bool) {
	ZVal.from_raw(ret.raw).set_bool(val)
}

pub fn (ret PhpReturn) int_value(val i64) {
	ZVal.from_raw(ret.raw).set_int(val)
}

pub fn (ret PhpReturn) double_value(val f64) {
	ZVal.from_raw(ret.raw).set_double(val)
}

pub fn (ret PhpReturn) string_value(val string) {
	ZVal.from_raw(ret.raw).set_string(val)
}
