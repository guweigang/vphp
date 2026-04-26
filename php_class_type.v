module vphp

pub struct PhpClass {
	class_name string
}

pub struct PhpClassMeta {
pub:
	name           string
	namespace_name string
	short_name     string
	parent_name    string
	interfaces     []string
	is_internal    bool
	is_user        bool
}

pub fn PhpClass.named(name string) PhpClass {
	return PhpClass{
		class_name: name
	}
}

pub fn PhpClass.find(name string) ?PhpClass {
	if !class_exists(name) {
		return none
	}
	return PhpClass.named(name)
}

pub fn (c PhpClass) name() string {
	return c.class_name
}

pub fn (c PhpClass) to_zval() ZVal {
	return ZVal.new_string(c.class_name)
}

pub fn (c PhpClass) exists() bool {
	return class_exists(c.class_name)
}

pub fn (c PhpClass) namespace_name() string {
	return c.to_zval().namespace_name()
}

pub fn (c PhpClass) short_name() string {
	return c.to_zval().short_name()
}

pub fn (c PhpClass) parent_name() string {
	return c.to_zval().parent_class_name()
}

pub fn (c PhpClass) is_internal() bool {
	return c.to_zval().is_internal_class()
}

pub fn (c PhpClass) is_user() bool {
	return c.exists() && !c.is_internal()
}

pub fn (c PhpClass) meta() PhpClassMeta {
	return PhpClassMeta{
		name:           c.name()
		namespace_name: c.namespace_name()
		short_name:     c.short_name()
		parent_name:    c.parent_name()
		interfaces:     c.interface_names()
		is_internal:    c.is_internal()
		is_user:        c.is_user()
	}
}

pub fn (c PhpClass) interface_names() []string {
	return c.to_zval().interface_names()
}

pub fn (c PhpClass) implements_interface(name string) bool {
	return c.to_zval().implements_interface(name)
}

pub fn (c PhpClass) is_subclass_of(name string) bool {
	return c.to_zval().is_subclass_of(name)
}

pub fn (c PhpClass) method_exists(name string) bool {
	return c.to_zval().method_exists(name)
}

pub fn (c PhpClass) property_exists(name string) bool {
	return c.to_zval().property_exists(name)
}

pub fn (c PhpClass) method_names() []string {
	return c.to_zval().method_names()
}

pub fn (c PhpClass) property_names() []string {
	return c.to_zval().property_names()
}

pub fn (c PhpClass) const_names() []string {
	return c.to_zval().const_names()
}

pub fn (c PhpClass) const_exists(name string) bool {
	return c.to_zval().const_exists(name)
}

pub fn (c PhpClass) construct(args []ZVal) ZVal {
	return c.to_zval().construct(args)
}

pub fn (c PhpClass) construct_owned_request(args []ZVal) ZVal {
	return c.to_zval().construct_owned_request(args)
}

pub fn (c PhpClass) construct_owned_persistent(args []ZVal) ZVal {
	return c.to_zval().construct_owned_persistent(args)
}

pub fn (c PhpClass) static_method(method string, args []ZVal) ZVal {
	return c.to_zval().static_method(method, args)
}

pub fn (c PhpClass) static_method_owned_request(method string, args []ZVal) ZVal {
	return c.to_zval().static_method_owned_request(method, args)
}

pub fn (c PhpClass) static_method_owned_persistent(method string, args []ZVal) ZVal {
	return c.to_zval().static_method_owned_persistent(method, args)
}

pub fn (c PhpClass) static_prop(name string) ZVal {
	return c.to_zval().static_prop(name)
}

pub fn (c PhpClass) static_prop_borrowed(name string) ZVal {
	return c.to_zval().static_prop_borrowed(name)
}

pub fn (c PhpClass) static_prop_owned_request(name string) ZVal {
	return c.to_zval().static_prop_owned_request(name)
}

pub fn (c PhpClass) static_prop_owned_persistent(name string) ZVal {
	return c.to_zval().static_prop_owned_persistent(name)
}

