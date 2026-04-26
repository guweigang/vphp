module vphp

pub fn json_encode(value ZVal) string {
	return json_encode_with_flags(value, 0)
}

pub fn json_encode_with_flags(value ZVal, flags int) string {
	res := php_fn('json_encode').call([value, ZVal.new_int(flags)])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return ''
	}
	return res.to_string()
}

pub fn json_decode_assoc(raw string) ZVal {
	return php_fn('json_decode').call([ZVal.new_string(raw), ZVal.new_bool(true)])
}

pub fn json_last_error_code() int {
	res := php_fn('json_last_error').call([])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return 0
	}
	return int(res.to_i64())
}

pub fn json_last_error_message() string {
	res := php_fn('json_last_error_msg').call([])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return ''
	}
	return res.to_string()
}
