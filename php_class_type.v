module vphp

pub struct PhpClass {
	name string
	meta ?PhpClassMeta
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
		name: name
	}
}

pub fn PhpClass.from_meta(meta PhpClassMeta) PhpClass {
	return PhpClass{
		name: meta.name
		meta: meta
	}
}

pub fn PhpClass.find(name string) ?PhpClass {
	if !class_exists(name) {
		return none
	}
	return PhpClass.named(name)
}

pub fn (c PhpClass) name() string {
	return c.name
}

pub fn (c PhpClass) to_zval() ZVal {
	return ZVal.new_string(c.name())
}

pub fn (c PhpClass) exists() bool {
	res := PhpFunction.named('class_exists').call_zval([ZVal.new_string(c.name()),
		ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
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

pub fn (c PhpClass) construct_zval(args []ZVal) ZVal {
	return c.to_zval().construct(args)
}

pub fn (c PhpClass) construct_owned_request_zval(args []ZVal) ZVal {
	return c.to_zval().construct_owned_request(args)
}

pub fn (c PhpClass) construct_owned_persistent_zval(args []ZVal) ZVal {
	return c.to_zval().construct_owned_persistent(args)
}

pub fn (c PhpClass) construct_request_owned_zval(args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(c.construct_owned_request_zval(args))
}

pub fn (c PhpClass) construct(args ...PhpFnArg) !PhpObject {
	result := c.construct_owned_request_zval(php_fn_args_to_zvals(args))
	return PhpObject.must_from_zval(result)
}

pub fn (c PhpClass) with_object[R](run fn (PhpObject) R, args ...PhpFnArg) !R {
	mut result := c.construct_owned_request_zval(php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	obj := PhpObject.must_from_zval(result)!
	return run(obj)
}

pub fn (c PhpClass) static_method_zval(method string, args []ZVal) ZVal {
	return c.to_zval().static_method(method, args)
}

pub fn (c PhpClass) static_method_owned_request_zval(method string, args []ZVal) ZVal {
	return c.to_zval().static_method_owned_request(method, args)
}

pub fn (c PhpClass) static_method_owned_persistent_zval(method string, args []ZVal) ZVal {
	return c.to_zval().static_method_owned_persistent(method, args)
}

pub fn (c PhpClass) static_method_request_owned(method string, args ...PhpFnArg) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(c.static_method_owned_request_zval(method, php_fn_args_to_zvals(args)))
}

pub fn (c PhpClass) static_method[T](method string, args ...PhpFnArg) !T {
	mut result := c.static_method_owned_request_zval(method, php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	return php_fn_copied_result_as[T](result)
}

pub fn (c PhpClass) with_static_method_result[T, R](method string, run fn (T) R, args ...PhpFnArg) !R {
	mut result := c.static_method_owned_request_zval(method, php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	value := php_fn_result_as[T](result)!
	return run(value)
}

pub fn (c PhpClass) static_prop_zval(name string) ZVal {
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

pub fn (c PhpClass) static_prop[T](name string) !T {
	mut result := c.static_prop_owned_request(name)
	defer {
		result.release()
	}
	return php_fn_copied_result_as[T](result)
}

pub fn (c PhpClass) with_static_prop_result[T, R](name string, run fn (T) R) !R {
	mut result := c.static_prop_owned_request(name)
	defer {
		result.release()
	}
	value := php_fn_result_as[T](result)!
	return run(value)
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

pub fn (c PhpClass) const_value[T](name string) !T {
	mut result := c.const_owned_request(name)
	defer {
		result.release()
	}
	return php_fn_copied_result_as[T](result)
}

pub fn (c PhpClass) with_const_result[T, R](name string, run fn (T) R) !R {
	mut result := c.const_owned_request(name)
	defer {
		result.release()
	}
	value := php_fn_result_as[T](result)!
	return run(value)
}
