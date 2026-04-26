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

// ======== 数组操作 ========

// 初始化为数组
pub fn (v ZVal) array_init() {
	unsafe { C.vphp_return_array_start(v.raw) }
}

pub fn (v ZVal) add_assoc_string(key string, val string) {
	unsafe { C.vphp_array_add_assoc_string(v.raw, &char(key.str), &char(val.str)) }
}

pub fn (v ZVal) add_assoc_long(key string, val i64) {
	unsafe { C.vphp_array_add_assoc_long(v.raw, &char(key.str), val) }
}

pub fn (v ZVal) add_assoc_double(key string, val f64) {
	unsafe { C.vphp_array_add_assoc_double(v.raw, &char(key.str), val) }
}

pub fn (v ZVal) add_assoc_bool(key string, val bool) {
	unsafe {
		b_val := if val { 1 } else { 0 }
		C.vphp_array_add_assoc_bool(v.raw, &char(key.str), b_val)
	}
}

pub fn (v ZVal) push_string(s string) {
	unsafe { C.vphp_array_push_stringl(v.raw, &char(s.str), s.len) }
}

pub fn (v ZVal) push_long(val i64) {
	unsafe { C.vphp_array_push_long(v.raw, val) }
}

pub fn (v ZVal) push_double(val f64) {
	unsafe { C.vphp_array_push_double(v.raw, val) }
}

pub fn (v ZVal) push_bool(val bool) {
	unsafe {
		b_val := if val { 1 } else { 0 }
		C.vphp_array_push_long(v.raw, b_val)
	}
}

pub fn (v ZVal) add_next_val(val ZVal) {
	unsafe { C.vphp_array_add_next_zval(v.raw, val.raw) }
}

// 获取数组长度
pub fn (v ZVal) array_count() int {
	if !v.is_array() {
		return 0
	}
	return C.vphp_array_count(v.raw)
}

// 按数字索引取值
pub fn (v ZVal) array_get(index int) ZVal {
	if !v.is_array() {
		return unsafe {
			ZVal{
				raw: 0
			}
		}
	}
	res := C.vphp_array_get_index(v.raw, u32(index))
	return ZVal{
		raw: res
	}
}

pub fn (v ZVal) keys() ZVal {
	if !v.is_array() {
		mut out := ZVal.new_null()
		out.array_init()
		return out
	}
	mut out := ZVal.new_null()
	out.array_init()
	v.foreach_with_ctx[ZVal](out, fn (key ZVal, _ ZVal, mut acc ZVal) {
		acc.add_next_val(key)
	})
	return out
}

pub fn (v ZVal) values() ZVal {
	if !v.is_array() {
		mut out := ZVal.new_null()
		out.array_init()
		return out
	}
	mut out := ZVal.new_null()
	out.array_init()
	v.foreach_with_ctx[ZVal](out, fn (_ ZVal, val ZVal, mut acc ZVal) {
		acc.add_next_val(val)
	})
	return out
}

pub fn (v ZVal) keys_string() []string {
	if !v.is_array() {
		return []string{}
	}
	return v.foreach_with_ctx[[]string]([]string{}, fn (key ZVal, _ ZVal, mut acc []string) {
		acc << key.to_string()
	})
}

pub fn (v ZVal) assoc_keys() []string {
	if !v.is_array() {
		return []string{}
	}
	return v.foreach_with_ctx[[]string]([]string{}, fn (key ZVal, _ ZVal, mut acc []string) {
		if key.is_string() {
			acc << key.get_string()
		}
	})
}

// 按字符串 key 取值（带错误处理）
pub fn (v ZVal) get(key string) !ZVal {
	if v.raw == 0 || C.vphp_is_null(v.raw) {
		return error('invalid zval or not an array')
	}
	unsafe {
		res := C.vphp_array_get_key(v.raw, &char(key.str), key.len)
		if res == 0 || C.vphp_is_null(res) {
			return error('key "${key}" not found')
		}
		return ZVal{
			raw: res
		}
	}
}

