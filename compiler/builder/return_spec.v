module builder

pub struct ReturnSpec {
pub:
	return_type     string
	php_return_type string
	return_obj_type string
}

pub fn new_return_spec(return_type string, php_return_type string, return_obj_type string) ReturnSpec {
	return ReturnSpec{
		return_type:     return_type
		php_return_type: php_return_type
		return_obj_type: return_obj_type
	}
}

pub fn (s ReturnSpec) resolved_type() string {
	if s.php_return_type != '' {
		return s.php_return_type
	}
	return s.return_type
}

pub fn (s ReturnSpec) arginfo_obj_type() string {
	if s.php_return_type != '' {
		return ''
	}
	return s.return_obj_type
}
