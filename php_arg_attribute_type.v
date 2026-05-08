module vphp

pub struct PhpArgAttributeItem {
pub:
	kind  string
	name  string
	value string
}

pub struct PhpArgAttribute {
pub:
	name string
pub mut:
	args []PhpArgAttributeItem
}

pub fn PhpArgAttribute.named(name string) PhpArgAttribute {
	return PhpArgAttribute{
		name: name
	}
}

pub fn (attr PhpArgAttribute) string(value string) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind:  'string'
		value: value
	}
	return next
}

pub fn (attr PhpArgAttribute) int(value int) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind:  'int'
		value: value.str()
	}
	return next
}

pub fn (attr PhpArgAttribute) i64(value i64) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind:  'int'
		value: value.str()
	}
	return next
}

pub fn (attr PhpArgAttribute) f64(value f64) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind:  'float'
		value: value.str()
	}
	return next
}

pub fn (attr PhpArgAttribute) bool_value(value bool) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind:  'bool'
		value: value.str()
	}
	return next
}

pub fn (attr PhpArgAttribute) null_value() PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind: 'null'
	}
	return next
}

pub fn (attr PhpArgAttribute) named_string(name string, value string) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind:  'string'
		name:  name
		value: value
	}
	return next
}

pub fn (attr PhpArgAttribute) named_int(name string, value int) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind:  'int'
		name:  name
		value: value.str()
	}
	return next
}

pub fn (attr PhpArgAttribute) named_i64(name string, value i64) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind:  'int'
		name:  name
		value: value.str()
	}
	return next
}

pub fn (attr PhpArgAttribute) named_f64(name string, value f64) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind:  'float'
		name:  name
		value: value.str()
	}
	return next
}

pub fn (attr PhpArgAttribute) named_bool(name string, value bool) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind:  'bool'
		name:  name
		value: value.str()
	}
	return next
}

pub fn (attr PhpArgAttribute) named_null(name string) PhpArgAttribute {
	mut next := attr
	next.args << PhpArgAttributeItem{
		kind: 'null'
		name: name
	}
	return next
}
