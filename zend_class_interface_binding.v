module vphp

import vphp.zend

fn zend_bind_class_interface(class_name string, iface_name string) bool {
	return zend.bind_class_interface(class_name, iface_name)
}

fn zend_register_auto_interface_binding(class_name string, iface_name string) {
	zend.register_auto_interface_binding(class_name, iface_name)
}
