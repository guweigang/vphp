module vphp

pub fn (v PersistentOwnedZBox) is_valid() bool {
	match v.kind {
		.dyn_data {
			return true
		}
		.retained_callable {
			return v.retained_callable.is_valid()
		}
		.retained_object {
			return v.retained.is_valid()
		}
		.fallback_zval {
			return v.z.is_valid()
		}
	}
}

pub fn (v PersistentOwnedZBox) kind_name() string {
	return match v.kind {
		.fallback_zval { 'fallback_zval' }
		.dyn_data { 'dyn_data' }
		.retained_callable { 'retained_callable' }
		.retained_object { 'retained_object' }
	}
}

pub fn (v PersistentOwnedZBox) is_null() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type == .null_
		}
		.retained_callable {
			return false
		}
		.retained_object {
			return false
		}
		.fallback_zval {
			return v.z.is_null()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_undef() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_callable {
			return false
		}
		.retained_object {
			return false
		}
		.fallback_zval {
			return v.z.is_undef()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_resource() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_callable {
			return false
		}
		.retained_object {
			return false
		}
		.fallback_zval {
			return v.z.is_resource()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_callable() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_callable {
			return true
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return false }
	defer {
		temp.release()
	}
	return temp.is_callable()
}

pub fn (v PersistentOwnedZBox) is_object() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_callable {
			return v.retained_callable.is_object_like()
		}
		.retained_object {
			return true
		}
		.fallback_zval {
			return v.z.is_object()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_string() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type == .string_
		}
		.retained_callable {
			return v.retained_callable.is_string_like()
		}
		.retained_object {
			return false
		}
		.fallback_zval {
			return v.z.is_string()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_array() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type in [.list_, .map_]
		}
		.retained_callable {
			return v.retained_callable.is_array_like()
		}
		.retained_object {
			return false
		}
		.fallback_zval {
			return v.z.is_array()
		}
	}
}

pub fn (v PersistentOwnedZBox) method_exists(name string) bool {
	match v.kind {
		.dyn_data {
			return false
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return false }
	defer {
		temp.release()
	}
	return temp.method_exists(name)
}

pub fn (v PersistentOwnedZBox) to_string() string {
	match v.kind {
		.dyn_data {
			return dyn_to_string(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return '' }
	defer {
		temp.release()
	}
	return temp.to_string()
}

pub fn (v PersistentOwnedZBox) to_string_list() []string {
	match v.kind {
		.dyn_data {
			return dyn_to_string_list(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return []string{} }
	defer {
		temp.release()
	}
	return temp.to_string_list()
}

pub fn (v PersistentOwnedZBox) to_string_map() map[string]string {
	match v.kind {
		.dyn_data {
			return dyn_to_string_map(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return map[string]string{} }
	defer {
		temp.release()
	}
	return temp.to_string_map()
}

pub fn (v PersistentOwnedZBox) resource_type() ?string {
	match v.kind {
		.dyn_data {
			return none
		}
		.retained_callable {
			return none
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return none }
	defer {
		temp.release()
	}
	return temp.resource_type()
}

pub fn (v PersistentOwnedZBox) stream_metadata() ?StreamMetadata {
	match v.kind {
		.dyn_data {
			return none
		}
		.retained_callable {
			return none
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return none }
	defer {
		temp.release()
	}
	return temp.stream_metadata()
}

pub fn (v PersistentOwnedZBox) to_bool() bool {
	match v.kind {
		.dyn_data {
			return dyn_to_bool(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return false }
	defer {
		temp.release()
	}
	return temp.to_bool()
}

pub fn (v PersistentOwnedZBox) to_int() int {
	match v.kind {
		.dyn_data {
			return dyn_to_int(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return 0 }
	defer {
		temp.release()
	}
	return temp.to_int()
}

pub fn (v PersistentOwnedZBox) to_i64() i64 {
	match v.kind {
		.dyn_data {
			return dyn_to_i64(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return i64(0) }
	defer {
		temp.release()
	}
	return temp.to_i64()
}

pub fn (v PersistentOwnedZBox) to_f64() f64 {
	match v.kind {
		.dyn_data {
			return dyn_to_f64(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return f64(0.0) }
	defer {
		temp.release()
	}
	return temp.to_f64()
}

pub fn (v PersistentOwnedZBox) call_owned_request(args []ZVal) ZVal {
	match v.kind {
		.dyn_data {
			return invalid_zval()
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return invalid_zval() }
	defer {
		temp.release()
	}
	return temp.call_owned_request(args)
}

pub fn (v PersistentOwnedZBox) method_owned_request(method string, args []ZVal) ZVal {
	match v.kind {
		.dyn_data {
			return invalid_zval()
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return invalid_zval() }
	defer {
		temp.release()
	}
	return temp.method_owned_request(method, args)
}
