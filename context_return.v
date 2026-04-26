module vphp

import vphp.zend as _

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
