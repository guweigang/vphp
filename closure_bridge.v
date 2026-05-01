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
	C.vphp_create_closure_with_arity(ctx.ret.raw_zval(), save_closure_value[T](v_cb),
		bridge, arity, arity)
}

pub fn (ctx Context) create_saved_variadic_closure[T](v_cb T, bridge voidptr) {
	C.vphp_create_variadic_closure(ctx.ret.raw_zval(), save_closure_value[T](v_cb), bridge)
}

fn C.emalloc(size usize) voidptr
