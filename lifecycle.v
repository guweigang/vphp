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

// --- New typed ownership wrappers ---
// ZValViewState carries the shared safe/read-only API surface.
// Ownership wrappers embed it so extension code gets the common methods
// without inheriting the full low-level ZVal lifecycle API directly.
pub struct ZValViewState {
pub mut:
	z ZVal
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
	retained_callable
	retained_object
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
	kind              PersistentOwnedKind = .fallback_zval
	dyn_data          DynValue
	retained          RetainedObject
	retained_callable RetainedCallable
}

@[inline]
fn zbox_view_state(z ZVal) ZValViewState {
	return ZValViewState{
		z: z
	}
}

@[inline]
fn borrowed_zbox_from_raw_zval(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox{
		ZValViewState: zbox_view_state(z)
	}
}

@[inline]
fn request_owned_zbox_from_adopted_zval(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox{
		ZValViewState: zbox_view_state(z)
	}
}

@[inline]
fn persistent_owned_dyn_box(value DynValue) PersistentOwnedZBox {
	return PersistentOwnedZBox{
		ZValViewState: zbox_view_state(invalid_zval())
		kind:          .dyn_data
		dyn_data:      value
	}
}

@[inline]
fn persistent_owned_retained_object_box(retained RetainedObject) PersistentOwnedZBox {
	return PersistentOwnedZBox{
		ZValViewState: zbox_view_state(invalid_zval())
		kind:          .retained_object
		retained:      retained
	}
}

@[inline]
fn persistent_owned_retained_callable_box(retained RetainedCallable) PersistentOwnedZBox {
	return PersistentOwnedZBox{
		ZValViewState: zbox_view_state(invalid_zval())
		kind:              .retained_callable
		retained_callable: retained
	}
}

pub fn borrow_zbox(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox.of(z)
}

pub fn own_request_zbox(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.of(z)
}

pub fn own_persistent_zbox(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.of(z)
}

pub fn borrow_zbox_raw(z ZVal) RequestBorrowedZBox {
	return borrowed_zbox_from_raw_zval(z)
}

pub fn RequestBorrowedZBox.from_zval(z ZVal) RequestBorrowedZBox {
	return borrow_zbox_raw(z)
}

pub fn RequestBorrowedZBox.of(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_zval(z)
}

// null borrowed helper for call-site ergonomics; lifetime is request-scoped.
pub fn RequestBorrowedZBox.null() RequestBorrowedZBox {
	return RequestOwnedZBox.new_null().borrowed()
}

pub fn own_request_zbox_raw(z ZVal) RequestOwnedZBox {
	return request_owned_zbox_from_adopted_zval(z.dup())
}

pub fn RequestOwnedZBox.from_zval(z ZVal) RequestOwnedZBox {
	return own_request_zbox_raw(z)
}

pub fn RequestOwnedZBox.of(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.from_zval(z)
}

pub fn RequestOwnedZBox.adopt_zval(z ZVal) RequestOwnedZBox {
	return request_owned_zbox_from_adopted_zval(z)
}

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

pub fn own_persistent_zbox_raw(z ZVal) PersistentOwnedZBox {
	if z.is_valid() && z.is_callable() {
		if retained_callable := RetainedCallable.from_zval(z) {
			return persistent_owned_retained_callable_box(retained_callable)
		}
	}
	if z.is_valid() && z.is_object() {
		if retained := RetainedObject.from_zval(z) {
			return persistent_owned_retained_object_box(retained)
		}
	}
	if dyn := decode_dyn_value(z) {
		if dyn_value_is_persistent_safe(dyn) {
			return persistent_owned_dyn_box(dyn)
		}
	}
	// Keep raw zval fallback as a narrow compatibility path only.
	// Safe long-lived values should prefer detached DynValue/string data or
	// retained object handles above.
	return PersistentOwnedZBox{
		ZValViewState: zbox_view_state(z.dup_persistent())
		kind:          .fallback_zval
	}

}

