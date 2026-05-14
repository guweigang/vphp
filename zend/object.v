module zend

pub fn allocate_contiguous_object(ce voidptr, v_size usize) voidptr {
	return C.vphp_allocate_contiguous_object(ce, v_size)
}

pub fn object_add_ref(obj &C.zend_object) {
	C.vphp_object_addref(obj)
}

pub fn object_release(obj &C.zend_object) {
	C.vphp_object_release(obj)
}

pub fn bind_borrowed_handlers(obj &C.zend_object, handlers voidptr) {
	C.vphp_bind_borrowed_handlers(obj, handlers)
}

pub fn bind_owned_handlers(obj &C.zend_object, handlers voidptr) {
	C.vphp_bind_owned_handlers(obj, handlers)
}

pub fn ensure_borrowed_instance_binding(obj &C.zend_object, handlers voidptr) &C.vphp_object_wrapper {
	return C.vphp_ensure_borrowed_instance_binding(obj, handlers)
}

pub fn ensure_owned_instance_binding(obj &C.zend_object, handlers voidptr) &C.vphp_object_wrapper {
	return C.vphp_ensure_owned_instance_binding(obj, handlers)
}

pub fn init_owned_instance(obj &C.zend_object, handlers voidptr) {
	C.vphp_init_owned_instance(obj, handlers)
}

pub fn object_wrapper(obj &C.zend_object) &C.vphp_object_wrapper {
	return C.vphp_obj_from_obj(obj)
}

pub fn wrap_existing_object(out &C.zval, obj &C.zend_object) {
	C.vphp_wrap_existing_object(out, obj)
}

pub fn read_property(obj &C.zend_object, name string, rv &C.zval) &C.zval {
	return C.vphp_read_property_compat(obj, &char(name.str), name.len, rv)
}

pub fn write_property(obj &C.zend_object, name string, value &C.zval) {
	C.vphp_write_property_compat(obj, &char(name.str), name.len, value)
}

pub fn has_property(obj &C.zend_object, name string) bool {
	return C.vphp_has_property_compat(obj, &char(name.str), name.len) == 1
}

pub fn isset_property(obj &C.zend_object, name string) bool {
	return C.vphp_isset_property_compat(obj, &char(name.str), name.len) == 1
}

pub fn unset_property(obj &C.zend_object, name string) {
	C.vphp_unset_property_compat(obj, &char(name.str), name.len)
}

pub fn init_object_zval(v &C.zval) {
	unsafe { C.vphp_object_init(v) }
}

pub fn add_property_string(v &C.zval, key string, val string) {
	unsafe { C.add_property_stringl(v, &char(key.str), &char(val.str), val.len) }
}

pub fn update_property_string(v &C.zval, key string, val string) {
	unsafe { C.vphp_update_property_string(v, &char(key.str), key.len, &char(val.str)) }
}

pub fn add_property_long(v &C.zval, key string, val i64) {
	unsafe { C.add_property_long(v, &char(key.str), val) }
}

pub fn add_property_double(v &C.zval, key string, val f64) {
	unsafe { C.vphp_add_property_double(v, &char(key.str), val) }
}

pub fn add_property_bool(v &C.zval, key string, val bool) {
	unsafe { C.add_property_bool(v, &char(key.str), val) }
}

pub fn object_class_name(v &C.zval) string {
	unsafe {
		mut len := 0
		name := C.vphp_get_object_class_name(v, &len)
		if name == 0 || len <= 0 {
			return ''
		}
		return name.vstring_with_len(len).clone()
	}
}

pub fn object_parent_class_name(v &C.zval) string {
	unsafe {
		mut len := 0
		name := C.vphp_get_parent_class_name(v, &len)
		if name == 0 || len <= 0 {
			return ''
		}
		return name.vstring_with_len(len).clone()
	}
}

pub fn object_class_is_internal(v &C.zval) bool {
	return C.vphp_class_is_internal(v) == 1
}
