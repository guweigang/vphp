module vphp

import vphp.zval

// ======== 数组操作 ========

fn zend_array_init(v ZVal) {
	zval.array_init(zval.Handle.from_ptr(v.raw))
}

fn zend_array_add_assoc_string(v ZVal, key string, val string) {
	zval.array_add_assoc_string(zval.Handle.from_ptr(v.raw), key, val)
}

fn zend_array_add_assoc_long(v ZVal, key string, val i64) {
	zval.array_add_assoc_long(zval.Handle.from_ptr(v.raw), key, val)
}

fn zend_array_add_assoc_double(v ZVal, key string, val f64) {
	zval.array_add_assoc_double(zval.Handle.from_ptr(v.raw), key, val)
}

fn zend_array_add_assoc_bool(v ZVal, key string, val bool) {
	zval.array_add_assoc_bool(zval.Handle.from_ptr(v.raw), key, val)
}

fn zend_array_add_assoc_zval(v ZVal, key string, val ZVal) {
	zval.array_add_assoc_zval(zval.Handle.from_ptr(v.raw), key, zval.Handle.from_ptr(val.raw))
}

fn zend_array_push_string(v ZVal, s string) {
	zval.array_push_string(zval.Handle.from_ptr(v.raw), s)
}

fn zend_array_push_long(v ZVal, val i64) {
	zval.array_push_long(zval.Handle.from_ptr(v.raw), val)
}

fn zend_array_push_double(v ZVal, val f64) {
	zval.array_push_double(zval.Handle.from_ptr(v.raw), val)
}

fn zend_array_push_bool(v ZVal, val bool) {
	zval.array_push_bool(zval.Handle.from_ptr(v.raw), val)
}

fn zend_array_add_next_zval(v ZVal, val ZVal) {
	zval.array_add_next_zval(zval.Handle.from_ptr(v.raw), zval.Handle.from_ptr(val.raw))
}

fn zend_array_count(v ZVal) int {
	return zval.array_count(zval.Handle.from_ptr(v.raw))
}

fn zend_array_get_index(v ZVal, index int) &C.zval {
	return ZVal.from_handle(zval.array_get_index(zval.Handle.from_ptr(v.raw), index)).raw
}

fn zend_array_get_key(v ZVal, key string) &C.zval {
	return ZVal.from_handle(zval.array_get_key(zval.Handle.from_ptr(v.raw), key)).raw
}

fn zend_zval_is_null_raw(raw &C.zval) bool {
	return zval.is_null(zval.Handle.from_ptr(raw))
}

// 初始化为数组
pub fn (v ZVal) array_init() {
	zend_array_init(v)
}

pub fn (v ZVal) add_assoc_string(key string, val string) {
	zend_array_add_assoc_string(v, key, val)
}

pub fn (v ZVal) add_assoc_long(key string, val i64) {
	zend_array_add_assoc_long(v, key, val)
}

pub fn (v ZVal) add_assoc_double(key string, val f64) {
	zend_array_add_assoc_double(v, key, val)
}

pub fn (v ZVal) add_assoc_bool(key string, val bool) {
	zend_array_add_assoc_bool(v, key, val)
}

pub fn (v ZVal) add_assoc_zval(key string, val ZVal) {
	zend_array_add_assoc_zval(v, key, val)
}

fn (v ZVal) add_assoc_dyn_value(key string, val DynValue) ! {
	mut sub_raw := C.zval{}
	mut sub := ZVal{
		raw: &sub_raw
	}
	val.to_zval(mut sub)!
	v.add_assoc_zval(key, sub)
}

pub fn (v ZVal) push_string(s string) {
	zend_array_push_string(v, s)
}

pub fn (v ZVal) push_long(val i64) {
	zend_array_push_long(v, val)
}

pub fn (v ZVal) push_double(val f64) {
	zend_array_push_double(v, val)
}

pub fn (v ZVal) push_bool(val bool) {
	zend_array_push_bool(v, val)
}

pub fn (v ZVal) add_next_val(val ZVal) {
	zend_array_add_next_zval(v, val)
}

