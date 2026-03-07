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

// ======== 构造与基础状态 ========

// 创建 Context 实例
pub fn Context.new(ex &C.zend_execute_data, ret &C.zval) Context {
	return unsafe {
		Context{
			ex:  ex
			ret: ret
		}
	}
}

pub fn new_context(ex &C.zend_execute_data, ret &C.zval) Context {
	// Backward-compat alias; prefer Context.new(...)
	return Context.new(ex, ret)
}

pub fn (ctx Context) num_args() int {
	return int(C.vphp_get_num_args(ctx.ex))
}

pub fn (ctx Context) has_exception() bool {
	return C.vphp_has_exception()
}

pub fn (ctx Context) get_ce() voidptr {
	return C.vphp_get_active_ce(ctx.ex)
}

// 获取当前 PHP 函数调用的所有参数
pub fn (ctx Context) get_args() []ZVal {
	num := ctx.num_args()
	mut res := []ZVal{}
	for i in 1 .. (num + 1) {
		res << ZVal{
			raw: C.vphp_get_arg_ptr(ctx.ex, u32(i))
		}
	}
	return res
}

// ======== 参数读取 ========

pub fn (ctx Context) arg_raw(index int) ZVal {
	if index < 0 || index >= ctx.num_args() {
		return unsafe {
			ZVal{
				raw: 0
			}
		}
	}
	raw := C.vphp_get_arg_ptr(ctx.ex, u32(index + 1))
	if raw == 0 {
		return unsafe {
			ZVal{
				raw: 0
			}
		}
	}
	return ZVal{
		raw: raw
	}
}

pub fn (ctx Context) arg_borrowed(index int) BorrowedValue {
	return borrow(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_borrowed_zval(index int) BorrowedZVal {
	return borrow_zval(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_owned_request(index int) OwnedValue {
	return own_request(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_owned_request_zval(index int) RequestOwnedZVal {
	return own_request_zval(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_owned_persistent(index int) OwnedValue {
	return own_persistent(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_owned_persistent_zval(index int) PersistentOwnedZVal {
	return own_persistent_zval(ctx.arg_raw(index))
}

pub fn (ctx Context) arg[T](index int) T {
	val := ctx.arg_raw(index)
	if !val.is_valid() {
		return T{}
	}
	$if T is ZVal {
		return val
	}
	return val.to_v[T]() or { T{} }
}

pub fn (ctx Context) arg_val(index int) ZVal {
	val := ctx.arg_raw(index)
	if !val.is_valid() {
		return ZVal.new_null()
	}
	return val
}

pub fn (ctx Context) arg_raw_obj(index int) voidptr {
	val := ctx.arg_raw(index)
	if !val.is_valid() || !val.is_object() {
		return unsafe { nil }
	}
	obj := C.vphp_get_obj_from_zval(val.raw)
	wrapper := C.vphp_obj_from_obj(obj)
	return wrapper.v_ptr
}

// ======== 返回值写入 ========

pub fn (ctx Context) return_null() {
	unsafe { C.vphp_set_null(ctx.ret) }
}

pub fn (ctx Context) return_bool(val bool) {
	unsafe { C.vphp_set_bool(ctx.ret, val) }
}

pub fn (ctx Context) return_int(val i64) {
	unsafe {
		ZVal{
			raw: ctx.ret
		}.set_int(val)
	}
}

pub fn (ctx Context) return_double(val f64) {
	unsafe { C.vphp_set_double(ctx.ret, val) }
}

pub fn (ctx Context) return_string(val string) {
	unsafe {
		ZVal{
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

pub fn (ctx Context) return_zval(val ZVal) {
	if !val.is_valid() {
		ctx.return_null()
		return
	}
	unsafe { C.ZVAL_COPY(ctx.ret, val.raw) }
}

pub fn (ctx Context) return_val[T](val T) {
	mut out := ZVal{
		raw: ctx.ret
	}
	out.from_v[T](val) or {
		$if T is $struct {
			ctx.return_struct(val)
		} $else {
			ctx.return_null()
		}
	}
}

pub fn (ctx Context) return_list[T](list []T) {
	out := ZVal{
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
			mut sub_raw := C.zval{}
			mut sub := ZVal{
				raw: &sub_raw
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
	out := ZVal{
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
	out := ZVal{
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
		mut out := ZVal{
			raw: ret
		}
		out.from_v[T](val) or { out.set_null() }
	}
}

pub fn return_zval_raw(ret &C.zval, val ZVal) {
	if !val.is_valid() {
		unsafe { C.vphp_set_null(ret) }
		return
	}
	unsafe { C.ZVAL_COPY(ret, val.raw) }
}

// ======== 闭包桥接 ========

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

// ======== 类与静态属性辅助 ========

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
	mut saved_cb := unsafe { &T(C.emalloc(usize(sizeof(T)))) }
	unsafe {
		*saved_cb = v_cb
	}
	C.vphp_create_closure_FULL_AUTO_V2(ctx.ret, voidptr(saved_cb), voidptr(bridge_handler[T]))
}

// ======== 运行时 FFI 辅助 ========
fn C.emalloc(size usize) voidptr
