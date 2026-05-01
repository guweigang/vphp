module vphp

pub struct PhpObject {
mut:
	value PhpValueZBox
}

pub fn PhpObject.from_zval(z ZVal) ?PhpObject {
	if !z.is_object() {
		return none
	}
	return PhpObject{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpObject.borrowed(z ZVal) PhpObject {
	return PhpObject{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpObject.must_from_zval(z ZVal) !PhpObject {
	obj := PhpObject.from_zval(z) or { return error('zval is not object') }
	return obj
}

pub fn PhpObject.from_request_owned_zbox(value RequestOwnedZBox) ?PhpObject {
	if !value.is_object() {
		return none
	}
	return PhpObject{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpObject.current() ?PhpObject {
	z := PhpObject.current_request_owned_zval()
	if !z.is_valid() {
		return none
	}
	return PhpObject.from_zval(z)
}

pub fn PhpObject.current_request_owned_zval() ZVal {
	unsafe {
		obj_raw := C.vphp_get_current_this_object()
		if obj_raw == 0 {
			return invalid_zval()
		}
		mut out := C.vphp_new_zval()
		if out == 0 {
			return invalid_zval()
		}
		C.vphp_wrap_existing_object(out, &C.zend_object(obj_raw))
		return adopt_raw_with_ownership(out, .owned_request)
	}
}

pub fn (o PhpObject) to_zval() ZVal {
	return o.value.to_zval()
}

pub fn (o PhpObject) borrowed_view() PhpObject {
	return o.to_borrowed()
}

pub fn (o PhpObject) to_borrowed() PhpObject {
	return PhpObject{
		value: o.value.borrowed()
	}
}

pub fn (o PhpObject) to_borrowed_zbox() RequestBorrowedZBox {
	return o.value.to_borrowed_zbox()
}

pub fn (o PhpObject) to_request_owned() PhpObject {
	return PhpObject.from_request_owned_zbox(o.value.to_request_owned_zbox()) or { o.to_borrowed() }
}

pub fn (o PhpObject) to_request_owned_zbox() RequestOwnedZBox {
	return o.value.to_request_owned_zbox()
}

pub fn (mut o PhpObject) take_zval() ZVal {
	return o.value.take_zval()
}

pub fn PhpObject.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpObject {
	if !value.is_object() {
		return none
	}
	return PhpObject{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpObject.from_persistent_zval(z ZVal) ?PhpObject {
	return PhpObject.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (o PhpObject) to_persistent_owned() PhpObject {
	return PhpObject.from_persistent_owned_zbox(o.value.to_persistent_owned_zbox()) or {
		o.to_borrowed()
	}
}

pub fn (o PhpObject) to_persistent_owned_zbox() PersistentOwnedZBox {
	return o.value.to_persistent_owned_zbox()
}

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

pub fn (o PhpObject) method_zval(method string, args []ZVal) ZVal {
	return o.value.with_request_object[ZVal](fn [method, args] (obj PhpObject) ZVal {
		return obj.to_zval().method(method, args)
	}) or { invalid_zval() }
}

pub fn (o PhpObject) method_owned_request(method string, args []ZVal) ZVal {
	return o.value.with_request_object[ZVal](fn [method, args] (obj PhpObject) ZVal {
		return obj.to_zval().method_owned_request(method, args)
	}) or { invalid_zval() }
}

pub fn (o PhpObject) method_owned_persistent(method string, args []ZVal) ZVal {
	return o.value.with_request_object[ZVal](fn [method, args] (obj PhpObject) ZVal {
		return obj.to_zval().method_owned_persistent(method, args)
	}) or { invalid_zval() }
}

pub fn (o PhpObject) method_request_owned_zval(method string, args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(o.method_owned_request(method, args))
}

pub fn (o PhpObject) method_request_owned(method string, args ...PhpFnArg) RequestOwnedZBox {
	return o.method_request_owned_zval(method, php_fn_args_to_zvals(args))
}

pub fn (o PhpObject) method[T](method string, args ...PhpFnArg) !T {
	mut result := o.method_owned_request(method, php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	return php_fn_copied_result_as[T](result)
}

pub fn (o PhpObject) with_method_result[T, R](method string, run fn (T) R, args ...PhpFnArg) !R {
	mut result := o.method_owned_request(method, php_fn_args_to_zvals(args))
	defer {
		result.release()
	}
	value := php_fn_result_as[T](result)!
	return run(value)
}

pub fn (o PhpObject) with_method_result_zval[T](method string, run fn (ZVal) T, args ...ZVal) T {
	mut result := o.method_owned_request(method, args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn (o PhpObject) prop(name string) ZVal {
	return o.to_zval().prop(name)
}

pub fn (o PhpObject) prop_borrowed(name string) ZVal {
	return o.to_zval().prop_borrowed(name)
}

pub fn (o PhpObject) prop_owned_request(name string) ZVal {
	return o.to_zval().prop_owned_request(name)
}

pub fn (o PhpObject) prop_owned_persistent(name string) ZVal {
	return o.to_zval().prop_owned_persistent(name)
}

pub fn (o PhpObject) set_prop(name string, value ZVal) {
	o.to_zval().set_prop(name, value)
}

pub fn (o PhpObject) has_prop(name string) bool {
	return o.to_zval().has_prop(name)
}

pub fn (o PhpObject) isset_prop(name string) bool {
	return o.to_zval().isset_prop(name)
}

pub fn (o PhpObject) unset_prop(name string) {
	o.to_zval().unset_prop(name)
}

pub fn (o PhpObject) method_v[T](method string, args []ZVal) !T {
	return o.method_zval(method, args).to_v[T]()
}

pub fn (o PhpObject) prop_v[T](name string) !T {
	return o.prop(name).to_v[T]()
}

pub fn (o PhpObject) kind_name() string {
	return o.value.kind_name()
}

pub fn (o PhpObject) is_valid() bool {
	return o.value.is_valid()
}

pub fn (o PhpObject) clone() PhpObject {
	return PhpObject{
		value: o.value.clone()
	}
}

pub fn (o PhpObject) clone_request_owned() RequestOwnedZBox {
	return o.to_request_owned_zbox()
}

pub fn (o PhpObject) with_object[T](run fn (PhpObject) T) T {
	mut temp := o.clone_request_owned()
	defer {
		temp.release()
	}
	obj := PhpObject{
		value: PhpValueZBox.borrowed(temp.borrowed())
	}
	return run(obj)
}

pub fn (mut o PhpObject) release() {
	o.value.release()
}
