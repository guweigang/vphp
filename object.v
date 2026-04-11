module vphp

// ============================================
// 运行时泛型 Handler
// 利用 V 的编译期反射 ($for field in T.fields)
// 替代 codegen 生成的局部 getter/setter 代码
// ============================================

__global (
	vphp_vptr_roots &map[voidptr]int
)

fn register_vptr_root(ptr voidptr) {
	if ptr == 0 {
		return
	}
	unsafe {
		if isnil(vphp_vptr_roots) {
			vphp_vptr_roots = &map[voidptr]int{}
		}
		mut m := vphp_vptr_roots
		m[ptr] = 1
	}
}

fn unregister_vptr_root(ptr voidptr) {
	if ptr == 0 {
		return
	}
	unsafe {
		if !isnil(vphp_vptr_roots) {
			mut m := vphp_vptr_roots
			m.delete(ptr)
		}
	}
}

// 泛型属性读取器 — 替代生成的 Article_get_prop 等函数
pub fn generic_get_prop[T](ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
	unsafe {
		name := name_ptr.vstring_with_len(name_len).clone()
		obj := &T(ptr)
		$for field in T.fields {
			if name == field.name {
				val := obj.$(field.name)
				$if field.typ is string {
					return_val_raw(rv, val)
				} $else $if field.typ is int {
					return_val_raw(rv, i64(val))
				} $else $if field.typ is i64 {
					return_val_raw(rv, val)
				} $else $if field.typ is bool {
					return_val_raw(rv, val)
				} $else $if field.typ is f64 {
					return_val_raw(rv, val)
				}
				return
			}
		}
	}
}

// 泛型属性写入器 — 替代生成的 Article_set_prop 等函数
pub fn generic_set_prop[T](ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
	unsafe {
		name := name_ptr.vstring_with_len(name_len).clone()
		mut obj := &T(ptr)
		arg := ZVal{ raw: value }
		$for field in T.fields {
			if name == field.name {
				$if field.typ is string {
					obj.$(field.name) = arg.get_string()
				} $else $if field.typ is int {
					obj.$(field.name) = int(arg.get_int())
				} $else $if field.typ is i64 {
					obj.$(field.name) = arg.get_int()
				} $else $if field.typ is bool {
					obj.$(field.name) = arg.get_bool()
				} $else $if field.typ is f64 {
					obj.$(field.name) = C.vphp_get_double(value)
				}
				return
			}
		}
	}
}

// 泛型同步器 — 用于 var_dump() 时将 V 内存同步到 PHP 属性表
pub fn generic_sync_props[T](ptr voidptr, zv &C.zval) {
	unsafe {
		obj := &T(ptr)
		out := ZVal{ raw: zv }
		$for field in T.fields {
			name := field.name
			val := obj.$(field.name)
			$if field.typ is string {
				out.add_property_string(name, val)
			} $else $if field.typ is int || field.typ is i64 {
				out.add_property_long(name, i64(val))
			} $else $if field.typ is f64 {
				out.add_property_double(name, val)
			} $else $if field.typ is bool {
				out.add_property_bool(name, val)
			}
		}
	}
}

// 连体分配器声明
fn C.vphp_allocate_contiguous_object(ce voidptr, v_size usize) voidptr
fn C.vphp_get_wrapper_from_vptr(v_ptr voidptr) voidptr
fn C.builtin___v_free(ptr voidptr)

// 泛型堆分配器必须保留 V 的默认字段初始化语义。
// 单纯 `vcalloc(sizeof(T))` 只会得到零内存，像 `[]T{}`、`map{}`、
// `PersistentOwnedZBox.new_null()` 这类字段默认值都会丢失，导致
// PHP `new` 出来的 @[php_class] 对象是“半初始化”状态。
pub fn generic_new_raw[T]() voidptr {
	unsafe {
		ptr := &T{}
		register_vptr_root(ptr)
		return ptr
	}
}

// 泛型释放器必须走 V 运行时释放语义，不能混用 ZendMM 的 `efree`。
// 否则 factory/clone 路径里由 `memdup`/`malloc` 产生的对象会在请求结束时打坏 Zend 堆。
pub fn generic_free_raw[T](ptr voidptr) {
	if ptr == 0 {
		return
	}
	unregister_vptr_root(ptr)
	unsafe {
		C.builtin___v_free(ptr)
	}
}

// 泛型连体分配器 (新：用于 @[php_class])
pub fn allocate_contiguous_object[T](ce voidptr) voidptr {
    return unsafe { C.vphp_allocate_contiguous_object(ce, sizeof(T)) }
}

