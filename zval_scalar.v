module vphp

import vphp.zval

// ======== 读取 — 标量类型 ========

// bool
pub fn (v ZVal) to_bool() bool {
	return v.type_id() == .true_
}

pub fn (v ZVal) get_bool() bool {
	return zval.get_long(v.handle()) != 0
}

// int / i64
pub fn (v ZVal) to_int() int {
	return int(zval.get_int(v.handle()))
}

pub fn (v ZVal) to_i64() i64 {
	return i64(zval.get_int(v.handle()))
}

pub fn (v ZVal) get_int() i64 {
	return zval.get_long(v.handle())
}

// float / f64
pub fn (v ZVal) to_f64() f64 {
	return zval.get_double(v.handle())
}

pub fn (v ZVal) to_float() f64 {
	return zval.get_double(v.handle())
}

// string
pub fn (v ZVal) to_string() string {
	if !v.is_valid() || v.is_null() || v.is_undef() {
		return ''
	}
	if v.is_string() {
		return v.get_string()
	}
	if v.is_bool() {
		return if v.get_bool() { '1' } else { '' }
	}
	if v.is_long() {
		return v.to_i64().str()
	}
	if v.is_double() {
		return v.to_f64().str()
	}
	text := php_fn('strval').call([v])
	if text.is_valid() && text.is_string() {
		return text.get_string()
	}
	return ''
}

pub fn (v ZVal) get_string() string {
	if !v.is_valid() {
		return ''
	}
	return zval.string_value(v.handle())
}

// ======== 写入 — 标量类型 ========

pub fn (v ZVal) set_null() {
	zval.set_null(v.handle())
}

pub fn (v ZVal) set_bool(b bool) {
	zval.set_bool(v.handle(), b)
}

pub fn (v ZVal) set_int(val i64) {
	zval.set_lval(v.handle(), val)
}

pub fn (v ZVal) set_double(val f64) {
	zval.set_double(v.handle(), val)
}

pub fn (v ZVal) set_float(val f64) {
	zval.set_double(v.handle(), val)
}

pub fn (v ZVal) set_string(s string) {
	zval.set_string(v.handle(), s)
}
