module vphp

// from_result_void maps a V `!` return to PHP exception/null semantics.
pub fn (ret PhpReturn) from_result_void(f fn () !) {
	f() or {
		throw_exception(err.msg(), 0)
		return
	}
}

// from_result maps a V `!T` return to PHP exception/value semantics.
pub fn (ret PhpReturn) from_result[T](f fn () !T) {
	res := f() or {
		throw_exception(err.msg(), 0)
		return
	}
	ret.v[T](res)
}

// from_option_void maps a V `?` return to PHP null semantics.
pub fn (ret PhpReturn) from_option_void(f fn () ?) {
	f() or {
		ret.null()
		return
	}
}

// from_option maps a V `?T` return to PHP null/value semantics.
pub fn (ret PhpReturn) from_option[T](f fn () ?T) {
	res := f() or {
		ret.null()
		return
	}
	ret.v[T](res)
}
