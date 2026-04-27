module vphp

pub struct PhpJson {}

pub fn PhpJson.encode(value ZVal) string {
	return PhpJson.encode_with_flags(value, 0)
}

pub fn PhpJson.encode_with_flags(value ZVal, flags int) string {
	res := PhpFunction.named('json_encode').call([value, ZVal.new_int(flags)])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return ''
	}
	return res.to_string()
}

pub fn PhpJson.decode_assoc(raw string) ZVal {
	return PhpFunction.named('json_decode').call([ZVal.new_string(raw),
		ZVal.new_bool(true)])
}

pub fn PhpJson.last_error_code() int {
	res := PhpFunction.named('json_last_error').call([])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return 0
	}
	return int(res.to_i64())
}

pub fn PhpJson.last_error_message() string {
	res := PhpFunction.named('json_last_error_msg').call([])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return ''
	}
	return res.to_string()
}

pub fn json_encode(value ZVal) string {
	return PhpJson.encode(value)
}

pub fn json_encode_with_flags(value ZVal, flags int) string {
	return PhpJson.encode_with_flags(value, flags)
}

pub fn json_decode_assoc(raw string) ZVal {
	return PhpJson.decode_assoc(raw)
}

pub fn json_last_error_code() int {
	return PhpJson.last_error_code()
}

pub fn json_last_error_message() string {
	return PhpJson.last_error_message()
}
