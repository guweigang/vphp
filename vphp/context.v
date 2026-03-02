module vphp

import vphp.zend as _

// ============================================
// Context — PHP 函数调用上下文
// ============================================

pub struct Context {
pub:
	ex  &C.zend_execute_data
	ret &C.zval
}

// ======== 核心方法 (获取参数相关) ========

pub fn (ctx Context) num_args() int {
	return int(C.vphp_get_num_args(ctx.ex))
}

pub fn (ctx Context) has_exception() bool {
	return C.vphp_has_exception()
}

pub fn (ctx Context) arg_raw(index int) Val {
	args := get_args(ctx.ex)
	if index >= args.len || index < 0 {
		return unsafe {
			Val{
				raw: 0
			}
		}
	}
	return args[index]
}

pub fn (ctx Context) arg[T](index int) T {
	args := get_args(ctx.ex)
	if index >= args.len {
		return T{}
	}
	val := args[index]
	raw_zval := val.raw
	$if T is $array {
		if !val.is_array() {
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
					item := Val{
						raw: item_zval
					}
					res << item.to_string()
				} $else $if T is []f64 {
					res << C.vphp_get_double(item_zval)
				} $else $if T is []int {
					res << int(C.vphp_get_int(item_zval))
				} $else $if T is []i64 {
					res << i64(C.vphp_get_int(item_zval))
				} $else $if T is []bool {
					item := Val{
						raw: item_zval
					}
					res << item.to_bool()
				}
			}
		}
		return res
	}
	$if T is string {
		len := 0
		ptr := voidptr(C.vphp_get_string_ptr(val.raw, &len))
		return if ptr != 0 { unsafe { (&char(ptr)).vstring_with_len(len).clone() } } else { '' }
	}
	$if T is int {
		return int(C.vphp_get_int(val.raw))
	}
	$if T is i64 {
		return i64(C.vphp_get_int(val.raw))
	}
	$if T is bool {
		return val.to_bool()
	}
	$if T is f64 {
		return C.vphp_get_double(val.raw)
	}
	$if T is map[string]string {
		if !val.is_array() {
			return map[string]string{}
		}
		mut res := map[string]string{}
		res = val.foreach_with_ctx[map[string]string](res, fn (key Val, v Val, mut r map[string]string) {
			r[key.to_string()] = v.to_string()
		})
		return res
	}
	$if T is map[string]int {
		if !val.is_array() {
			return map[string]int{}
		}
		mut res := map[string]int{}
		res = val.foreach_with_ctx[map[string]int](res, fn (key Val, v Val, mut r map[string]int) {
			r[key.to_string()] = v.to_int()
		})
		return res
	}
	$if T is map[string]f64 {
		if !val.is_array() {
			return map[string]f64{}
		}
		mut res := map[string]f64{}
		res = val.foreach_with_ctx[map[string]f64](res, fn (key Val, v Val, mut r map[string]f64) {
			r[key.to_string()] = v.to_f64()
		})
		return res
	}
	$if T is Val {
		return ctx.arg_val(index)
	}
	return T{}
}

pub fn (ctx Context) arg_val(index int) Val {
	args := get_args(ctx.ex)
	if index >= args.len {
		return new_val_null()
	}
	return args[index]
}

pub fn (ctx Context) arg_raw_obj(index int) voidptr {
	args := get_args(ctx.ex)
	if index >= args.len {
		return unsafe { nil }
	}
	val := args[index]
	if !val.is_object() {
		return unsafe { nil }
	}
	obj := C.vphp_get_obj_from_zval(val.raw)
	wrapper := C.vphp_obj_from_obj(obj)
	return wrapper.v_ptr
}

// ======== 返回值管理 ========

pub fn (ctx Context) return_null() {
	unsafe { C.vphp_set_null(ctx.ret) }
}

pub fn (ctx Context) return_bool(val bool) {
	unsafe { C.vphp_set_bool(ctx.ret, val) }
}

pub fn (ctx Context) return_int(val i64) {
	unsafe {
		Val{
			raw: ctx.ret
		}.set_int(val)
	}
}

pub fn (ctx Context) return_double(val f64) {
	unsafe { C.vphp_set_double(ctx.ret, val) }
}

