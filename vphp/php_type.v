module vphp

import vphp.zend

pub enum PHPType {
	unknown   = -1
	undef     = zend.is_undef
	null      = zend.is_null
	false_    = zend.is_false
	true_     = zend.is_true
	long      = zend.is_long
	double    = zend.is_double
	string    = zend.is_string
	array     = zend.is_array
	object    = zend.is_object
	resource  = zend.is_resource
	reference = zend.is_reference
}

pub fn php_type_from_id(id int) PHPType {
	return match id {
		zend.is_undef { .undef }
		zend.is_null { .null }
		zend.is_false { .false_ }
		zend.is_true { .true_ }
		zend.is_long { .long }
		zend.is_double { .double }
		zend.is_string { .string }
		zend.is_array { .array }
		zend.is_object { .object }
		zend.is_resource { .resource }
		zend.is_reference { .reference }
		else { .unknown }
	}
}

pub fn (t PHPType) name() string {
	return match t {
		.unknown { 'unknown' }
		.undef { 'undefined' }
		.null { 'null' }
		.false_, .true_ { 'boolean' }
		.long { 'integer' }
		.double { 'float' }
		.string { 'string' }
		.array { 'array' }
		.object { 'object' }
		.resource { 'resource' }
		.reference { 'reference' }
	}
}

pub fn (t PHPType) is_bool() bool {
	return t == .false_ || t == .true_
}

pub fn (t PHPType) is_numeric() bool {
	return t == .long || t == .double
}
