module vphp

// ======== 闭包桥接 ========

@[inline]
fn save_closure_value[T](v_cb T) voidptr {
	mut saved_cb := unsafe { &T(C.emalloc(usize(sizeof(T)))) }
	unsafe {
		*saved_cb = v_cb
	}
	return voidptr(saved_cb)
}

pub fn (ctx Context) create_saved_closure[T](v_cb T, bridge voidptr, arity int) {
	C.vphp_create_closure_with_arity(ctx.ret.raw_zval(), save_closure_value[T](v_cb), bridge,
		arity, arity)
}

pub fn (ctx Context) create_saved_variadic_closure[T](v_cb T, bridge voidptr) {
	C.vphp_create_variadic_closure(ctx.ret.raw_zval(), save_closure_value[T](v_cb), bridge)
}

pub fn (ctx Context) invoke_variadic_closure[T, R](cb T) {
	$match T {
		fn (...vphp.ZVal) R {
			args := ctx.variadic_zval_args()
			res := cb(...args)
			ctx.return().v[R](res)
		}
		fn (...vphp.PhpValue) R {
			args := ctx.variadic_php_value_args()
			res := cb(...args)
			ctx.return().v[R](res)
		}
		fn (...vphp.RequestBorrowedZBox) R {
			args := ctx.variadic_borrowed_zbox_args()
			res := cb(...args)
			ctx.return().v[R](res)
		}
		fn (...vphp.VScalarValue) R {
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
		fn (...vphp.ZVal) {
			args := ctx.variadic_zval_args()
			cb(...args)
			ctx.return().null()
		}
		fn (...vphp.PhpValue) {
			args := ctx.variadic_php_value_args()
			cb(...args)
			ctx.return().null()
		}
		fn (...vphp.RequestBorrowedZBox) {
			args := ctx.variadic_borrowed_zbox_args()
			cb(...args)
			ctx.return().null()
		}
		fn (...vphp.VScalarValue) {
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
	mut args := []vphp.ZVal{cap: ctx.num_args()}
	for i in 0 .. ctx.num_args() {
		args << ctx.arg_val(i)
	}
	return args
}

fn (ctx Context) variadic_php_value_args() []vphp.PhpValue {
	mut args := []vphp.PhpValue{cap: ctx.num_args()}
	for i in 0 .. ctx.num_args() {
		args << ctx.arg_value(i)
	}
	return args
}

fn (ctx Context) variadic_borrowed_zbox_args() []vphp.RequestBorrowedZBox {
	mut args := []vphp.RequestBorrowedZBox{cap: ctx.num_args()}
	for i in 0 .. ctx.num_args() {
		args << ctx.arg_borrowed_zbox(i)
	}
	return args
}

fn (ctx Context) variadic_v_scalar_args() ![]vphp.VScalarValue {
	mut args := []vphp.VScalarValue{cap: ctx.num_args()}
	for i in 0 .. ctx.num_args() {
		args << ctx.arg_v_scalar(i)!
	}
	return args
}

fn C.emalloc(size usize) voidptr
