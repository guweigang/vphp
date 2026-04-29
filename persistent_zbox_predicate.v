module vphp

pub fn (v PersistentOwnedZBox) is_valid() bool {
	match v.kind {
		.dyn_data {
			if !v.dyn_data.is_runtime_ref() {
				return true
			}
			return v.dyn_data.with_runtime_zval(fn (z ZVal) bool {
				return z.is_valid()
			}) or { false }
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
	}
}

pub fn (v PersistentOwnedZBox) is_null() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type == .null_
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
		.fallback_zval {
			return v.z.is_resource()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_callable() bool {
	match v.kind {
		.dyn_data {
			if v.dyn_data.type == .callable_ref {
				return true
			}
		}
		else {}
	}
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.is_callable()
}

pub fn (v PersistentOwnedZBox) is_object() bool {
	match v.kind {
		.dyn_data {
			if v.dyn_data.type == .object_ref {
				return true
			}
		}
		.fallback_zval {
			return v.z.is_object()
		}
	}
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.is_object()
}

pub fn (v PersistentOwnedZBox) is_string() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type == .string_
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
		.fallback_zval {
			return v.z.is_array()
		}
	}
}
