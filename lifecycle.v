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
	borrowed() BorrowedZVal
	clone_request_owned() RequestOwnedZVal
	clone_persistent_owned() PersistentOwnedZVal
mut:
	release()
}

// --- New typed ownership wrappers ---
// ZValViewState carries the shared safe/read-only API surface.
// Ownership wrappers embed it so extension code gets the common methods
// without inheriting the full low-level ZVal lifecycle API directly.
pub struct ZValViewState {
pub mut:
	z ZVal
}

// They all wrap ZVal, but encode lifetime in type-level API.
pub struct BorrowedZVal {
	ZValViewState
}

pub struct RequestOwnedZVal {
	ZValViewState
}

pub enum PersistentOwnedKind {
	zval_data
	dyn_data
	string_data
	retained_object
}

pub struct PersistentOwnedZVal {
	ZValViewState
pub mut:
	kind        PersistentOwnedKind = .zval_data
	dyn_data    DynValue
	string_data string
	retained    RetainedObject
}

// Preferred public naming for ownership-aware Zend wrappers.
// Keep the old names as the implementation types for now so existing code stays
// source-compatible while new code can move to the clearer ZBox terminology.
pub type RequestBorrowedZBox = BorrowedZVal
pub type RequestOwnedZBox = RequestOwnedZVal
pub type PersistentOwnedZBox = PersistentOwnedZVal

pub fn borrow_zbox(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox.of(z)
}

pub fn own_request_zbox(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.of(z)
}

pub fn own_persistent_zbox(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.of(z)
}

pub fn borrow_zval(z ZVal) BorrowedZVal {
	return BorrowedZVal{
		ZValViewState: ZValViewState{
			z: z
		}
	}
}

pub fn BorrowedZVal.from_zval(z ZVal) BorrowedZVal {
	return borrow_zval(z)
}

pub fn BorrowedZVal.of(z ZVal) BorrowedZVal {
	return BorrowedZVal.from_zval(z)
}

// null borrowed helper for call-site ergonomics; lifetime is request-scoped.
pub fn BorrowedZVal.null() BorrowedZVal {
	return RequestOwnedZVal.new_null().borrowed()
}

pub fn own_request_zval(z ZVal) RequestOwnedZVal {
	return RequestOwnedZVal{
		ZValViewState: ZValViewState{
			z: z.dup()
		}
	}
}

pub fn RequestOwnedZVal.from_zval(z ZVal) RequestOwnedZVal {
	return own_request_zval(z)
}

pub fn RequestOwnedZVal.of(z ZVal) RequestOwnedZVal {
	return RequestOwnedZVal.from_zval(z)
}

pub fn RequestOwnedZVal.adopt_zval(z ZVal) RequestOwnedZVal {
	return RequestOwnedZVal{
		ZValViewState: ZValViewState{
			z: z
		}
	}
}

pub fn own_persistent_zval(z ZVal) PersistentOwnedZVal {
	if z.is_valid() && z.is_object() {
		if retained := RetainedObject.from_zval(z) {
			return PersistentOwnedZVal{
				ZValViewState: ZValViewState{
					z: invalid_zval()
				}
				kind:          .retained_object
				retained:      retained
			}
		}
	}
	if dyn := decode_dyn_value(z) {
		if dyn.type == .string_ {
			unsafe {
				return PersistentOwnedZVal{
					ZValViewState: ZValViewState{
						z: invalid_zval()
					}
					kind:          .string_data
					string_data:   dyn.data.s.clone()
				}
			}
		}
		return PersistentOwnedZVal{
			ZValViewState: ZValViewState{
				z: invalid_zval()
			}
			kind:          .dyn_data
			dyn_data:      dyn
		}
	}
	if z.is_valid() && z.is_string() {
		return PersistentOwnedZVal{
			ZValViewState: ZValViewState{
				z: invalid_zval()
			}
			kind:          .string_data
			string_data:   z.to_string()
		}
	}
	// Keep raw zval fallback as a narrow compatibility path only.
	// Safe long-lived values should prefer detached DynValue/string data or
	// retained object handles above.
	return PersistentOwnedZVal{
		ZValViewState: ZValViewState{
			z: z.dup_persistent()
		}
		kind:          .zval_data
	}
}

