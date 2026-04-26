module vphp

__global (
	vphp_persistent_fallback_zval_count int
)

fn persistent_fallback_zval_count() int {
	unsafe {
		return vphp_persistent_fallback_zval_count
	}
}

fn persistent_fallback_zval_inc() {
	unsafe {
		vphp_persistent_fallback_zval_count++
	}
}

fn persistent_fallback_zval_dec() {
	unsafe {
		if vphp_persistent_fallback_zval_count > 0 {
			vphp_persistent_fallback_zval_count--
		}
	}
}

pub fn stringify_value(value ZVal) string {
	if !value.is_valid() || value.is_null() || value.is_undef() {
		return ''
	}
	if value.is_string() || value.is_bool() || value.is_long() || value.is_double() {
		return value.to_string()
	}
	if value.is_array() {
		encoded := json_encode(value)
		if json_last_error_code() == 0 {
			return encoded
		}
		return '[array]'
	}
	if value.is_object() {
		if value.method_exists('__toString') {
			return with_method_result_zval(value, '__toString', []ZVal{}, fn (raw ZVal) string {
				return raw.to_string()
			})
		}
		encoded := json_encode(value)
		if json_last_error_code() == 0 {
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

// RequestScope gives a structured, nestable request arena on top of
// autorelease marks. It is intentionally tiny and can be used with `defer`.
pub struct RequestScope {
pub:
	mark int
mut:
	active bool
}

pub fn request_scope() RequestScope {
	return RequestScope{
		mark:   request_scope_enter()
		active: true
	}
}

pub fn (mut s RequestScope) close() {
	if !s.active {
		return
	}
	request_scope_leave(s.mark)
	s.active = false
}

// with_request_scope is the recommended structured entry point for framework
// dispatch paths and middleware chains.
pub fn with_request_scope[T](run fn () T) T {
	mut s := request_scope()
	defer {
		s.close()
	}
	return run()
}
