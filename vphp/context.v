module vphp

import vphp.zend as _

// ============================================
// Context — PHP 函数调用上下文
// 封装 execute_data + return_value，提供参数获取和返回值设置
// ============================================

pub struct Context {
pub:
	ex  &C.zend_execute_data
	ret &C.zval
}

// ======== 参数个数 ========

pub fn (ctx Context) num_args() int {
	return int(C.vphp_get_num_args(ctx.ex))
}

// ======== 异常检查 ========

pub fn (ctx Context) has_exception() bool {
	return C.vphp_has_exception()
}

// ======== 获取原始参数 ========

pub fn (ctx Context) arg_raw(index int) Val {
	args := get_args(ctx.ex)
	if index >= args.len || index < 0 {
		return unsafe { Val{
			raw: 0
		} }
	}
	return args[index]
}

// ======== 泛型参数获取 ========
// 支持类型：string, int, i64, f64, bool,
//           []string, []int, []i64, []f64, []bool,
//           map[string]string, map[string]f64, map[string]int

pub fn (ctx Context) arg[T](index int) T {
	args := get_args(ctx.ex)
	if index >= args.len {
		return T{}
	}
	val := args[index]
	raw_zval := val.raw

	// --- 数组 / 切片 ---
	$if T is $array {
		if !val.is_array() {
			C.vphp_throw(&char('Expected array at index ${index}'.str), 0)
			return T{}
		}
		count := C.vphp_array_count(raw_zval)
		mut res := T{
			cap: count
		}
		for i in 0 .. count {
			item_zval := C.vphp_array_get_index(raw_zval, u32(i))
			if item_zval != 0 {
				$if T is []string {
					len := 0
					ptr := voidptr(C.vphp_get_string_ptr(item_zval, &len))
					if ptr != 0 {
						res << unsafe { (&char(ptr)).vstring_with_len(len).clone() }
					} else {
						res << ''
					}
				} $else $if T is []f64 {
					res << C.vphp_get_double(item_zval)
				} $else $if T is []int {
					res << int(C.vphp_get_int(item_zval))
				} $else $if T is []i64 {
					res << i64(C.vphp_get_int(item_zval))
				} $else $if T is []bool {
					res << C.vphp_get_bool(item_zval)
				}
			}
		}
		return res
	}

	// --- 布尔 ---
	$if T is bool {
		if !val.is_bool() {
			C.vphp_throw(&char('Argument ${index} must be a boolean'.str), 0)
			return false
		}
		return val.to_bool()
	}

	// --- 浮点 ---
	$if T is f64 {
		if !val.is_double() && !val.is_long() {
			C.vphp_throw(&char('Argument ${index} must be a number'.str), 0)
			return 0.0
		}
		return C.vphp_get_double(val.raw)
	}

	// --- 整型 int ---
	$if T is int {
		if !val.is_long() && !val.is_double() {
			C.vphp_throw(&char('Argument ${index}: expected integer, got ${val.type_name()}'.str),
				0)
			return 0
		}
		return int(C.vphp_get_int(val.raw))
	}

	// --- 整型 i64 ---
	$if T is i64 {
		if !val.is_long() && !val.is_double() {
			C.vphp_throw(&char('Argument ${index}: expected integer, got ${val.type_name()}'.str),
				0)
			return 0
		}
		return i64(C.vphp_get_int(val.raw))
	}

	// --- map[string]string ---
	$if T is map[string]string {
		mut m_ctx := MapContext{
			m: map[string]string{}
		}
		unsafe {
			C.vphp_array_each(raw_zval, &m_ctx, voidptr(map_callback))
		}
		return m_ctx.m.clone()
	}

	// --- map[string]f64 ---
	$if T is map[string]f64 {
		mut m_ctx := MapF64Context{
			m: map[string]f64{}
		}
		unsafe {
			C.vphp_array_each(raw_zval, &m_ctx, voidptr(map_f64_callback))
		}
		return m_ctx.m.clone()
	}

	// --- map[string]int ---
	$if T is map[string]int {
		mut m_ctx := MapIntContext{
			m: map[string]int{}
		}
		unsafe {
			C.vphp_array_each(raw_zval, &m_ctx, voidptr(map_int_callback))
		}
		return m_ctx.m.clone()
	}

	// --- 字符串 ---
	$if T is string {
		len := 0
		ptr := voidptr(C.vphp_get_string_ptr(val.raw, &len))
		return if ptr != 0 { unsafe { (&char(ptr)).vstring_with_len(len).clone() } } else { '' }
	}

	return T{}
}

