module vphp

import vphp.zend

pub fn (c PhpClass) bind_interface(iface_name string) bool {
	return zend.bind_class_interface(c.name(), iface_name)
}

pub fn (c PhpClass) register_auto_interface(iface_name string) {
	zend.register_auto_interface_binding(c.name(), iface_name)
}

pub fn bind_class_interface(class_name string, iface_name string) bool {
	return PhpClass.named(class_name).bind_interface(iface_name)
}

pub fn register_auto_interface_binding(class_name string, iface_name string) {
	PhpClass.named(class_name).register_auto_interface(iface_name)
}
