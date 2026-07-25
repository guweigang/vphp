module vphp

pub fn (v PersistentOwnedZBox) borrowed() RequestBorrowedZBox {
	match v.kind {
		.dyn_data {
			return v.clone_request_owned().borrowed()
		}
		.fallback_zval {
			return RequestBorrowedZBox.from_handle(v.z.handle())
		}
	}
}

pub fn (v PersistentOwnedZBox) clone_request_owned() RequestOwnedZBox {
	match v.kind {
		.dyn_data {
			return v.dyn_data.request_owned()
		}
		.fallback_zval {
			return RequestOwnedZBox.from_handle(v.z.handle())
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

pub fn (v PersistentOwnedZBox) with_request_value[T](run fn (PhpValue) T) T {
	return v.with_request_zval[T](fn [run] [T](z ZVal) T {
		return run(PhpValue.from_zval(z))
	})
}

pub fn (v PersistentOwnedZBox) with_request_array[T](run fn (PhpArray) T) ?T {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	arr := PhpArray.from_zval(temp.to_zval()) or { return none }
	return run(arr)
}

pub fn (v PersistentOwnedZBox) with_request_object[T](run fn (PhpObject) T) ?T {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	obj := PhpObject.from_zval(temp.to_zval()) or { return none }
	return run(obj)
}

fn (v PersistentOwnedZBox) fn_request_owned_zval(args []ZVal) RequestOwnedZBox {
	return v.with_request_zval(fn [args] (callable ZVal) RequestOwnedZBox {
		return RequestOwnedZBox.adopt_zval(callable.call_owned_request(args))
	})
}

fn (v PersistentOwnedZBox) fn_request_owned(args ...PhpArgInput) RequestOwnedZBox {
	return v.fn_request_owned_zval(php_arg_inputs_to_zvals(args))
}

fn (v PersistentOwnedZBox) method_request_owned_zval(method string, args []ZVal) RequestOwnedZBox {
	return v.with_request_zval(fn [method, args] (receiver ZVal) RequestOwnedZBox {
		return RequestOwnedZBox.adopt_zval(receiver.method_owned_request(method, args))
	})
}

fn (v PersistentOwnedZBox) method_request_owned(method string, args ...PhpArgInput) RequestOwnedZBox {
	return v.method_request_owned_zval(method, php_arg_inputs_to_zvals(args))
}

pub fn (v PersistentOwnedZBox) with_fn_result[T, R](run fn (T) R, args ...PhpArgInput) !R {
	mut result := v.fn_request_owned(args)
	defer {
		result.release()
	}
	value := php_call_result_as[T](result.to_zval())!
	return run(value)
}

pub fn (v PersistentOwnedZBox) with_method_result[T, R](method string, run fn (T) R, args ...PhpArgInput) !R {
	mut result := v.method_request_owned(method, args)
	defer {
		result.release()
	}
	value := php_call_result_as[T](result.to_zval())!
	return run(value)
}

// with_fn_result_zval keeps PHP callable result ownership inside the callback
// scope so callers don't have to manually release transient return zvals.
pub fn (v PersistentOwnedZBox) with_fn_result_zval[T](run fn (ZVal) T, args ...ZVal) T {
	mut result := v.fn_request_owned_zval(args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

// with_method_result_zval mirrors with_fn_result_zval for object method dispatch.
pub fn (v PersistentOwnedZBox) with_method_result_zval[T](method string, run fn (ZVal) T, args ...ZVal) T {
	mut result := v.method_request_owned_zval(method, args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

pub fn (mut v PersistentOwnedZBox) release() {
	match v.kind {
		.dyn_data {
			v.dyn_data.release()
			v.dyn_data = DynValue.null()
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
			return PersistentOwnedZBox.from_dyn(v.dyn_data.clone())
		}
		.fallback_zval {
			return PersistentOwnedZBox.from_persistent_zval(v.z)
		}
	}
}

pub fn (v PersistentOwnedZBox) to_zval() ZVal {
	match v.kind {
		.dyn_data {
			mut temp := v.dyn_data.request_owned()
			return temp.take_zval()
		}
		.fallback_zval {
			return v.z
		}
	}
}
