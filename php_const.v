module vphp

// PHP constant entry. Return the constant value itself.
pub fn php_const(name string) ZVal {
	return php_fn('constant').call([ZVal.new_string(name)])
}

pub fn global_const_exists(name string) bool {
	res := php_fn('defined').call([ZVal.new_string(name)])
	return res.is_valid() && res.to_bool()
}
