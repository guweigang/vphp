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