fn (v ZVal) add_next_dyn_value(val DynValue) ! {
	mut sub_raw := C.zval{}
	mut sub := ZVal{
		raw: &sub_raw
	}
	val.to_zval(mut sub)!
	v.add_next_val(sub)
}

// 获取数组长度
pub fn (v ZVal) array_count() int {
	if !v.is_array() {
		return 0
	}
	return zend_array_count(v)
}

// 按数字索引取值
pub fn (v ZVal) array_get(index int) ZVal {
	if !v.is_array() {
		return unsafe {
			ZVal{
				raw: 0
			}
		}
	}
	res := zend_array_get_index(v, index)
	return ZVal{
		raw: res
	}
}

pub fn (v ZVal) keys() ZVal {
	if !v.is_array() {
		mut out := ZVal.new_null()
		out.array_init()
		return out
	}
	mut out := ZVal.new_null()
	out.array_init()
	v.foreach_with_ctx[ZVal](out, fn (key ZVal, _ ZVal, mut acc ZVal) {
		acc.add_next_val(key)
	})
	return out
}

pub fn (v ZVal) values() ZVal {
	if !v.is_array() {
		mut out := ZVal.new_null()
		out.array_init()
		return out
	}
	mut out := ZVal.new_null()
	out.array_init()
	v.foreach_with_ctx[ZVal](out, fn (_ ZVal, val ZVal, mut acc ZVal) {
		acc.add_next_val(val)
	})
	return out
}

pub fn (v ZVal) keys_string() []string {
	if !v.is_array() {
		return []string{}
	}
	return v.foreach_with_ctx[[]string]([]string{}, fn (key ZVal, _ ZVal, mut acc []string) {
		acc << key.to_string()
	})
}

pub fn (v ZVal) assoc_keys() []string {
	if !v.is_array() {
		return []string{}
	}
	return v.foreach_with_ctx[[]string]([]string{}, fn (key ZVal, _ ZVal, mut acc []string) {
		if key.is_string() {
			acc << key.get_string()
		}
	})
}

// 按字符串 key 取值（带错误处理）
pub fn (v ZVal) get(key string) !ZVal {
	if v.raw == 0 || zend_zval_is_null_raw(v.raw) {
		return error('invalid zval or not an array')
	}
	unsafe {
		res := zend_array_get_key(v, key)
		if res == 0 || zend_zval_is_null_raw(res) {
			return error('key "${key}" not found')
		}
		return ZVal{
			raw: res
		}
	}
}

pub fn (v ZVal) get_key(key ZVal) !ZVal {
	if v.raw == 0 || zend_zval_is_null_raw(v.raw) {
		return error('invalid zval or not an array')
	}
	if key.is_long() {
		index := key.to_i64()
		if index < 0 {
			return error('negative array index ${index} is not supported')
		}
		res := zend_array_get_index(v, int(index))
		if res == 0 || zend_zval_is_null_raw(res) {
			return error('index ${index} not found')
		}
		return ZVal{
			raw: res
		}
	}
	if key.is_string() {
		return v.get(key.to_string())
	}
	return error('unsupported array key type: ${key.type_name()}')
}

// 按字符串 key 取值（返回默认值）
pub fn (v ZVal) get_or(key string, default_val string) string {
	val := v.get(key) or { return default_val }
	return val.to_string()
}

fn zval_string_key_or(input ZVal, key string, default_value string) string {
	raw := input.get(key) or { return default_value }
	if !raw.is_valid() || raw.is_null() || raw.is_undef() {
		return default_value
	}
	return raw.to_string()
}

fn zval_bool_key_or(input ZVal, key string, default_value bool) bool {
	raw := input.get(key) or { return default_value }
	if !raw.is_valid() || raw.is_null() || raw.is_undef() {
		return default_value
	}
	if raw.is_bool() {
		return raw.to_bool()
	}
	if raw.is_long() {
		return raw.to_i64() != 0
	}
	return raw.to_string().trim_space().to_lower() in ['1', 'true', 'yes', 'on']
}
