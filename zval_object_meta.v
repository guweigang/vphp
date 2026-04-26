module vphp

// ======== 对象属性与类元信息 ========

// -------- 对象属性操作 --------
pub fn (v ZVal) add_property_string(key string, val string) {
	unsafe { C.add_property_stringl(v.raw, &char(key.str), &char(val.str), val.len) }
}

pub fn (v ZVal) add_property_long(key string, val i64) {
	unsafe { C.add_property_long(v.raw, &char(key.str), val) }
}

pub fn (v ZVal) add_property_double(key string, val f64) {
	unsafe { C.vphp_add_property_double(v.raw, &char(key.str), val) }
}

pub fn (v ZVal) add_property_bool(key string, val bool) {
	unsafe { C.add_property_bool(v.raw, &char(key.str), val) }
}

// 通用属性获取：返回一个新的 ZVal
pub fn (v ZVal) get_prop(name string) ZVal {
	return v.prop_owned_request(name)
}

pub fn (v ZVal) prop_borrowed(name string) ZVal {
	if !v.is_object() {
		return invalid_zval()
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	rv := C.vphp_new_zval()
	res := C.vphp_read_property_compat(obj, &char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .borrowed)
}

pub fn (v ZVal) prop_owned_request(name string) ZVal {
	if !v.is_object() {
		return invalid_zval()
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	rv := C.vphp_new_zval()
	res := C.vphp_read_property_compat(obj, &char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_request)
}

pub fn (v ZVal) prop_owned_persistent(name string) ZVal {
	if !v.is_object() {
		return invalid_zval()
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	rv := C.vphp_new_zval()
	res := C.vphp_read_property_compat(obj, &char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_persistent)
}

pub fn (v ZVal) prop(name string) ZVal {
	return v.prop_owned_request(name)
}

pub fn (v ZVal) set_prop(name string, value ZVal) {
	if !v.is_object() || value.raw == 0 {
		return
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	C.vphp_write_property_compat(obj, &char(name.str), name.len, value.raw)
}

pub fn (v ZVal) has_prop(name string) bool {
	if !v.is_object() {
		return false
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	return C.vphp_has_property_compat(obj, &char(name.str), name.len) == 1
}

pub fn (v ZVal) isset_prop(name string) bool {
	if !v.is_object() {
		return false
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	return C.vphp_isset_property_compat(obj, &char(name.str), name.len) == 1
}

pub fn (v ZVal) unset_prop(name string) {
	if !v.is_object() {
		return
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	C.vphp_unset_property_compat(obj, &char(name.str), name.len)
}

// 快捷方式：属性 → string
pub fn (v ZVal) get_prop_string(name string) string {
	prop := v.get_prop(name)
	if prop.raw == 0 || prop.is_null() {
		return ''
	}
	return prop.to_string()
}

// 快捷方式：属性 → int
pub fn (v ZVal) get_prop_int(name string) int {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return 0
	}
	return int(C.vphp_get_int(prop.raw))
}

// 快捷方式：属性 → i64
pub fn (v ZVal) get_prop_i64(name string) i64 {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return 0
	}
	return i64(C.vphp_get_int(prop.raw))
}

// 快捷方式：属性 → f64
pub fn (v ZVal) get_prop_float(name string) f64 {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return 0.0
	}
	return C.vphp_get_double(prop.raw)
}

// 快捷方式：属性 → bool
pub fn (v ZVal) get_prop_bool(name string) bool {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return false
	}
	return prop.to_bool()
}

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