pub fn (v ZVal) get_key(key ZVal) !ZVal {
	if v.raw == 0 || C.vphp_is_null(v.raw) {
		return error('invalid zval or not an array')
	}
	if key.is_long() {
		index := key.to_i64()
		if index < 0 {
			return error('negative array index ${index} is not supported')
		}
		res := C.vphp_array_get_index(v.raw, u32(index))
		if res == 0 || C.vphp_is_null(res) {
			return error('index ${index} not found')
		}
		return ZVal{
			raw: res
		}
	}
	if key.is_string() {
		return v.get(key.to_string())
	}
	return error('unsupported array key type: ${key.type_name()}')
}

// 按字符串 key 取值（返回默认值）
pub fn (v ZVal) get_or(key string, default_val string) string {
	val := v.get(key) or { return default_val }
	return val.to_string()
}

fn zval_string_key_or(input ZVal, key string, default_value string) string {
	raw := input.get(key) or { return default_value }
	if !raw.is_valid() || raw.is_null() || raw.is_undef() {
		return default_value
	}
	return raw.to_string()
}

fn zval_bool_key_or(input ZVal, key string, default_value bool) bool {
	raw := input.get(key) or { return default_value }
	if !raw.is_valid() || raw.is_null() || raw.is_undef() {
		return default_value
	}
	if raw.is_bool() {
		return raw.to_bool()
	}
	if raw.is_long() {
		return raw.to_i64() != 0
	}
	return raw.to_string().trim_space().to_lower() in ['1', 'true', 'yes', 'on']
}

// ======== 对象属性与类元信息 ========

// -------- 对象属性操作 --------
pub fn (v ZVal) add_property_string(key string, val string) {
	unsafe { C.add_property_stringl(v.raw, &char(key.str), &char(val.str), val.len) }
}

pub fn (v ZVal) add_property_long(key string, val i64) {
	unsafe { C.add_property_long(v.raw, &char(key.str), val) }
}

pub fn (v ZVal) add_property_double(key string, val f64) {
	unsafe { C.vphp_add_property_double(v.raw, &char(key.str), val) }
}

pub fn (v ZVal) add_property_bool(key string, val bool) {
	unsafe { C.add_property_bool(v.raw, &char(key.str), val) }
}

// 通用属性获取：返回一个新的 ZVal
pub fn (v ZVal) get_prop(name string) ZVal {
	return v.prop_owned_request(name)
}

