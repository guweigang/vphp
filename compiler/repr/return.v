module repr

pub struct PhpReturnRepr {
pub:
	v_type   string
	php_type string
}

pub fn new_return_repr(v_type string, php_type string) PhpReturnRepr {
	return PhpReturnRepr{
		v_type:   v_type
		php_type: php_type
	}
}

pub fn (s PhpReturnRepr) effective_v_type() string {
	if s.v_type == '' {
		return 'void'
	}
	return s.v_type
}
