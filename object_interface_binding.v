module vphp

pub fn bind_class_interface(class_name string, iface_name string) bool {
	return C.vphp_bind_class_interface(&char(class_name.str), class_name.len, &char(iface_name.str),
		iface_name.len) != 0
}

pub fn register_auto_interface_binding(class_name string, iface_name string) {
	C.vphp_register_auto_interface_binding(&char(class_name.str), class_name.len, &char(iface_name.str),
		iface_name.len)
}
