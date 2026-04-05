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

// Low-level borrowed view; prefer `arg_borrowed_zbox()` for ownership-facing
// application code.
pub fn (ctx Context) arg_borrowed_zval(index int) BorrowedZVal {
	return borrow_zval(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_borrowed_zbox(index int) RequestBorrowedZBox {
	return RequestBorrowedZBox.of(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_any_zbox(index int) RequestBorrowedZBox {
	return RequestBorrowedZBox.of(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_owned_request(index int) OwnedValue {
	return own_request(ctx.arg_raw(index))
}

// Low-level request-owned wrapper; prefer `arg_owned_request_zbox()` for new
// ownership-facing code.
pub fn (ctx Context) arg_owned_request_zval(index int) RequestOwnedZVal {
	return own_request_zval(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_owned_request_zbox(index int) RequestOwnedZBox {
	return RequestOwnedZBox.of(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_owned_persistent(index int) OwnedValue {
	return own_persistent(ctx.arg_raw(index))
}

// Low-level persistent wrapper; prefer `arg_owned_persistent_zbox()` for new
// ownership-facing code.
pub fn (ctx Context) arg_owned_persistent_zval(index int) PersistentOwnedZVal {
	return own_persistent_zval(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_owned_persistent_zbox(index int) PersistentOwnedZBox {
	return PersistentOwnedZBox.of(ctx.arg_raw(index))
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

pub fn (ctx Context) arg_opt[T](index int) ?T {
	val := ctx.arg_raw(index)
	if !val.is_valid() || val.is_null() || val.is_undef() {
		return none
	}
	$if T is ZVal {
		return val
	}
	if converted := val.to_v[T]() {
		return converted
	}
	return none
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

pub fn (ctx Context) return_bound_object(v_ptr voidptr, ce voidptr, handlers voidptr, ownership OwnershipKind) {
	return_bound_object_raw(ctx.ret, v_ptr, ce, handlers, ownership)
}

pub fn (ctx Context) return_owned_object(v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_owned_object_raw(ctx.ret, v_ptr, ce, handlers)
}

pub fn (ctx Context) return_borrowed_object(v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_borrowed_object_raw(ctx.ret, v_ptr, ce, handlers)
}

pub fn (ctx Context) return_zval(val ZVal) {
	if !val.is_valid() {
		ctx.return_null()
		return
	}
	unsafe { C.ZVAL_COPY(ctx.ret, val.raw) }
}

pub fn (ctx Context) return_any[T](val T) {
	ctx.return_val[T](val)
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

// ======== 闘包桥接 ========

// Typed closure aliases (original - kept for backward compatibility)
type ClosureArity0Void = fn ()

type ClosureArity1IntInt = fn (int) int

type ClosureArity2StrIntStr = fn (string, int) string

// Universal ZVal-based closure aliases (arity 0-4)
// Users can use these directly with wrap_closure for maximum flexibility.
// All parameters and return values are ZVal, giving flexibility at the cost of V type safety.
pub type ClosureUniversal0 = fn () ZVal

pub type ClosureUniversal1 = fn (ZVal) ZVal

pub type ClosureUniversal2 = fn (ZVal, ZVal) ZVal

pub type ClosureUniversal3 = fn (ZVal, ZVal, ZVal) ZVal

pub type ClosureUniversal4 = fn (ZVal, ZVal, ZVal, ZVal) ZVal

// Void-returning universal closure aliases
pub type ClosureUniversal0Void = fn ()

pub type ClosureUniversal1Void = fn (ZVal)

pub type ClosureUniversal2Void = fn (ZVal, ZVal)

pub type ClosureUniversal3Void = fn (ZVal, ZVal, ZVal)

pub type ClosureUniversal4Void = fn (ZVal, ZVal, ZVal, ZVal)

fn bridge_handler[T](v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
    unsafe {
        c := Context{
            ex:  ex
            ret: ret
        }

        // Note: We avoid inspecting param types here because V's comptime
        // inspection of function parameter types is unreliable across V versions.
        // Instead, we only inspect arity and delegate to the universal bridges.
        $if T is $function {
            mut arity := 0
            $for _ in T.params {
                arity++
            }
            if arity == 0 {
                cb := *(&ClosureUniversal0(v_ptr))
                result := cb()
                c.return_zval(result)
            } else if arity == 1 {
                cb := *(&ClosureUniversal1(v_ptr))
                result := cb(c.arg_val(0))
                c.return_zval(result)
            } else if arity == 2 {
                cb := *(&ClosureUniversal2(v_ptr))
                result := cb(c.arg_val(0), c.arg_val(1))
                c.return_zval(result)
            } else if arity == 3 {
                cb := *(&ClosureUniversal3(v_ptr))
                result := cb(c.arg_val(0), c.arg_val(1), c.arg_val(2))
                c.return_zval(result)
            } else if arity == 4 {
                cb := *(&ClosureUniversal4(v_ptr))
                result := cb(c.arg_val(0), c.arg_val(1), c.arg_val(2), c.arg_val(3))
                c.return_zval(result)
            } else {
                // unsupported arity
                c.return_null()
            }
        }
    }
}

// bridge_universal_0 - handler for ClosureUniversal0
fn bridge_universal_0(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal0(v_ptr))
		result := cb()
		c.return_zval(result)
	}
}

// bridge_universal_1 - handler for ClosureUniversal1
fn bridge_universal_1(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal1(v_ptr))
		result := cb(c.arg_val(0))
		c.return_zval(result)
	}
}

// bridge_universal_2 - handler for ClosureUniversal2
fn bridge_universal_2(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal2(v_ptr))
		result := cb(c.arg_val(0), c.arg_val(1))
		c.return_zval(result)
	}
}

// bridge_universal_1_void - handler for ClosureUniversal1Void
fn bridge_universal_1_void(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal1Void(v_ptr))
		cb(c.arg_val(0))
		c.return_null()
	}
}

// bridge_universal_2_void - handler for ClosureUniversal2Void
fn bridge_universal_2_void(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal2Void(v_ptr))
		cb(c.arg_val(0), c.arg_val(1))
		c.return_null()
	}
}

// bridge_universal_3 - handler for ClosureUniversal3
fn bridge_universal_3(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal3(v_ptr))
		result := cb(c.arg_val(0), c.arg_val(1), c.arg_val(2))
		c.return_zval(result)
	}
}

// bridge_universal_4 - handler for ClosureUniversal4
fn bridge_universal_4(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal4(v_ptr))
		result := cb(c.arg_val(0), c.arg_val(1), c.arg_val(2), c.arg_val(3))
		c.return_zval(result)
	}
}

// bridge_universal_3_void - handler for ClosureUniversal3Void
fn bridge_universal_3_void(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal3Void(v_ptr))
		cb(c.arg_val(0), c.arg_val(1), c.arg_val(2))
		c.return_null()
	}
}

