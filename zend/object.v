module zend

pub fn allocate_contiguous_object(ce voidptr, v_size usize) voidptr {
	return C.vphp_allocate_contiguous_object(ce, v_size)
}

pub fn object_add_ref(obj &C.zend_object) {
	C.vphp_object_addref(obj)
}

pub fn object_add_ref_ptr(obj voidptr) {
	object_add_ref(unsafe { &C.zend_object(obj) })
}

pub fn object_release(obj &C.zend_object) {
	C.vphp_object_release(obj)
}

pub fn object_release_ptr(obj voidptr) {
	object_release(unsafe { &C.zend_object(obj) })
}

pub fn bind_borrowed_handlers(obj &C.zend_object, handlers voidptr) {
	C.vphp_bind_borrowed_handlers(obj, handlers)
}

pub fn bind_borrowed_handlers_ptr(obj voidptr, handlers voidptr) {
	bind_borrowed_handlers(unsafe { &C.zend_object(obj) }, handlers)
}

pub fn bind_owned_handlers(obj &C.zend_object, handlers voidptr) {
	C.vphp_bind_owned_handlers(obj, handlers)
}

pub fn bind_owned_handlers_ptr(obj voidptr, handlers voidptr) {
	bind_owned_handlers(unsafe { &C.zend_object(obj) }, handlers)
}

pub fn ensure_borrowed_instance_binding(obj &C.zend_object, handlers voidptr) &C.vphp_object_wrapper {
	return C.vphp_ensure_borrowed_instance_binding(obj, handlers)
}

pub fn ensure_borrowed_instance_binding_ptr(obj voidptr, handlers voidptr) voidptr {
	return ensure_borrowed_instance_binding(unsafe { &C.zend_object(obj) }, handlers)
}

pub fn ensure_owned_instance_binding(obj &C.zend_object, handlers voidptr) &C.vphp_object_wrapper {
	return C.vphp_ensure_owned_instance_binding(obj, handlers)
}

pub fn ensure_owned_instance_binding_ptr(obj voidptr, handlers voidptr) voidptr {
	return ensure_owned_instance_binding(unsafe { &C.zend_object(obj) }, handlers)
}

pub fn init_owned_instance(obj &C.zend_object, handlers voidptr) {
	C.vphp_init_owned_instance(obj, handlers)
}

pub fn init_owned_instance_ptr(obj voidptr, handlers voidptr) {
	init_owned_instance(unsafe { &C.zend_object(obj) }, handlers)
}

pub fn object_wrapper(obj &C.zend_object) &C.vphp_object_wrapper {
	return C.vphp_obj_from_obj(obj)
}

pub fn object_wrapper_ptr(obj voidptr) voidptr {
	return object_wrapper(unsafe { &C.zend_object(obj) })
}

pub fn wrap_existing_object(out &C.zval, obj &C.zend_object) {
	C.vphp_wrap_existing_object(out, obj)
}

pub fn wrap_existing_object_ptr(out voidptr, obj voidptr) {
	wrap_existing_object(unsafe { &C.zval(out) }, unsafe { &C.zend_object(obj) })
}

pub fn current_this_object() voidptr {
	return C.vphp_get_current_this_object()
}

pub fn object_from_zval(v &C.zval) &C.zend_object {
	return C.vphp_get_obj_from_zval(v)
}

pub fn object_from_zval_ptr(v voidptr) voidptr {
	return object_from_zval(unsafe { &C.zval(v) })
}

pub fn return_unbound_object(ret &C.zval, v_ptr voidptr, ce voidptr) {
	C.vphp_return_obj(ret, v_ptr, ce)
}

pub fn return_unbound_object_ptr(ret voidptr, v_ptr voidptr, ce voidptr) {
	return_unbound_object(unsafe { &C.zval(ret) }, v_ptr, ce)
}

pub fn return_borrowed_object(ret &C.zval, v_ptr voidptr, ce voidptr, handlers voidptr) {
	C.vphp_return_borrowed_object(ret, v_ptr, ce, handlers)
}

pub fn return_borrowed_object_ptr(ret voidptr, v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_borrowed_object(unsafe { &C.zval(ret) }, v_ptr, ce, handlers)
}

pub fn return_owned_object(ret &C.zval, v_ptr voidptr, ce voidptr, handlers voidptr) {
	C.vphp_return_owned_object(ret, v_ptr, ce, handlers)
}

pub fn return_owned_object_ptr(ret voidptr, v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_owned_object(unsafe { &C.zval(ret) }, v_ptr, ce, handlers)
}

pub fn read_property(obj &C.zend_object, name string, rv &C.zval) &C.zval {
	return C.vphp_read_property_compat(obj, &char(name.str), name.len, rv)
}

pub fn read_property_ptr(obj voidptr, name string, rv voidptr) voidptr {
	return read_property(unsafe { &C.zend_object(obj) }, name, unsafe { &C.zval(rv) })
}

pub fn write_property(obj &C.zend_object, name string, value &C.zval) {
	C.vphp_write_property_compat(obj, &char(name.str), name.len, value)
}

pub fn write_property_ptr(obj voidptr, name string, value voidptr) {
	write_property(unsafe { &C.zend_object(obj) }, name, unsafe { &C.zval(value) })
}

pub fn has_property(obj &C.zend_object, name string) bool {
	return C.vphp_has_property_compat(obj, &char(name.str), name.len) == 1
}

pub fn has_property_ptr(obj voidptr, name string) bool {
	return has_property(unsafe { &C.zend_object(obj) }, name)
}

pub fn isset_property(obj &C.zend_object, name string) bool {
	return C.vphp_isset_property_compat(obj, &char(name.str), name.len) == 1
}

pub fn isset_property_ptr(obj voidptr, name string) bool {
	return isset_property(unsafe { &C.zend_object(obj) }, name)
}

pub fn unset_property(obj &C.zend_object, name string) {
	C.vphp_unset_property_compat(obj, &char(name.str), name.len)
}

pub fn unset_property_ptr(obj voidptr, name string) {
	unset_property(unsafe { &C.zend_object(obj) }, name)
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
