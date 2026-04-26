module vphp

type MapDynValue = map[string]DynValue

pub enum DynValueType {
	null_
	bool_
	int_
	float_
	string_
	list_
	map_
	object_ref
	callable_ref
	resource_ref
}

// DynRuntimeLifecycle describes the Zend lifetime attached to runtime refs.
// `.detached` means this DynValue has no active Zend ref; scalar/list/map data
// is owned by V, and released runtime refs return to this state.
pub enum DynRuntimeLifecycle {
	detached
	request
	persistent
}

pub union DynValueData {
	b bool
	i i64
	f f64
	s string
}

pub union DynRuntimeRefData {
	request  ?RequestBorrowedZBox
	object   RetainedObject
	callable RetainedCallable
}

// DynValue is a V-side mixed value for unknown PHP payloads.
// Scalars, lists, and maps are detached data; object/callable/resource leaves
// are runtime refs exposed through semantic wrappers.
pub struct DynValue {
pub mut:
	type              DynValueType
	data              DynValueData
	list              []DynValue
	map               map[string]DynValue
	runtime_lifecycle DynRuntimeLifecycle
	runtime_ref       ?DynRuntimeRefData
}

pub fn dyn_value_null() DynValue {
	return DynValue{
		type: .null_
	}
}

pub fn dyn_value_bool(v bool) DynValue {
	return DynValue{
		type: .bool_
		data: DynValueData{
			b: v
		}
	}
}

pub fn dyn_value_int(v i64) DynValue {
	return DynValue{
		type: .int_
		data: DynValueData{
			i: v
		}
	}
}

pub fn dyn_value_float(v f64) DynValue {
	return DynValue{
		type: .float_
		data: DynValueData{
			f: v
		}
	}
}

pub fn dyn_value_string(v string) DynValue {
	return DynValue{
		type: .string_
		data: DynValueData{
			s: v
		}
	}
}

pub fn dyn_value_list(v []DynValue) DynValue {
	return DynValue{
		type: .list_
		list: v
	}
}

pub fn dyn_value_map(v map[string]DynValue) DynValue {
	return DynValue{
		type: .map_
		map:  v
	}
}

pub fn DynValue.object_ref(obj PhpObject) DynValue {
	return DynValue{
		type:              .object_ref
		runtime_lifecycle: .request
		runtime_ref:       DynRuntimeRefData{
			request: ?RequestBorrowedZBox(RequestBorrowedZBox.from_zval(obj.to_zval()))
		}
	}
}

pub fn DynValue.persistent_object_ref(obj PersistentPhpObject) DynValue {
	retained := obj.value.with_request_zval(fn (z ZVal) RetainedObject {
		return RetainedObject.from_zval(z) or { RetainedObject.invalid() }
	})
	return dyn_value_persistent_retained_object(retained)
}

fn dyn_value_persistent_retained_object(retained RetainedObject) DynValue {
	return DynValue{
		type:              .object_ref
		runtime_lifecycle: .persistent
		runtime_ref:       DynRuntimeRefData{
			object: retained
		}
	}
}

pub fn DynValue.callable_ref(callable PhpCallable) DynValue {
	return DynValue{
		type:              .callable_ref
		runtime_lifecycle: .request
		runtime_ref:       DynRuntimeRefData{
			request: ?RequestBorrowedZBox(RequestBorrowedZBox.from_zval(callable.to_zval()))
		}
	}
}

pub fn DynValue.closure_ref(closure PhpClosure) DynValue {
	return DynValue.callable_ref(PhpCallable.from_zval(closure.to_zval()) or {
		panic('closure_ref requires callable zval')
	})
}

pub fn DynValue.persistent_closure_ref(closure PersistentPhpClosure) DynValue {
	retained := closure.callable.with_request_zval(fn (z ZVal) RetainedCallable {
		return RetainedCallable.from_zval(z) or { RetainedCallable.invalid() }
	})
	return dyn_value_persistent_retained_callable(retained)
}

fn dyn_value_persistent_retained_callable(retained RetainedCallable) DynValue {
	return DynValue{
		type:              .callable_ref
		runtime_lifecycle: .persistent
		runtime_ref:       DynRuntimeRefData{
			callable: retained
		}
	}
}

pub fn DynValue.resource_ref(res PhpResource) DynValue {
	return DynValue{
		type:              .resource_ref
		runtime_lifecycle: .request
		runtime_ref:       DynRuntimeRefData{
			request: ?RequestBorrowedZBox(RequestBorrowedZBox.from_zval(res.to_zval()))
		}
	}
}

