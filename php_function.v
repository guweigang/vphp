module vphp

// PHP function entry. Return a callable ZVal for `.call(args)`.
pub fn php_fn(name string) ZVal {
	return ZVal.new_string(name)
}

pub fn function_exists(name string) bool {
	res := php_fn('function_exists').call([ZVal.new_string(name)])
	return res.is_valid() && res.to_bool()
}

// Compatibility entry point for direct PHP function calls.
// Prefer with_php_call_result_zval()/php_call_request_owned_box() in new code so
// request-owned results stay behind an explicit ownership boundary.
pub fn call_php(name string, args []ZVal) ZVal {
	return php_fn(name).call(args)
}
