module vphp

pub struct PhpJson {}

pub fn PhpJson.encode(value ZVal) string {
	return PhpJson.encode_with_flags(value, 0)
}

pub fn PhpJson.encode_with_flags(value ZVal, flags int) string {
	return PhpFunction.named('json_encode').result_string(PhpValue.from_zval(value), PhpInt.of(flags))
}

pub fn PhpJson.decode_assoc(raw string) ZVal {
	mut result := PhpFunction.named('json_decode').request_owned(PhpString.of(raw), PhpBool.of(true))
	return result.take_zval()
}

pub fn PhpJson.last_error_code() int {
	return int(PhpFunction.named('json_last_error').result_i64())
}

pub fn PhpJson.last_error_message() string {
	return PhpFunction.named('json_last_error_msg').result_string()
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