pub fn PersistentOwnedZBox.from_callable_zval(z ZVal) PersistentOwnedZBox {
	if retained_callable := RetainedCallable.from_zval(z) {
		return persistent_owned_retained_callable_box(retained_callable)
	}
	if retained := RetainedObject.from_zval(z) {
		return persistent_owned_retained_object_box(retained)
	}
	return own_persistent_zbox_raw(z)
}

pub fn PersistentOwnedZBox.of_callable(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_callable_zval(z)
}

// from_object_zval is the explicit long-lived path for PHP objects.
// Prefer this over generic value routing when the input is known to be object-like.
pub fn PersistentOwnedZBox.from_object_zval(z ZVal) PersistentOwnedZBox {
	if retained := RetainedObject.from_zval(z) {
		return persistent_owned_retained_object_box(retained)
	}
	return own_persistent_zbox_raw(z)
}

pub fn PersistentOwnedZBox.of_object(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_object_zval(z)
}

pub fn own_persistent_dyn(value DynValue) PersistentOwnedZBox {
	return persistent_owned_dyn_box(value)
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

pub fn PersistentOwnedZBox.from_zval(z ZVal) PersistentOwnedZBox {
	return own_persistent_zbox_raw(z)
}

// from_persistent_zval keeps the original zval payload as a persistent duplicate
// without routing through detached DynValue decoding.
pub fn PersistentOwnedZBox.from_persistent_zval(z ZVal) PersistentOwnedZBox {
	if !z.is_valid() || z.is_undef() {
		return PersistentOwnedZBox.new_null()
	}
	return PersistentOwnedZBox{
		ZValViewState: zbox_view_state(z.dup_persistent())
		kind:          .fallback_zval
	}
}

// of is the friendly long-lived entry point for a general PHP value.
// It will route safe data into detached storage and objects into retained
// handles, only falling back to raw persistent zval compatibility when needed.
pub fn PersistentOwnedZBox.of(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_zval(z)
}

pub fn PersistentOwnedZBox.from_dyn(value DynValue) PersistentOwnedZBox {
	return own_persistent_dyn(value)
}

// of_data is the preferred long-lived entry point when the caller already has
// detached V-side data instead of a Zend value.
pub fn PersistentOwnedZBox.of_data(value DynValue) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_dyn(value)
}

pub fn PersistentOwnedZBox.from_detached_zval(z ZVal) ?PersistentOwnedZBox {
	detached := decode_dyn_value(z) or { return none }
	if !dyn_value_is_persistent_safe(detached) {
		return none
	}
	return own_persistent_dyn(detached)
}

// try_of_detached requires the input zval to be safely detachable pure data.
pub fn PersistentOwnedZBox.try_of_detached(z ZVal) ?PersistentOwnedZBox {
	return PersistentOwnedZBox.from_detached_zval(z)
}

// from_mixed_zval is the explicit "general long-lived input" path.
// It prefers detached data first, then falls back to the smart routing used by of().
pub fn PersistentOwnedZBox.from_mixed_zval(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_detached_zval(z) or { PersistentOwnedZBox.from_zval(z) }
}

// from_value_zval is kept as a narrow compatibility alias.
// New code should prefer from_mixed_zval(...).
pub fn PersistentOwnedZBox.from_value_zval(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_mixed_zval(z)
}

// of_mixed prefers detached long-lived data, then falls back to the general
// long-lived route for mixed values. Use of_callable/of_object when the input
// kind is already known, so mixed fallback stays a narrow compatibility path.
pub fn PersistentOwnedZBox.of_mixed(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_mixed_zval(z)
}

// of_value is kept as a narrow compatibility alias.
// New code should prefer of_mixed(...).
pub fn PersistentOwnedZBox.of_value(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.of_mixed(z)
}

pub fn RequestOwnedZBox.new_null() RequestOwnedZBox {
	return own_request_zbox_raw(ZVal.new_null())
}