// bridge_universal_4_void - handler for ClosureUniversal4Void
fn bridge_universal_4_void(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal4Void(v_ptr))
		cb(c.arg_val(0), c.arg_val(1), c.arg_val(2), c.arg_val(3))
		c.return_null()
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

// NOTE: We intentionally expose a single generic universal wrapper
// `wrap_closure_universal[T]` instead of many N-suffixed helpers. The
// following low-level N-suffixed helpers were removed to keep the public API
// surface minimal. Their behavior is implemented directly inside
// wrap_closure_universal[T] below.

// New: Single entrypoint for universal closures.
// Users can pass any ClosureUniversalN alias (0..4, void or returning ZVal)
pub fn (ctx Context) wrap_closure_universal[T](v_cb T) {
    // Map the alias type to the corresponding bridge and create the PHP
    // closure with the right arity. We accept only the explicit
    // ClosureUniversalN aliases (including Void variants) here to keep the
    // mapping obvious and stable across V compiler variations.
    $if T is ClosureUniversal0 {
        mut saved_cb := unsafe { &ClosureUniversal0(C.emalloc(usize(sizeof(ClosureUniversal0)))) }
        unsafe { *saved_cb = v_cb }
        C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_0), 0,
            0)
    } $else $if T is ClosureUniversal1 {
        mut saved_cb := unsafe { &ClosureUniversal1(C.emalloc(usize(sizeof(ClosureUniversal1)))) }
        unsafe { *saved_cb = v_cb }
        C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_1), 1,
            1)
    } $else $if T is ClosureUniversal2 {
        mut saved_cb := unsafe { &ClosureUniversal2(C.emalloc(usize(sizeof(ClosureUniversal2)))) }
        unsafe { *saved_cb = v_cb }
        C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_2), 2,
            2)
    } $else $if T is ClosureUniversal3 {
        mut saved_cb := unsafe { &ClosureUniversal3(C.emalloc(usize(sizeof(ClosureUniversal3)))) }
        unsafe { *saved_cb = v_cb }
        C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_3), 3,
            3)
    } $else $if T is ClosureUniversal4 {
        mut saved_cb := unsafe { &ClosureUniversal4(C.emalloc(usize(sizeof(ClosureUniversal4)))) }
        unsafe { *saved_cb = v_cb }
        C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_4), 4,
            4)
    } $else $if T is ClosureUniversal0Void {
        mut saved_cb := unsafe { &ClosureUniversal0Void(C.emalloc(usize(sizeof(ClosureUniversal0Void)))) }
        unsafe { *saved_cb = v_cb }
        C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_0_void), 0,
            0)
    } $else $if T is ClosureUniversal1Void {
        mut saved_cb := unsafe { &ClosureUniversal1Void(C.emalloc(usize(sizeof(ClosureUniversal1Void)))) }
        unsafe { *saved_cb = v_cb }
        C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_1_void), 1,
            1)
    } $else $if T is ClosureUniversal2Void {
        mut saved_cb := unsafe { &ClosureUniversal2Void(C.emalloc(usize(sizeof(ClosureUniversal2Void)))) }
        unsafe { *saved_cb = v_cb }
        C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_2_void), 2,
            2)
    } $else $if T is ClosureUniversal3Void {
        mut saved_cb := unsafe { &ClosureUniversal3Void(C.emalloc(usize(sizeof(ClosureUniversal3Void)))) }
        unsafe { *saved_cb = v_cb }
        C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_3_void), 3,
            3)
    } $else $if T is ClosureUniversal4Void {
        mut saved_cb := unsafe { &ClosureUniversal4Void(C.emalloc(usize(sizeof(ClosureUniversal4Void)))) }
        unsafe { *saved_cb = v_cb }
        C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_4_void), 4,
            4)
    } $else {
        $if T is $function {
            compile_error('wrap_closure_universal: please declare your closure with one of the ClosureUniversalN aliases (ClosureUniversal0..4 or the Void variants)')
        } $else {
            compile_error('wrap_closure_universal: T must be a ClosureUniversalN alias')
        }
    }
}

