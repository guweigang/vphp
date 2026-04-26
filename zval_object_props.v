module vphp

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
