module vphp

pub fn (v DynValue) clone() DynValue {
	return match v.type {
		.null_ {
			DynValue.null()
		}
		.bool_ {
			DynValue.of_bool(v.bool_value())
		}
		.int_ {
			DynValue.of_int(v.int_value())
		}
		.float_ {
			DynValue.of_float(v.float_value())
		}
		.string_ {
			DynValue.of_string(v.string_value())
		}
		.list_ {
			mut out := []DynValue{cap: v.list.len}
			for item in v.list {
				out << item.clone()
			}
			DynValue.of_list(out)
		}
		.map_ {
			mut out := map[string]DynValue{}
			for key, item in v.map {
				out[key] = item.clone()
			}
			DynValue.of_map(out)
		}
		.object_ref {
			v.clone_runtime_ref()
		}
		.callable_ref {
			v.clone_runtime_ref()
		}
		.resource_ref {
			v.clone_runtime_ref()
		}
	}
}

fn (v DynValue) clone_runtime_ref() DynValue {
	return match v.runtime_lifecycle {
		.request {
			DynValue{
				type:              v.type
				runtime_lifecycle: .request
				runtime_ref:       DynRuntimeRefData{
					request: ?RequestBorrowedZBox(v.request_ref() or {
						return DynValue{
							type: v.type
						}
					})
				}
			}
		}
		.persistent {
			match v.type {
				.object_ref {
					ref := v.retained_object_ref()

					DynValue{
						type:              v.type
						runtime_lifecycle: .persistent
						runtime_ref:       DynRuntimeRefData{
							object: ref.clone()
						}
					}
				}
				.callable_ref {
					ref := v.retained_callable_ref()

					DynValue{
						type:              v.type
						runtime_lifecycle: .persistent
						runtime_ref:       DynRuntimeRefData{
							callable: ref.clone()
						}
					}
				}
				else {
					DynValue{
						type: v.type
					}
				}
			}
		}
		.detached {
			DynValue{
				type: v.type
			}
		}
	}
}

fn (v DynValue) request_ref() ?RequestBorrowedZBox {
	runtime_ref := v.runtime_ref or { return none }
	request := unsafe { runtime_ref.request }
	return request
}

fn (v DynValue) retained_object_ref() RetainedObject {
	runtime_ref := v.runtime_ref or { return RetainedObject.invalid() }
	return unsafe { runtime_ref.object }
}

fn (v DynValue) retained_callable_ref() RetainedCallable {
	runtime_ref := v.runtime_ref or { return RetainedCallable.invalid() }
	return unsafe { runtime_ref.callable }
}

pub fn (mut v DynValue) release() {
	match v.type {
		.list_ {
			for i in 0 .. v.list.len {
				v.list[i].release()
			}
			v.list = []DynValue{}
		}
		.map_ {
			for _, item in v.map {
				item.release_runtime_refs()
			}
			v.map = map[string]DynValue{}
		}
		.object_ref, .callable_ref, .resource_ref {
			if v.runtime_lifecycle == .persistent && v.type == .object_ref {
				mut retained := v.retained_object_ref()
				retained.release()
			}
			if v.runtime_lifecycle == .persistent && v.type == .callable_ref {
				mut retained := v.retained_callable_ref()
				retained.release()
			}
			v.runtime_lifecycle = .detached
			v.runtime_ref = none
		}
		else {}
	}

	v.type = .null_
	v.str = ''
}

fn (v DynValue) release_runtime_refs() {
	match v.type {
		.list_ {
			for item in v.list {
				item.release_runtime_refs()
			}
		}
		.map_ {
			for _, item in v.map {
				item.release_runtime_refs()
			}
		}
		.object_ref {
			if v.runtime_lifecycle == .persistent {
				mut retained := v.retained_object_ref()
				retained.release()
			}
		}
		.callable_ref {
			if v.runtime_lifecycle == .persistent {
				mut retained := v.retained_callable_ref()
				retained.release()
			}
		}
		else {}
	}
}

pub fn (v DynValue) bool_value() bool {
	return unsafe { v.data.b }
}

pub fn (v DynValue) int_value() i64 {
	return unsafe { v.data.i }
}

pub fn (v DynValue) float_value() f64 {
	return unsafe { v.data.f }
}

pub fn (v DynValue) string_value() string {
	return v.str
}

pub fn (v DynValue) is_runtime_ref() bool {
	return v.type in [.object_ref, .callable_ref, .resource_ref]
}

pub fn (v DynValue) has_runtime_refs() bool {
	return match v.type {
		.object_ref, .callable_ref, .resource_ref {
			true
		}
		.list_ {
			for item in v.list {
				if item.has_runtime_refs() {
					return true
				}
			}
			false
		}
		.map_ {
			for _, item in v.map {
				if item.has_runtime_refs() {
					return true
				}
			}
			false
		}
		else {
			false
		}
	}
}

pub fn (v DynValue) is_detached() bool {
	return !v.has_runtime_refs()
}

pub fn (v DynValue) can_new_zval() bool {
	return v.is_detached()
}

pub fn (v DynValue) as_object() ?PhpObject {
	if v.type != .object_ref {
		return none
	}
	if v.runtime_lifecycle != .request {
		return none
	}
	ref := v.request_ref() or { return none }
	return PhpObject.from_zval(ref.to_zval())
}

