module vphp

// ============================================
// ZVal — low-level bridge wrapper around Zend zval
// NOTE:
// - This type is intended for vphp bridge internals.
// - Extension/framework code should prefer ownership-aware wrappers in
//   lifecycle.v, with `RequestBorrowedZBox` / `RequestOwnedZBox` /
//   `PersistentOwnedZBox` as the primary public naming.
// ============================================

pub struct ZVal {
pub mut:
	raw           &C.zval
	owned         bool
	is_persistent bool
}

// Callable — semantic alias for ZVal used as a PHP callable parameter.
// When used as a method parameter type, the compiler emits ZEND_ARG_CALLABLE_INFO
// so PHP reflection sees the parameter as 'callable' typed.
pub type Callable = ZVal

pub struct RuntimeCounters {
pub:
	autorelease_len              int
	owned_len                    int
	obj_registry_len             u32
	rev_registry_len             u32
	persistent_fallback_zval_len int
}

fn C.vphp_release_zval(z &C.zval)
fn C.vphp_release_zval_persistent(z &C.zval)
fn C.vphp_disown_zval(z &C.zval)

pub struct StreamMetadata {
pub:
	mode      string
	uri       string
	seekable  bool
	timed_out bool
	blocked   bool
	eof       bool
}

fn invalid_zval() ZVal {
	return unsafe {
		ZVal{
			raw: 0
		}
	}
}

pub fn ZVal.invalid() ZVal {
	return invalid_zval()
}

fn adopt_raw_with_ownership(raw &C.zval, ownership OwnershipKind) ZVal {
	if raw == 0 {
		return invalid_zval()
	}
	mut out := unsafe {
		ZVal{
			raw:   raw
			owned: true
		}
	}
	if ownership == .owned_request {
		autorelease_add(out.raw)
		if out.is_object() {
			autorelease_forget(out.raw)
		}
	}
	return out
}

fn clone_raw_with_ownership(src &C.zval, ownership OwnershipKind) ZVal {
	if src == 0 {
		return invalid_zval()
	}
	mut out := ZVal{
		raw:           if ownership == .owned_persistent {
			C.vphp_new_persistent_zval()
		} else {
			C.vphp_new_zval()
		}
		owned:         true
		is_persistent: ownership == .owned_persistent
	}
	C.ZVAL_COPY(out.raw, src)
	if ownership == .owned_request {
		autorelease_add(out.raw)
		if out.is_object() {
			autorelease_forget(out.raw)
		}
	}
	return out
}

fn adopt_read_result(rv &C.zval, res &C.zval, ownership OwnershipKind) ZVal {
	if rv == 0 {
		return invalid_zval()
	}
	if res == 0 {
		C.vphp_release_zval(rv)
		return invalid_zval()
	}
	if usize(res) == usize(rv) {
		return adopt_raw_with_ownership(rv, ownership)
	}
	C.vphp_release_zval(rv)
	if ownership == .borrowed {
		return unsafe {
			ZVal{
				raw: res
			}
		}
	}
	return clone_raw_with_ownership(res, ownership)
}

pub fn autorelease_mark() int {
	return C.vphp_autorelease_mark()
}

fn autorelease_add(z &C.zval) {
	if z == 0 {
		return
	}
	C.vphp_autorelease_add(z)
}

fn autorelease_forget(z &C.zval) {
	if z == 0 {
		return
	}
	C.vphp_autorelease_forget(z)
}

pub fn autorelease_drain(mark int) {
	C.vphp_autorelease_drain(mark)
}

// Request scope helpers for frameworks (supports nested scopes).
pub fn request_scope_enter() int {
	return autorelease_mark()
}

pub fn request_scope_leave(mark int) {
	autorelease_drain(mark)
}

