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
	str               string
	list              []DynValue
	map               map[string]DynValue
	runtime_lifecycle DynRuntimeLifecycle
	runtime_ref       ?DynRuntimeRefData
}

pub fn DynValue.null() DynValue {
	return DynValue{
		type: .null_
	}
}

pub fn DynValue.of_bool(v bool) DynValue {
	return DynValue{
		type: .bool_
		data: DynValueData{
			b: v
		}
	}
}

pub fn DynValue.of_int(v i64) DynValue {
	return DynValue{
		type: .int_
		data: DynValueData{
			i: v
		}
	}
}

pub fn DynValue.of_float(v f64) DynValue {
	return DynValue{
		type: .float_
		data: DynValueData{
			f: v
		}
	}
}

pub fn DynValue.of_string(v string) DynValue {
	return DynValue{
		type: .string_
		str:  v.clone()
	}
}

pub fn DynValue.of_list(v []DynValue) DynValue {
	mut out := []DynValue{cap: v.len}
	for item in v {
		out << item.clone()
	}
	return DynValue{
		type: .list_
		list: out
	}
}

pub fn DynValue.of_map(v map[string]DynValue) DynValue {
	mut out := map[string]DynValue{}
	for key, item in v {
		out[key.clone()] = item.clone()
	}
	return DynValue{
		type: .map_
		map:  out
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

pub fn DynValue.persistent_object_ref(obj PhpObject) DynValue {
	retained := obj.value.with_request_zval[RetainedObject](fn (z ZVal) RetainedObject {
		return RetainedObject.from_zval(z) or { RetainedObject.invalid() }
	})
	return DynValue.retained_object(retained)
}

pub fn DynValue.retained_object(retained RetainedObject) DynValue {
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

pub fn DynValue.persistent_closure_ref(closure PhpClosure) DynValue {
	retained := closure.callable.with_request_zval[RetainedCallable](fn (z ZVal) RetainedCallable {
		return RetainedCallable.from_zval(z) or { RetainedCallable.invalid() }
	})
	return DynValue.retained_callable(retained)
}

pub fn DynValue.retained_callable(retained RetainedCallable) DynValue {
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
