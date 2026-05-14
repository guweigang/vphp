module vphp

import vphp.zend

fn zend_init_object_zval(v ZVal) {
	zend.init_object_zval(v.raw_ptr())
}

fn zend_add_property_string(v ZVal, key string, val string) {
	zend.add_property_string(v.raw_ptr(), key, val)
}

fn zend_update_property_string(v ZVal, key string, val string) {
	zend.update_property_string(v.raw_ptr(), key, val)
}

fn zend_add_property_long(v ZVal, key string, val i64) {
	zend.add_property_long(v.raw_ptr(), key, val)
}

fn zend_add_property_double(v ZVal, key string, val f64) {
	zend.add_property_double(v.raw_ptr(), key, val)
}

fn zend_add_property_bool(v ZVal, key string, val bool) {
	zend.add_property_bool(v.raw_ptr(), key, val)
}

fn zend_object_class_name(v ZVal) string {
	if !v.is_valid() {
		return ''
	}
	return zend.object_class_name(v.raw_ptr())
}

fn zend_object_parent_class_name(v ZVal) string {
	if !v.is_valid() {
		return ''
	}
	return zend.object_parent_class_name(v.raw_ptr())
}

fn zend_object_class_is_internal(v ZVal) bool {
	if !v.is_valid() {
		return false
	}
	return zend.object_class_is_internal(v.raw_ptr())
}
