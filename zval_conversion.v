module vphp

// ======== 新版清晰转换 API ========
// Zend Value -> V:   v.to_v[T]()
// V -> Zend Value:   v.from_v[T](x), new_zval_from[T](x)
//
// Ownership-aware code should prefer `RequestBorrowedZBox`,
// `RequestOwnedZBox`, and `PersistentOwnedZBox`.

// 便捷转换：array => map<string,string>（无效/null/undef 返回空 map）
pub fn (v ZVal) to_string_map() map[string]string {
	if !v.is_valid() || v.is_null() || v.is_undef() || !v.is_array() {
		return map[string]string{}
	}
	return v.foreach_with_ctx[map[string]string](map[string]string{}, fn (key ZVal, val ZVal, mut acc map[string]string) {
		acc[key.to_string()] = val.to_string()
	})
}

// 便捷转换：array => []string（无效/null/undef 返回空数组）
pub fn (v ZVal) to_string_list() []string {
	if !v.is_valid() || v.is_null() || v.is_undef() || !v.is_array() {
		return []string{}
	}
	return v.foreach_with_ctx[[]string]([]string{}, fn (_ ZVal, val ZVal, mut acc []string) {
		acc << val.to_string()
	})
}

// 将 Zend Value 转换为明确的 V 类型（严格校验类型）
pub fn (v ZVal) to_v[T]() !T {
	$if T is ZVal {
		return v
	}
	$if T is RequestBorrowedZBox {
		return RequestBorrowedZBox.of(v)
	}
	$if T is RequestOwnedZBox {
		return RequestOwnedZBox.of(v)
	}
	$if T is PersistentOwnedZBox {
		return PersistentOwnedZBox.of(v)
	}
	$if T is bool {
		if !v.is_bool() {
			return error('type mismatch: expected bool, got ${v.type_name()}')
		}
		return v.to_bool()
	}
	$if T is int {
		if !v.is_numeric() {
			return error('type mismatch: expected int, got ${v.type_name()}')
		}
		return v.to_int()
	}
	$if T is i64 {
		if !v.is_numeric() {
			return error('type mismatch: expected i64, got ${v.type_name()}')
		}
		return v.to_i64()
	}
	$if T is f64 {
		if !v.is_numeric() {
			return error('type mismatch: expected f64, got ${v.type_name()}')
		}
		return v.to_f64()
	}
	$if T is string {
		if !v.is_string() {
			return error('type mismatch: expected string, got ${v.type_name()}')
		}
		return v.to_string()
	}
	$if T is []string {
		if !v.is_array() {
			return error('type mismatch: expected array<string>, got ${v.type_name()}')
		}
		mut out := []string{}
		for i in 0 .. v.array_count() {
			item := v.array_get(i)
			out << item.to_v[string]()!
		}
		return out
	}
	$if T is []int {
		if !v.is_array() {
			return error('type mismatch: expected array<int>, got ${v.type_name()}')
		}
		mut out := []int{}
		for i in 0 .. v.array_count() {
			item := v.array_get(i)
			out << item.to_v[int]()!
		}
		return out
	}
	$if T is []i64 {
		if !v.is_array() {
			return error('type mismatch: expected array<i64>, got ${v.type_name()}')
		}
		mut out := []i64{}
		for i in 0 .. v.array_count() {
			item := v.array_get(i)
			out << item.to_v[i64]()!
		}
		return out
	}
	$if T is []f64 {
		if !v.is_array() {
			return error('type mismatch: expected array<f64>, got ${v.type_name()}')
		}
		mut out := []f64{}
		for i in 0 .. v.array_count() {
			item := v.array_get(i)
			out << item.to_v[f64]()!
		}
		return out
	}
	$if T is []bool {
		if !v.is_array() {
			return error('type mismatch: expected array<bool>, got ${v.type_name()}')
		}
		mut out := []bool{}
		for i in 0 .. v.array_count() {
			item := v.array_get(i)
			out << item.to_v[bool]()!
		}
		return out
	}
	$if T is []ZVal {
		if !v.is_array() {
			return error('type mismatch: expected array<ZVal>, got ${v.type_name()}')
		}
		mut out := []ZVal{}
		for i in 0 .. v.array_count() {
			out << v.array_get(i)
		}
		return out
	}
	$if T is map[string]string {
		if !v.is_array() {
			return error('type mismatch: expected map<string,string>, got ${v.type_name()}')
		}
		mut out := map[string]string{}
		out = v.foreach_with_ctx[map[string]string](out, fn (key ZVal, val ZVal, mut m map[string]string) {
			m[key.to_string()] = val.to_string()
		})
		return out
	}
	$if T is map[string]int {
		if !v.is_array() {
			return error('type mismatch: expected map<string,int>, got ${v.type_name()}')
		}
		mut out := map[string]int{}
		out = v.foreach_with_ctx[map[string]int](out, fn (key ZVal, val ZVal, mut m map[string]int) {
			m[key.to_string()] = val.to_int()
		})
		return out
	}
	$if T is map[string]f64 {
		if !v.is_array() {
			return error('type mismatch: expected map<string,f64>, got ${v.type_name()}')
		}
		mut out := map[string]f64{}
		out = v.foreach_with_ctx[map[string]f64](out, fn (key ZVal, val ZVal, mut m map[string]f64) {
			m[key.to_string()] = val.to_f64()
		})
		return out
	}
	$if T is map[string]ZVal {
		if !v.is_array() {
			return error('type mismatch: expected map<string,ZVal>, got ${v.type_name()}')
		}
		mut out := map[string]ZVal{}
		out = v.foreach_with_ctx[map[string]ZVal](out, fn (key ZVal, val ZVal, mut m map[string]ZVal) {
			m[key.to_string()] = val
		})
		return out
	}
	return error('unsupported to_v conversion for requested type')
}

