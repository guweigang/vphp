module vphp

// -------- 类元信息 / introspection --------
pub fn (v ZVal) class_name() string {
	if v.raw == 0 {
		return ''
	}
	if v.is_string() {
		return v.to_string()
	}
	if !v.is_object() {
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

pub fn (v ZVal) namespace_name() string {
	class_name := v.class_name()
	if !class_name.contains('\\') {
		return ''
	}
	return class_name.all_before_last('\\')
}

pub fn (v ZVal) short_name() string {
	class_name := v.class_name()
	if !class_name.contains('\\') {
		return class_name
	}
	return class_name.all_after_last('\\')
}

pub fn (v ZVal) parent_class_name() string {
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

pub fn (v ZVal) is_internal_class() bool {
	if v.raw == 0 {
		return false
	}
	return C.vphp_class_is_internal(v.raw) == 1
}

pub fn (v ZVal) is_user_class() bool {
	return !v.is_internal_class()
}

pub fn (v ZVal) interface_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	interfaces := php_fn('class_implements').call([ZVal.new_string(class_name)])
	if !interfaces.is_array() {
		return []string{}
	}
	mut out := []string{}
	out = interfaces.foreach_with_ctx[[]string](out, fn (_ ZVal, val ZVal, mut acc []string) {
		acc << val.to_string()
	})
	out.sort()
	return out
}

pub fn (v ZVal) is_instance_of(name string) bool {
	if v.raw == 0 {
		return false
	}
	res := php_fn('is_a').call([v, ZVal.new_string(name), ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}

pub fn (v ZVal) is_subclass_of(name string) bool {
	if v.raw == 0 {
		return false
	}
	res := php_fn('is_subclass_of').call([v, ZVal.new_string(name),
		ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}

pub fn (v ZVal) implements_interface(name string) bool {
	if name.len == 0 {
		return false
	}
	return name in v.interface_names()
}

pub fn (v ZVal) method_exists(name string) bool {
	if v.raw == 0 {
		return false
	}
	res := php_fn('method_exists').call([v, ZVal.new_string(name)])
	return res.is_valid() && res.to_bool()
}

pub fn (v ZVal) property_exists(name string) bool {
	if v.raw == 0 {
		return false
	}
	res := php_fn('property_exists').call([v, ZVal.new_string(name)])
	return res.is_valid() && res.to_bool()
}

pub fn (v ZVal) method_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	methods := php_class('ReflectionClass').construct([
		ZVal.new_string(class_name),
	]).method('getMethods', [])
	if !methods.is_array() {
		return []string{}
	}
	mut out := []string{}
	out = methods.foreach_with_ctx[[]string](out, fn (_ ZVal, val ZVal, mut acc []string) {
		acc << val.method('getName', []).to_string()
	})
	out.sort()
	return out
}

pub fn (v ZVal) property_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	props := php_class('ReflectionClass').construct([
		ZVal.new_string(class_name),
	]).method('getProperties', [])
	if !props.is_array() {
		return []string{}
	}
	mut out := []string{}
	out = props.foreach_with_ctx[[]string](out, fn (_ ZVal, val ZVal, mut acc []string) {
		acc << val.method('getName', []).to_string()
	})
	out.sort()
	return out
}

pub fn (v ZVal) const_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	consts := php_class('ReflectionClass').construct([
		ZVal.new_string(class_name),
	]).method('getConstants', [])
	mut out := consts.foreach_with_ctx[[]string]([]string{}, fn (k ZVal, _ ZVal, mut acc []string) {
		acc << k.to_string()
	})
	out.sort()
	return out
}

pub fn (v ZVal) const_exists(name string) bool {
	class_name := v.class_name()
	if class_name.len == 0 {
		return false
	}
	rc := php_class('ReflectionClass').construct([
		ZVal.new_string(class_name),
	])
	res := rc.method('hasConstant', [ZVal.new_string(name)])
	return res.is_valid() && res.to_bool()
}
