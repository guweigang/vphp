module vphp

import vphp.zend as _

pub struct ZendObject {
	raw &C.zend_object
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

pub fn (obj ZendObject) is_valid() bool {
	return obj.raw != 0
}

fn (obj ZendObject) read_property_with_ownership(name string, ownership OwnershipKind) ZVal {
	if !obj.is_valid() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
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
