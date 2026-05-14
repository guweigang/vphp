module vphp

import vphp.zval

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
