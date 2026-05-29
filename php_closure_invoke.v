module vphp

import vphp.zend

// ======== 闭包桥接 ========

@[inline]
fn save_closure_value[T](v_cb T) voidptr {
	mut saved_cb := unsafe { &T(zend.emalloc(usize(sizeof(T)))) }
	// SAFETY: C interop block with valid pointer arguments
	unsafe {
		*saved_cb = v_cb
	}
	return voidptr(saved_cb)
}

pub fn (ctx Context) create_saved_closure[T](v_cb T, bridge voidptr, arity int) {
	zend.create_closure_with_arity_ptr(ctx.return().raw_ptr(), save_closure_value[T](v_cb), bridge,
		arity, arity)
}

pub fn (ctx Context) create_saved_variadic_closure[T](v_cb T, bridge voidptr) {
	zend.create_variadic_closure_ptr(ctx.return().raw_ptr(), save_closure_value[T](v_cb), bridge)
}

pub fn (ctx Context) invoke_struct_closure[T, A, R](cb T, args A) {
	$match T {
		fn (A) R {
			res := cb(args)
			ctx.return().v[R](res)
		}
		$else {
			throw_exception('unsupported struct closure type', 0)
		}
	}
}

pub fn (ctx Context) invoke_struct_closure_void[T, A](cb T, args A) {
	$match T {
		fn (A) {
			cb(args)
			ctx.return().null()
		}
		$else {
			throw_exception('unsupported struct closure type', 0)
		}
	}
}

pub fn (ctx Context) invoke_variadic_closure[T, R](cb T) {
	$match T {
		fn (...ZVal) R {
			args := ctx.variadic_zval_args()
			res := cb(...args)
			ctx.return().v[R](res)
		}
		fn (...PhpValue) R {
			args := ctx.variadic_php_value_args()
			res := cb(...args)
			ctx.return().v[R](res)
		}
		fn (...RequestBorrowedZBox) R {
			args := ctx.variadic_borrowed_zbox_args()
			res := cb(...args)
			ctx.return().v[R](res)
		}
		fn (...VScalarValue) R {
			args := ctx.variadic_v_scalar_args() or {
				throw_exception(err.msg(), 0)
				return
			}
			res := cb(...args)
			ctx.return().v[R](res)
		}
		$else {
			throw_exception('unsupported variadic closure type', 0)
		}
	}
}

pub fn (ctx Context) invoke_variadic_closure_void[T](cb T) {
	$match T {
		fn (...ZVal) {
			args := ctx.variadic_zval_args()
			cb(...args)
			ctx.return().null()
		}
		fn (...PhpValue) {
			args := ctx.variadic_php_value_args()
			cb(...args)
			ctx.return().null()
		}
		fn (...RequestBorrowedZBox) {
			args := ctx.variadic_borrowed_zbox_args()
			cb(...args)
			ctx.return().null()
		}
		fn (...VScalarValue) {
			args := ctx.variadic_v_scalar_args() or {
				throw_exception(err.msg(), 0)
				return
			}
			cb(...args)
			ctx.return().null()
		}
		$else {
			throw_exception('unsupported variadic closure type', 0)
		}
	}
}

fn (ctx Context) variadic_zval_args() []vphp.ZVal {
	mut args := []ZVal{cap: ctx.num_args()}
	for i in 0 .. ctx.num_args() {
		args << ctx.arg_val(i)
	}
	return args
}

fn (ctx Context) variadic_php_value_args() []vphp.PhpValue {
	mut args := []PhpValue{cap: ctx.num_args()}
	for i in 0 .. ctx.num_args() {
		args << ctx.arg_value(i)
	}
	return args
}

fn (ctx Context) variadic_borrowed_zbox_args() []vphp.RequestBorrowedZBox {
	mut args := []RequestBorrowedZBox{cap: ctx.num_args()}
	for i in 0 .. ctx.num_args() {
		args << ctx.arg_borrowed_zbox(i)
	}
	return args
}

fn (ctx Context) variadic_v_scalar_args() ![]vphp.VScalarValue {
	mut args := []VScalarValue{cap: ctx.num_args()}
	for i in 0 .. ctx.num_args() {
		args << ctx.arg_v_scalar(i)!
	}
	return args
}
