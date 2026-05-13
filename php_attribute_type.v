module vphp

pub enum PhpAttributeTarget {
	unknown
	class_
	function_
	method
	property
	class_constant
	parameter
	constant
	all
}

pub struct PhpAttributeItem {
pub:
	kind  string
	name  string
	value string
}

pub struct PhpAttribute {
pub:
	name   string
	target PhpAttributeTarget
pub mut:
	items []PhpAttributeItem
}

pub fn PhpAttribute.named(name string) PhpAttribute {
	return PhpAttribute{
		name: name
	}
}

pub fn (attr PhpAttribute) for_target(target PhpAttributeTarget) PhpAttribute {
	return PhpAttribute{
		name:   attr.name
		target: target
		items:  attr.items.clone()
	}
}

pub fn (attr PhpAttribute) for_class() PhpAttribute {
	return attr.for_target(.class_)
}

pub fn (attr PhpAttribute) for_function() PhpAttribute {
	return attr.for_target(.function_)
}

pub fn (attr PhpAttribute) for_method() PhpAttribute {
	return attr.for_target(.method)
}

pub fn (attr PhpAttribute) for_property() PhpAttribute {
	return attr.for_target(.property)
}

pub fn (attr PhpAttribute) for_class_constant() PhpAttribute {
	return attr.for_target(.class_constant)
}

pub fn (attr PhpAttribute) for_parameter() PhpAttribute {
	return attr.for_target(.parameter)
}

pub fn (attr PhpAttribute) for_constant() PhpAttribute {
	return attr.for_target(.constant)
}

pub fn (attr PhpAttribute) for_all_targets() PhpAttribute {
	return attr.for_target(.all)
}

pub fn (attr PhpAttribute) string(value string) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind:  'string'
		value: value
	}
	return next
}

pub fn (attr PhpAttribute) int(value int) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind:  'int'
		value: value.str()
	}
	return next
}

pub fn (attr PhpAttribute) i64(value i64) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind:  'int'
		value: value.str()
	}
	return next
}

pub fn (attr PhpAttribute) f64(value f64) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind:  'float'
		value: value.str()
	}
	return next
}

pub fn (attr PhpAttribute) bool_value(value bool) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind:  'bool'
		value: value.str()
	}
	return next
}

pub fn (attr PhpAttribute) null_value() PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind: 'null'
	}
	return next
}

pub fn (attr PhpAttribute) named_string(name string, value string) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind:  'string'
		name:  name
		value: value
	}
	return next
}

pub fn (attr PhpAttribute) named_int(name string, value int) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind:  'int'
		name:  name
		value: value.str()
	}
	return next
}

pub fn (attr PhpAttribute) named_i64(name string, value i64) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind:  'int'
		name:  name
		value: value.str()
	}
	return next
}

pub fn (attr PhpAttribute) named_f64(name string, value f64) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind:  'float'
		name:  name
		value: value.str()
	}
	return next
}

pub fn (attr PhpAttribute) named_bool(name string, value bool) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind:  'bool'
		name:  name
		value: value.str()
	}
	return next
}

pub fn (attr PhpAttribute) named_null(name string) PhpAttribute {
	mut next := attr
	next.items << PhpAttributeItem{
		kind: 'null'
		name: name
	}
	return next
}
