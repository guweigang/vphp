module vphp

import vphp.zval

// ======== 数组操作 ========

// 初始化为数组
pub fn (v ZVal) array_init() {
	zval.array_init(v.handle())
}

pub fn (v ZVal) add_assoc_string(key string, val string) {
	zval.array_add_assoc_string(v.handle(), key, val)
}

pub fn (v ZVal) add_assoc_long(key string, val i64) {
	zval.array_add_assoc_long(v.handle(), key, val)
}

pub fn (v ZVal) add_assoc_double(key string, val f64) {
	zval.array_add_assoc_double(v.handle(), key, val)
}

pub fn (v ZVal) add_assoc_bool(key string, val bool) {
	zval.array_add_assoc_bool(v.handle(), key, val)
}

pub fn (v ZVal) add_assoc_zval(key string, val ZVal) {
	zval.array_add_assoc_zval(v.handle(), key, val.handle())
}

fn (v ZVal) add_assoc_dyn_value(key string, val DynValue) ! {
	mut temp := RequestOwnedZBox.new_null()
	defer {
		temp.release()
	}
	mut sub := temp.to_zval()
	val.to_zval(mut sub)!
	v.add_assoc_zval(key, sub)
}

pub fn (v ZVal) push_string(s string) {
	zval.array_push_string(v.handle(), s)
}

pub fn (v ZVal) push_long(val i64) {
	zval.array_push_long(v.handle(), val)
}

pub fn (v ZVal) push_double(val f64) {
	zval.array_push_double(v.handle(), val)
}

pub fn (v ZVal) push_bool(val bool) {
	zval.array_push_bool(v.handle(), val)
}

pub fn (v ZVal) add_next_val(val ZVal) {
	zval.array_add_next_zval(v.handle(), val.handle())
}

fn (v ZVal) add_next_dyn_value(val DynValue) ! {
	mut temp := RequestOwnedZBox.new_null()
	defer {
		temp.release()
	}
	mut sub := temp.to_zval()
	val.to_zval(mut sub)!
	v.add_next_val(sub)
}

// 获取数组长度
pub fn (v ZVal) array_count() int {
	if !v.is_array() {
		return 0
	}
	return zval.array_count(v.handle())
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
	res := zval.array_get_index(v.handle(), index)
	return ZVal.from_handle(res)
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
		acc.add_next_val(key.dup())
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
		acc.add_next_val(val.dup())
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
	if !v.is_valid() || zval.is_null(v.handle()) {
		return error('invalid zval or not an array')
	}
	res := zval.array_get_key(v.handle(), key)
	if !res.is_valid() || zval.is_null(res) {
		return error('key "${key}" not found')
	}
	return ZVal.from_handle(res)
}

// value_at returns the value for a string array key, or a request-owned null
// value when the key is absent. Use get() when absence should remain explicit.
pub fn (v ZVal) value_at(key string) ZVal {
	return v.get(key) or { ZVal.new_null() }
}

pub fn (v ZVal) [] (key string) ZVal {
	return v.value_at(key)
}

pub fn (v ZVal) string_at(key string, default_value string) string {
	raw := v.get(key) or { return default_value }
	text := raw.to_string().trim_space()
	return if text == '' { default_value } else { text }
}

pub fn (v ZVal) raw_string_at(key string, default_value string) string {
	raw := v.get(key) or { return default_value }
	return raw.to_string()
}

pub fn (v ZVal) int_at(key string, default_value int) int {
	raw := v.get(key) or { return default_value }
	if raw.is_string() {
		text := raw.to_string().trim_space()
		return if text == '' { default_value } else { text.int() }
	}
	return int(raw.to_i64())
}

pub fn (v ZVal) bool_at(key string, default_value bool) bool {
	raw := v.get(key) or { return default_value }
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

pub fn (v ZVal) get_key(key ZVal) !ZVal {
	if !v.is_valid() || zval.is_null(v.handle()) {
		return error('invalid zval or not an array')
	}
	if key.is_long() {
		index := key.to_i64()
		if index < 0 {
			return error('negative array index ${index} is not supported')
		}
		res := zval.array_get_index(v.handle(), int(index))
		if !res.is_valid() || zval.is_null(res) {
			return error('index ${index} not found')
		}
		return ZVal.from_handle(res)
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