pub fn (v DynValue) clone() DynValue {
	return match v.type {
		.null_ {
			dyn_value_null()
		}
		.bool_ {
			dyn_value_bool(v.bool_value())
		}
		.int_ {
			dyn_value_int(v.int_value())
		}
		.float_ {
			dyn_value_float(v.float_value())
		}
		.string_ {
			dyn_value_string(v.string_value())
		}
		.list_ {
			mut out := []DynValue{cap: v.list.len}
			for item in v.list {
				out << item.clone()
			}
			dyn_value_list(out)
		}
		.map_ {
			mut out := map[string]DynValue{}
			for key, item in v.map {
				out[key] = item.clone()
			}
			dyn_value_map(out)
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
					ref := v.retained_object()

					DynValue{
						type:              v.type
						runtime_lifecycle: .persistent
						runtime_ref:       DynRuntimeRefData{
							object: ref.clone()
						}
					}
				}
				.callable_ref {
					ref := v.retained_call()

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

fn (v DynValue) retained_object() RetainedObject {
	runtime_ref := v.runtime_ref or { return RetainedObject.invalid() }
	return unsafe { runtime_ref.object }
}

fn (v DynValue) retained_call() RetainedCallable {
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
			for key, _ in v.map {
				mut item := v.map[key] or { continue }
				item.release()
				v.map[key] = dyn_value_null()
			}
			v.map = map[string]DynValue{}
		}
		.object_ref, .callable_ref, .resource_ref {
			if v.runtime_lifecycle == .persistent && v.type == .object_ref {
				mut retained := v.retained_object()
				retained.release()
			}
			if v.runtime_lifecycle == .persistent && v.type == .callable_ref {
				mut retained := v.retained_call()
				retained.release()
			}
			v.runtime_lifecycle = .detached
			v.runtime_ref = none
		}
		else {}
	}
	v.type = .null_
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
	return unsafe { v.data.s }
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

pub fn (v DynValue) as_persistent_object() ?PersistentPhpObject {
	if v.type != .object_ref {
		return none
	}
	if v.runtime_lifecycle == .persistent {
		ref := v.retained_object()
		if !ref.is_valid() {
			return none
		}
		return PersistentPhpObject{
			value: persistent_owned_dyn_box(dyn_value_persistent_retained_object(ref.clone()))
		}
	}
	ref := v.request_ref() or { return none }
	return PersistentPhpObject.from_zval(ref.to_zval())
}

pub fn (v DynValue) as_persistent_closure() ?PersistentPhpClosure {
	if v.type != .callable_ref {
		return none
	}
	if v.runtime_lifecycle == .persistent {
		ref := v.retained_call()
		if !ref.is_valid() {
			return none
		}
		return PersistentPhpClosure{
			callable: persistent_owned_dyn_box(dyn_value_persistent_retained_callable(ref.clone()))
		}
	}
	ref := v.request_ref() or { return none }
	return PersistentPhpClosure.from_zval(ref.to_zval())
}

pub fn (v DynValue) with_object[T](run fn (PhpObject) T) ?T {
	if v.type != .object_ref {
		return none
	}
	if v.runtime_lifecycle == .request {
		obj := v.as_object() or { return none }
		return run(obj)
	}
	ref := v.retained_object()
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
	ref := v.retained_call()
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
	ref := v.retained_call()
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
			ref := v.retained_object()
			mut temp := ref.to_request_owned_zval()
			defer {
				temp.release()
			}
			return run(temp)
		}
		.callable_ref {
			ref := v.retained_call()
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

pub fn (v DynValue) to_persistent() !PersistentOwnedZBox {
	return match v.type {
		.object_ref {
			if v.runtime_lifecycle == .persistent {
				ref := v.retained_object()
				return persistent_owned_dyn_box(dyn_value_persistent_retained_object(ref.clone()))
			}
			ref := v.request_ref() or { return error('object_ref is no longer valid') }
			PersistentOwnedZBox.of_object(ref.to_zval())
		}
		.callable_ref {
			if v.runtime_lifecycle == .persistent {
				ref := v.retained_call()
				return persistent_owned_dyn_box(dyn_value_persistent_retained_callable(ref.clone()))
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

// from_zval detaches a ZVal into a plain dynamic value tree.
pub fn DynValue.from_zval(z ZVal) !DynValue {
	if !z.is_valid() || z.is_null() || z.is_undef() {
		return dyn_value_null()
	}
	if z.is_bool() {
		return dyn_value_bool(z.to_bool())
	}
	if z.is_long() {
		return dyn_value_int(z.to_i64())
	}
	if z.is_double() {
		return dyn_value_float(z.to_f64())
	}
	if z.is_string() {
		return dyn_value_string(z.to_string())
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
		return dyn_value_map(out)
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
		closure := PersistentPhpClosure.from_zval(z) or { return error('zval is not callable') }
		return DynValue.persistent_closure_ref(closure)
	}
	if z.is_object() {
		obj := PersistentPhpObject.from_zval(z) or { return error('zval is not object') }
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
			unsafe {
				out.set_string(v.data.s)
			}
		}
		.list_ {
			out.array_init()
			for item in v.list {
				mut sub_raw := C.zval{}
				mut sub := ZVal{
					raw: &sub_raw
				}
				item.to_zval(mut sub)!
				out.add_next_val(sub)
			}
		}
		.map_ {
			out.array_init()
			for k, item in v.map {
				mut sub_raw := C.zval{}
				mut sub := ZVal{
					raw: &sub_raw
				}
				item.to_zval(mut sub)!
				C.vphp_array_add_assoc_zval(out.raw, &char(k.str), sub.raw)
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
			unsafe { C.ZVAL_COPY(out.raw, ref.to_zval().raw) }
		}
		.persistent {
			mut temp := match v.type {
				.object_ref {
					ref := v.retained_object()

					ref.to_request_owned_zval()
				}
				.callable_ref {
					ref := v.retained_call()

					ref.to_request_owned_zval()
				}
				else {
					return error('persistent runtime ref is no longer valid')
				}
			}
			defer {
				temp.release()
			}
			unsafe { C.ZVAL_COPY(out.raw, temp.raw) }
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
	mut out := ZVal{
		raw:   C.vphp_new_zval()
		owned: true
	}
	autorelease_add(out.raw)
	framework_debug_log('dyn_value.new_zval allocated raw=${usize(out.raw)}')
	v.to_zval(mut out)!
	framework_debug_log('dyn_value.new_zval exit raw=${usize(out.raw)} valid=${out.is_valid()} type=${out.type_name()}')
	return out
}
