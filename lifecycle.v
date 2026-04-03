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
	retained_object
}

pub struct PersistentOwnedZVal {
	ZValViewState
pub mut:
	kind     PersistentOwnedKind = .zval_data
	retained RetainedObject
}

// --- Developer-facing value API ---
// These wrappers keep the lifecycle model, but hide Zend-specific naming.
pub struct BorrowedValue {
	ZValViewState
}

pub struct Value {
	ZValViewState
}

pub struct PersistentValue {
	ZValViewState
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

pub fn BorrowedValue.from_zval(z ZVal) BorrowedValue {
	return BorrowedValue{
		ZValViewState: borrow_zval(z).ZValViewState
	}
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

pub fn Value.from_zval(z ZVal) Value {
	return Value{
		ZValViewState: own_request_zval(z).ZValViewState
	}
}

pub fn own_persistent_zval(z ZVal) PersistentOwnedZVal {
	if z.is_valid() && z.is_object() {
		if retained := RetainedObject.from_zval(z) {
			return PersistentOwnedZVal{
				ZValViewState: ZValViewState{
					z: invalid_zval()
				}
				kind: .retained_object
				retained: retained
			}
		}
	}
	return PersistentOwnedZVal{
		ZValViewState: ZValViewState{
			z: z.dup_persistent()
		}
		kind: .zval_data
	}
}

pub fn PersistentOwnedZVal.from_zval(z ZVal) PersistentOwnedZVal {
	return own_persistent_zval(z)
}

pub fn PersistentValue.from_zval(z ZVal) PersistentValue {
	return PersistentValue{
		ZValViewState: own_persistent_zval(z).clone_request_owned().ZValViewState
	}
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

pub fn Value.new_null() Value {
	return Value.from_zval(ZVal.new_null())
}

pub fn Value.new_int(n i64) Value {
	return Value.from_zval(ZVal.new_int(n))
}

pub fn Value.new_float(f f64) Value {
	return Value.from_zval(ZVal.new_float(f))
}

pub fn Value.new_bool(b bool) Value {
	return Value.from_zval(ZVal.new_bool(b))
}

pub fn Value.new_string(s string) Value {
	return Value.from_zval(ZVal.new_string(s))
}

pub fn PersistentOwnedZVal.new_null() PersistentOwnedZVal {
	return own_persistent_zval(ZVal.new_null())
}

pub fn PersistentOwnedZVal.invalid() PersistentOwnedZVal {
	return own_persistent_zval(ZVal.invalid())
}

pub fn PersistentOwnedZVal.new_int(n i64) PersistentOwnedZVal {
	return own_persistent_zval(ZVal.new_int(n))
}

pub fn PersistentOwnedZVal.new_float(f f64) PersistentOwnedZVal {
	return own_persistent_zval(ZVal.new_float(f))
}

pub fn PersistentOwnedZVal.new_bool(b bool) PersistentOwnedZVal {
	return own_persistent_zval(ZVal.new_bool(b))
}

pub fn PersistentOwnedZVal.new_string(s string) PersistentOwnedZVal {
	return own_persistent_zval(ZVal.new_string(s))
}

pub fn PersistentValue.new_null() PersistentValue {
	return PersistentValue.from_zval(ZVal.new_null())
}

pub fn PersistentValue.new_int(n i64) PersistentValue {
	return PersistentValue.from_zval(ZVal.new_int(n))
}

pub fn PersistentValue.new_float(f f64) PersistentValue {
	return PersistentValue.from_zval(ZVal.new_float(f))
}

pub fn PersistentValue.new_bool(b bool) PersistentValue {
	return PersistentValue.from_zval(ZVal.new_bool(b))
}

pub fn PersistentValue.new_string(s string) PersistentValue {
	return PersistentValue.from_zval(ZVal.new_string(s))
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

pub fn (mut v RequestOwnedZVal) release() {
	v.z.release()
}

pub fn (v PersistentOwnedZVal) borrowed() BorrowedZVal {
	match v.kind {
		.retained_object {
			return v.clone_request_owned().borrowed()
		}
		.zval_data {
			return borrow_zval(v.z)
		}
	}
}

pub fn (v PersistentOwnedZVal) clone_request_owned() RequestOwnedZVal {
	match v.kind {
		.retained_object {
			return RequestOwnedZVal.from_zval(v.retained.to_request_owned_zval())
		}
		.zval_data {
			return own_request_zval(v.z)
		}
	}
}

pub fn (mut v PersistentOwnedZVal) release() {
	match v.kind {
		.retained_object {
			mut retained := v.retained
			retained.release()
			v.retained = RetainedObject.invalid()
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
		.retained_object {
			return own_persistent_zval(v.retained.to_request_owned_zval())
		}
		.zval_data {
			return own_persistent_zval(v.z)
		}
	}
}

pub fn (v PersistentOwnedZVal) to_zval() ZVal {
	match v.kind {
		.retained_object {
			return v.retained.to_request_owned_zval()
		}
		.zval_data {
			return v.z
		}
	}
}

pub fn (v PersistentOwnedZVal) is_valid() bool {
	match v.kind {
		.retained_object {
			return v.retained.is_valid()
		}
		.zval_data {
			return v.z.is_valid()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_null() bool {
	match v.kind {
		.retained_object {
			return false
		}
		.zval_data {
			return v.z.is_null()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_undef() bool {
	match v.kind {
		.retained_object {
			return false
		}
		.zval_data {
			return v.z.is_undef()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_resource() bool {
	match v.kind {
		.retained_object {
			return false
		}
		.zval_data {
			return v.z.is_resource()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_callable() bool {
	match v.kind {
		.retained_object {
			return v.retained.to_request_owned_zval().is_callable()
		}
		.zval_data {
			return v.z.is_callable()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_object() bool {
	match v.kind {
		.retained_object {
			return true
		}
		.zval_data {
			return v.z.is_object()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_string() bool {
	match v.kind {
		.retained_object {
			return false
		}
		.zval_data {
			return v.z.is_string()
		}
	}
}

pub fn (v PersistentOwnedZVal) is_array() bool {
	match v.kind {
		.retained_object {
			return false
		}
		.zval_data {
			return v.z.is_array()
		}
	}
}

pub fn (v PersistentOwnedZVal) method_exists(name string) bool {
	return v.to_zval().method_exists(name)
}

pub fn (v PersistentOwnedZVal) to_string() string {
	return v.to_zval().to_string()
}

pub fn (v PersistentOwnedZVal) to_string_list() []string {
	return v.to_zval().to_string_list()
}

pub fn (v PersistentOwnedZVal) to_string_map() map[string]string {
	return v.to_zval().to_string_map()
}

pub fn (v PersistentOwnedZVal) resource_type() ?string {
	return v.to_zval().resource_type()
}

pub fn (v PersistentOwnedZVal) stream_metadata() ?StreamMetadata {
	return v.to_zval().stream_metadata()
}

pub fn (v PersistentOwnedZVal) to_bool() bool {
	return v.to_zval().to_bool()
}

pub fn (v PersistentOwnedZVal) to_int() int {
	return v.to_zval().to_int()
}

pub fn (v PersistentOwnedZVal) to_i64() i64 {
	return v.to_zval().to_i64()
}

pub fn (v PersistentOwnedZVal) to_f64() f64 {
	return v.to_zval().to_f64()
}

pub fn (v PersistentOwnedZVal) call_owned_request(args []ZVal) ZVal {
	return v.to_zval().call_owned_request(args)
}

pub fn (v PersistentOwnedZVal) method_owned_request(method string, args []ZVal) ZVal {
	return v.to_zval().method_owned_request(method, args)
}

pub fn (v BorrowedValue) own_request() Value {
	return Value{
		ZValViewState: own_request_zval(v.z).ZValViewState
	}
}

pub fn (v BorrowedValue) own_persistent() PersistentValue {
	return PersistentValue{
		ZValViewState: own_persistent_zval(v.z).ZValViewState
	}
}

pub fn (v Value) view() BorrowedValue {
	return BorrowedValue{
		ZValViewState: borrow_zval(v.z).ZValViewState
	}
}

pub fn (v Value) own_persistent() PersistentValue {
	return PersistentValue{
		ZValViewState: own_persistent_zval(v.z).ZValViewState
	}
}

pub fn (v Value) clone_value() Value {
	return Value{
		ZValViewState: own_request_zval(v.z).ZValViewState
	}
}

pub fn (mut v Value) release() {
	v.z.release()
}

pub fn (v PersistentValue) view() BorrowedValue {
	return BorrowedValue{
		ZValViewState: borrow_zval(v.z).ZValViewState
	}
}

pub fn (v PersistentValue) own_request() Value {
	return Value{
		ZValViewState: own_request_zval(v.z).ZValViewState
	}
}

pub fn (mut v PersistentValue) release() {
	v.z.release()
}

pub fn borrowed_zval_from_raw(raw &C.zval) BorrowedZVal {
	return unsafe {
		borrow_zval(ZVal{
			raw: raw
			owned: false
		})
	}
}

pub struct OwnedValue {
	ZValViewState
pub mut:
	lifetime OwnershipKind
}

pub fn borrow(z ZVal) BorrowedValue {
	return BorrowedValue{
		ZValViewState: ZValViewState{
			z: z
		}
	}
}

// own() keeps backward compatibility and now defaults to request lifetime.
pub fn own(z ZVal) OwnedValue {
	return own_request(z)
}

pub fn own_request(z ZVal) OwnedValue {
	owned := own_request_zval(z)
	return OwnedValue{
		ZValViewState: owned.ZValViewState
		lifetime: .owned_request
	}
}

pub fn own_persistent(z ZVal) OwnedValue {
	persistent := own_persistent_zval(z)
	return OwnedValue{
		ZValViewState: persistent.ZValViewState
		lifetime: .owned_persistent
	}
}

pub fn (v BorrowedValue) clone_owned() OwnedValue {
	return own_request(v.z)
}

pub fn (v BorrowedValue) clone_owned_request() OwnedValue {
	return own_request(v.z)
}

pub fn (v BorrowedValue) clone_owned_persistent() OwnedValue {
	return own_persistent(v.z)
}

pub fn (mut v OwnedValue) release() {
	v.z.release()
}

pub fn (v OwnedValue) ownership() OwnershipKind {
	return v.lifetime
}

pub fn borrowed_from_raw(raw &C.zval) BorrowedValue {
	return BorrowedValue{
		ZValViewState: borrowed_zval_from_raw(raw).ZValViewState
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
		mark: request_scope_enter()
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