pub fn RequestOwnedZBox.new_int(n i64) RequestOwnedZBox {
	return own_request_zbox_raw(ZVal.new_int(n))
}

pub fn RequestOwnedZBox.new_float(f f64) RequestOwnedZBox {
	return own_request_zbox_raw(ZVal.new_float(f))
}

pub fn RequestOwnedZBox.new_bool(b bool) RequestOwnedZBox {
	return own_request_zbox_raw(ZVal.new_bool(b))
}

pub fn RequestOwnedZBox.new_string(s string) RequestOwnedZBox {
	return own_request_zbox_raw(ZVal.new_string(s))
}

pub fn PersistentOwnedZBox.new_null() PersistentOwnedZBox {
	return own_persistent_dyn(dyn_value_null())
}

pub fn PersistentOwnedZBox.invalid() PersistentOwnedZBox {
	return PersistentOwnedZBox{
		ZValViewState: zbox_view_state(invalid_zval())
		kind:          .fallback_zval
	}
}

pub fn release_persistent_boxes(mut list []PersistentOwnedZBox) {
	for i in 0 .. list.len {
		list[i].release()
	}
	unsafe {
		list.free()
	}
}

pub fn PersistentOwnedZBox.new_int(n i64) PersistentOwnedZBox {
	return own_persistent_dyn(dyn_value_int(n))
}

pub fn PersistentOwnedZBox.new_float(f f64) PersistentOwnedZBox {
	return own_persistent_dyn(dyn_value_float(f))
}

pub fn PersistentOwnedZBox.new_bool(b bool) PersistentOwnedZBox {
	return own_persistent_dyn(dyn_value_bool(b))
}