// ======== 获取传入对象参数 ========
pub fn (ctx Context) arg_raw_obj(index int) voidptr {
	args := get_args(ctx.ex)
	if index >= args.len {
		return unsafe { nil }
	}
	val := args[index]
	if !val.is_object() {
		C.vphp_throw(&char('Argument ${index} must be an object'.str), 0)
		return unsafe { nil }
	}
	obj := C.vphp_get_obj_from_zval(val.raw)
	wrapper := C.vphp_obj_from_obj(obj)
	return wrapper.v_ptr
}

// 获取任意 Val 类型参数
pub fn (ctx Context) arg_val(index int) Val {
	args := get_args(ctx.ex)
	if index >= args.len {
		return new_val_null()
	}
	return args[index]
}

// ======== 返回值 — 对象 ========

pub fn (ctx Context) return_obj(v_ptr voidptr, ce voidptr) {
    C.vphp_return_obj(ctx.ret, v_ptr, ce)
}

// ======== 返回值 — 标量 ========

pub fn (ctx Context) return_null() {
	unsafe { C.vphp_set_null(ctx.ret) }
}

pub fn (ctx Context) return_bool(val bool) {
	unsafe { C.vphp_set_bool(ctx.ret, val) }
}

pub fn (ctx Context) return_int(val i64) {
	unsafe {
		out := Val{
			raw: ctx.ret
		}
		out.set_int(val)
	}
}

pub fn (ctx Context) return_float(val f64) {
	unsafe { C.vphp_set_double(ctx.ret, val) }
}

pub fn (ctx Context) return_double(val f64) {
	unsafe { C.vphp_set_double(ctx.ret, val) }
}

pub fn (ctx Context) return_string(val string) {
	unsafe {
		out := Val{
			raw: ctx.ret
		}
		out.set_string(val)
	}
}

// ======== 返回值 — 资源 ========

pub fn (ctx Context) return_res(ptr voidptr, label string) {
	C.vphp_make_res(ctx.ret, ptr, &char(label.str))
}

// ======== 返回值 — 数组 / Map ========

pub fn (ctx Context) return_map(m map[string]string) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	for k, v in m {
		out.add_assoc_string(k, v)
	}
}

pub fn (ctx Context) return_map_f64(m map[string]f64) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	for k, v in m {
		out.add_assoc_double(k, v)
	}
}

pub fn (ctx Context) return_map_int(m map[string]int) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	for k, v in m {
		out.add_assoc_long(k, i64(v))
	}
}

pub fn (ctx Context) return_map_bool(m map[string]bool) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	for k, v in m {
		out.add_assoc_bool(k, v)
	}
}

// ======== 返回值 — 对象 (stdClass) ========

pub fn (ctx Context) return_object(props map[string]string) {
	unsafe {
		C.vphp_object_init(ctx.ret)
		for k, v in props {
			C.vphp_update_property_string(ctx.ret, &char(k.str), k.len, &char(v.str))
		}
	}
}

// ======== 返回值 — 结构体 → PHP 关联数组 ========

pub fn (ctx Context) return_struct[T](s T) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	$for field in T.fields {
		key := field.name
		val := s.$(field.name)
		$if field.typ is string {
			out.add_assoc_string(key, val)
		} $else $if field.typ is f64 {
			out.add_assoc_double(key, val)
		} $else $if field.typ is int || field.typ is i64 {
			out.add_assoc_long(key, i64(val))
		} $else $if field.typ is bool {
			out.add_assoc_bool(key, val)
		}
	}
}

