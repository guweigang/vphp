module vphp

pub fn (c PhpClass) bind_interface(iface_name string) bool {
	return C.vphp_bind_class_interface(&char(c.name().str), c.name().len, &char(iface_name.str),
		iface_name.len) != 0
}

pub fn (c PhpClass) register_auto_interface(iface_name string) {
	C.vphp_register_auto_interface_binding(&char(c.name().str), c.name().len, &char(iface_name.str),
		iface_name.len)
}

pub fn bind_class_interface(class_name string, iface_name string) bool {
	return PhpClass.named(class_name).bind_interface(iface_name)
}

pub fn register_auto_interface_binding(class_name string, iface_name string) {
	PhpClass.named(class_name).register_auto_interface(iface_name)
}