pub fn own_persistent_dyn(value DynValue) PersistentOwnedZVal {
	if value.type == .string_ {
		unsafe {
			return PersistentOwnedZVal{
				ZValViewState: ZValViewState{
					z: invalid_zval()
				}
				kind:        .string_data
				string_data: value.data.s.clone()
			}
		}
	}
	return PersistentOwnedZVal{
		ZValViewState: ZValViewState{
			z: invalid_zval()
		}
		kind:     .dyn_data
		dyn_data: value
	}
}

fn dyn_value_is_persistent_safe(value DynValue) bool {
	return match value.type {
		.null_, .bool_, .int_, .float_, .string_ { true }
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
		.object_ref, .resource_ref { false }
	}
}

pub fn PersistentOwnedZVal.from_zval(z ZVal) PersistentOwnedZVal {
	return own_persistent_zval(z)
}

// of is the friendly long-lived entry point for a general PHP value.
// It will route safe data into detached storage and objects into retained
// handles, only falling back to raw persistent zval compatibility when needed.
pub fn PersistentOwnedZVal.of(z ZVal) PersistentOwnedZVal {
	return PersistentOwnedZVal.from_zval(z)
}

pub fn PersistentOwnedZVal.from_dyn(value DynValue) PersistentOwnedZVal {
	return own_persistent_dyn(value)
}

// of_data is the preferred long-lived entry point when the caller already has
// detached V-side data instead of a Zend value.
pub fn PersistentOwnedZVal.of_data(value DynValue) PersistentOwnedZVal {
	return PersistentOwnedZVal.from_dyn(value)
}

pub fn PersistentOwnedZVal.from_detached_zval(z ZVal) ?PersistentOwnedZVal {
	detached := decode_dyn_value(z) or { return none }
	if !dyn_value_is_persistent_safe(detached) {
		return none
	}
	return own_persistent_dyn(detached)
}

// try_of_detached requires the input zval to be safely detachable pure data.
pub fn PersistentOwnedZVal.try_of_detached(z ZVal) ?PersistentOwnedZVal {
	return PersistentOwnedZVal.from_detached_zval(z)
}

pub fn PersistentOwnedZVal.from_value_zval(z ZVal) PersistentOwnedZVal {
	return PersistentOwnedZVal.from_detached_zval(z) or { PersistentOwnedZVal.from_zval(z) }
}

// of_value prefers detached long-lived data, then falls back to the general
// long-lived route for mixed values.
pub fn PersistentOwnedZVal.of_value(z ZVal) PersistentOwnedZVal {
	return PersistentOwnedZVal.from_value_zval(z)
}

pub fn RequestOwnedZVal.new_null() RequestOwnedZVal {
	return own_request_zval(ZVal.new_null())
}

pub fn RequestOwnedZVal.new_int(n i64) RequestOwnedZVal {
	return own_request_zval(ZVal.new_int(n))
}

pub fn RequestOwnedZVal.new_float(f f64) RequestOwnedZVal {
	return own_request_zval(ZVal.new_float(f))
}

pub fn RequestOwnedZVal.new_bool(b bool) RequestOwnedZVal {
	return own_request_zval(ZVal.new_bool(b))
}

pub fn RequestOwnedZVal.new_string(s string) RequestOwnedZVal {
	return own_request_zval(ZVal.new_string(s))
}

pub fn PersistentOwnedZVal.new_null() PersistentOwnedZVal {
	return own_persistent_dyn(dyn_value_null())
}

pub fn PersistentOwnedZVal.invalid() PersistentOwnedZVal {
	return own_persistent_zval(ZVal.invalid())
}

