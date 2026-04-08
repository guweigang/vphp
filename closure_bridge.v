module vphp

// ======== 闭包桥接 ========

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

@[inline]
fn save_closure_value[T](v_cb T) voidptr {
	mut saved_cb := unsafe { &T(C.emalloc(usize(sizeof(T)))) }
	unsafe {
		*saved_cb = v_cb
	}
	return voidptr(saved_cb)
}

@[inline]
fn (ctx Context) create_saved_full_auto_closure[T](v_cb T, bridge voidptr) {
	C.vphp_create_closure_FULL_AUTO_V2(ctx.ret, save_closure_value[T](v_cb), bridge)
}

@[inline]
fn (ctx Context) create_saved_universal_closure[T](v_cb T, bridge voidptr, arity int) {
	C.vphp_create_closure_with_arity(ctx.ret, save_closure_value[T](v_cb), bridge, arity, arity)
}

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
				c.return_null()
			}
		}
	}
}

fn bridge_universal_0(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal0(v_ptr))
		result := cb()
		c.return_zval(result)
	}
}

fn bridge_universal_1(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal1(v_ptr))
		result := cb(c.arg_val(0))
		c.return_zval(result)
	}
}

fn bridge_universal_2(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal2(v_ptr))
		result := cb(c.arg_val(0), c.arg_val(1))
		c.return_zval(result)
	}
}

fn bridge_universal_1_void(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal1Void(v_ptr))
		cb(c.arg_val(0))
		c.return_null()
	}
}

fn bridge_universal_2_void(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal2Void(v_ptr))
		cb(c.arg_val(0), c.arg_val(1))
		c.return_null()
	}
}

fn bridge_universal_3(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal3(v_ptr))
		result := cb(c.arg_val(0), c.arg_val(1), c.arg_val(2))
		c.return_zval(result)
	}
}

fn bridge_universal_4(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal4(v_ptr))
		result := cb(c.arg_val(0), c.arg_val(1), c.arg_val(2), c.arg_val(3))
		c.return_zval(result)
	}
}

fn bridge_universal_3_void(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal3Void(v_ptr))
		cb(c.arg_val(0), c.arg_val(1), c.arg_val(2))
		c.return_null()
	}
}

fn bridge_universal_4_void(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {
	unsafe {
		c := Context{ ex: ex, ret: ret }
		cb := *(&ClosureUniversal4Void(v_ptr))
		cb(c.arg_val(0), c.arg_val(1), c.arg_val(2), c.arg_val(3))
		c.return_null()
	}
}

pub fn (ctx Context) wrap_closure[T](v_cb T) {
	ctx.create_saved_full_auto_closure[T](v_cb, voidptr(bridge_handler[T]))
}

// NOTE: `wrap_closure_universal[T]` is the main entrypoint. The concrete
// N-suffixed helpers remain as thin compatibility shims so generated glue can
// target fixed signatures without duplicating allocation/registration logic.
pub fn (ctx Context) wrap_closure_universal[T](v_cb T) {
	$if T is ClosureUniversal0 {
		ctx.create_saved_universal_closure[ClosureUniversal0](v_cb, voidptr(bridge_universal_0), 0)
	} $else $if T is ClosureUniversal1 {
		ctx.create_saved_universal_closure[ClosureUniversal1](v_cb, voidptr(bridge_universal_1), 1)
	} $else $if T is ClosureUniversal2 {
		ctx.create_saved_universal_closure[ClosureUniversal2](v_cb, voidptr(bridge_universal_2), 2)
	} $else $if T is ClosureUniversal3 {
		ctx.create_saved_universal_closure[ClosureUniversal3](v_cb, voidptr(bridge_universal_3), 3)
	} $else $if T is ClosureUniversal4 {
		ctx.create_saved_universal_closure[ClosureUniversal4](v_cb, voidptr(bridge_universal_4), 4)
	} $else $if T is ClosureUniversal0Void {
		ctx.create_saved_universal_closure[ClosureUniversal0Void](v_cb, voidptr(bridge_universal_0_void), 0)
	} $else $if T is ClosureUniversal1Void {
		ctx.create_saved_universal_closure[ClosureUniversal1Void](v_cb, voidptr(bridge_universal_1_void), 1)
	} $else $if T is ClosureUniversal2Void {
		ctx.create_saved_universal_closure[ClosureUniversal2Void](v_cb, voidptr(bridge_universal_2_void), 2)
	} $else $if T is ClosureUniversal3Void {
		ctx.create_saved_universal_closure[ClosureUniversal3Void](v_cb, voidptr(bridge_universal_3_void), 3)
	} $else $if T is ClosureUniversal4Void {
		ctx.create_saved_universal_closure[ClosureUniversal4Void](v_cb, voidptr(bridge_universal_4_void), 4)
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

// Concrete non-generic helpers remain as stable glue targets.
pub fn (ctx Context) wrap_closure_universal_0(v_cb ClosureUniversal0) {
	ctx.create_saved_universal_closure[ClosureUniversal0](v_cb, voidptr(bridge_universal_0), 0)
}

pub fn (ctx Context) wrap_closure_universal_1(v_cb ClosureUniversal1) {
	ctx.create_saved_universal_closure[ClosureUniversal1](v_cb, voidptr(bridge_universal_1), 1)
}

pub fn (ctx Context) wrap_closure_universal_2(v_cb ClosureUniversal2) {
	ctx.create_saved_universal_closure[ClosureUniversal2](v_cb, voidptr(bridge_universal_2), 2)
}

pub fn (ctx Context) wrap_closure_universal_3(v_cb ClosureUniversal3) {
	ctx.create_saved_universal_closure[ClosureUniversal3](v_cb, voidptr(bridge_universal_3), 3)
}

pub fn (ctx Context) wrap_closure_universal_4(v_cb ClosureUniversal4) {
	ctx.create_saved_universal_closure[ClosureUniversal4](v_cb, voidptr(bridge_universal_4), 4)
}

pub fn (ctx Context) wrap_closure_universal_0_void(v_cb ClosureUniversal0Void) {
	ctx.create_saved_universal_closure[ClosureUniversal0Void](v_cb, voidptr(bridge_universal_0_void), 0)
}

pub fn (ctx Context) wrap_closure_universal_1_void(v_cb ClosureUniversal1Void) {
	ctx.create_saved_universal_closure[ClosureUniversal1Void](v_cb, voidptr(bridge_universal_1_void), 1)
}

pub fn (ctx Context) wrap_closure_universal_2_void(v_cb ClosureUniversal2Void) {
	ctx.create_saved_universal_closure[ClosureUniversal2Void](v_cb, voidptr(bridge_universal_2_void), 2)
}

pub fn (ctx Context) wrap_closure_universal_3_void(v_cb ClosureUniversal3Void) {
	ctx.create_saved_universal_closure[ClosureUniversal3Void](v_cb, voidptr(bridge_universal_3_void), 3)
}

pub fn (ctx Context) wrap_closure_universal_4_void(v_cb ClosureUniversal4Void) {
	ctx.create_saved_universal_closure[ClosureUniversal4Void](v_cb, voidptr(bridge_universal_4_void), 4)
}

fn C.emalloc(size usize) voidptr
