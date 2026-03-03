module repr

pub struct PhpInterfaceRepr {
pub mut:
	name     string
	php_name string
	methods  []PhpMethodRepr
}

pub fn (r PhpInterfaceRepr) c_name() string {
	return r.php_name.replace('\\', '_')
}

pub fn new_interface_repr() &PhpInterfaceRepr {
	return &PhpInterfaceRepr{}
}