pub fn PersistentOwnedZVal.new_int(n i64) PersistentOwnedZVal {
	return own_persistent_dyn(dyn_value_int(n))
}

pub fn PersistentOwnedZVal.new_float(f f64) PersistentOwnedZVal {
	return own_persistent_dyn(dyn_value_float(f))
}

pub fn PersistentOwnedZVal.new_bool(b bool) PersistentOwnedZVal {
	return own_persistent_dyn(dyn_value_bool(b))
}

pub fn PersistentOwnedZVal.new_string(s string) PersistentOwnedZVal {
	return own_persistent_dyn(dyn_value_string(s))
}


pub fn (v ZValViewState) to_zval() ZVal {
	return v.z
}

pub fn (v ZValViewState) is_valid() bool {
	return v.z.is_valid()
}

pub fn (v ZValViewState) is_null() bool {
	return v.z.is_null()
}

pub fn (v ZValViewState) is_undef() bool {
	return v.z.is_undef()
}

pub fn (v ZValViewState) is_resource() bool {
	return v.z.is_resource()
}

pub fn (v ZValViewState) is_callable() bool {
	return v.z.is_callable()
}

pub fn (v ZValViewState) is_object() bool {
	return v.z.is_object()
}

pub fn (v ZValViewState) is_string() bool {
	return v.z.is_string()
}

pub fn (v ZValViewState) is_array() bool {
	return v.z.is_array()
}

pub fn (v ZValViewState) method_exists(name string) bool {
	return v.z.method_exists(name)
}

pub fn (v ZValViewState) to_string() string {
	return v.z.to_string()
}

pub fn (v ZValViewState) to_string_list() []string {
	return v.z.to_string_list()
}

pub fn (v ZValViewState) to_string_map() map[string]string {
	return v.z.to_string_map()
}

pub fn (v ZValViewState) resource_type() ?string {
	return v.z.resource_type()
}

pub fn (v ZValViewState) stream_metadata() ?StreamMetadata {
	return v.z.stream_metadata()
}

pub fn (v ZValViewState) to_bool() bool {
	return v.z.to_bool()
}

pub fn (v ZValViewState) to_int() int {
	return v.z.to_int()
}

pub fn (v ZValViewState) to_i64() i64 {
	return v.z.to_i64()
}

pub fn (v ZValViewState) to_f64() f64 {
	return v.z.to_f64()
}

pub fn (v ZValViewState) to_v[T]() !T {
	return v.z.to_v[T]()
}

pub fn (v ZValViewState) call_owned_request(args []ZVal) ZVal {
	return v.z.call_owned_request(args)
}

pub fn (v ZValViewState) method_owned_request(method string, args []ZVal) ZVal {
	return v.z.method_owned_request(method, args)
}

