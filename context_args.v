module vphp

import vphp.zend as _

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
pub fn (ctx Context) arg_borrowed_zbox(index int) RequestBorrowedZBox {
	return RequestBorrowedZBox.of(ctx.arg_raw(index))
}

pub fn (ctx Context) arg_any_zbox(index int) RequestBorrowedZBox {
	return ctx.arg_borrowed_zbox(index)
}

pub fn (ctx Context) arg_owned_request_zbox(index int) RequestOwnedZBox {
	return RequestOwnedZBox.of(ctx.arg_raw(index))
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
