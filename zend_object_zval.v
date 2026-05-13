module vphp

import vphp.zend as _

fn zend_init_object_zval(v ZVal) {
	unsafe { C.vphp_object_init(v.raw) }
}

fn zend_add_property_string(v ZVal, key string, val string) {
	unsafe { C.add_property_stringl(v.raw, &char(key.str), &char(val.str), val.len) }
}

fn zend_update_property_string(v ZVal, key string, val string) {
	unsafe { C.vphp_update_property_string(v.raw, &char(key.str), key.len, &char(val.str)) }
}

fn zend_add_property_long(v ZVal, key string, val i64) {
	unsafe { C.add_property_long(v.raw, &char(key.str), val) }
}

fn zend_add_property_double(v ZVal, key string, val f64) {
	unsafe { C.vphp_add_property_double(v.raw, &char(key.str), val) }
}

fn zend_add_property_bool(v ZVal, key string, val bool) {
	unsafe { C.add_property_bool(v.raw, &char(key.str), val) }
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