pub fn PersistentOwnedZBox.new_string(s string) PersistentOwnedZBox {
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

// with_php_call_result_zval mirrors with_call_result_zval for global PHP
// functions. Callers inspect the transient result inside the callback instead
// of carrying a bare request-owned ZVal through outer scopes.
pub fn with_php_call_result_zval[T](name string, args []ZVal, run fn (ZVal) T) T {
	return with_call_result_zval(php_fn(name), args, run)
}

pub fn with_php_call_result_string(name string, args []ZVal) string {
	return with_php_call_result_zval(name, args, fn (z ZVal) string {
		return z.to_string()
	})
}

pub fn with_php_call_result_bool(name string, args []ZVal) bool {
	return with_php_call_result_zval(name, args, fn (z ZVal) bool {
		return z.to_bool()
	})
}

pub fn with_php_call_result_i64(name string, args []ZVal) i64 {
	return with_php_call_result_zval(name, args, fn (z ZVal) i64 {
		return z.to_i64()
	})
}

pub fn call_request_owned_box(callable ZVal, args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(callable.call_owned_request(args))
}

// php_call_request_owned_box is the global-function counterpart to
// call_request_owned_box. Prefer this or with_php_call_result_zval over
// exposing a bare request-owned ZVal to callers.
pub fn php_call_request_owned_box(name string, args []ZVal) RequestOwnedZBox {
	return call_request_owned_box(php_fn(name), args)
}

pub fn with_method_result_zval[T](receiver ZVal, method string, args []ZVal, run fn (ZVal) T) T {
	mut result := receiver.method_owned_request(method, args)
	defer {
		result.release()
	}
	return run(result)
}

pub fn method_request_owned_box(receiver ZVal, method string, args []ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(receiver.method_owned_request(method, args))
}

pub fn (v RequestBorrowedZBox) clone_request_owned() RequestOwnedZBox {
	return own_request_zbox_raw(v.z)
}

pub fn (v RequestBorrowedZBox) clone() PersistentOwnedZBox {
	return own_persistent_zbox_raw(v.z)
}

pub fn (v RequestOwnedZBox) borrowed() RequestBorrowedZBox {
	return borrow_zbox_raw(v.z)
}

pub fn (v RequestOwnedZBox) clone() PersistentOwnedZBox {
	return own_persistent_zbox_raw(v.z)
}

pub fn (v RequestOwnedZBox) to_persistent() PersistentOwnedZBox {
	return v.clone()
}

pub fn (v RequestOwnedZBox) clone_request_owned() RequestOwnedZBox {
	return own_request_zbox_raw(v.z)
}

pub fn (v RequestOwnedZBox) with_zval[T](run fn (ZVal) T) T {
	return run(v.z)
}

pub fn (mut v RequestOwnedZBox) take_zval() ZVal {
	out := v.z
	v.z = invalid_zval()
	return out
}

pub fn (mut v RequestOwnedZBox) release() {
	v.z.release()
}

fn retained_request_owned(retained RetainedObject) RequestOwnedZBox {
	return request_owned_zbox_from_adopted_zval(retained.to_request_owned_zval())
}

fn retained_callable_request_owned(retained RetainedCallable) RequestOwnedZBox {
	return request_owned_zbox_from_adopted_zval(retained.to_request_owned_zval())
}

fn persistent_dyn_request_owned(value DynValue) RequestOwnedZBox {
	return request_owned_zbox_from_adopted_zval(new_zval_from_dyn_value(value) or { ZVal.new_null() })
}

@[inline]
fn dyn_to_request_owned_box(value DynValue) RequestOwnedZBox {
	return persistent_dyn_request_owned(value)
}

fn dyn_to_string(value DynValue) string {
	return match value.type {
		.null_ { '' }
		.bool_ { if value.bool_value() { '1' } else { '' } }
		.int_ { value.int_value().str() }
		.float_ { value.float_value().str() }
		.string_ { value.string_value().clone() }
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
		.string_ { [dyn_to_string(value)] }
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
		.int_ { int(value.int_value()) }
		.bool_ { if value.bool_value() { 1 } else { 0 } }
		.float_ { int(value.float_value()) }
		.string_ { dyn_to_string(value).int() }
		else { 0 }
	}
}

fn dyn_to_i64(value DynValue) i64 {
	return match value.type {
		.int_ { value.int_value() }
		.bool_ { if value.bool_value() { i64(1) } else { i64(0) } }
		.float_ { i64(value.float_value()) }
		.string_ { dyn_to_string(value).i64() }
		else { i64(0) }
	}
}

fn dyn_to_f64(value DynValue) f64 {
	return match value.type {
		.float_ { value.float_value() }
		.int_ { f64(value.int_value()) }
		.bool_ { if value.bool_value() { 1.0 } else { 0.0 } }
		.string_ { dyn_to_string(value).f64() }
		else { 0.0 }
	}
}

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
			return new_zval_from_dyn_value(v.dyn_data) or { ZVal.new_null() }
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

pub fn (v PersistentOwnedZBox) is_valid() bool {
	match v.kind {
		.dyn_data {
			return true
		}
		.retained_callable {
			return v.retained_callable.is_valid()
		}
		.retained_object {
			return v.retained.is_valid()
		}
		.fallback_zval {
			return v.z.is_valid()
		}
	}
}

pub fn (v PersistentOwnedZBox) kind_name() string {
	return match v.kind {
		.fallback_zval { 'fallback_zval' }
		.dyn_data { 'dyn_data' }
		.retained_callable { 'retained_callable' }
		.retained_object { 'retained_object' }
	}
}

pub fn (v PersistentOwnedZBox) is_null() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type == .null_
		}
		.retained_callable {
			return false
		}
		.retained_object {
			return false
		}
		.fallback_zval {
			return v.z.is_null()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_undef() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_callable {
			return false
		}
		.retained_object {
			return false
		}
		.fallback_zval {
			return v.z.is_undef()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_resource() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_callable {
			return false
		}
		.retained_object {
			return false
		}
		.fallback_zval {
			return v.z.is_resource()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_callable() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_callable { return true }
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return false }
	defer {
		temp.release()
	}
	return temp.is_callable()
}

pub fn (v PersistentOwnedZBox) is_object() bool {
	match v.kind {
		.dyn_data {
			return false
		}
		.retained_callable {
			return v.retained_callable.is_object_like()
		}
		.retained_object {
			return true
		}
		.fallback_zval {
			return v.z.is_object()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_string() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type == .string_
		}
		.retained_callable {
			return v.retained_callable.is_string_like()
		}
		.retained_object {
			return false
		}
		.fallback_zval {
			return v.z.is_string()
		}
	}
}

pub fn (v PersistentOwnedZBox) is_array() bool {
	match v.kind {
		.dyn_data {
			return v.dyn_data.type in [.list_, .map_]
		}
		.retained_callable {
			return v.retained_callable.is_array_like()
		}
		.retained_object {
			return false
		}
		.fallback_zval {
			return v.z.is_array()
		}
	}
}

pub fn (v PersistentOwnedZBox) method_exists(name string) bool {
	match v.kind {
		.dyn_data {
			return false
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return false }
	defer {
		temp.release()
	}
	return temp.method_exists(name)
}

pub fn (v PersistentOwnedZBox) to_string() string {
	match v.kind {
		.dyn_data {
			return dyn_to_string(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return '' }
	defer {
		temp.release()
	}
	return temp.to_string()
}

pub fn (v PersistentOwnedZBox) to_string_list() []string {
	match v.kind {
		.dyn_data {
			return dyn_to_string_list(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return []string{} }
	defer {
		temp.release()
	}
	return temp.to_string_list()
}

pub fn (v PersistentOwnedZBox) to_string_map() map[string]string {
	match v.kind {
		.dyn_data {
			return dyn_to_string_map(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return map[string]string{} }
	defer {
		temp.release()
	}
	return temp.to_string_map()
}

pub fn (v PersistentOwnedZBox) resource_type() ?string {
	match v.kind {
		.dyn_data {
			return none
		}
		.retained_callable { return none }
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return none }
	defer {
		temp.release()
	}
	return temp.resource_type()
}

pub fn (v PersistentOwnedZBox) stream_metadata() ?StreamMetadata {
	match v.kind {
		.dyn_data {
			return none
		}
		.retained_callable { return none }
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return none }
	defer {
		temp.release()
	}
	return temp.stream_metadata()
}

pub fn (v PersistentOwnedZBox) to_bool() bool {
	match v.kind {
		.dyn_data {
			return dyn_to_bool(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return false }
	defer {
		temp.release()
	}
	return temp.to_bool()
}

pub fn (v PersistentOwnedZBox) to_int() int {
	match v.kind {
		.dyn_data {
			return dyn_to_int(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return 0 }
	defer {
		temp.release()
	}
	return temp.to_int()
}

pub fn (v PersistentOwnedZBox) to_i64() i64 {
	match v.kind {
		.dyn_data {
			return dyn_to_i64(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return i64(0) }
	defer {
		temp.release()
	}
	return temp.to_i64()
}

pub fn (v PersistentOwnedZBox) to_f64() f64 {
	match v.kind {
		.dyn_data {
			return dyn_to_f64(v.dyn_data)
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return f64(0.0) }
	defer {
		temp.release()
	}
	return temp.to_f64()
}

pub fn (v PersistentOwnedZBox) call_owned_request(args []ZVal) ZVal {
	match v.kind {
		.dyn_data {
			return invalid_zval()
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return invalid_zval() }
	defer {
		temp.release()
	}
	return temp.call_owned_request(args)
}

pub fn (v PersistentOwnedZBox) method_owned_request(method string, args []ZVal) ZVal {
	match v.kind {
		.dyn_data {
			return invalid_zval()
		}
		else {}
	}
	mut temp := v.request_owned_non_dyn() or { return invalid_zval() }
	defer {
		temp.release()
	}
	return temp.method_owned_request(method, args)
}

pub fn borrowed_zbox_from_raw(raw &C.zval) RequestBorrowedZBox {
	return unsafe {
		borrow_zbox_raw(ZVal{
			raw:   raw
			owned: false
		})
	}
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
