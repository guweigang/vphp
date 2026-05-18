module vphp

pub fn (o PhpObject) prop(name string) ZVal {
	return o.to_zval().prop(name)
}

pub fn (o PhpObject) prop_borrowed(name string) ZVal {
	return o.to_zval().prop_borrowed(name)
}

pub fn (o PhpObject) prop_owned_request(name string) ZVal {
	return o.to_zval().prop_owned_request(name)
}

pub fn (o PhpObject) prop_value(name string) PhpValue {
	return PhpValue.adopt_zval(o.prop_owned_request(name))
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

pub fn (o PhpObject) prop_v[T](name string) !T {
	return o.prop(name).to_v[T]()
}
