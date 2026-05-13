module vphp

// -------- 对象属性操作 --------
pub fn (v ZVal) object_init() {
	unsafe { C.vphp_object_init(v.raw) }
}

pub fn (v ZVal) add_property_string(key string, val string) {
	unsafe { C.add_property_stringl(v.raw, &char(key.str), &char(val.str), val.len) }
}

pub fn (v ZVal) update_property_string(key string, val string) {
	unsafe { C.vphp_update_property_string(v.raw, &char(key.str), key.len, &char(val.str)) }
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
	return ZendObject.from_zval(v).prop_borrowed(name)
}

pub fn (v ZVal) prop_owned_request(name string) ZVal {
	return ZendObject.from_zval(v).prop_owned_request(name)
}

pub fn (v ZVal) prop_owned_persistent(name string) ZVal {
	return ZendObject.from_zval(v).prop_owned_persistent(name)
}

pub fn (v ZVal) prop(name string) ZVal {
	return v.prop_owned_request(name)
}

pub fn (v ZVal) set_prop(name string, value ZVal) {
	ZendObject.from_zval(v).set_prop(name, value)
}

pub fn (v ZVal) has_prop(name string) bool {
	return ZendObject.from_zval(v).has_prop(name)
}

pub fn (v ZVal) isset_prop(name string) bool {
	return ZendObject.from_zval(v).isset_prop(name)
}

pub fn (v ZVal) unset_prop(name string) {
	ZendObject.from_zval(v).unset_prop(name)
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
	return int(prop.to_i64())
}

// 快捷方式：属性 → i64
pub fn (v ZVal) get_prop_i64(name string) i64 {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return 0
	}
	return prop.to_i64()
}

// 快捷方式：属性 → f64
pub fn (v ZVal) get_prop_float(name string) f64 {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return 0.0
	}
	return prop.to_f64()
}

// 快捷方式：属性 → bool
pub fn (v ZVal) get_prop_bool(name string) bool {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return false
	}
	return prop.to_bool()
}