pub fn (ctx Context) return_string(val string) {
	unsafe {
		Val{
			raw: ctx.ret
		}.set_string(val)
	}
}

pub fn (ctx Context) return_res(ptr voidptr, label string) {
	C.vphp_make_res(ctx.ret, ptr, &char(label.str))
}

pub fn (ctx Context) return_obj(v_ptr voidptr, ce voidptr) {
	C.vphp_return_obj(ctx.ret, v_ptr, ce)
}

pub fn (ctx Context) return_val[T](val T) {
	$if T is i64 || T is int {
		ctx.return_int(i64(val))
	} $else $if T is f64 {
		ctx.return_double(val)
	} $else $if T is string {
		ctx.return_string(val)
	} $else $if T is bool {
		ctx.return_bool(val)
	} $else $if T is map[string]string {
		ctx.return_map(val)
	} $else $if T is map[string]int {
		ctx.return_map(val)
	} $else $if T is map[string]f64 {
		ctx.return_map(val)
	} $else $if T is []string {
		ctx.return_list(val)
	} $else $if T is []int {
		ctx.return_list(val)
	} $else $if T is []i64 {
		ctx.return_list(val)
	} $else $if T is []f64 {
		ctx.return_list(val)
	}
}

pub fn (ctx Context) return_list[T](list []T) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	for item in list {
		$if T is string {
			out.push_string(item)
		} $else $if T is f64 {
			out.push_double(item)
		} $else $if T is int || T is i64 {
			out.push_long(i64(item))
		} $else {
			mut sub := Val{
				raw: C.vphp_new_zval()
			}
			sub.array_init()
			$for field in T.fields {
				key := field.name
				$if field.typ is string {
					sub.add_assoc_string(key, item.$(field.name))
				} $else $if field.typ is f64 {
					sub.add_assoc_double(key, item.$(field.name))
				} $else $if field.typ is int || field.typ is i64 {
					sub.add_assoc_long(key, i64(item.$(field.name)))
				} $else $if field.typ is bool {
					sub.add_assoc_bool(key, item.$(field.name))
				}
			}
			C.vphp_array_add_next_zval(out.raw, sub.raw)
		}
	}
}

pub fn (ctx Context) return_map[T](m map[string]T) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	for k, v in m {
		$if T is string {
			out.add_assoc_string(k, v)
		} $else $if T is int || T is i64 {
			out.add_assoc_long(k, i64(v))
		} $else $if T is f64 {
			out.add_assoc_double(k, v)
		} $else $if T is bool {
			out.add_assoc_bool(k, v)
		}
	}
}

pub fn (ctx Context) return_object(props map[string]string) {
	unsafe {
		C.vphp_object_init(ctx.ret)
		for k, v in props {
			C.vphp_update_property_string(ctx.ret, &char(k.str), k.len, &char(v.str))
		}
	}
}

pub fn (ctx Context) return_struct[T](s T) {
	out := Val{
		raw: ctx.ret
	}
	out.array_init()
	$for field in T.fields {
		key := field.name
		$if field.typ is string {
			out.add_assoc_string(key, s.$(field.name))
		} $else $if field.typ is f64 {
			out.add_assoc_double(key, s.$(field.name))
		} $else $if field.typ is int || field.typ is i64 {
			out.add_assoc_long(key, i64(s.$(field.name)))
		} $else $if field.typ is bool {
			out.add_assoc_bool(key, s.$(field.name))
		}
	}
}

