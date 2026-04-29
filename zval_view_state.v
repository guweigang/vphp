module vphp

// ZValViewState carries the shared safe/read-only API surface.
// Ownership wrappers embed it so extension code gets the common methods
// without inheriting the full low-level ZVal lifecycle API directly.
pub struct ZValViewState {
pub mut:
	z ZVal
}

pub fn (v ZValViewState) to_zval() ZVal {
	return v.z
}

pub fn (v ZValViewState) is_valid() bool {
	return v.z.is_valid()
}

pub fn (v ZValViewState) is_null() bool {
	return v.z.is_null()
}

pub fn (v ZValViewState) is_undef() bool {
	return v.z.is_undef()
}

pub fn (v ZValViewState) is_resource() bool {
	return v.z.is_resource()
}

pub fn (v ZValViewState) is_callable() bool {
	return v.z.is_callable()
}

pub fn (v ZValViewState) is_object() bool {
	return v.z.is_object()
}

pub fn (v ZValViewState) is_string() bool {
	return v.z.is_string()
}

pub fn (v ZValViewState) is_array() bool {
	return v.z.is_array()
}

pub fn (v ZValViewState) method_exists(name string) bool {
	return v.z.method_exists(name)
}

pub fn (v ZValViewState) to_string() string {
	return v.z.to_string()
}

pub fn (v ZValViewState) to_string_list() []string {
	return v.z.to_string_list()
}

pub fn (v ZValViewState) to_string_map() map[string]string {
	return v.z.to_string_map()
}

pub fn (v ZValViewState) resource_type() ?string {
	return v.z.resource_type()
}

pub fn (v ZValViewState) stream_metadata() ?StreamMetadata {
	return v.z.stream_metadata()
}

pub fn (v ZValViewState) to_bool() bool {
	return v.z.to_bool()
}

pub fn (v ZValViewState) to_int() int {
	return v.z.to_int()
}

pub fn (v ZValViewState) to_i64() i64 {
	return v.z.to_i64()
}

pub fn (v ZValViewState) to_f64() f64 {
	return v.z.to_f64()
}

pub fn (v ZValViewState) to_v[T]() !T {
	return v.z.to_v[T]()
}

pub fn (v ZValViewState) call_owned_request(args []ZVal) ZVal {
	return v.z.call_owned_request(args)
}

pub fn (v ZValViewState) method_owned_request(method string, args []ZVal) ZVal {
	return v.z.method_owned_request(method, args)
}
