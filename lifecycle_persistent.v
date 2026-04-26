module vphp

fn (v PersistentOwnedZBox) request_owned_non_dyn() ?RequestOwnedZBox {
	return match v.kind {
		.retained_callable { retained_callable_request_owned(v.retained_callable) }
		.retained_object { retained_request_owned(v.retained) }
		.fallback_zval { own_request_zbox_raw(v.z) }
		.dyn_data { none }
	}
}

pub fn (v PersistentOwnedZBox) borrowed() RequestBorrowedZBox {
	match v.kind {
		.dyn_data {
			return v.clone_request_owned().borrowed()
		}
		.retained_callable {
			return v.clone_request_owned().borrowed()
		}
		.retained_object {
			return v.clone_request_owned().borrowed()
		}
		.fallback_zval {
			return borrow_zbox_raw(v.z)
		}
	}
}

pub fn (v PersistentOwnedZBox) clone_request_owned() RequestOwnedZBox {
	match v.kind {
		.dyn_data {
			return persistent_dyn_request_owned(v.dyn_data)
		}
		.retained_callable {
			return retained_callable_request_owned(v.retained_callable)
		}
		.retained_object {
			return retained_request_owned(v.retained)
		}
		.fallback_zval {
			return own_request_zbox_raw(v.z)
		}
	}
}

pub fn (v PersistentOwnedZBox) with_request_zval[T](run fn (ZVal) T) T {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return run(temp.to_zval())
}

pub fn (v PersistentOwnedZBox) call_request_owned(args []ZVal) RequestOwnedZBox {
	return v.with_request_zval(fn [args] (callable ZVal) RequestOwnedZBox {
		return RequestOwnedZBox.adopt_zval(callable.call_owned_request(args))
	})
}

pub fn (v PersistentOwnedZBox) method_request_owned(method string, args []ZVal) RequestOwnedZBox {
	return v.with_request_zval(fn [method, args] (receiver ZVal) RequestOwnedZBox {
		return RequestOwnedZBox.adopt_zval(receiver.method_owned_request(method, args))
	})
}

// with_call_result keeps PHP callable result ownership inside the callback
// scope so callers don't have to manually release transient return zvals.
pub fn (v PersistentOwnedZBox) with_call_result[T](args []ZVal, run fn (ZVal) T) T {
	mut result := v.call_request_owned(args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

// with_method_result mirrors with_call_result for object method dispatch.
pub fn (v PersistentOwnedZBox) with_method_result[T](method string, args []ZVal, run fn (ZVal) T) T {
	mut result := v.method_request_owned(method, args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

pub fn (mut v PersistentOwnedZBox) release() {
	match v.kind {
		.dyn_data {
			v.dyn_data = dyn_value_null()
			v.z = invalid_zval()
		}
		.retained_callable {
			mut retained := v.retained_callable
			retained.release()
			v.retained_callable = RetainedCallable.invalid()
			v.z = invalid_zval()
		}
		.retained_object {
			mut retained := v.retained
			retained.release()
			v.retained = RetainedObject.invalid()
			v.z = invalid_zval()
		}
		.fallback_zval {
			if v.z.is_valid() {
				persistent_fallback_zval_dec()
			}
			v.z.release()
		}
	}
	v.kind = .fallback_zval
}

pub fn (v PersistentOwnedZBox) clone() PersistentOwnedZBox {
	match v.kind {
		.dyn_data {
			return persistent_owned_dyn_box(v.dyn_data.clone())
		}
		.retained_callable {
			return persistent_owned_retained_callable_box(v.retained_callable.clone())
		}
		.retained_object {
			return persistent_owned_retained_object_box(v.retained.clone())
		}
		.fallback_zval {
			return PersistentOwnedZBox.from_persistent_zval(v.z)
		}
	}
}

pub fn (v PersistentOwnedZBox) to_zval() ZVal {
	match v.kind {
		.dyn_data {
			return v.dyn_data.new_zval() or { ZVal.new_null() }
		}
		.retained_callable {
			return v.retained_callable.to_request_owned_zval()
		}
		.retained_object {
			return v.retained.to_request_owned_zval()
		}
		.fallback_zval {
			return v.z
		}
	}
}
