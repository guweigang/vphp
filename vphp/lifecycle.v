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
	is_callable() bool
	is_object() bool
	is_string() bool
	is_array() bool
	method_exists(name string) bool
	to_string() string
	to_string_list() []string
	to_string_map() map[string]string
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
// They all wrap ZVal, but encode lifetime in type-level API.
pub struct BorrowedZVal {
pub:
	z ZVal
}

pub struct RequestOwnedZVal {
pub mut:
	z ZVal
}

pub struct PersistentOwnedZVal {
pub mut:
	z ZVal
}

pub fn borrow_zval(z ZVal) BorrowedZVal {
	return BorrowedZVal{
		z: z
	}
}

pub fn BorrowedZVal.from_zval(z ZVal) BorrowedZVal {
	return borrow_zval(z)
}

// null borrowed helper for call-site ergonomics; lifetime is request-scoped.
pub fn BorrowedZVal.null() BorrowedZVal {
	return RequestOwnedZVal.new_null().borrowed()
}

pub fn own_request_zval(z ZVal) RequestOwnedZVal {
	return RequestOwnedZVal{
		z: z.dup()
	}
}

pub fn RequestOwnedZVal.from_zval(z ZVal) RequestOwnedZVal {
	return own_request_zval(z)
}

pub fn own_persistent_zval(z ZVal) PersistentOwnedZVal {
	return PersistentOwnedZVal{
		z: z.dup_persistent()
	}
}

