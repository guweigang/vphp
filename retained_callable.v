module vphp

pub fn RetainedCallable.invalid() RetainedCallable {
	return RetainedCallable{}
}

pub fn RetainedCallable.from_zval(z ZVal) ?RetainedCallable {
	if !z.is_valid() || !z.is_callable() {
		return none
	}
	if z.is_object() {
		retained := RetainedObject.from_zval(z) or { return none }
		return RetainedCallable{
			kind:   .invokable_object
			object: retained
		}
	}
	if z.is_string() {
		return RetainedCallable{
			kind: .string_name
			name: z.to_string()
		}
	}
	if z.is_array() && z.array_count() >= 2 {
		target := z.array_get(0)
		method := z.array_get(1).to_string()
		if method == '' {
			return none
		}
		if target.is_object() {
			retained := RetainedObject.from_zval(target) or { return none }
			return RetainedCallable{
				kind:   .object_method
				method: method
				object: retained
			}
		}
		if target.is_string() {
			return RetainedCallable{
				kind:   .static_method
				name:   target.to_string()
				method: method
			}
		}
	}
	return none
}

pub fn (r RetainedCallable) is_valid() bool {
	return r.kind != .invalid
}

pub fn (r RetainedCallable) is_object_like() bool {
	return r.kind == .invokable_object
}

pub fn (r RetainedCallable) is_string_like() bool {
	return r.kind == .string_name
}

pub fn (r RetainedCallable) is_array_like() bool {
	return r.kind in [.static_method, .object_method]
}

pub fn (r RetainedCallable) clone() RetainedCallable {
	return RetainedCallable{
		kind:   r.kind
		name:   r.name.clone()
		method: r.method.clone()
		object: r.object.clone()
	}
}

pub fn (r RetainedCallable) to_request_owned_zval() ZVal {
	match r.kind {
		.string_name {
			mut out := RequestOwnedZBox.new_string(r.name)
			return out.take_zval()
		}
		.static_method {
			mut out := ZVal.new_null()
			out.array_init()
			out.add_next_val(ZVal.new_string(r.name))
			out.add_next_val(ZVal.new_string(r.method))
			return out
		}
		.object_method {
			mut out := ZVal.new_null()
			out.array_init()
			out.add_next_val(r.object.to_request_owned_zval())
			out.add_next_val(ZVal.new_string(r.method))
			return out
		}
		.invokable_object {
			return r.object.to_request_owned_zval()
		}
		.invalid {
			return invalid_zval()
		}
	}
}

pub fn (mut r RetainedCallable) release() {
	r.name = ''
	r.method = ''
	mut object := r.object
	object.release()
	r.object = RetainedObject.invalid()
	r.kind = .invalid
}
