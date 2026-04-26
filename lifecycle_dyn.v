module vphp

fn dyn_value_is_persistent_safe(value DynValue) bool {
	return match value.type {
		.null_, .bool_, .int_, .float_, .string_ {
			true
		}
		.list_ {
			for item in value.list {
				if !dyn_value_is_persistent_safe(item) {
					return false
				}
			}
			true
		}
		.map_ {
			for _, item in value.map {
				if !dyn_value_is_persistent_safe(item) {
					return false
				}
			}
			true
		}
		.object_ref, .resource_ref {
			false
		}
	}
}

fn persistent_dyn_request_owned(value DynValue) RequestOwnedZBox {
	return request_owned_zbox_from_adopted_zval(value.new_zval() or { ZVal.new_null() })
}

@[inline]
fn dyn_to_request_owned_box(value DynValue) RequestOwnedZBox {
	return persistent_dyn_request_owned(value)
}

fn dyn_to_string(value DynValue) string {
	return match value.type {
		.null_ {
			''
		}
		.bool_ {
			if value.bool_value() {
				'1'
			} else {
				''
			}
		}
		.int_ {
			value.int_value().str()
		}
		.float_ {
			value.float_value().str()
		}
		.string_ {
			value.string_value().clone()
		}
		else {
			mut temp := dyn_to_request_owned_box(value)
			defer {
				temp.release()
			}
			temp.to_string()
		}
	}
}

fn dyn_to_string_list(value DynValue) []string {
	return match value.type {
		.list_ {
			mut out := []string{}
			for item in value.list {
				out << dyn_to_string(item)
			}
			out
		}
		.string_ {
			[dyn_to_string(value)]
		}
		else {
			mut temp := dyn_to_request_owned_box(value)
			defer {
				temp.release()
			}
			temp.to_string_list()
		}
	}
}

fn dyn_to_string_map(value DynValue) map[string]string {
	return match value.type {
		.map_ {
			mut out := map[string]string{}
			for key, item in value.map {
				out[key] = dyn_to_string(item)
			}
			out
		}
		else {
			mut temp := dyn_to_request_owned_box(value)
			defer {
				temp.release()
			}
			temp.to_string_map()
		}
	}
}

fn dyn_to_bool(value DynValue) bool {
	return match value.type {
		.null_ { false }
		.bool_ { value.bool_value() }
		.int_ { value.int_value() != 0 }
		.float_ { value.float_value() != 0.0 }
		.string_ { value.string_value().len > 0 }
		.list_, .map_ { true }
		else { false }
	}
}

fn dyn_to_int(value DynValue) int {
	return match value.type {
		.int_ {
			int(value.int_value())
		}
		.bool_ {
			if value.bool_value() {
				1
			} else {
				0
			}
		}
		.float_ {
			int(value.float_value())
		}
		.string_ {
			dyn_to_string(value).int()
		}
		else {
			0
		}
	}
}

fn dyn_to_i64(value DynValue) i64 {
	return match value.type {
		.int_ {
			value.int_value()
		}
		.bool_ {
			if value.bool_value() {
				i64(1)
			} else {
				i64(0)
			}
		}
		.float_ {
			i64(value.float_value())
		}
		.string_ {
			dyn_to_string(value).i64()
		}
		else {
			i64(0)
		}
	}
}

fn dyn_to_f64(value DynValue) f64 {
	return match value.type {
		.float_ {
			value.float_value()
		}
		.int_ {
			f64(value.int_value())
		}
		.bool_ {
			if value.bool_value() {
				1.0
			} else {
				0.0
			}
		}
		.string_ {
			dyn_to_string(value).f64()
		}
		else {
			0.0
		}
	}
}
