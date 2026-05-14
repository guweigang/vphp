module vphp

import vphp.zval

// ======== 工厂方法 ========

fn zend_new_null_zval() zval.Handle {
	return zval.new_null()
}

fn zend_new_int_zval(n i64) zval.Handle {
	return zval.new_int(n)
}

fn zend_new_float_zval(f f64) zval.Handle {
	return zval.new_float(f)
}

fn zend_new_bool_zval(b bool) zval.Handle {
	return zval.new_bool(b)
}

fn zend_new_string_zval(s string) zval.Handle {
	return zval.new_string(s)
}

fn zend_foreach_zval(v ZVal, ctx voidptr, wrapper voidptr) {
	zval.foreach(v.handle(), ctx, wrapper)
}

fn request_owned_zval_from_handle(handle zval.Handle) ZVal {
	RequestScope.autorelease_add_handle(handle)
	return unsafe {
		ZVal{
			raw:   ZVal.from_handle(handle).raw
			owned: true
		}
	}
}

// 创建一个 null ZVal
pub fn ZVal.new_null() ZVal {
	return request_owned_zval_from_handle(zend_new_null_zval())
}

// 创建一个 int ZVal
pub fn ZVal.new_int(n i64) ZVal {
	return request_owned_zval_from_handle(zend_new_int_zval(n))
}

// 创建一个 float ZVal
pub fn ZVal.new_float(f f64) ZVal {
	return request_owned_zval_from_handle(zend_new_float_zval(f))
}

// 创建一个 bool ZVal
pub fn ZVal.new_bool(b bool) ZVal {
	return request_owned_zval_from_handle(zend_new_bool_zval(b))
}

// 创建一个 string ZVal
pub fn ZVal.new_string(s string) ZVal {
	return request_owned_zval_from_handle(zend_new_string_zval(s))
}

// 兼容旧命名：建议改用 ZVal.new_null()
pub fn new_val_null() ZVal {
	return ZVal.new_null()
}

// 兼容旧命名：建议改用 ZVal.new_int()
pub fn new_val_int(n i64) ZVal {
	return ZVal.new_int(n)
}

// 兼容旧命名：建议改用 ZVal.new_float()
pub fn new_val_float(f f64) ZVal {
	return ZVal.new_float(f)
}

// 兼容旧命名：建议改用 ZVal.new_bool()
pub fn new_val_bool(b bool) ZVal {
	return ZVal.new_bool(b)
}

// 兼容旧命名：建议改用 ZVal.new_string()
pub fn new_val_string(s string) ZVal {
	return ZVal.new_string(s)
}

// ======== 高级：对象转换 ========

// 将 zval 对象转化为具体的 V 结构体指针
pub fn (v ZVal) to_object[T]() ?&T {
	if !v.is_object() {
		return none
	}
	ptr := ZendObject.from_zval(v).bound_v_ptr()
	if ptr == 0 {
		return none
	}
	return unsafe { &T(ptr) }
}

// ======== 高级：迭代器 foreach ========

pub type ForeachCb = fn (key ZVal, val ZVal)

fn vphp_foreach_wrapper(ctx voidptr, key &C.zval, val &C.zval) {
	unsafe {
		cb := *(&ForeachCb(ctx))
		cb(ZVal.from_handle(zval.Handle.from_ptr(key)), ZVal.from_handle(zval.Handle.from_ptr(val)))
	}
}

// 遍历当前 ZVal (对 array 和 object 有效)
pub fn (v ZVal) foreach(cb ForeachCb) {
	if !v.is_array() && !v.is_object() {
		return
	}
	zend_foreach_zval(v, &cb, vphp_foreach_wrapper)
}

// 语义化别名：更贴近日常遍历语义
pub fn (v ZVal) each(cb ForeachCb) {
	v.foreach(cb)
}

pub type ForeachWithCtxCb[T] = fn (key ZVal, val ZVal, mut ctx T)

fn vphp_foreach_with_ctx_wrapper[T](ctx voidptr, key &C.zval, val &C.zval) {
	unsafe {
		mut pack := &ForeachPack[T](ctx)
		cb := pack.cb
		cb(ZVal.from_handle(zval.Handle.from_ptr(key)),
			ZVal.from_handle(zval.Handle.from_ptr(val)), mut pack.ctx)
	}
}

struct ForeachPack[T] {
	cb ForeachWithCtxCb[T] = unsafe { nil }
mut:
	ctx T
}

pub fn (v ZVal) foreach_with_ctx[T](ctx T, cb ForeachWithCtxCb[T]) T {
	if !v.is_array() && !v.is_object() {
		return ctx
	}
	mut pack := ForeachPack[T]{
		cb:  cb
		ctx: ctx
	}
	zend_foreach_zval(v, &pack, vphp_foreach_with_ctx_wrapper[T])
	return pack.ctx
}

// 语义化别名：带累积器的遍历
pub fn (v ZVal) fold[T](init T, cb ForeachWithCtxCb[T]) T {
	return v.foreach_with_ctx[T](init, cb)
}

// reduce 目前与 fold 保持同义；统一采用显式初始值版本
pub fn (v ZVal) reduce[T](init T, cb ForeachWithCtxCb[T]) T {
	return v.foreach_with_ctx[T](init, cb)
}