pub fn (v DynValue) as_callable() ?PhpCallable {
	if v.type != .callable_ref {
		return none
	}
	if v.runtime_lifecycle != .request {
		return none
	}
	ref := v.request_ref() or { return none }
	return PhpCallable.from_zval(ref.to_zval())
}

pub fn (v DynValue) as_closure() ?PhpClosure {
	if v.type != .callable_ref {
		return none
	}
	if v.runtime_lifecycle != .request {
		return none
	}
	ref := v.request_ref() or { return none }
	return PhpClosure.from_zval(ref.to_zval())
}

pub fn (v DynValue) as_resource() ?PhpResource {
	if v.type != .resource_ref {
		return none
	}
	if v.runtime_lifecycle != .request {
		return none
	}
	ref := v.request_ref() or { return none }
	return PhpResource.from_zval(ref.to_zval())
}

pub fn (v DynValue) as_persistent_object() ?PhpObject {
	if v.type != .object_ref {
		return none
	}
	if v.runtime_lifecycle == .persistent {
		ref := v.retained_object_ref()
		if !ref.is_valid() {
			return none
		}
		return PhpObject.from_persistent_owned_zbox(DynValue.persistent_owned_zbox(ref.clone()))
	}
	ref := v.request_ref() or { return none }
	return PhpObject.from_persistent_owned_zbox(PersistentOwnedZBox.of_object(ref.to_zval()))
}

pub fn (v DynValue) as_persistent_closure() ?PhpClosure {
	if v.type != .callable_ref {
		return none
	}
	if v.runtime_lifecycle == .persistent {
		ref := v.retained_callable_ref()
		if !ref.is_valid() {
			return none
		}
		return PhpClosure.from_persistent_owned_zbox(DynValue.persistent_owned_zbox(ref.clone()))
	}
	ref := v.request_ref() or { return none }
	return PhpClosure.from_persistent_owned_zbox(PersistentOwnedZBox.of_callable(ref.to_zval()))
}

pub fn (v DynValue) with_object[T](run fn (PhpObject) T) ?T {
	if v.type != .object_ref {
		return none
	}
	if v.runtime_lifecycle == .request {
		obj := v.as_object() or { return none }
		return run(obj)
	}
	ref := v.retained_object_ref()
	if !ref.is_valid() {
		return none
	}
	mut temp := ref.to_request_owned_zval()
	defer {
		temp.release()
	}
	obj := PhpObject.must_from_zval(temp) or { return none }
	return run(obj)
}

pub fn (v DynValue) with_callable[T](run fn (PhpCallable) T) ?T {
	if v.type != .callable_ref {
		return none
	}
	if v.runtime_lifecycle == .request {
		callable := v.as_callable() or { return none }
		return run(callable)
	}
	ref := v.retained_callable_ref()
	if !ref.is_valid() {
		return none
	}
	mut temp := ref.to_request_owned_zval()
	defer {
		temp.release()
	}
	callable := PhpCallable.must_from_zval(temp) or { return none }
	return run(callable)
}

pub fn (v DynValue) with_closure[T](run fn (PhpClosure) T) ?T {
	if v.type != .callable_ref {
		return none
	}
	if v.runtime_lifecycle == .request {
		closure := v.as_closure() or { return none }
		return run(closure)
	}
	ref := v.retained_callable_ref()
	if !ref.is_valid() {
		return none
	}
	mut temp := ref.to_request_owned_zval()
	defer {
		temp.release()
	}
	closure := PhpClosure.must_from_zval(temp) or { return none }
	return run(closure)
}

pub fn (v DynValue) with_runtime_zval[T](run fn (ZVal) T) ?T {
	if !v.is_runtime_ref() {
		return none
	}
	if v.runtime_lifecycle == .request {
		ref := v.request_ref() or { return none }
		return run(ref.to_zval())
	}
	match v.type {
		.object_ref {
			ref := v.retained_object_ref()
			mut temp := ref.to_request_owned_zval()
			defer {
				temp.release()
			}
			return run(temp)
		}
		.callable_ref {
			ref := v.retained_callable_ref()
			mut temp := ref.to_request_owned_zval()
			defer {
				temp.release()
			}
			return run(temp)
		}
		else {
			return none
		}
	}
}

pub fn (v DynValue) to_persistent_owned_zbox() !PersistentOwnedZBox {
	return match v.type {
		.object_ref {
			if v.runtime_lifecycle == .persistent {
				ref := v.retained_object_ref()
				return DynValue.persistent_owned_zbox(ref.clone())
			}
			ref := v.request_ref() or { return error('object_ref is no longer valid') }
			PersistentOwnedZBox.of_object(ref.to_zval())
		}
		.callable_ref {
			if v.runtime_lifecycle == .persistent {
				ref := v.retained_callable_ref()
				return DynValue.persistent_owned_zbox(ref.clone())
			}
			ref := v.request_ref() or { return error('callable_ref is no longer valid') }
			PersistentOwnedZBox.of_callable(ref.to_zval())
		}
		.resource_ref {
			error('resource_ref cannot be made persistent')
		}
		else {
			if !v.can_new_zval() {
				return error('DynValue contains runtime refs that cannot be made persistent as data')
			}
			PersistentOwnedZBox.from_dyn(v.clone())
		}
	}
}

