module vphp

import vphp.zend

pub enum PHPType {
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
