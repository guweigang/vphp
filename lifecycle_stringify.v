module vphp

pub fn stringify_value(value ZVal) string {
	return value.stringify()
}

pub fn (value ZVal) stringify() string {
	if !value.is_valid() || value.is_null() || value.is_undef() {
		return ''
	}
	if value.is_string() || value.is_bool() || value.is_long() || value.is_double() {
		return value.to_string()
	}
	if value.is_array() {
		encoded := PhpJson.encode(value)
		if PhpJson.last_error_code() == 0 {
			return encoded
		}
		return '[array]'
	}
	if value.is_object() {
		if value.method_exists('__toString') {
			return PhpObject.borrowed(value).with_method_result_zval('__toString', []ZVal{}, fn (raw ZVal) string {
				return raw.to_string()
			})
		}
		encoded := PhpJson.encode(value)
		if PhpJson.last_error_code() == 0 {
			return encoded
		}
		class_name := value.class_name().trim_space()
		if class_name != '' {
			return '[object ${class_name}]'
		}
		return '[object]'
	}
	if value.is_resource() {
		resource_type := value.resource_type() or { '' }
		if resource_type != '' {
			return '[resource ${resource_type}]'
		}
		return '[resource]'
	}
	type_name := value.type_name().trim_space()
	if type_name != '' {
		return '[${type_name}]'
	}
	return ''
}
