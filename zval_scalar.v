module vphp

import vphp.zval

// ======== 读取 — 标量类型 ========

fn zend_zval_get_long(v ZVal) i64 {
	return zval.get_long(v.handle())
}

fn zend_zval_get_int(v ZVal) i64 {
	return zval.get_int(v.handle())
}

fn zend_zval_get_lval(v ZVal) i64 {
	return zval.get_lval(v.handle())
}

fn zend_zval_get_double(v ZVal) f64 {
	return zval.get_double(v.handle())
}

fn zend_zval_set_null(v ZVal) {
	zval.set_null(v.handle())
}

fn zend_zval_set_bool(v ZVal, b bool) {
	zval.set_bool(v.handle(), b)
}

fn zend_zval_set_lval(v ZVal, val i64) {
	zval.set_lval(v.handle(), val)
}

fn zend_zval_set_double(v ZVal, val f64) {
	zval.set_double(v.handle(), val)
}

fn zend_zval_set_string(v ZVal, s string) {
	zval.set_string(v.handle(), s)
}

// bool
pub fn (v ZVal) to_bool() bool {
	return v.type_id() == .true_
}

pub fn (v ZVal) get_bool() bool {
	return zend_zval_get_long(v) != 0
}

// int / i64
pub fn (v ZVal) to_int() int {
	return int(zend_zval_get_int(v))
}

pub fn (v ZVal) to_i64() i64 {
	return i64(zend_zval_get_int(v))
}

pub fn (v ZVal) get_int() i64 {
	return zend_zval_get_long(v)
}

// float / f64
pub fn (v ZVal) to_f64() f64 {
	return zend_zval_get_double(v)
}

pub fn (v ZVal) to_float() f64 {
	return zend_zval_get_double(v)
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
	zend_zval_set_null(v)
}

pub fn (v ZVal) set_bool(b bool) {
	zend_zval_set_bool(v, b)
}

pub fn (v ZVal) set_int(val i64) {
	zend_zval_set_lval(v, val)
}

pub fn (v ZVal) set_double(val f64) {
	zend_zval_set_double(v, val)
}

pub fn (v ZVal) set_float(val f64) {
	zend_zval_set_double(v, val)
}

pub fn (v ZVal) set_string(s string) {
	zend_zval_set_string(v, s)
}