pub fn (v ZVal) prop_borrowed(name string) ZVal {
	if !v.is_object() {
		return invalid_zval()
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	rv := C.vphp_new_zval()
	res := C.vphp_read_property_compat(obj, &char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .borrowed)
}

pub fn (v ZVal) prop_owned_request(name string) ZVal {
	if !v.is_object() {
		return invalid_zval()
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	rv := C.vphp_new_zval()
	res := C.vphp_read_property_compat(obj, &char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_request)
}

pub fn (v ZVal) prop_owned_persistent(name string) ZVal {
	if !v.is_object() {
		return invalid_zval()
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	rv := C.vphp_new_zval()
	res := C.vphp_read_property_compat(obj, &char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_persistent)
}

pub fn (v ZVal) prop(name string) ZVal {
	return v.prop_owned_request(name)
}

pub fn (v ZVal) set_prop(name string, value ZVal) {
	if !v.is_object() || value.raw == 0 {
		return
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	C.vphp_write_property_compat(obj, &char(name.str), name.len, value.raw)
}

pub fn (v ZVal) has_prop(name string) bool {
	if !v.is_object() {
		return false
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	return C.vphp_has_property_compat(obj, &char(name.str), name.len) == 1
}

pub fn (v ZVal) isset_prop(name string) bool {
	if !v.is_object() {
		return false
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	return C.vphp_isset_property_compat(obj, &char(name.str), name.len) == 1
}

pub fn (v ZVal) unset_prop(name string) {
	if !v.is_object() {
		return
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	C.vphp_unset_property_compat(obj, &char(name.str), name.len)
}

// 快捷方式：属性 → string
pub fn (v ZVal) get_prop_string(name string) string {
	prop := v.get_prop(name)
	if prop.raw == 0 || prop.is_null() {
		return ''
	}
	return prop.to_string()
}

// 快捷方式：属性 → int
pub fn (v ZVal) get_prop_int(name string) int {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return 0
	}
	return int(C.vphp_get_int(prop.raw))
}

// 快捷方式：属性 → i64
pub fn (v ZVal) get_prop_i64(name string) i64 {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return 0
	}
	return i64(C.vphp_get_int(prop.raw))
}

// 快捷方式：属性 → f64
pub fn (v ZVal) get_prop_float(name string) f64 {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return 0.0
	}
	return C.vphp_get_double(prop.raw)
}

// 快捷方式：属性 → bool
pub fn (v ZVal) get_prop_bool(name string) bool {
	prop := v.get_prop(name)
	if prop.raw == 0 {
		return false
	}
	return prop.to_bool()
}

// -------- 类元信息 / introspection --------
pub fn (v ZVal) class_name() string {
	if v.raw == 0 {
		return ''
	}
	if v.is_string() {
		return v.to_string()
	}
	if !v.is_object() {
		return ''
	}
	unsafe {
		mut len := 0
		name := C.vphp_get_object_class_name(v.raw, &len)
		if name == 0 || len <= 0 {
			return ''
		}
		return name.vstring_with_len(len).clone()
	}
}

pub fn (v ZVal) namespace_name() string {
	class_name := v.class_name()
	if !class_name.contains('\\') {
		return ''
	}
	return class_name.all_before_last('\\')
}

pub fn (v ZVal) short_name() string {
	class_name := v.class_name()
	if !class_name.contains('\\') {
		return class_name
	}
	return class_name.all_after_last('\\')
}

pub fn (v ZVal) parent_class_name() string {
	if v.raw == 0 {
		return ''
	}
	unsafe {
		mut len := 0
		name := C.vphp_get_parent_class_name(v.raw, &len)
		if name == 0 || len <= 0 {
			return ''
		}
		return name.vstring_with_len(len).clone()
	}
}

pub fn (v ZVal) is_internal_class() bool {
	if v.raw == 0 {
		return false
	}
	return C.vphp_class_is_internal(v.raw) == 1
}

pub fn (v ZVal) is_user_class() bool {
	return !v.is_internal_class()
}

pub fn (v ZVal) interface_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	interfaces := php_fn('class_implements').call([ZVal.new_string(class_name)])
	if !interfaces.is_array() {
		return []string{}
	}
	mut out := []string{}
	out = interfaces.foreach_with_ctx[[]string](out, fn (_ ZVal, val ZVal, mut acc []string) {
		acc << val.to_string()
	})
	out.sort()
	return out
}

pub fn (v ZVal) is_instance_of(name string) bool {
	if v.raw == 0 {
		return false
	}
	res := php_fn('is_a').call([v, ZVal.new_string(name), ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}

pub fn (v ZVal) is_subclass_of(name string) bool {
	if v.raw == 0 {
		return false
	}
	res := php_fn('is_subclass_of').call([v, ZVal.new_string(name),
		ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}

pub fn (v ZVal) implements_interface(name string) bool {
	if name.len == 0 {
		return false
	}
	return name in v.interface_names()
}

pub fn (v ZVal) method_exists(name string) bool {
	if v.raw == 0 {
		return false
	}
	res := php_fn('method_exists').call([v, ZVal.new_string(name)])
	return res.is_valid() && res.to_bool()
}

pub fn (v ZVal) property_exists(name string) bool {
	if v.raw == 0 {
		return false
	}
	res := php_fn('property_exists').call([v, ZVal.new_string(name)])
	return res.is_valid() && res.to_bool()
}

pub fn (v ZVal) method_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	methods := php_class('ReflectionClass').construct([
		ZVal.new_string(class_name),
	]).method('getMethods', [])
	if !methods.is_array() {
		return []string{}
	}
	mut out := []string{}
	out = methods.foreach_with_ctx[[]string](out, fn (_ ZVal, val ZVal, mut acc []string) {
		acc << val.method('getName', []).to_string()
	})
	out.sort()
	return out
}

pub fn (v ZVal) property_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	props := php_class('ReflectionClass').construct([
		ZVal.new_string(class_name),
	]).method('getProperties', [])
	if !props.is_array() {
		return []string{}
	}
	mut out := []string{}
	out = props.foreach_with_ctx[[]string](out, fn (_ ZVal, val ZVal, mut acc []string) {
		acc << val.method('getName', []).to_string()
	})
	out.sort()
	return out
}

pub fn (v ZVal) const_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	consts := php_class('ReflectionClass').construct([
		ZVal.new_string(class_name),
	]).method('getConstants', [])
	mut out := consts.foreach_with_ctx[[]string]([]string{}, fn (k ZVal, _ ZVal, mut acc []string) {
		acc << k.to_string()
	})
	out.sort()
	return out
}

pub fn (v ZVal) const_exists(name string) bool {
	class_name := v.class_name()
	if class_name.len == 0 {
		return false
	}
	rc := php_class('ReflectionClass').construct([
		ZVal.new_string(class_name),
	])
	res := rc.method('hasConstant', [ZVal.new_string(name)])
	return res.is_valid() && res.to_bool()
}

// ======== PHP interop ========
// 和 `docs/interop.md` 保持一致的分层：
// 1. base actions
// 2. typed value helpers
// 3. typed object helpers
// 4. compatibility aliases

// -------- Base actions --------

// 调用对象方法：$obj->method(args...)
pub fn (v ZVal) method_owned_request(method string, args []ZVal) ZVal {
	if v.raw == 0 || !v.is_object() {
		return invalid_zval()
	}

	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}

		res := C.vphp_call_method(v.raw, &char(method.str), method.len, retval, args.len,
			p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		mut result := adopt_raw_with_ownership(retval, .owned_request)
		if result.is_object() {
			autorelease_forget(result.raw)
		}
		return result
	}
}

pub fn (v ZVal) method_owned_persistent(method string, args []ZVal) ZVal {
	if v.raw == 0 || !v.is_object() {
		return invalid_zval()
	}
	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}
		res := C.vphp_call_method(v.raw, &char(method.str), method.len, retval, args.len,
			p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_persistent)
	}
}

pub fn (v ZVal) method(method string, args []ZVal) ZVal {
	return v.method_owned_request(method, args)
}

// 调用 callable（闭包、匿名函数、函数名字符串等）
pub fn (v ZVal) call_owned_request(args []ZVal) ZVal {
	if v.raw == 0 {
		framework_debug_log('zval.call_owned_request skip raw=0 args=${args.len}')
		return invalid_zval()
	}
	framework_debug_log('zval.call_owned_request enter raw=${usize(v.raw)} valid=${v.is_valid()} type=${v.type_name()} class=${v.class_name()} args=${args.len}')
	for idx, arg in args {
		framework_debug_log('zval.call_owned_request arg idx=${idx} raw=${usize(arg.raw)} valid=${arg.is_valid()} type=${arg.type_name()} class=${arg.class_name()}')
	}

	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}

		res := C.vphp_call_callable(v.raw, retval, args.len, p_args)
		if res == -1 {
			framework_debug_log('zval.call_owned_request failure raw=${usize(v.raw)} retval=${usize(retval)}')
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		mut result := adopt_raw_with_ownership(retval, .owned_request)
		if result.is_object() {
			autorelease_forget(result.raw)
		}
		framework_debug_log('zval.call_owned_request exit raw=${usize(v.raw)} retval=${usize(result.raw)} valid=${result.is_valid()} type=${result.type_name()} class=${result.class_name()}')
		return result
	}
}