fn object_from_zval_or_nil(z ZVal) &C.zend_object {
	if !z.is_valid() || !z.is_object() {
		return unsafe { nil }
	}
	return C.vphp_get_obj_from_zval(z.raw)
}

pub fn bind_object_with_ownership(z ZVal, handlers voidptr, ownership OwnershipKind) {
	obj := object_from_zval_or_nil(z)
	if isnil(obj) {
		return
	}
	match ownership {
		.borrowed {
			C.vphp_bind_borrowed_handlers(obj, handlers)
		}
		.owned_request, .owned_persistent {
			C.vphp_bind_owned_handlers(obj, handlers)
		}
	}
}

pub fn bind_owned_object(z ZVal, handlers voidptr) {
	bind_object_with_ownership(z, handlers, .owned_request)
}

pub fn bind_borrowed_object(z ZVal, handlers voidptr) {
	bind_object_with_ownership(z, handlers, .borrowed)
}

pub fn ensure_object_binding(z ZVal, handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {
	obj := object_from_zval_or_nil(z)
	if isnil(obj) {
		return unsafe { nil }
	}
	return match ownership {
		.borrowed {
			C.vphp_ensure_borrowed_instance_binding(obj, handlers)
		}
		.owned_request, .owned_persistent {
			C.vphp_ensure_owned_instance_binding(obj, handlers)
		}
	}
}

pub fn ensure_owned_object_binding(z ZVal, handlers voidptr) &C.vphp_object_wrapper {
	return ensure_object_binding(z, handlers, .owned_request)
}

pub fn ensure_borrowed_object_binding(z ZVal, handlers voidptr) &C.vphp_object_wrapper {
	return ensure_object_binding(z, handlers, .borrowed)
}

pub fn init_owned_object(z ZVal, handlers voidptr) {
	obj := object_from_zval_or_nil(z)
	if isnil(obj) {
		return
	}
	C.vphp_init_owned_instance(obj, handlers)
}

pub fn return_bound_object_raw(ret &C.zval, v_ptr voidptr, ce voidptr, handlers voidptr, ownership OwnershipKind) {
	match ownership {
		.borrowed {
			C.vphp_return_borrowed_object(ret, v_ptr, ce, handlers)
		}
		.owned_request, .owned_persistent {
			register_vptr_root(v_ptr)
			C.vphp_return_owned_object(ret, v_ptr, ce, handlers)
		}
	}
}

pub fn return_owned_object_raw(ret &C.zval, v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_bound_object_raw(ret, v_ptr, ce, handlers, .owned_request)
}

pub fn return_borrowed_object_raw(ret &C.zval, v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_bound_object_raw(ret, v_ptr, ce, handlers, .borrowed)
}

pub struct RetainedObject {
pub mut:
	raw &C.zend_object = unsafe { nil }
}

pub fn RetainedObject.invalid() RetainedObject {
	return RetainedObject{}
}

pub fn RetainedObject.from_zval(z ZVal) ?RetainedObject {
	if !z.is_valid() || !z.is_object() {
		return none
	}
	obj := C.vphp_get_obj_from_zval(z.raw)
	if isnil(obj) {
		return none
	}
	C.vphp_object_addref(obj)
	return RetainedObject{
		raw: obj
	}
}

pub fn (r RetainedObject) is_valid() bool {
	return r.raw != unsafe { nil }
}

pub fn (r RetainedObject) clone() RetainedObject {
	if r.raw == unsafe { nil } {
		return RetainedObject.invalid()
	}
	C.vphp_object_addref(r.raw)
	return RetainedObject{
		raw: r.raw
	}
}

pub fn (r RetainedObject) to_request_owned_zval() ZVal {
	if r.raw == unsafe { nil } {
		return invalid_zval()
	}
	unsafe {
		mut out := C.vphp_new_zval()
		if out == 0 {
			return invalid_zval()
		}
		C.vphp_wrap_existing_object(out, r.raw)
		return adopt_raw_with_ownership(out, .owned_request)
	}
}

pub fn (r RetainedObject) with_request_zval[T](run fn (ZVal) T) T {
	mut out := RequestOwnedZBox{
		ZValViewState: ZValViewState{
			z: r.to_request_owned_zval()
		}
	}
	defer {
		out.release()
	}
	return run(out.to_zval())
}

pub fn (mut r RetainedObject) release() {
	if r.raw == unsafe { nil } {
		return
	}
	C.vphp_object_release(r.raw)
	r.raw = unsafe { nil }
}
