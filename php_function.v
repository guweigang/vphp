module vphp

// PHP function entry. Return a callable ZVal for `.call(args)`.
pub fn php_fn(name string) ZVal {
	return PhpFunction.named(name).to_zval()
}

pub fn function_exists(name string) bool {
	return PhpFunction.named(name).exists()
}
