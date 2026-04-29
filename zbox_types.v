module vphp

// OwnershipKind is explicit by design: every bridge value is either borrowed
// from Zend, or owned by the current runtime scope.
pub enum OwnershipKind {
	borrowed
	owned_request
	owned_persistent
}

// ZValView defines read-only inspection/conversion surface for typed wrappers.
pub interface ZValView {
	to_zval() ZVal
	is_valid() bool
	is_null() bool
	is_undef() bool
	is_resource() bool
	is_callable() bool
	is_object() bool
	is_string() bool
	is_array() bool
	method_exists(name string) bool
	to_string() string
	to_string_list() []string
	to_string_map() map[string]string
	resource_type() ?string
	stream_metadata() ?StreamMetadata
	to_bool() bool
	to_int() int
	to_i64() i64
	to_f64() f64
}

// ZValInvoke defines callable/method invocation without changing ownership.
pub interface ZValInvoke {
	call_owned_request(args []ZVal) ZVal
	method_owned_request(method string, args []ZVal) ZVal
}

// ZValOwnership is only for owned wrappers.
pub interface ZValOwnership {
	borrowed() RequestBorrowedZBox
	clone_request_owned() RequestOwnedZBox
	clone() PersistentOwnedZBox
mut:
	release()
}

// They all wrap ZVal, but encode lifetime in type-level API.
pub struct RequestBorrowedZBox {
	ZValViewState
}

pub struct RequestOwnedZBox {
	ZValViewState
}

pub enum PersistentOwnedKind {
	fallback_zval
	dyn_data
}

pub enum RetainedCallableKind {
	invalid
	string_name
	static_method
	object_method
	invokable_object
}

pub struct RetainedCallable {
pub mut:
	kind   RetainedCallableKind = .invalid
	name   string
	method string
	object RetainedObject
}

pub struct PersistentOwnedZBox {
	ZValViewState
pub mut:
	kind     PersistentOwnedKind = .fallback_zval
	dyn_data DynValue
}
