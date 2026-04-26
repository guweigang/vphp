module vphp

// PHP class entry. Return a class-string ZVal for construct/static/const calls.
pub fn php_class(name string) ZVal {
	return ZVal.new_string(name)
}

pub fn class_exists(name string) bool {
	res := php_fn('class_exists').call([ZVal.new_string(name),
		ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}

pub fn interface_exists(name string) bool {
	res := php_fn('interface_exists').call([ZVal.new_string(name),
		ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}

pub fn trait_exists(name string) bool {
	res := php_fn('trait_exists').call([ZVal.new_string(name),
		ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}
