module vphp

import vphp.object
import vphp.zend
import vphp.zval

// --- From zend_class_entry_type.v ---
pub struct ZendClassEntry {
	raw voidptr
}

pub fn ZendClassEntry.from_ptr(raw voidptr) ZendClassEntry {
	return ZendClassEntry{
		raw: raw
	}
}

pub fn (ce ZendClassEntry) is_valid() bool {
	return ce.raw_ptr() != 0
}

pub fn (ce ZendClassEntry) raw_ptr() voidptr {
	return ce.raw
}

pub fn (ce ZendClassEntry) set_static_prop[T](name string, val T) {
	if !ce.is_valid() {
		return
	}
	$if T is int {
		zend.set_static_long(ce.raw_ptr(), name, i64(val))
	} $else $if T is string {
		zend.set_static_string(ce.raw_ptr(), name, val)
	} $else $if T is bool {
		zend.set_static_bool(ce.raw_ptr(), name, val)
	}
}

pub fn (ce ZendClassEntry) static_prop[T](name string) T {
	if !ce.is_valid() {
		return T{}
	}
	$if T is int {
		return int(zend.static_long(ce.raw_ptr(), name))
	} $else $if T is string {
		return zend.static_string(ce.raw_ptr(), name)
	} $else $if T is bool {
		return zend.static_bool(ce.raw_ptr(), name)
	}
	return T{}
}

// --- From zend_class_handlers_type.v ---
@[params]
pub struct ZendClassHandlersConfig {
pub:
	prop_handler  voidptr
	write_handler voidptr
	sync_handler  voidptr
	new_raw       voidptr
	cleanup_raw   voidptr
	free_raw      voidptr
}

pub struct ZendClassHandlers {}

pub fn ZendClassHandlers.new(config ZendClassHandlersConfig) voidptr {
	return zend.new_class_handlers(zend.ClassHandlersConfig{
		prop_handler:  config.prop_handler
		write_handler: config.write_handler
		sync_handler:  config.sync_handler
		new_raw:       config.new_raw
		cleanup_raw:   config.cleanup_raw
		free_raw:      config.free_raw
	})
}

// --- From zend_object_type.v ---
pub struct ZendObject {
	handle object.Handle
}

pub fn ZendObject.invalid() ZendObject {
	return ZendObject{
		handle: object.Handle.invalid()
	}
}

pub fn ZendObject.from_ptr(ptr voidptr) ZendObject {
	return ZendObject{
		handle: object.Handle.from_ptr(ptr)
	}
}

pub fn ZendObject.current() ZendObject {
	obj_raw := zend.current_this_object()
	if obj_raw == 0 {
		return ZendObject.invalid()
	}
	return ZendObject.from_ptr(obj_raw)
}

pub fn ZendObject.from_zval(v ZVal) ZendObject {
	if !v.is_valid() || !v.is_object() {
		return ZendObject.invalid()
	}
	return ZendObject{
		handle: object.from_zval(v.handle())
	}
}

pub fn (obj ZendObject) is_valid() bool {
	return obj.handle.is_valid()
}

pub fn (obj ZendObject) raw_ptr() voidptr {
	return obj.handle.raw_ptr()
}

// --- From zend_object_lifecycle.v ---
fn object_binding_ownership(ownership OwnershipKind) object.BindingOwnership {
	return match ownership {
		.borrowed {
			.borrowed
		}
		.owned_request, .owned_persistent {
			.owned
		}
	}
}

fn wrap_existing_object(out zval.Handle, obj ZendObject) {
	object.wrap_existing_zval(out, obj.handle)
}

pub fn (obj ZendObject) add_ref() {
	if !obj.is_valid() {
		return
	}
	obj.handle.add_ref()
}

pub fn (obj ZendObject) release() {
	if !obj.is_valid() {
		return
	}
	obj.handle.release()
}

pub fn (obj ZendObject) bind_handlers(handlers object.ObjectHandlers, ownership OwnershipKind) {
	if !obj.is_valid() {
		return
	}
	match ownership {
		.borrowed {
			obj.handle.bind_borrowed_handlers(handlers)
		}
		.owned_request, .owned_persistent {
			obj.handle.bind_owned_handlers(handlers)
		}
	}
}

pub fn (obj ZendObject) ensure_binding_ptr(handlers object.ObjectHandlers, ownership OwnershipKind) voidptr {
	if !obj.is_valid() {
		return // SAFETY: nil literal in unsafe context
		 unsafe { nil }
	}
	return obj.handle.ensure_binding_ptr(handlers, object_binding_ownership(ownership))
}

pub fn (obj ZendObject) init_owned_instance(handlers object.ObjectHandlers) {
	if !obj.is_valid() {
		return
	}
	obj.handle.init_owned_instance(handlers)
}

pub fn (obj ZendObject) bound_v_ptr() voidptr {
	if !obj.is_valid() {
		return // SAFETY: nil literal in unsafe context
		 unsafe { nil }
	}
	return obj.handle.bound_v_ptr()
}

pub fn (obj ZendObject) to_request_owned_zval() ZVal {
	if !obj.is_valid() {
		return invalid_zval()
	}
	out := zval.new_request()
	if !out.is_valid() {
		return invalid_zval()
	}
	wrap_existing_object(out, obj)
	return adopt_handle_with_ownership(out, .owned_request)
}

// --- From zend_object_property.v ---
fn (obj ZendObject) read_property_with_ownership(name string, ownership OwnershipKind) ZVal {
	if !obj.is_valid() {
		return invalid_zval()
	}
	return adopt_read_result_handles(obj.handle.read_property(name), ownership)
}

fn (obj ZendObject) with_scalar_prop(name string, run fn (ZVal)) bool {
	if !obj.is_valid() {
		return false
	}
	result := obj.handle.read_property(name)
	if !result.rv.is_valid() {
		return false
	}
	defer {
		zval.release_request(result.rv)
	}
	if !result.res.is_valid() {
		return false
	}
	value := ZVal.from_handle(result.res)
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
	obj.handle.write_property_ptr(name, value.raw_ptr())
}

pub fn (obj ZendObject) set_prop_value(name string, value PhpValue) {
	obj.set_prop(name, value.to_zval())
}

pub fn (obj ZendObject) set_prop_input(name string, value PhpArgInput) {
	obj.set_prop(name, value.to_zval())
}

pub fn (obj ZendObject) has_prop(name string) bool {
	if !obj.is_valid() {
		return false
	}
	return obj.handle.has_property(name)
}

pub fn (obj ZendObject) isset_prop(name string) bool {
	if !obj.is_valid() {
		return false
	}
	return obj.handle.isset_property(name)
}

pub fn (obj ZendObject) unset_prop(name string) {
	if !obj.is_valid() {
		return
	}
	obj.handle.unset_property(name)
}