pub fn runtime_counters() RuntimeCounters {
	mut ar := 0
	mut owned := 0
	mut obj_reg := u32(0)
	mut rev_reg := u32(0)
	C.vphp_runtime_counters(&ar, &owned, &obj_reg, &rev_reg)
	return RuntimeCounters{
		autorelease_len:              ar
		owned_len:                    owned
		obj_registry_len:             obj_reg
		rev_registry_len:             rev_reg
		persistent_fallback_zval_len: persistent_fallback_zval_count()
	}
}

// ======== 空值检查 ========

pub fn (v ZVal) is_valid() bool {
	return v.raw != 0
}

// ======== 类型判断 ========

pub fn (v ZVal) type_raw() int {
	if v.raw == 0 {
		return int(PHPType.undef)
	}
	return C.vphp_get_type(v.raw)
}

pub fn (v ZVal) type_id() PHPType {
	return PHPType.from_id(v.type_raw())
}

pub fn (v ZVal) is_undef() bool {
	return v.type_id() == .undef
}

pub fn (v ZVal) is_null() bool {
	return v.type_id() == .null
}

pub fn (v ZVal) is_bool() bool {
	return v.type_id().is_bool()
}

pub fn (v ZVal) is_long() bool {
	return v.type_id() == .long
}

pub fn (v ZVal) is_double() bool {
	return v.type_id() == .double
}

pub fn (v ZVal) is_numeric() bool {
	return v.type_id().is_numeric()
}

pub fn (v ZVal) is_string() bool {
	return v.type_id() == .string
}

pub fn (v ZVal) is_array() bool {
	return v.type_id() == .array
}

pub fn (v ZVal) is_list() bool {
	if !v.is_array() {
		return false
	}
	if !function_exists('array_is_list') {
		state := v.fold[ListCheckState](ListCheckState{}, fn (key ZVal, _ ZVal, mut acc ListCheckState) {
			if !acc.ok {
				return
			}
			if !key.is_long() || key.to_i64() != acc.expected {
				acc.ok = false
				return
			}
			acc.expected++
		})
		return state.ok
	}
	res := php_fn('array_is_list').call([v])
	return res.is_valid() && res.to_bool()
}

struct ListCheckState {
mut:
	expected i64
	ok       bool = true
}

pub fn (v ZVal) is_object() bool {
	return v.type_id() == .object
}

pub fn (v ZVal) is_resource() bool {
	return v.type_id() == .resource
}

pub fn (v ZVal) resource_type() ?string {
	if !v.is_valid() || !v.is_resource() {
		return none
	}
	res := php_fn('get_resource_type').call([v])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return none
	}
	type_name := res.to_string().trim_space()
	if type_name == '' {
		return none
	}
	return type_name
}

pub fn (v ZVal) stream_metadata() ?StreamMetadata {
	if !v.is_valid() || !v.is_resource() {
		return none
	}
	resource_type := v.resource_type() or { return none }
	if resource_type != 'stream' {
		return none
	}
	meta := php_fn('stream_get_meta_data').call([v])
	if !meta.is_valid() || !meta.is_array() {
		return none
	}
	return StreamMetadata{
		mode:      zval_string_key_or(meta, 'mode', '')
		uri:       zval_string_key_or(meta, 'uri', '')
		seekable:  zval_bool_key_or(meta, 'seekable', false)
		timed_out: zval_bool_key_or(meta, 'timed_out', false)
		blocked:   zval_bool_key_or(meta, 'blocked', false)
		eof:       zval_bool_key_or(meta, 'eof', false)
	}
}

pub fn (v ZVal) is_stream_resource() bool {
	return v.stream_metadata() != none
}

pub fn (v ZVal) stream_rewind() bool {
	if !v.is_stream_resource() {
		return false
	}
	res := php_fn('rewind').call([v])
	return res.is_valid() && (!res.is_bool() || res.to_bool())
}

pub fn (v ZVal) stream_get_contents() ?string {
	if !v.is_stream_resource() {
		return none
	}
	content := php_fn('stream_get_contents').call([v])
	if !content.is_valid() || content.is_null() || content.is_undef()
		|| (content.is_bool() && !content.to_bool()) {
		return none
	}
	return content.to_string()
}

