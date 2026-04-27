module vphp

// PHP class entry. Return a class-string ZVal for construct/static/const calls.
pub fn php_class(name string) ZVal {
	return PhpClass.named(name).to_zval()
}

pub fn class_exists(name string) bool {
	return PhpClass.named(name).exists()
}

pub fn interface_exists(name string) bool {
	res := PhpFunction.named('interface_exists').call([ZVal.new_string(name),
		ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}

pub fn trait_exists(name string) bool {
	res := PhpFunction.named('trait_exists').call([ZVal.new_string(name),
		ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}
