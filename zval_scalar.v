module vphp

// ======== 读取 — 标量类型 ========

// bool
pub fn (v ZVal) to_bool() bool {
	return v.type_id() == .true_
}

pub fn (v ZVal) get_bool() bool {
	return unsafe { C.zval_get_long(v.raw) != 0 }
}

// int / i64
pub fn (v ZVal) to_int() int {
	return int(C.vphp_get_int(v.raw))
}

pub fn (v ZVal) to_i64() i64 {
	return i64(C.vphp_get_int(v.raw))
}

// 兼容旧 API
pub fn (v ZVal) as_int() i64 {
	return C.vphp_get_lval(v.raw)
}

pub fn (v ZVal) get_int() i64 {
	return unsafe { C.zval_get_long(v.raw) }
}

// float / f64
pub fn (v ZVal) to_f64() f64 {
	return C.vphp_get_double(v.raw)
}

pub fn (v ZVal) to_float() f64 {
	return C.vphp_get_double(v.raw)
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
	unsafe {
		ptr := C.VPHP_Z_STRVAL(v.raw)
		len := C.VPHP_Z_STRLEN(v.raw)
		if ptr == 0 {
			return ''
		}
		return ptr.vstring_with_len(len).clone()
	}
}

// ======== 写入 — 标量类型 ========

pub fn (v ZVal) set_null() {
	unsafe { C.vphp_set_null(v.raw) }
}

pub fn (v ZVal) set_bool(b bool) {
	unsafe { C.vphp_set_bool(v.raw, b) }
}

pub fn (v ZVal) set_int(val i64) {
	unsafe { C.vphp_set_lval(v.raw, val) }
}

pub fn (v ZVal) set_double(val f64) {
	unsafe { C.vphp_set_double(v.raw, val) }
}

pub fn (v ZVal) set_float(val f64) {
	unsafe { C.vphp_set_double(v.raw, val) }
}

pub fn (v ZVal) set_string(s string) {
	unsafe { C.vphp_set_strval(v.raw, &char(s.str), s.len) }
}