fn bridge_universal_0_void(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal0Void(v_ptr))
		cb()
		c.return_null()
	}
}

// Concrete non-generic helpers to avoid emitting generic bracket forms in
// generated glue. The V compiler has occasionally crashed when processing
// generic specializations with function-type aliases; emitting calls to these
// concrete helpers avoids that by providing fixed signatures the compiler can
// check without instantiating generics.
pub fn (ctx Context) wrap_closure_universal_0(v_cb ClosureUniversal0) {
    mut saved_cb := unsafe { &ClosureUniversal0(C.emalloc(usize(sizeof(ClosureUniversal0)))) }
    unsafe { *saved_cb = v_cb }
    C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_0), 0,
        0)
}

pub fn (ctx Context) wrap_closure_universal_1(v_cb ClosureUniversal1) {
    mut saved_cb := unsafe { &ClosureUniversal1(C.emalloc(usize(sizeof(ClosureUniversal1)))) }
    unsafe { *saved_cb = v_cb }
    C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_1), 1,
        1)
}

pub fn (ctx Context) wrap_closure_universal_2(v_cb ClosureUniversal2) {
    mut saved_cb := unsafe { &ClosureUniversal2(C.emalloc(usize(sizeof(ClosureUniversal2)))) }
    unsafe { *saved_cb = v_cb }
    C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_2), 2,
        2)
}

