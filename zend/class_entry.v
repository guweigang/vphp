module zend

pub fn set_static_long(ce voidptr, name string, val i64) {
	C.vphp_update_static_property_long(ce, &char(name.str), int(name.len), val)
}

pub fn set_static_string(ce voidptr, name string, val string) {
	C.vphp_update_static_property_string(ce, &char(name.str), int(name.len), &char(val.str),
		int(val.len))
}

pub fn set_static_bool(ce voidptr, name string, val bool) {
	C.vphp_update_static_property_bool(ce, &char(name.str), int(name.len), int(val))
}

pub fn static_long(ce voidptr, name string) i64 {
	return C.vphp_get_static_property_long(ce, &char(name.str), int(name.len))
}

pub fn static_string(ce voidptr, name string) string {
	res := C.vphp_get_static_property_string(ce, &char(name.str), int(name.len))
	return unsafe { res.vstring() }
}

pub fn static_bool(ce voidptr, name string) bool {
	return C.vphp_get_static_property_bool(ce, &char(name.str), int(name.len)) != 0
}

pub fn bind_class_interface(class_name string, iface_name string) bool {
	return C.vphp_bind_class_interface(&char(class_name.str), class_name.len,
		&char(iface_name.str), iface_name.len) != 0
}

pub fn register_auto_interface_binding(class_name string, iface_name string) {
	C.vphp_register_auto_interface_binding(&char(class_name.str), class_name.len,
		&char(iface_name.str), iface_name.len)
}
