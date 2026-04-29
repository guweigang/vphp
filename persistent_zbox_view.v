module vphp

pub fn (v PersistentOwnedZBox) method_exists(name string) bool {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.method_exists(name)
}

pub fn (v PersistentOwnedZBox) to_string() string {
	match v.kind {
		.dyn_data {
			return v.dyn_data.to_string()
		}
		else {}
	}
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.to_string()
}

pub fn (v PersistentOwnedZBox) to_string_list() []string {
	match v.kind {
		.dyn_data {
			return v.dyn_data.to_string_list()
		}
		else {}
	}
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.to_string_list()
}

pub fn (v PersistentOwnedZBox) to_string_map() map[string]string {
	match v.kind {
		.dyn_data {
			return v.dyn_data.to_string_map()
		}
		else {}
	}
	mut temp := v.clone_request_owned()
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
		else {}
	}
	mut temp := v.clone_request_owned()
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
		else {}
	}
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.stream_metadata()
}

pub fn (v PersistentOwnedZBox) to_bool() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.to_bool()
		}
		else {}
	}
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.to_bool()
}

pub fn (v PersistentOwnedZBox) to_int() int {
	match v.kind {
		.dyn_data {
			return v.dyn_data.to_int()
		}
		else {}
	}
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.to_int()
}

pub fn (v PersistentOwnedZBox) to_i64() i64 {
	match v.kind {
		.dyn_data {
			return v.dyn_data.to_i64()
		}
		else {}
	}
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.to_i64()
}

pub fn (v PersistentOwnedZBox) to_f64() f64 {
	match v.kind {
		.dyn_data {
			return v.dyn_data.to_f64()
		}
		else {}
	}
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.to_f64()
}

pub fn (v PersistentOwnedZBox) call_owned_request(args []ZVal) ZVal {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.call_owned_request(args)
}

pub fn (v PersistentOwnedZBox) method_owned_request(method string, args []ZVal) ZVal {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return temp.method_owned_request(method, args)
}
