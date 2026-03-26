module repr

pub struct PhpEnumRepr {
pub mut:
	name      string
	php_name  string
	cases     []PhpEnumCase
	parse_err string
}

pub struct PhpEnumCase {
pub:
	name  string
	value string
}

pub fn (r PhpEnumRepr) c_name() string {
	return r.php_name.replace('\\', '_')
}

pub fn new_enum_repr() &PhpEnumRepr {
	return &PhpEnumRepr{}
}