pub fn PersistentOwnedZVal.from_zval(z ZVal) PersistentOwnedZVal {
	return own_persistent_zval(z)
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
	return own_persistent_zval(ZVal.new_null())
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

pub fn (v BorrowedZVal) to_zval() ZVal {
	return v.z
}

pub fn (v BorrowedZVal) is_valid() bool {
	return v.z.is_valid()
}

pub fn (v BorrowedZVal) is_null() bool {
	return v.z.is_null()
}

pub fn (v BorrowedZVal) is_undef() bool {
	return v.z.is_undef()
}

pub fn (v BorrowedZVal) is_callable() bool {
	return v.z.is_callable()
}

pub fn (v BorrowedZVal) is_object() bool {
	return v.z.is_object()
}

pub fn (v BorrowedZVal) is_string() bool {
	return v.z.is_string()
}

pub fn (v BorrowedZVal) is_array() bool {
	return v.z.is_array()
}

pub fn (v BorrowedZVal) method_exists(name string) bool {
	return v.z.method_exists(name)
}

pub fn (v BorrowedZVal) to_string() string {
	return v.z.to_string()
}

pub fn (v BorrowedZVal) to_string_list() []string {
	return v.z.to_string_list()
}

pub fn (v BorrowedZVal) to_string_map() map[string]string {
	return v.z.to_string_map()
}

pub fn (v BorrowedZVal) to_bool() bool {
	return v.z.to_bool()
}

pub fn (v BorrowedZVal) to_int() int {
	return v.z.to_int()
}

pub fn (v BorrowedZVal) to_i64() i64 {
	return v.z.to_i64()
}

pub fn (v BorrowedZVal) to_f64() f64 {
	return v.z.to_f64()
}

pub fn (v BorrowedZVal) to_v[T]() !T {
	return v.z.to_v[T]()
}

pub fn (v BorrowedZVal) call_owned_request(args []ZVal) ZVal {
	return v.z.call_owned_request(args)
}

pub fn (v BorrowedZVal) method_owned_request(method string, args []ZVal) ZVal {
	return v.z.method_owned_request(method, args)
}

pub fn (v BorrowedZVal) clone_request_owned() RequestOwnedZVal {
	return own_request_zval(v.z)
}

pub fn (v BorrowedZVal) clone_persistent_owned() PersistentOwnedZVal {
	return own_persistent_zval(v.z)
}

pub fn (v RequestOwnedZVal) to_zval() ZVal {
	return v.z
}

pub fn (v RequestOwnedZVal) is_valid() bool {
	return v.z.is_valid()
}

pub fn (v RequestOwnedZVal) is_null() bool {
	return v.z.is_null()
}

pub fn (v RequestOwnedZVal) is_undef() bool {
	return v.z.is_undef()
}

pub fn (v RequestOwnedZVal) is_callable() bool {
	return v.z.is_callable()
}

pub fn (v RequestOwnedZVal) is_object() bool {
	return v.z.is_object()
}

pub fn (v RequestOwnedZVal) is_string() bool {
	return v.z.is_string()
}

pub fn (v RequestOwnedZVal) is_array() bool {
	return v.z.is_array()
}

pub fn (v RequestOwnedZVal) method_exists(name string) bool {
	return v.z.method_exists(name)
}

pub fn (v RequestOwnedZVal) to_string() string {
	return v.z.to_string()
}

pub fn (v RequestOwnedZVal) to_string_list() []string {
	return v.z.to_string_list()
}

pub fn (v RequestOwnedZVal) to_string_map() map[string]string {
	return v.z.to_string_map()
}

pub fn (v RequestOwnedZVal) to_bool() bool {
	return v.z.to_bool()
}

pub fn (v RequestOwnedZVal) to_int() int {
	return v.z.to_int()
}

pub fn (v RequestOwnedZVal) to_i64() i64 {
	return v.z.to_i64()
}

pub fn (v RequestOwnedZVal) to_f64() f64 {
	return v.z.to_f64()
}

pub fn (v RequestOwnedZVal) to_v[T]() !T {
	return v.z.to_v[T]()
}

pub fn (v RequestOwnedZVal) call_owned_request(args []ZVal) ZVal {
	return v.z.call_owned_request(args)
}

pub fn (v RequestOwnedZVal) method_owned_request(method string, args []ZVal) ZVal {
	return v.z.method_owned_request(method, args)
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

pub fn (v PersistentOwnedZVal) to_zval() ZVal {
	return v.z
}

pub fn (v PersistentOwnedZVal) is_valid() bool {
	return v.z.is_valid()
}

pub fn (v PersistentOwnedZVal) is_null() bool {
	return v.z.is_null()
}

pub fn (v PersistentOwnedZVal) is_undef() bool {
	return v.z.is_undef()
}

pub fn (v PersistentOwnedZVal) is_callable() bool {
	return v.z.is_callable()
}

pub fn (v PersistentOwnedZVal) is_object() bool {
	return v.z.is_object()
}

pub fn (v PersistentOwnedZVal) is_string() bool {
	return v.z.is_string()
}

pub fn (v PersistentOwnedZVal) is_array() bool {
	return v.z.is_array()
}

pub fn (v PersistentOwnedZVal) method_exists(name string) bool {
	return v.z.method_exists(name)
}

pub fn (v PersistentOwnedZVal) to_string() string {
	return v.z.to_string()
}

pub fn (v PersistentOwnedZVal) to_string_list() []string {
	return v.z.to_string_list()
}

pub fn (v PersistentOwnedZVal) to_string_map() map[string]string {
	return v.z.to_string_map()
}

pub fn (v PersistentOwnedZVal) to_bool() bool {
	return v.z.to_bool()
}

pub fn (v PersistentOwnedZVal) to_int() int {
	return v.z.to_int()
}

pub fn (v PersistentOwnedZVal) to_i64() i64 {
	return v.z.to_i64()
}

pub fn (v PersistentOwnedZVal) to_f64() f64 {
	return v.z.to_f64()
}

pub fn (v PersistentOwnedZVal) to_v[T]() !T {
	return v.z.to_v[T]()
}

pub fn (v PersistentOwnedZVal) call_owned_request(args []ZVal) ZVal {
	return v.z.call_owned_request(args)
}

pub fn (v PersistentOwnedZVal) method_owned_request(method string, args []ZVal) ZVal {
	return v.z.method_owned_request(method, args)
}

pub fn (v PersistentOwnedZVal) borrowed() BorrowedZVal {
	return borrow_zval(v.z)
}

pub fn (v PersistentOwnedZVal) clone_request_owned() RequestOwnedZVal {
	return own_request_zval(v.z)
}

pub fn (mut v PersistentOwnedZVal) release() {
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

// --- Compatibility wrappers (kept for existing code) ---
pub struct OwnedValue {
pub mut:
	z        ZVal
	lifetime OwnershipKind
}

pub struct BorrowedValue {
pub:
	z ZVal
}

pub fn borrow(z ZVal) BorrowedValue {
	return BorrowedValue{ z: z }
}

// own() keeps backward compatibility and now defaults to request lifetime.
pub fn own(z ZVal) OwnedValue {
	return own_request(z)
}

pub fn own_request(z ZVal) OwnedValue {
	owned := own_request_zval(z)
	return OwnedValue{
		z: owned.z
		lifetime: .owned_request
	}
}

pub fn own_persistent(z ZVal) OwnedValue {
	persistent := own_persistent_zval(z)
	return OwnedValue{
		z: persistent.z
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
		z: borrowed_zval_from_raw(raw).z
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