pub fn with_call_result_zval[T](callable ZVal, args []ZVal, run fn (ZVal) T) T {
	mut result := callable.call_owned_request(args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn call_request_owned_zval(callable ZVal, args []ZVal) RequestOwnedZVal {
	return RequestOwnedZVal.adopt_zval(callable.call_owned_request(args))
}

pub fn with_method_result_zval[T](receiver ZVal, method string, args []ZVal, run fn (ZVal) T) T {
	mut result := receiver.method_owned_request(method, args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn method_request_owned_zval(receiver ZVal, method string, args []ZVal) RequestOwnedZVal {
	return RequestOwnedZVal.adopt_zval(receiver.method_owned_request(method, args))
}

pub fn (v BorrowedZVal) clone_request_owned() RequestOwnedZVal {
	return own_request_zval(v.z)
}

pub fn (v BorrowedZVal) clone_persistent_owned() PersistentOwnedZVal {
	return own_persistent_zval(v.z)
}

pub fn (v RequestOwnedZVal) borrowed() BorrowedZVal {
	return borrow_zval(v.z)
}

pub fn (v RequestOwnedZVal) clone_persistent_owned() PersistentOwnedZVal {
	return own_persistent_zval(v.z)
}

pub fn (v RequestOwnedZVal) clone_request_owned() RequestOwnedZVal {
	return own_request_zval(v.z)
}

pub fn (v RequestOwnedZVal) with_zval[T](run fn (ZVal) T) T {
	return run(v.z)
}

pub fn (mut v RequestOwnedZVal) take_zval() ZVal {
	out := v.z
	v.z = invalid_zval()
	return out
}

pub fn (mut v RequestOwnedZVal) release() {
	v.z.release()
}

fn retained_request_owned(retained RetainedObject) RequestOwnedZVal {
	return RequestOwnedZVal{
		ZValViewState: ZValViewState{
			z: retained.to_request_owned_zval()
		}
	}
}

fn persistent_string_request_owned(value string) RequestOwnedZVal {
	return RequestOwnedZVal.new_string(value)
}

fn persistent_dyn_request_owned(value DynValue) RequestOwnedZVal {
	return RequestOwnedZVal{
		ZValViewState: ZValViewState{
			z: new_zval_from_dyn_value(value) or { ZVal.new_null() }
		}
	}
}

pub fn (v PersistentOwnedZVal) borrowed() BorrowedZVal {
	match v.kind {
		.dyn_data {
			return v.clone_request_owned().borrowed()
		}
		.retained_object {
			return v.clone_request_owned().borrowed()
		}
		.string_data {
			return v.clone_request_owned().borrowed()
		}
		.zval_data {
			return borrow_zval(v.z)
		}
	}
}

pub fn (v PersistentOwnedZVal) clone_request_owned() RequestOwnedZVal {
	match v.kind {
		.dyn_data {
			return persistent_dyn_request_owned(v.dyn_data)
		}
		.retained_object {
			return retained_request_owned(v.retained)
		}
		.string_data {
			return persistent_string_request_owned(v.string_data)
		}
		.zval_data {
			return own_request_zval(v.z)
		}
	}
}

pub fn (v PersistentOwnedZVal) with_request_zval[T](run fn (ZVal) T) T {
	mut temp := v.clone_request_owned()
	defer {
		temp.release()
	}
	return run(temp.to_zval())
}

pub fn (v PersistentOwnedZVal) call_request_owned(args []ZVal) RequestOwnedZVal {
	return v.with_request_zval(fn [args] (callable ZVal) RequestOwnedZVal {
		return RequestOwnedZVal.adopt_zval(callable.call_owned_request(args))
	})
}

pub fn (v PersistentOwnedZVal) method_request_owned(method string, args []ZVal) RequestOwnedZVal {
	return v.with_request_zval(fn [method, args] (receiver ZVal) RequestOwnedZVal {
		return RequestOwnedZVal.adopt_zval(receiver.method_owned_request(method, args))
	})
}

// with_call_result keeps PHP callable result ownership inside the callback
// scope so callers don't have to manually release transient return zvals.
pub fn (v PersistentOwnedZVal) with_call_result[T](args []ZVal, run fn (ZVal) T) T {
	mut result := v.call_request_owned(args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

// with_method_result mirrors with_call_result for object method dispatch.
pub fn (v PersistentOwnedZVal) with_method_result[T](method string, args []ZVal, run fn (ZVal) T) T {
	mut result := v.method_request_owned(method, args)
	defer {
		result.release()
	}
	return run(result.to_zval())
}

pub fn (mut v PersistentOwnedZVal) release() {
	match v.kind {
		.dyn_data {
			v.dyn_data = dyn_value_null()
			v.z = invalid_zval()
		}
		.retained_object {
			mut retained := v.retained
			retained.release()
			v.retained = RetainedObject.invalid()
			v.z = invalid_zval()
		}
		.string_data {
			unsafe {
				v.string_data.free()
			}
			v.z = invalid_zval()
		}
		.zval_data {
			v.z.release()
		}
	}
	v.kind = .zval_data
}

pub fn (v PersistentOwnedZVal) clone_persistent_owned() PersistentOwnedZVal {
	match v.kind {
		.dyn_data {
			return PersistentOwnedZVal{
				ZValViewState: ZValViewState{
					z: invalid_zval()
				}
				kind:          .dyn_data
				dyn_data:      v.dyn_data
			}
		}
		.retained_object {
			return PersistentOwnedZVal{
				ZValViewState: ZValViewState{
					z: invalid_zval()
				}
				kind:          .retained_object
				retained:      v.retained.clone()
			}
		}
		.string_data {
			return PersistentOwnedZVal{
				ZValViewState: ZValViewState{
					z: invalid_zval()
				}
				kind:          .string_data
				string_data:   v.string_data.clone()
			}
		}
		.zval_data {
			return own_persistent_zval(v.z)
		}
	}
}

pub fn (v PersistentOwnedZVal) to_zval() ZVal {
	match v.kind {
		.dyn_data {
			return new_zval_from_dyn_value(v.dyn_data) or { ZVal.new_null() }
		}
		.retained_object {
			return v.retained.to_request_owned_zval()
		}
		.string_data {
			return RequestOwnedZVal.new_string(v.string_data).to_zval()
		}
		.zval_data {
			return v.z
		}
	}
}

pub fn (v PersistentOwnedZVal) is_valid() bool {
	match v.kind {
		.dyn_data {
			return true
		}
		.retained_object {
			return v.retained.is_valid()
		}
		.string_data {
			return true
		}
		.zval_data {
			return v.z.is_valid()
		}
	}
}

pub fn (v PersistentOwnedZVal) kind_name() string {
	return match v.kind {
		.zval_data { 'zval_data' }
		.dyn_data { 'dyn_data' }
		.string_data { 'string_data' }
		.retained_object { 'retained_object' }
	}
}

pub fn (v PersistentOwnedZVal) is_null() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type == .null_
		}
		.retained_object {
			return false
		}
		.string_data {
			return false
		}
		.zval_data {
			return v.z.is_null()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_undef() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_object {
			return false
		}
		.string_data {
			return false
		}
		.zval_data {
			return v.z.is_undef()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_resource() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_object {
			return false
		}
		.string_data {
			return false
		}
		.zval_data {
			return v.z.is_resource()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_callable() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.is_callable()
		}
		.string_data {
			return false
		}
		.zval_data {
			return v.z.is_callable()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_object() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_object {
			return true
		}
		.string_data {
			return false
		}
		.zval_data {
			return v.z.is_object()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_string() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type == .string_
		}
		.retained_object {
			return false
		}
		.string_data {
			return true
		}
		.zval_data {
			return v.z.is_string()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_array() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type in [.list_, .map_]
		}
		.retained_object {
			return false
		}
		.string_data {
			return false
		}
		.zval_data {
			return v.z.is_array()
		}
	}
}

pub fn (v PersistentOwnedZVal) method_exists(name string) bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.method_exists(name)
		}
		.string_data {
			return false
		}
		.zval_data {
			return v.z.method_exists(name)
		}
	}
}

pub fn (v PersistentOwnedZVal) to_string() string {
	match v.kind {
		.dyn_data {
			match v.dyn_data.type {
				.null_ {
					return ''
				}
				.bool_ {
					unsafe {
						return if v.dyn_data.data.b { '1' } else { '' }
					}
				}
				.int_ {
					unsafe {
						return v.dyn_data.data.i.str()
					}
				}
				.float_ {
					unsafe {
						return v.dyn_data.data.f.str()
					}
				}
				.string_ {
					unsafe {
						return v.dyn_data.data.s.clone()
					}
				}
				else {
					mut temp := persistent_dyn_request_owned(v.dyn_data)
					defer {
						temp.release()
					}
					return temp.to_string()
				}
			}
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.to_string()
		}
		.string_data {
			return v.string_data
		}
		.zval_data {
			return v.z.to_string()
		}
	}
}

pub fn (v PersistentOwnedZVal) to_string_list() []string {
	match v.kind {
		.dyn_data {
			match v.dyn_data.type {
				.list_ {
					mut out := []string{}
					for item in v.dyn_data.list {
						out << PersistentOwnedZVal{
							ZValViewState: ZValViewState{
								z: invalid_zval()
							}
							kind:          .dyn_data
							dyn_data:      item
						}.to_string()
					}
					return out
				}
				.string_ {
					return [v.to_string()]
				}
				else {
					mut temp := persistent_dyn_request_owned(v.dyn_data)
					defer {
						temp.release()
					}
					return temp.to_string_list()
				}
			}
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.to_string_list()
		}
		.string_data {
			return [v.string_data.clone()]
		}
		.zval_data {
			return v.z.to_string_list()
		}
	}
}

pub fn (v PersistentOwnedZVal) to_string_map() map[string]string {
	match v.kind {
		.dyn_data {
			match v.dyn_data.type {
				.map_ {
					mut out := map[string]string{}
					for key, item in v.dyn_data.map {
						out[key] = PersistentOwnedZVal{
							ZValViewState: ZValViewState{
								z: invalid_zval()
							}
							kind:          .dyn_data
							dyn_data:      item
						}.to_string()
					}
					return out
				}
				else {
					mut temp := persistent_dyn_request_owned(v.dyn_data)
					defer {
						temp.release()
					}
					return temp.to_string_map()
				}
			}
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.to_string_map()
		}
		.string_data {
			return map[string]string{}
		}
		.zval_data {
			return v.z.to_string_map()
		}
	}
}

pub fn (v PersistentOwnedZVal) resource_type() ?string {
	match v.kind {
		.dyn_data {
			return none
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.resource_type()
		}
		.string_data {
			return none
		}
		.zval_data {
			return v.z.resource_type()
		}
	}
}

pub fn (v PersistentOwnedZVal) stream_metadata() ?StreamMetadata {
	match v.kind {
		.dyn_data {
			return none
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.stream_metadata()
		}
		.string_data {
			return none
		}
		.zval_data {
			return v.z.stream_metadata()
		}
	}
}

pub fn (v PersistentOwnedZVal) to_bool() bool {
	match v.kind {
		.dyn_data {
			match v.dyn_data.type {
				.null_ {
					return false
				}
				.bool_ {
					unsafe {
						return v.dyn_data.data.b
					}
				}
				.int_ {
					unsafe {
						return v.dyn_data.data.i != 0
					}
				}
				.float_ {
					unsafe {
						return v.dyn_data.data.f != 0.0
					}
				}
				.string_ {
					unsafe {
						return v.dyn_data.data.s.len > 0
					}
				}
				.list_, .map_ {
					return true
				}
				else {
					return false
				}
			}
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.to_bool()
		}
		.string_data {
			return v.string_data.len > 0
		}
		.zval_data {
			return v.z.to_bool()
		}
	}
}

pub fn (v PersistentOwnedZVal) to_int() int {
	match v.kind {
		.dyn_data {
			match v.dyn_data.type {
				.int_ {
					unsafe {
						return int(v.dyn_data.data.i)
					}
				}
				.bool_ {
					unsafe {
						return if v.dyn_data.data.b { 1 } else { 0 }
					}
				}
				.float_ {
					unsafe {
						return int(v.dyn_data.data.f)
					}
				}
				.string_ {
					return v.to_string().int()
				}
				else {
					return 0
				}
			}
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.to_int()
		}
		.string_data {
			return v.string_data.int()
		}
		.zval_data {
			return v.z.to_int()
		}
	}
}

pub fn (v PersistentOwnedZVal) to_i64() i64 {
	match v.kind {
		.dyn_data {
			match v.dyn_data.type {
				.int_ {
					unsafe {
						return v.dyn_data.data.i
					}
				}
				.bool_ {
					unsafe {
						return if v.dyn_data.data.b { i64(1) } else { i64(0) }
					}
				}
				.float_ {
					unsafe {
						return i64(v.dyn_data.data.f)
					}
				}
				.string_ {
					return v.to_string().i64()
				}
				else {
					return 0
				}
			}
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.to_i64()
		}
		.string_data {
			return v.string_data.i64()
		}
		.zval_data {
			return v.z.to_i64()
		}
	}
}

pub fn (v PersistentOwnedZVal) to_f64() f64 {
	match v.kind {
		.dyn_data {
			match v.dyn_data.type {
				.float_ {
					unsafe {
						return v.dyn_data.data.f
					}
				}
				.int_ {
					unsafe {
						return f64(v.dyn_data.data.i)
					}
				}
				.bool_ {
					unsafe {
						return if v.dyn_data.data.b { 1.0 } else { 0.0 }
					}
				}
				.string_ {
					return v.to_string().f64()
				}
				else {
					return 0.0
				}
			}
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.to_f64()
		}
		.string_data {
			return v.string_data.f64()
		}
		.zval_data {
			return v.z.to_f64()
		}
	}
}

pub fn (v PersistentOwnedZVal) call_owned_request(args []ZVal) ZVal {
	match v.kind {
		.dyn_data {
			return invalid_zval()
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.call_owned_request(args)
		}
		.string_data {
			return invalid_zval()
		}
		.zval_data {
			return v.z.call_owned_request(args)
		}
	}
}

pub fn (v PersistentOwnedZVal) method_owned_request(method string, args []ZVal) ZVal {
	match v.kind {
		.dyn_data {
			return invalid_zval()
		}
		.retained_object {
			mut temp := retained_request_owned(v.retained)
			defer {
				temp.release()
			}
			return temp.method_owned_request(method, args)
		}
		.string_data {
			return invalid_zval()
		}
		.zval_data {
			return v.z.method_owned_request(method, args)
		}
	}
}

pub fn borrowed_zval_from_raw(raw &C.zval) BorrowedZVal {
	return unsafe {
		borrow_zval(ZVal{
			raw:   raw
			owned: false
		})
	}
}

pub struct OwnedValue {
	ZValViewState
pub mut:
	lifetime OwnershipKind
}

// own() keeps backward compatibility and now defaults to request lifetime.
pub fn own(z ZVal) OwnedValue {
	return own_request(z)
}

pub fn own_request(z ZVal) OwnedValue {
	owned := own_request_zval(z)
	return OwnedValue{
		ZValViewState: owned.ZValViewState
		lifetime:      .owned_request
	}
}

pub fn own_persistent(z ZVal) OwnedValue {
	persistent := own_persistent_zval(z)
	return OwnedValue{
		ZValViewState: persistent.ZValViewState
		lifetime:      .owned_persistent
	}
}

pub fn (mut v OwnedValue) release() {
	v.z.release()
}

pub fn (v OwnedValue) ownership() OwnershipKind {
	return v.lifetime
}

// RequestScope gives a structured, nestable request arena on top of
// autorelease marks. It is intentionally tiny and can be used with `defer`.
pub struct RequestScope {
pub:
	mark int
mut:
	active bool
}

pub fn request_scope() RequestScope {
	return RequestScope{
		mark:   request_scope_enter()
		active: true
	}
}

pub fn (mut s RequestScope) close() {
	if !s.active {
		return
	}
	request_scope_leave(s.mark)
	s.active = false
}

// with_request_scope is the recommended structured entry point for framework
// dispatch paths and middleware chains.
pub fn with_request_scope[T](run fn () T) T {
	mut s := request_scope()
	defer {
		s.close()
	}
	return run()
}
