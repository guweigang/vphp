module vphp

import vphp.zend as _

fn C.vphp_allocate_contiguous_object(ce voidptr, v_size usize) voidptr

pub struct ZendObject {
	raw &C.zend_object
}

pub fn ZendObject.invalid() ZendObject {
	return unsafe {
		ZendObject{
			raw: nil
		}
	}
}

pub fn ZendObject.from_raw(raw &C.zend_object) ZendObject {
	return unsafe {
		ZendObject{
			raw: raw
		}
	}
}

pub fn ZendObject.from_ptr(ptr voidptr) ZendObject {
	return unsafe {
		ZendObject{
			raw: &C.zend_object(ptr)
		}
	}
}

fn zend_allocate_contiguous_object(ce voidptr, v_size usize) voidptr {
	return C.vphp_allocate_contiguous_object(ce, v_size)
}

pub fn ZendObject.current() ZendObject {
	obj_raw := C.vphp_get_current_this_object()
	if obj_raw == 0 {
		return ZendObject.invalid()
	}
	return ZendObject.from_ptr(obj_raw)
}

pub fn ZendObject.from_zval(v ZVal) ZendObject {
	if v.raw == 0 || !v.is_object() {
		return ZendObject.invalid()
	}
	return ZendObject.from_raw(C.vphp_get_obj_from_zval(v.raw))
}

pub fn (obj ZendObject) is_valid() bool {
	return obj.raw != 0
}

pub fn (obj ZendObject) raw_ptr() voidptr {
	return obj.raw
}

pub fn (obj ZendObject) add_ref() {
	if !obj.is_valid() {
		return
	}
	C.vphp_object_addref(obj.raw)
}

pub fn (obj ZendObject) release() {
	if !obj.is_valid() {
		return
	}
	C.vphp_object_release(obj.raw)
}

pub fn (obj ZendObject) bind_handlers(handlers voidptr, ownership OwnershipKind) {
	if !obj.is_valid() {
		return
	}
	match ownership {
		.borrowed {
			C.vphp_bind_borrowed_handlers(obj.raw, handlers)
		}
		.owned_request, .owned_persistent {
			C.vphp_bind_owned_handlers(obj.raw, handlers)
		}
	}
}

pub fn (obj ZendObject) ensure_binding(handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {
	if !obj.is_valid() {
		return unsafe { nil }
	}
	return match ownership {
		.borrowed {
			C.vphp_ensure_borrowed_instance_binding(obj.raw, handlers)
		}
		.owned_request, .owned_persistent {
			C.vphp_ensure_owned_instance_binding(obj.raw, handlers)
		}
	}
}

pub fn (obj ZendObject) init_owned_instance(handlers voidptr) {
	if !obj.is_valid() {
		return
	}
	C.vphp_init_owned_instance(obj.raw, handlers)
}

pub fn (obj ZendObject) bound_v_ptr() voidptr {
	if !obj.is_valid() {
		return unsafe { nil }
	}
	wrapper := C.vphp_obj_from_obj(obj.raw)
	if isnil(wrapper) {
		return unsafe { nil }
	}
	return wrapper.v_ptr
}

pub fn (obj ZendObject) to_request_owned_zval() ZVal {
	if !obj.is_valid() {
		return invalid_zval()
	}
	unsafe {
		mut out := zend_new_zval()
		if out == 0 {
			return invalid_zval()
		}
		C.vphp_wrap_existing_object(out, obj.raw)
		return adopt_raw_with_ownership(out, .owned_request)
	}
}

fn (obj ZendObject) read_property_with_ownership(name string, ownership OwnershipKind) ZVal {
	if !obj.is_valid() {
		return invalid_zval()
	}
	rv := zend_new_zval()
	res := C.vphp_read_property_compat(obj.raw, &char(name.str), name.len, rv)
	return adopt_read_result(rv, res, ownership)
}

fn (obj ZendObject) with_scalar_prop(name string, run fn (ZVal)) bool {
	if !obj.is_valid() {
		return false
	}
	mut rv := C.zval{}
	res := C.vphp_read_property_compat(obj.raw, &char(name.str), name.len, &rv)
	if res == 0 {
		return false
	}
	value := ZVal.from_raw(res)
	if value.is_null() || value.is_undef() {
		return false
	}
	run(value)
	return true
}

pub fn (obj ZendObject) prop_string_or(name string, fallback string) string {
	mut out := fallback
	obj.with_scalar_prop(name, fn [mut out] (value ZVal) {
		out = value.to_string()
	})
	return out
}

pub fn (obj ZendObject) prop_i64_or(name string, fallback i64) i64 {
	mut out := fallback
	obj.with_scalar_prop(name, fn [mut out] (value ZVal) {
		out = value.to_i64()
	})
	return out
}

pub fn (obj ZendObject) prop_bool_or(name string, fallback bool) bool {
	mut out := fallback
	obj.with_scalar_prop(name, fn [mut out] (value ZVal) {
		out = value.to_bool()
	})
	return out
}

pub fn (obj ZendObject) prop_f64_or(name string, fallback f64) f64 {
	mut out := fallback
	obj.with_scalar_prop(name, fn [mut out] (value ZVal) {
		out = value.to_f64()
	})
	return out
}

pub fn (obj ZendObject) prop_borrowed(name string) ZVal {
	return obj.read_property_with_ownership(name, .borrowed)
}

pub fn (obj ZendObject) prop_owned_request(name string) ZVal {
	return obj.read_property_with_ownership(name, .owned_request)
}

pub fn (obj ZendObject) prop_owned_persistent(name string) ZVal {
	return obj.read_property_with_ownership(name, .owned_persistent)
}

pub fn (obj ZendObject) set_prop(name string, value ZVal) {
	if !obj.is_valid() || !value.is_valid() {
		return
	}
	C.vphp_write_property_compat(obj.raw, &char(name.str), name.len, value.raw)
}

pub fn (obj ZendObject) has_prop(name string) bool {
	if !obj.is_valid() {
		return false
	}
	return C.vphp_has_property_compat(obj.raw, &char(name.str), name.len) == 1
}

pub fn (obj ZendObject) isset_prop(name string) bool {
	if !obj.is_valid() {
		return false
	}
	return C.vphp_isset_property_compat(obj.raw, &char(name.str), name.len) == 1
}

pub fn (obj ZendObject) unset_prop(name string) {
	if !obj.is_valid() {
		return
	}
	C.vphp_unset_property_compat(obj.raw, &char(name.str), name.len)
}

fn zend_object_class_name(v ZVal) string {
	if v.raw == 0 {
		return ''
	}
	unsafe {
		mut len := 0
		name := C.vphp_get_object_class_name(v.raw, &len)
		if name == 0 || len <= 0 {
			return ''
		}
		return name.vstring_with_len(len).clone()
	}
}

fn zend_object_parent_class_name(v ZVal) string {
	if v.raw == 0 {
		return ''
	}
	unsafe {
		mut len := 0
		name := C.vphp_get_parent_class_name(v.raw, &len)
		if name == 0 || len <= 0 {
			return ''
		}
		return name.vstring_with_len(len).clone()
	}
}

fn zend_object_class_is_internal(v ZVal) bool {
	if v.raw == 0 {
		return false
	}
	return C.vphp_class_is_internal(v.raw) == 1
}