pub fn (v ZVal) call_owned_persistent(args []ZVal) ZVal {
	if v.raw == 0 {
		return invalid_zval()
	}
	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}
		res := C.vphp_call_callable(v.raw, retval, args.len, p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_persistent)
	}
}

pub fn (v ZVal) call(args []ZVal) ZVal {
	return v.call_owned_request(args)
}

pub fn (v ZVal) must_call(args []ZVal) !ZVal {
	callable := v.must_callable()!
	res := callable.call(args)
	if !res.is_valid() {
		return error('callable invocation failed')
	}
	return res
}

pub fn (v ZVal) dup() ZVal {
	if v.raw == 0 {
		return invalid_zval()
	}
	return clone_raw_with_ownership(v.raw, .owned_request)
}

pub fn (mut v ZVal) release() {
	if v.raw == 0 || !v.owned {
		return
	}
	autorelease_forget(v.raw)
	unsafe {
		if v.is_persistent {
			C.vphp_release_zval_persistent(v.raw)
		} else {
			C.vphp_release_zval(v.raw)
		}
	}
	v.raw = unsafe { nil }
	v.owned = false
	v.is_persistent = false
}

pub fn (v ZVal) dup_persistent() ZVal {
	if v.raw == 0 {
		return invalid_zval()
	}
	return clone_raw_with_ownership(v.raw, .owned_persistent)
}