pub fn (c PhpClass) set_static_prop(name string, value ZVal) {
	c.to_zval().set_static_prop(name, value)
}

pub fn (c PhpClass) @const(name string) ZVal {
	return c.to_zval().@const(name)
}

pub fn (c PhpClass) const_borrowed(name string) ZVal {
	return c.to_zval().const_borrowed(name)
}

pub fn (c PhpClass) const_owned_request(name string) ZVal {
	return c.to_zval().const_owned_request(name)
}

pub fn (c PhpClass) const_owned_persistent(name string) ZVal {
	return c.to_zval().const_owned_persistent(name)
}

// Compatibility alias. Prefer `.@const(...)` in new code.
pub fn (c PhpClass) constant(name string) ZVal {
	return c.@const(name)
}

pub fn (c PhpClass) construct_v[T](args []ZVal) !T {
	return c.construct(args).to_v[T]()
}

pub fn (c PhpClass) construct_owned_request_v[T](args []ZVal) !T {
	return c.construct_owned_request(args).to_v[T]()
}

pub fn (c PhpClass) construct_owned_persistent_v[T](args []ZVal) !T {
	return c.construct_owned_persistent(args).to_v[T]()
}

pub fn (c PhpClass) static_method_v[T](method string, args []ZVal) !T {
	return c.static_method(method, args).to_v[T]()
}

pub fn (c PhpClass) static_method_owned_request_v[T](method string, args []ZVal) !T {
	return c.static_method_owned_request(method, args).to_v[T]()
}

pub fn (c PhpClass) static_method_owned_persistent_v[T](method string, args []ZVal) !T {
	return c.static_method_owned_persistent(method, args).to_v[T]()
}

pub fn (c PhpClass) static_prop_v[T](name string) !T {
	return c.static_prop(name).to_v[T]()
}

pub fn (c PhpClass) static_prop_borrowed_v[T](name string) !T {
	return c.static_prop_borrowed(name).to_v[T]()
}

pub fn (c PhpClass) static_prop_owned_request_v[T](name string) !T {
	return c.static_prop_owned_request(name).to_v[T]()
}

pub fn (c PhpClass) static_prop_owned_persistent_v[T](name string) !T {
	return c.static_prop_owned_persistent(name).to_v[T]()
}

pub fn (c PhpClass) const_v[T](name string) !T {
	return c.@const(name).to_v[T]()
}

pub fn (c PhpClass) const_borrowed_v[T](name string) !T {
	return c.const_borrowed(name).to_v[T]()
}

pub fn (c PhpClass) const_owned_request_v[T](name string) !T {
	return c.const_owned_request(name).to_v[T]()
}

pub fn (c PhpClass) const_owned_persistent_v[T](name string) !T {
	return c.const_owned_persistent(name).to_v[T]()
}

pub fn (c PhpClass) construct_object[T](args []ZVal) ?&T {
	return c.construct(args).to_object[T]()
}

pub fn (c PhpClass) construct_owned_request_object[T](args []ZVal) ?&T {
	return c.construct_owned_request(args).to_object[T]()
}

pub fn (c PhpClass) construct_owned_persistent_object[T](args []ZVal) ?&T {
	return c.construct_owned_persistent(args).to_object[T]()
}

pub fn (c PhpClass) static_method_object[T](method string, args []ZVal) ?&T {
	return c.static_method(method, args).to_object[T]()
}

pub fn (c PhpClass) static_method_owned_request_object[T](method string, args []ZVal) ?&T {
	return c.static_method_owned_request(method, args).to_object[T]()
}

pub fn (c PhpClass) static_method_owned_persistent_object[T](method string, args []ZVal) ?&T {
	return c.static_method_owned_persistent(method, args).to_object[T]()
}

// 兼容旧命名：建议改用 `.const_v[T](...)`
pub fn (c PhpClass) constant_v[T](name string) !T {
	return c.const_v[T](name)
}
