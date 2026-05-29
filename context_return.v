module vphp

import vphp.zend as _
import vphp.object

// ======== 返回值写入 ========

pub fn (ctx Context) return_null() {
	ctx.return().null()
}

pub fn (ctx Context) return_bool(val bool) {
	ctx.return().bool_value(val)
}

pub fn (ctx Context) return_int(val i64) {
	ctx.return().int_value(val)
}

pub fn (ctx Context) return_double(val f64) {
	ctx.return().double_value(val)
}

pub fn (ctx Context) return_string(val string) {
	ctx.return().string_value(val)
}

pub fn (ctx Context) return_res(ptr voidptr, label string) {
	ctx.return().resource(ptr, label)
}

pub fn (ctx Context) return_obj(v_ptr voidptr, ce ZendClassEntry) {
	ctx.return().object(v_ptr, ce)
}

pub fn (ctx Context) return_bound_object(v_ptr voidptr, ce ZendClassEntry, handlers object.ObjectHandlers, ownership OwnershipKind) {
	ctx.return().bound_object(v_ptr, ce, handlers, ownership)
}

pub fn (ctx Context) return_owned_object(v_ptr voidptr, ce ZendClassEntry, handlers object.ObjectHandlers) {
	ctx.return().owned_object(v_ptr, ce, handlers)
}

pub fn (ctx Context) return_borrowed_object(v_ptr voidptr, ce ZendClassEntry, handlers object.ObjectHandlers) {
	ctx.return().borrowed_object(v_ptr, ce, handlers)
}

pub fn (ctx Context) return_zval(val ZVal) {
	ctx.return().zval(val)
}

pub fn (ctx Context) return_value(value PhpValue) {
	ctx.return().value(value)
}

pub fn (ctx Context) return_null_value(value PhpNull) {
	ctx.return().null_value(value)
}

pub fn (ctx Context) return_dyn(value DynValue) {
	ctx.return().dyn_value(value)
}

pub fn (ctx Context) return_request_owned(value RequestOwnedZBox) {
	ctx.return().request_owned(value)
}

pub fn (ctx Context) return_any[T](val T) {
	ctx.return().any[T](val)
}

pub fn (ctx Context) return_val[T](val T) {
	ctx.return().v[T](val)
}

pub fn (ctx Context) return_list[T](list []T) {
	ctx.return().list[T](list)
}

pub fn (ctx Context) return_map[T](m map[string]T) {
	ctx.return().map_value[T](m)
}

pub fn (ctx Context) return_object(props map[string]string) {
	ctx.return().object_props(props)
}

pub fn (ctx Context) return_struct[T](s T) {
	ctx.return().struct_value[T](s)
}