pub fn (v ZVal) stream_eof() bool {
	if !v.is_stream_resource() {
		return true
	}
	res := php_fn('feof').call([v])
	return res.is_valid() && res.to_bool()
}

pub fn (v ZVal) stream_read_line() ?string {
	if !v.is_stream_resource() {
		return none
	}
	line := php_fn('fgets').call([v])
	if !line.is_valid() || line.is_null() || line.is_undef() || (line.is_bool() && !line.to_bool()) {
		return none
	}
	return line.to_string()
}

pub fn (v ZVal) stream_close() bool {
	if !v.is_stream_resource() {
		return false
	}
	res := php_fn('fclose').call([v])
	return res.is_valid() && (!res.is_bool() || res.to_bool())
}

pub fn (v ZVal) is_callable() bool {
	return C.vphp_is_callable(v.raw) == 1
}

pub fn (v ZVal) to_callable() ?Callable {
	if !v.is_callable() {
		return none
	}
	return Callable(v)
}

pub fn (v ZVal) must_callable() !Callable {
	callable := v.to_callable() or { return error('zval is not callable') }
	return callable
}

pub fn (v ZVal) type_name() string {
	return v.type_id().name()
}

// ======== 读取 — 标量类型 ========

// bool
pub fn (v ZVal) to_bool() bool {
	return v.type_id() == .true_
}

pub fn (v ZVal) get_bool() bool {
	return unsafe { C.zval_get_long(v.raw) != 0 }
}

// int / i64
pub fn (v ZVal) to_int() int {
	return int(C.vphp_get_int(v.raw))
}

pub fn (v ZVal) to_i64() i64 {
	return i64(C.vphp_get_int(v.raw))
}

// 兼容旧 API
pub fn (v ZVal) as_int() i64 {
	return C.vphp_get_lval(v.raw)
}

pub fn (v ZVal) get_int() i64 {
	return unsafe { C.zval_get_long(v.raw) }
}

// float / f64
pub fn (v ZVal) to_f64() f64 {
	return C.vphp_get_double(v.raw)
}

pub fn (v ZVal) to_float() f64 {
	return C.vphp_get_double(v.raw)
}

// string
pub fn (v ZVal) to_string() string {
	if !v.is_valid() || v.is_null() || v.is_undef() {
		return ''
	}
	if v.is_string() {
		return v.get_string()
	}
	if v.is_bool() {
		return if v.get_bool() { '1' } else { '' }
	}
	if v.is_long() {
		return v.to_i64().str()
	}
	if v.is_double() {
		return v.to_f64().str()
	}
	text := php_fn('strval').call([v])
	if text.is_valid() && text.is_string() {
		return text.get_string()
	}
	return ''
}

pub fn (v ZVal) get_string() string {
	unsafe {
		ptr := C.VPHP_Z_STRVAL(v.raw)
		len := C.VPHP_Z_STRLEN(v.raw)
		if ptr == 0 {
			return ''
		}
		return ptr.vstring_with_len(len).clone()
	}
}

// resource
pub fn (v ZVal) to_res() voidptr {
	return C.vphp_fetch_res(v.raw)
}

// ======== 写入 — 标量类型 ========

pub fn (v ZVal) set_null() {
	unsafe { C.vphp_set_null(v.raw) }
}

pub fn (v ZVal) set_bool(b bool) {
	unsafe { C.vphp_set_bool(v.raw, b) }
}

pub fn (v ZVal) set_int(val i64) {
	unsafe { C.vphp_set_lval(v.raw, val) }
}

pub fn (v ZVal) set_double(val f64) {
	unsafe { C.vphp_set_double(v.raw, val) }
}

pub fn (v ZVal) set_float(val f64) {
	unsafe { C.vphp_set_double(v.raw, val) }
}

pub fn (v ZVal) set_string(s string) {
	unsafe { C.vphp_set_strval(v.raw, &char(s.str), s.len) }
}