// Duplicate and keep beyond current autorelease scope.
// dup_escaped creates an emalloc'd copy that escapes the current autorelease
// scope. The zval is still request-scoped memory — it will NOT survive across
// PHP requests. Use dup_persistent() for truly long-lived storage.
pub fn (v ZVal) dup_escaped() ZVal {
	mut out := v.dup()
	autorelease_forget(out.raw)
	return out
}

// current_this_owned_request captures the current PHP `$this` object as a
// request-owned ZVal so framework code can safely re-enter user-visible
// methods without hand-constructing object wrappers.
pub fn current_this_owned_request() ZVal {
	unsafe {
		obj_raw := C.vphp_get_current_this_object()
		if obj_raw == 0 {
			return invalid_zval()
		}
		mut out := C.vphp_new_zval()
		if out == 0 {
			return invalid_zval()
		}
		C.vphp_wrap_existing_object(out, &C.zend_object(obj_raw))
		return adopt_raw_with_ownership(out, .owned_request)
	}
}

pub fn (v ZVal) construct(args []ZVal) ZVal {
	return v.construct_owned_request(args)
}

pub fn (v ZVal) construct_owned_request(args []ZVal) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}

	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}

		res := C.vphp_new_instance(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw), retval,
			args.len, p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		mut result := adopt_raw_with_ownership(retval, .owned_request)
		if result.is_object() {
			autorelease_forget(result.raw)
		}
		return result
	}
}

pub fn (v ZVal) construct_owned_persistent(args []ZVal) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}
		res := C.vphp_new_instance(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw), retval,
			args.len, p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_persistent)
	}
}

pub fn (v ZVal) static_method_owned_request(method string, args []ZVal) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}

	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}

		res := C.vphp_call_static_method(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
			&char(method.str), method.len, retval, args.len, p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		mut result := adopt_raw_with_ownership(retval, .owned_request)
		if result.is_object() {
			autorelease_forget(result.raw)
		}
		return result
	}
}

pub fn (v ZVal) static_method_owned_persistent(method string, args []ZVal) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	unsafe {
		mut retval := C.vphp_new_zval()
		mut argv := []&C.zval{cap: args.len}
		for arg in args {
			argv << arg.raw
		}
		mut p_args := &&C.zval(nil)
		if argv.len > 0 {
			p_args = &argv[0]
		}
		res := C.vphp_call_static_method(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
			&char(method.str), method.len, retval, args.len, p_args)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_persistent)
	}
}

pub fn (v ZVal) static_method(method string, args []ZVal) ZVal {
	return v.static_method_owned_request(method, args)
}

pub fn (v ZVal) static_prop_borrowed(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}

	rv := C.vphp_new_zval()
	res := C.vphp_read_static_property_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .borrowed)
}

pub fn (v ZVal) static_prop_owned_request(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
	res := C.vphp_read_static_property_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_request)
}

pub fn (v ZVal) static_prop_owned_persistent(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
	res := C.vphp_read_static_property_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_persistent)
}

pub fn (v ZVal) static_prop(name string) ZVal {
	return v.static_prop_owned_request(name)
}

pub fn (v ZVal) const_borrowed(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}

	rv := C.vphp_new_zval()
	res := C.vphp_read_class_constant_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .borrowed)
}

pub fn (v ZVal) const_owned_request(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
	res := C.vphp_read_class_constant_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_request)
}

pub fn (v ZVal) const_owned_persistent(name string) ZVal {
	if v.raw == 0 || !v.is_string() {
		return invalid_zval()
	}
	rv := C.vphp_new_zval()
	res := C.vphp_read_class_constant_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, rv)
	return adopt_read_result(rv, res, .owned_persistent)
}

pub fn (v ZVal) @const(name string) ZVal {
	return v.const_owned_request(name)
}

// 兼容旧命名：建议改用 `.@const(...)`
pub fn (v ZVal) constant(name string) ZVal {
	return v.@const(name)
}

pub fn (v ZVal) set_static_prop(name string, value ZVal) {
	if v.raw == 0 || !v.is_string() || value.raw == 0 {
		return
	}
	C.vphp_write_static_property_compat(C.VPHP_Z_STRVAL(v.raw), C.VPHP_Z_STRLEN(v.raw),
		&char(name.str), name.len, value.raw)
}