pub fn return_val_raw[T](ret &C.zval, val T) {
	unsafe {
		mut out := Val{
			raw: ret
		}
		$if T is i64 || T is int {
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

// ======== 自动化闭包桥接器 (穿梭版：解引针对性) ========

// 内部桥接用的临时结构体，必须与 C 侧一致
struct C.vphp_vstring {
	str    &char
	len    int
	is_lit int
}

type ClosureArity0Void = fn ()

type ClosureArity1IntInt = fn (int) int

type ClosureArity2StrIntStr = fn (string, int) string

fn bridge_handler[T](v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{
			ex:  ex
			ret: ret
		}

		$if T is $function {
			mut arity := 0
			$for _ in T.params {
				arity++
			}
			if arity == 1 {
				// 针对 test_closure.php: (int) -> int
				cb := *(&ClosureArity1IntInt(v_ptr))
				c.return_val(cb(c.arg[int](0)))
			} else if arity == 2 {
				// 针对 test_closure_auto.php: (string, int) -> string
				cb := *(&ClosureArity2StrIntStr(v_ptr))
				c.return_val(cb(c.arg[string](0), c.arg[int](1)))
			} else if arity == 0 {
				cb := *(&ClosureArity0Void(v_ptr))
				cb()
				c.return_null()
			}
		}
	}
}

pub fn (ctx Context) get_ce() voidptr {
	return C.vphp_get_active_ce(ctx.ex)
}

pub fn set_static_prop[T](ce voidptr, name string, val T) {
	$if T is int {
		C.vphp_update_static_property_long(ce, &char(name.str), int(name.len), i64(val))
	} $else $if T is string {
		C.vphp_update_static_property_string(ce, &char(name.str), int(name.len), &char(val.str),
			int(val.len))
	} $else $if T is bool {
		C.vphp_update_static_property_bool(ce, &char(name.str), int(name.len), int(val))
	}
}

pub fn get_static_prop[T](ce voidptr, name string) T {
	$if T is int {
		return int(C.vphp_get_static_property_long(ce, &char(name.str), int(name.len)))
	} $else $if T is string {
		res := C.vphp_get_static_property_string(ce, &char(name.str), int(name.len))
		return unsafe { res.vstring() }
	} $else $if T is bool {
		return C.vphp_get_static_property_bool(ce, &char(name.str), int(name.len)) != 0
	}
	return T{}
}

pub fn (ctx Context) wrap_closure[T](v_cb T) {
	mut saved_cb := unsafe { &T(C.malloc(usize(sizeof(T)))) }
	unsafe {
		*saved_cb = v_cb
	}
	C.vphp_create_closure_FULL_AUTO_V2(ctx.ret, voidptr(saved_cb), voidptr(bridge_handler[T]))
}

// ======== 类与静态属性支持 ========

// ======== C 声明 ========

fn C.vphp_get_num_args(ex voidptr) u32
fn C.vphp_has_exception() bool
fn C.vphp_get_int(z voidptr) i64
fn C.vphp_get_double(z voidptr) f64
fn C.vphp_get_string_ptr(z voidptr, len &int) &char
fn C.vphp_set_bool(z voidptr, val bool)
fn C.vphp_set_null(z voidptr)
fn C.vphp_set_double(z voidptr, val f64)
fn C.vphp_array_count(z voidptr) int
fn C.vphp_array_get_index(z voidptr, i u32) voidptr
fn C.vphp_new_zval() voidptr
fn C.vphp_array_add_next_zval(main_array voidptr, sub_item voidptr)
fn C.vphp_object_init(z voidptr)
fn C.vphp_update_property_string(z voidptr, name &char, name_len int, val &char)
fn C.vphp_make_res(z voidptr, p voidptr, l &char)
fn C.vphp_return_obj(z voidptr, v voidptr, ce voidptr)
fn C.vphp_get_active_ce(ex voidptr) voidptr
fn C.vphp_update_static_property_long(ce voidptr, n &char, nl int, v i64)
fn C.vphp_update_static_property_string(ce voidptr, n &char, nl int, v &char, vl int)
fn C.vphp_update_static_property_bool(ce voidptr, n &char, nl int, v int)
fn C.vphp_get_static_property_long(ce voidptr, n &char, nl int) i64
fn C.vphp_get_static_property_string(ce voidptr, n &char, nl int) &char
fn C.vphp_get_static_property_bool(ce voidptr, n &char, nl int) int
fn C.vphp_create_closure_FULL_AUTO_V2(z voidptr, thunk voidptr, bridge voidptr)
fn C.vphp_get_obj_from_zval(z voidptr) voidptr
fn C.vphp_obj_from_obj(obj voidptr) voidptr
fn C.malloc(size usize) voidptr

// Shuttle 函数声明 (返回 voidptr 以匹配新的 C 侧指针策略)
fn C.vphp_shuttle_v_closure_0(v_ptr voidptr) voidptr
fn C.vphp_shuttle_v_closure_1(v_ptr voidptr, p0 voidptr) voidptr
fn C.vphp_shuttle_v_closure_2(v_ptr voidptr, p0 voidptr, p1 voidptr) voidptr

#include "v_bridge.h"
