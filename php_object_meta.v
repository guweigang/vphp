module vphp

pub fn (o PhpObject) class_name() string {
	return o.to_zval().class_name()
}

pub fn (o PhpObject) namespace_name() string {
	return o.to_zval().namespace_name()
}

pub fn (o PhpObject) short_name() string {
	return o.to_zval().short_name()
}

pub fn (o PhpObject) parent_class_name() string {
	return o.to_zval().parent_class_name()
}

pub fn (o PhpObject) is_internal_class() bool {
	return o.to_zval().is_internal_class()
}

pub fn (o PhpObject) is_user_class() bool {
	return o.to_zval().is_user_class()
}

pub fn (o PhpObject) interface_names() []string {
	return o.to_zval().interface_names()
}

pub fn (o PhpObject) implements_interface(name string) bool {
	return o.to_zval().implements_interface(name)
}

pub fn (o PhpObject) is_instance_of(name string) bool {
	return o.to_zval().is_instance_of(name)
}

pub fn (o PhpObject) is_subclass_of(name string) bool {
	return o.to_zval().is_subclass_of(name)
}

pub fn (o PhpObject) method_exists(name string) bool {
	return o.to_zval().method_exists(name)
}

pub fn (o PhpObject) property_exists(name string) bool {
	return o.to_zval().property_exists(name)
}

pub fn (o PhpObject) method_names() []string {
	return o.to_zval().method_names()
}

pub fn (o PhpObject) property_names() []string {
	return o.to_zval().property_names()
}

pub fn (o PhpObject) const_names() []string {
	return o.to_zval().const_names()
}

pub fn (o PhpObject) const_exists(name string) bool {
	return o.to_zval().const_exists(name)
}