// 将 V 类型写入 Zend Value
pub fn (v ZVal) from_v[T](value T) ! {
	$if T is ZVal {
		if !value.is_valid() {
			v.set_null()
			return
		}
		unsafe { C.ZVAL_COPY(v.raw, value.raw) }
		return
	}
	$if T is RequestBorrowedZBox {
		if !value.is_valid() {
			v.set_null()
			return
		}
		unsafe { C.ZVAL_COPY(v.raw, value.to_zval().raw) }
		return
	}
	$if T is RequestOwnedZBox {
		if !value.is_valid() {
			v.set_null()
			return
		}
		unsafe { C.ZVAL_COPY(v.raw, value.to_zval().raw) }
		return
	}
	$if T is PersistentOwnedZBox {
		if !value.is_valid() {
			v.set_null()
			return
		}
		unsafe { C.ZVAL_COPY(v.raw, value.to_zval().raw) }
		return
	}
	$if T is bool {
		v.set_bool(value)
		return
	}
	$if T is int || T is i64 {
		v.set_int(i64(value))
		return
	}
	$if T is f64 {
		v.set_double(value)
		return
	}
	$if T is string {
		v.set_string(value)
		return
	}
	$if T is []string {
		v.array_init()
		for item in value {
			v.push_string(item)
		}
		return
	}
	$if T is []int || T is []i64 {
		v.array_init()
		for item in value {
			v.push_long(i64(item))
		}
		return
	}
	$if T is []f64 {
		v.array_init()
		for item in value {
			v.push_double(item)
		}
		return
	}
	$if T is []bool {
		v.array_init()
		for item in value {
			v.push_bool(item)
		}
		return
	}
	$if T is []ZVal {
		v.array_init()
		for item in value {
			v.add_next_val(item)
		}
		return
	}
	$if T is []map[string]string {
		v.array_init()
		for item in value {
			mut sub := RequestOwnedZBox.new_null().to_zval()
			sub.array_init()
			for key, val in item {
				sub.add_assoc_string(key, val)
			}
			v.add_next_val(sub)
		}
		return
	}
	$if T is map[string][]string {
		v.array_init()
		for key, item in value {
			mut sub := RequestOwnedZBox.new_null().to_zval()
			sub.array_init()
			for entry in item {
				sub.push_string(entry)
			}
			C.vphp_array_add_assoc_zval(v.raw, &char(key.str), sub.raw)
		}
		return
	}
	$if T is map[string]string {
		v.array_init()
		for key, item in value {
			v.add_assoc_string(key, item)
		}
		return
	}
	$if T is map[string]int || T is map[string]i64 {
		v.array_init()
		for key, item in value {
			v.add_assoc_long(key, i64(item))
		}
		return
	}
	$if T is map[string]f64 {
		v.array_init()
		for key, item in value {
			v.add_assoc_double(key, item)
		}
		return
	}
	$if T is map[string]bool {
		v.array_init()
		for key, item in value {
			v.add_assoc_bool(key, item)
		}
		return
	}
	$if T is map[string]ZVal {
		v.array_init()
		for key, item in value {
			C.vphp_array_add_assoc_zval(v.raw, &char(key.str), item.raw)
		}
		return
	}
	return error('unsupported from_v conversion for source type')
}

// 便捷工厂：从 V 类型直接创建 Zend Value 包装
pub fn new_zval_from[T](value T) !ZVal {
	mut out := ZVal{
		raw:   C.vphp_new_zval()
		owned: true
	}
	autorelease_add(out.raw)
	out.from_v[T](value)!
	return out
}

pub fn ZVal.from[T](value T) !ZVal {
	return new_zval_from[T](value)!
}

// 兼容旧命名：建议改用 new_zval_from[T]
pub fn new_val_from[T](value T) !ZVal {
	return new_zval_from[T](value)
}