pub fn (ctx Context) wrap_closure_universal_3(v_cb ClosureUniversal3) {
    mut saved_cb := unsafe { &ClosureUniversal3(C.emalloc(usize(sizeof(ClosureUniversal3)))) }
    unsafe { *saved_cb = v_cb }
    C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_3), 3,
        3)
}

pub fn (ctx Context) wrap_closure_universal_4(v_cb ClosureUniversal4) {
    mut saved_cb := unsafe { &ClosureUniversal4(C.emalloc(usize(sizeof(ClosureUniversal4)))) }
    unsafe { *saved_cb = v_cb }
    C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_4), 4,
        4)
}

// Void-returning variants
pub fn (ctx Context) wrap_closure_universal_0_void(v_cb ClosureUniversal0Void) {
    mut saved_cb := unsafe { &ClosureUniversal0Void(C.emalloc(usize(sizeof(ClosureUniversal0Void)))) }
    unsafe { *saved_cb = v_cb }
    C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_0_void), 0,
        0)
}

pub fn (ctx Context) wrap_closure_universal_1_void(v_cb ClosureUniversal1Void) {
    mut saved_cb := unsafe { &ClosureUniversal1Void(C.emalloc(usize(sizeof(ClosureUniversal1Void)))) }
    unsafe { *saved_cb = v_cb }
    C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_1_void), 1,
        1)
}

pub fn (ctx Context) wrap_closure_universal_2_void(v_cb ClosureUniversal2Void) {
    mut saved_cb := unsafe { &ClosureUniversal2Void(C.emalloc(usize(sizeof(ClosureUniversal2Void)))) }
    unsafe { *saved_cb = v_cb }
    C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_2_void), 2,
        2)
}

pub fn (ctx Context) wrap_closure_universal_3_void(v_cb ClosureUniversal3Void) {
    mut saved_cb := unsafe { &ClosureUniversal3Void(C.emalloc(usize(sizeof(ClosureUniversal3Void)))) }
    unsafe { *saved_cb = v_cb }
    C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_3_void), 3,
        3)
}

pub fn (ctx Context) wrap_closure_universal_4_void(v_cb ClosureUniversal4Void) {
    mut saved_cb := unsafe { &ClosureUniversal4Void(C.emalloc(usize(sizeof(ClosureUniversal4Void)))) }
    unsafe { *saved_cb = v_cb }
    C.vphp_create_closure_with_arity(ctx.ret, voidptr(saved_cb), voidptr(bridge_universal_4_void), 4,
        4)
}

// Convenience helpers: accept plain function types (no explicit aliasing)
// and delegate to the existing universal wrappers. These make it easier for
// callers to pass plain fn(...) ZVal functions without having to declare the
// ClosureUniversalN alias explicitly.
// Convenience wrappers removed. Users should either:
// - use ctx.wrap_closure_universal[ClosureUniversalN](...) with the explicit
//   alias; or
// - prefer ctx.wrap_closure[T](...) where T is a concrete function TYPE
//   (e.g. fn (ZVal, ZVal) ZVal) or a typed function alias. This keeps the API
// minimal and avoids proliferation of N-suffixed helper names.


// Typed closure helpers removed: prefer universal ZVal-based closures and the
// single generic wrap_closure[T] entrypoint. Removing typed bridges reduces
// duplication and avoids maintaining many specialized bridge functions.

// ======== 运行时 FFI 辅助 ========
fn C.emalloc(size usize) voidptr
