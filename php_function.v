module vphp

// PHP function entry. Return a callable ZVal for `.call(args)`.
pub fn php_fn(name string) ZVal {
	return PhpFunction.named(name).to_zval()
}

pub fn function_exists(name string) bool {
	return PhpFunction.named(name).exists()
}

// Direct PHP function call by name.
// Prefer php_call_result_string/bool/i64/double, PhpFunction.with_result_zval(),
// or PhpFunction.request_owned_box() in new code so request-owned results stay scoped.
pub fn call_php_fn(name string, args []ZVal) ZVal {
	return PhpFunction.named(name).call(args)
}