// ======== 返回值 — 结构体数组 → PHP 索引数组 ========

pub fn (ctx Context) return_list[T](list []T) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	if list.len == 0 {
		return
	}

	for item in list {
		sub_zv := C.zval{}
		sub_val := Val{
			raw: &sub_zv
		}
		sub_val.array_init()

		$for field in T.fields {
			key := field.name
			val := item.$(field.name)
			$if field.typ is string {
				sub_val.add_assoc_string(key, val)
			} $else $if field.typ is f64 {
				sub_val.add_assoc_double(key, val)
			} $else $if field.typ is int || field.typ is i64 {
				sub_val.add_assoc_long(key, i64(val))
			} $else $if field.typ is bool {
				sub_val.add_assoc_bool(key, val)
			}
		}
		out.add_next_val(sub_val)
	}
}

// ======== 返回值 — 泛型 ========

pub fn (ctx Context) return_val[T](val T) {
	unsafe {
		out := Val{
			raw: ctx.ret
		}
		$if T is i64 {
			out.set_int(val)
		} $else $if T is int {
			out.set_int(i64(val))
		} $else $if T is f64 {
			out.set_double(val)
		} $else $if T is string {
			out.set_string(val)
		} $else $if T is bool {
			out.set_bool(val)
		} $else $if T is map[string]string {
			ctx.return_map(val)
		} $else $if T is map[string]int {
			ctx.return_map_int(val)
		} $else $if T is map[string]f64 {
			ctx.return_map_f64(val)
		} $else $if T is map[string]bool {
			ctx.return_map_bool(val)
		} $else $if T is []int {
			ctx.return_list_int(val)
		} $else $if T is []i64 {
			ctx.return_list_i64(val)
		} $else $if T is []f64 {
			ctx.return_list_f64(val)
		} $else $if T is []string {
			ctx.return_list_string(val)
		} $else {
			// 对于不在枚举列表中的复杂类型（比如 map[string]Any 或 []MyStruct），触发异常
			throw_exception('Unsupported generic return type', 0)
		}
	}
}

pub fn (ctx Context) return_list_int(val []int) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	for v in val {
		C.vphp_array_push_long(ctx.ret, i64(v))
	}
}

pub fn (ctx Context) return_list_i64(val []i64) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	for v in val {
		C.vphp_array_push_long(ctx.ret, v)
	}
}

pub fn (ctx Context) return_list_f64(val []f64) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	for v in val {
		C.vphp_array_push_double(ctx.ret, v)
	}
}

pub fn (ctx Context) return_list_string(val []string) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	for v in val {
		C.vphp_array_push_string(ctx.ret, &char(v.str))
	}
}

// ======== 泛型返回（低级 API，直接操作 retval） ========

pub fn return_val_raw[T](ret &C.zval, val T) {
	unsafe {
		mut out := Val{
			raw: ret
		}
		$if T is i64 {
			out.set_int(val)
		} $else $if T is int {
			out.set_int(i64(val))
		} $else $if T is f64 {
			out.set_double(val)
		} $else $if T is string {
			out.set_string(val)
		} $else $if T is bool {
			out.set_bool(val)
		}
	}
}

// ======== 兼容旧 API ========

pub fn (ctx Context) parse1[T]() T {
	args := get_args(ctx.ex)
	if args.len < 1 {
		return T{}
	}
	$if T is i64 {
		return args[0].as_int()
	} $else $if T is string {
		return args[0].to_string()
	}
	return T{}
}

pub fn parse2[T, U](ctx Context) (T, U) {
	args := get_args(ctx.ex)
	if args.len < 2 {
		return T{}, U{}
	}
	mut r1 := T{}
	mut r2 := U{}
	$if T is i64 {
		r1 = args[0].as_int()
	} $else $if T is string {
		r1 = args[0].to_string()
	}
	$if U is i64 {
		r2 = args[1].as_int()
	} $else $if U is string {
		r2 = args[1].to_string()
	}
	return r1, r2
}
