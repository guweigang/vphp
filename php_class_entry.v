module vphp

// PHP class entry. Return a class-string ZVal for construct/static/const calls.
pub fn php_class(name string) ZVal {
	return PhpClass.named(name).to_zval()
}

pub fn class_exists(name string) bool {
	return PhpClass.named(name).exists()
}

pub fn interface_exists(name string) bool {
	return PhpFunction.named('interface_exists').result_bool(PhpString.of(name), PhpBool.of(true))
}

pub fn trait_exists(name string) bool {
	return PhpFunction.named('trait_exists').result_bool(PhpString.of(name), PhpBool.of(true))
}
