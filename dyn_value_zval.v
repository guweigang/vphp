module vphp

// from_zval detaches a ZVal into a plain dynamic value tree.
pub fn DynValue.from_zval(z ZVal) !DynValue {
	if !z.is_valid() || z.is_null() || z.is_undef() {
		return DynValue.null()
	}
	if z.is_bool() {
		return DynValue.of_bool(z.to_bool())
	}
	if z.is_long() {
		return DynValue.of_int(z.to_i64())
	}
	if z.is_double() {
		return DynValue.of_float(z.to_f64())
	}
	if z.is_string() {
		return DynValue.of_string(z.to_string())
	}
	if z.is_array() {
		mut out := map[string]DynValue{}
		mut err_msg := ''
		z.foreach_with_ctx[voidptr](unsafe { &mut out }, fn [mut err_msg] (key ZVal, v ZVal, mut ctx voidptr) {
			if err_msg != '' {
				return
			}
			m := unsafe { &MapDynValue(ctx) }
			decoded := DynValue.from_zval(v) or {
				err_msg = err.msg()
				return
			}
			(*m)[key.to_string()] = decoded
		})
		if err_msg != '' {
			return error(err_msg)
		}
		return DynValue.of_map(out)
	}
	if z.is_callable() {
		callable := PhpCallable.from_zval(z) or { return error('zval is not callable') }
		return DynValue.callable_ref(callable)
	}
	if z.is_object() {
		obj := PhpObject.from_zval(z) or { return error('zval is not object') }
		return DynValue.object_ref(obj)
	}
	if z.is_resource() {
		res := PhpResource.from_zval(z) or { return error('zval is not resource') }
		return DynValue.resource_ref(res)
	}
	return error('unsupported zval type: ${z.type_name()}')
}

pub fn DynValue.from_persistent_zval(z ZVal) !DynValue {
	if !z.is_valid() || z.is_null() || z.is_undef() || z.is_bool() || z.is_long() || z.is_double()
		|| z.is_string() || z.is_array() {
		return DynValue.from_zval(z)
	}
	if z.is_callable() {
		closure := PhpClosure.from_persistent_owned_zbox(PersistentOwnedZBox.of_callable(z)) or {
			return error('zval is not callable')
		}
		return DynValue.persistent_closure_ref(closure)
	}
	if z.is_object() {
		obj := PhpObject.from_persistent_owned_zbox(PersistentOwnedZBox.of_object(z)) or {
			return error('zval is not object')
		}
		return DynValue.persistent_object_ref(obj)
	}
	if z.is_resource() {
		return error('resource_ref cannot be made persistent')
	}
	return error('unsupported zval type: ${z.type_name()}')
}

// to_zval writes a detached dynamic value tree back into an existing ZVal.
pub fn (v DynValue) to_zval(mut out ZVal) ! {
	match v.type {
		.null_ {
			out.set_null()
		}
		.bool_ {
			unsafe {
				out.set_bool(v.data.b)
			}
		}
		.int_ {
			unsafe {
				out.set_int(v.data.i)
			}
		}
		.float_ {
			unsafe {
				out.set_double(v.data.f)
			}
		}
		.string_ {
			out.set_string(v.str)
		}
		.list_ {
			out.array_init()
			for item in v.list {
				out.add_next_dyn_value(item)!
			}
		}
		.map_ {
			out.array_init()
			for k, item in v.map {
				out.add_assoc_dyn_value(k, item)!
			}
		}
		.object_ref {
			v.runtime_ref_to_zval(mut out)!
		}
		.callable_ref {
			v.runtime_ref_to_zval(mut out)!
		}
		.resource_ref {
			if v.runtime_lifecycle == .persistent {
				return error('resource_ref cannot be persistent')
			}
			v.runtime_ref_to_zval(mut out)!
		}
	}
}

fn (v DynValue) runtime_ref_to_zval(mut out ZVal) ! {
	match v.runtime_lifecycle {
		.request {
			ref := v.request_ref() or { return error('runtime ref is no longer valid') }
			if !ref.is_valid() {
				return error('runtime ref is no longer valid')
			}
			out.copy_from(ref.to_zval())
		}
		.persistent {
			mut temp := match v.type {
				.object_ref {
					ref := v.retained_object_ref()

					ref.to_request_owned_zval()
				}
				.callable_ref {
					ref := v.retained_callable_ref()

					ref.to_request_owned_zval()
				}
				else {
					return error('persistent runtime ref is no longer valid')
				}
			}

			defer {
				temp.release()
			}
			out.copy_from(temp)
		}
		.detached {
			return error('runtime ref is no longer valid')
		}
	}
}

pub fn (v DynValue) new_zval() !ZVal {
	framework_debug_log('dyn_value.new_zval enter type=${v.type}')
	if !v.can_new_zval() {
		return error('DynValue.new_zval only supports detached data')
	}
	mut out := ZVal.new_request()
	RequestScope.autorelease_add_handle(out.handle())
	framework_debug_log('dyn_value.new_zval allocated raw=${usize(out.raw_ptr())}')
	v.to_zval(mut out)!
	framework_debug_log('dyn_value.new_zval exit raw=${usize(out.raw_ptr())} valid=${out.is_valid()} type=${out.type_name()}')
	return out
}

pub fn (v DynValue) to_value() !PhpValue {
	return PhpValue.adopt_zval(v.new_zval()!)
}
