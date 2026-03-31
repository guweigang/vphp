module repr

pub struct PhpReturnSpec {
pub:
	v_type   string
	php_type string
}

pub fn new_return_spec(v_type string, php_type string) PhpReturnSpec {
	return PhpReturnSpec{
		v_type:   v_type
		php_type: php_type
	}
}

pub fn (s PhpReturnSpec) effective_v_type() string {
	if s.v_type == '' {
		return 'void'
	}
	return s.v_type
}
