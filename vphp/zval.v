module vphp

// ============================================
// ZVal — low-level bridge wrapper around Zend zval
// NOTE:
// - This type is intended for vphp bridge internals.
// - Extension/framework code should prefer typed wrappers in lifecycle.v:
//   BorrowedZVal / RequestOwnedZVal / PersistentOwnedZVal.
// ============================================

pub struct ZVal {
pub mut:
	raw   &C.zval
	owned bool
}

pub struct RuntimeCounters {
pub:
	autorelease_len int
	owned_len       int
	obj_registry_len u32
	rev_registry_len u32
}

fn invalid_zval() ZVal {
	return unsafe {
		ZVal{
			raw: 0
		}
	}
}

fn adopt_raw_with_ownership(raw &C.zval, ownership OwnershipKind) ZVal {
	if raw == 0 {
		return invalid_zval()
	}
	mut out := unsafe {
		ZVal{
			raw: raw
			owned: true
		}
	}
	if ownership == .owned_request {
		autorelease_add(out.raw)
	}
	return out
}

fn clone_raw_with_ownership(src &C.zval, ownership OwnershipKind) ZVal {
	if src == 0 {
		return invalid_zval()
	}
	mut out := ZVal{
		raw: C.vphp_new_zval()
		owned: true
	}
	C.ZVAL_COPY(out.raw, src)
	if ownership == .owned_request {
		autorelease_add(out.raw)
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
		autorelease_len: ar
		owned_len: owned
		obj_registry_len: obj_reg
		rev_registry_len: rev_reg
	}
}

// ======== 空值检查 ========

pub fn (v ZVal) is_valid() bool {
	return v.raw != 0
}

// ======== 类型判断 ========

pub fn (v ZVal) type_raw() int {
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

pub fn (v ZVal) is_object() bool {
	return v.type_id() == .object
}

pub fn (v ZVal) is_resource() bool {
	return v.type_id() == .resource
}

pub fn (v ZVal) is_callable() bool {
	return C.vphp_is_callable(v.raw) == 1
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
	unsafe {
		p := C.vphp_get_strval(v.raw)
		l := C.vphp_get_strlen(v.raw)
		return p.vstring_with_len(l).clone()
	}
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
	unsafe { C.vphp_array_push_string(v.raw, &char(s.str)) }
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

// 按字符串 key 取值（返回默认值）
pub fn (v ZVal) get_or(key string, default_val string) string {
	val := v.get(key) or { return default_val }
	return val.to_string()
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
	res := php_fn('is_subclass_of').call([v, ZVal.new_string(name), ZVal.new_bool(true)])
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
	if !consts.is_array() {
		return []string{}
	}
	keys := php_fn('array_keys').call([consts])
	if !keys.is_array() {
		return []string{}
	}
	mut out := []string{}
	out = keys.foreach_with_ctx[[]string](out, fn (_ ZVal, val ZVal, mut acc []string) {
		acc << val.to_string()
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
// 和 `interop.md` 保持一致的分层：
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
		return adopt_raw_with_ownership(retval, .owned_request)
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
		res := C.vphp_call_method(v.raw, &char(method.str), method.len, retval, args.len, p_args)
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
		return adopt_raw_with_ownership(retval, .owned_request)
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
	unsafe { C.vphp_release_zval(v.raw) }
	v.raw = unsafe { nil }
	v.owned = false
}

// Duplicate and keep beyond current autorelease scope.
pub fn (v ZVal) dup_persistent() ZVal {
	mut out := v.dup()
	autorelease_forget(out.raw)
	return out
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
		return adopt_raw_with_ownership(retval, .owned_request)
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
		return adopt_raw_with_ownership(retval, .owned_request)
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

// -------- Typed value helpers --------
// 本质上是 `base action + to_v[T]()` 的语法糖。

pub fn (v ZVal) call_v[T](args []ZVal) !T {
	return v.call(args).to_v[T]()
}

pub fn (v ZVal) call_owned_request_v[T](args []ZVal) !T {
	return v.call_owned_request(args).to_v[T]()
}

pub fn (v ZVal) call_owned_persistent_v[T](args []ZVal) !T {
	return v.call_owned_persistent(args).to_v[T]()
}

pub fn (v ZVal) invoke_v[T](args []ZVal) !T {
	return v.invoke(args).to_v[T]()
}

pub fn (v ZVal) invoke_owned_request_v[T](args []ZVal) !T {
	return v.call_owned_request_v[T](args)
}

pub fn (v ZVal) invoke_owned_persistent_v[T](args []ZVal) !T {
	return v.call_owned_persistent_v[T](args)
}

pub fn (v ZVal) construct_v[T](args []ZVal) !T {
	return v.construct(args).to_v[T]()
}

pub fn (v ZVal) construct_owned_request_v[T](args []ZVal) !T {
	return v.construct_owned_request(args).to_v[T]()
}

pub fn (v ZVal) construct_owned_persistent_v[T](args []ZVal) !T {
	return v.construct_owned_persistent(args).to_v[T]()
}

pub fn (v ZVal) method_v[T](method string, args []ZVal) !T {
	return v.method(method, args).to_v[T]()
}

pub fn (v ZVal) method_owned_request_v[T](method string, args []ZVal) !T {
	return v.method_owned_request(method, args).to_v[T]()
}

pub fn (v ZVal) method_owned_persistent_v[T](method string, args []ZVal) !T {
	return v.method_owned_persistent(method, args).to_v[T]()
}

pub fn (v ZVal) prop_v[T](name string) !T {
	return v.prop(name).to_v[T]()
}

pub fn (v ZVal) prop_borrowed_v[T](name string) !T {
	return v.prop_borrowed(name).to_v[T]()
}

pub fn (v ZVal) prop_owned_request_v[T](name string) !T {
	return v.prop_owned_request(name).to_v[T]()
}

pub fn (v ZVal) prop_owned_persistent_v[T](name string) !T {
	return v.prop_owned_persistent(name).to_v[T]()
}

pub fn (v ZVal) static_prop_v[T](name string) !T {
	return v.static_prop(name).to_v[T]()
}

pub fn (v ZVal) static_prop_borrowed_v[T](name string) !T {
	return v.static_prop_borrowed(name).to_v[T]()
}

pub fn (v ZVal) static_prop_owned_request_v[T](name string) !T {
	return v.static_prop_owned_request(name).to_v[T]()
}

pub fn (v ZVal) static_prop_owned_persistent_v[T](name string) !T {
	return v.static_prop_owned_persistent(name).to_v[T]()
}

pub fn (v ZVal) const_v[T](name string) !T {
	return v.@const(name).to_v[T]()
}

pub fn (v ZVal) const_borrowed_v[T](name string) !T {
	return v.const_borrowed(name).to_v[T]()
}

pub fn (v ZVal) const_owned_request_v[T](name string) !T {
	return v.const_owned_request(name).to_v[T]()
}

pub fn (v ZVal) const_owned_persistent_v[T](name string) !T {
	return v.const_owned_persistent(name).to_v[T]()
}

pub fn (v ZVal) static_method_v[T](method string, args []ZVal) !T {
	return v.static_method(method, args).to_v[T]()
}

pub fn (v ZVal) static_method_owned_request_v[T](method string, args []ZVal) !T {
	return v.static_method_owned_request(method, args).to_v[T]()
}

pub fn (v ZVal) static_method_owned_persistent_v[T](method string, args []ZVal) !T {
	return v.static_method_owned_persistent(method, args).to_v[T]()
}

// -------- Typed object helpers --------
// 只对 `vphp` 导出的对象有意义，
// 本质上是 `base action + to_object[T]()` 的语法糖。

pub fn (v ZVal) call_object[T](args []ZVal) ?&T {
	return v.call(args).to_object[T]()
}

pub fn (v ZVal) call_owned_request_object[T](args []ZVal) ?&T {
	return v.call_owned_request(args).to_object[T]()
}

pub fn (v ZVal) call_owned_persistent_object[T](args []ZVal) ?&T {
	return v.call_owned_persistent(args).to_object[T]()
}

pub fn (v ZVal) method_object[T](method string, args []ZVal) ?&T {
	return v.method(method, args).to_object[T]()
}

pub fn (v ZVal) method_owned_request_object[T](method string, args []ZVal) ?&T {
	return v.method_owned_request(method, args).to_object[T]()
}

pub fn (v ZVal) method_owned_persistent_object[T](method string, args []ZVal) ?&T {
	return v.method_owned_persistent(method, args).to_object[T]()
}

pub fn (v ZVal) prop_object[T](name string) ?&T {
	return v.prop(name).to_object[T]()
}

pub fn (v ZVal) prop_borrowed_object[T](name string) ?&T {
	return v.prop_borrowed(name).to_object[T]()
}

pub fn (v ZVal) prop_owned_request_object[T](name string) ?&T {
	return v.prop_owned_request(name).to_object[T]()
}

pub fn (v ZVal) prop_owned_persistent_object[T](name string) ?&T {
	return v.prop_owned_persistent(name).to_object[T]()
}

pub fn (v ZVal) construct_object[T](args []ZVal) ?&T {
	return v.construct(args).to_object[T]()
}

pub fn (v ZVal) construct_owned_request_object[T](args []ZVal) ?&T {
	return v.construct_owned_request(args).to_object[T]()
}

pub fn (v ZVal) construct_owned_persistent_object[T](args []ZVal) ?&T {
	return v.construct_owned_persistent(args).to_object[T]()
}

pub fn (v ZVal) static_method_object[T](method string, args []ZVal) ?&T {
	return v.static_method(method, args).to_object[T]()
}

pub fn (v ZVal) static_method_owned_request_object[T](method string, args []ZVal) ?&T {
	return v.static_method_owned_request(method, args).to_object[T]()
}

pub fn (v ZVal) static_method_owned_persistent_object[T](method string, args []ZVal) ?&T {
	return v.static_method_owned_persistent(method, args).to_object[T]()
}

// 兼容旧命名：建议改用 `.const_v[T](...)`
pub fn (v ZVal) constant_v[T](name string) !T {
	return v.const_v[T](name)
}

// -------- Compatibility aliases --------

// 兼容旧 API：对象方法调用
pub fn (v ZVal) call_method(method string, args []ZVal) ZVal {
	return v.method(method, args)
}

// 兼容旧 API：callable 调用
pub fn (v ZVal) invoke(args []ZVal) ZVal {
	return v.call(args)
}

// ======== 工厂方法 ========

// 创建一个 null ZVal
pub fn ZVal.new_null() ZVal {
	unsafe {
		z := C.vphp_new_zval()
		C.vphp_set_null(z)
		autorelease_add(z)
		return ZVal{
			raw: z
			owned: true
		}
	}
}

// 创建一个 int ZVal
pub fn ZVal.new_int(n i64) ZVal {
	unsafe {
		z := C.vphp_new_zval()
		C.vphp_set_lval(z, n)
		autorelease_add(z)
		return ZVal{
			raw: z
			owned: true
		}
	}
}

// 创建一个 float ZVal
pub fn ZVal.new_float(f f64) ZVal {
	unsafe {
		z := C.vphp_new_zval()
		C.vphp_set_double(z, f)
		autorelease_add(z)
		return ZVal{
			raw: z
			owned: true
		}
	}
}

// 创建一个 bool ZVal
pub fn ZVal.new_bool(b bool) ZVal {
	unsafe {
		z := C.vphp_new_zval()
		C.vphp_set_bool(z, b)
		autorelease_add(z)
		return ZVal{
			raw: z
			owned: true
		}
	}
}

// 创建一个 string ZVal
pub fn ZVal.new_string(s string) ZVal {
	unsafe {
		z := C.vphp_new_str(&char(s.str))
		autorelease_add(z)
		return ZVal{
			raw: z
			owned: true
		}
	}
}

// 兼容旧命名：建议改用 ZVal.new_null()
pub fn new_val_null() ZVal {
	return ZVal.new_null()
}

// 兼容旧命名：建议改用 ZVal.new_int()
pub fn new_val_int(n i64) ZVal {
	return ZVal.new_int(n)
}

// 兼容旧命名：建议改用 ZVal.new_float()
pub fn new_val_float(f f64) ZVal {
	return ZVal.new_float(f)
}

// 兼容旧命名：建议改用 ZVal.new_bool()
pub fn new_val_bool(b bool) ZVal {
	return ZVal.new_bool(b)
}

// 兼容旧命名：建议改用 ZVal.new_string()
pub fn new_val_string(s string) ZVal {
	return ZVal.new_string(s)
}

// ======== 新版清晰转换 API ========
// Zend Value -> V:   v.to_v[T]()
// V -> Zend Value:   v.from_v[T](x), new_zval_from[T](x)

// 便捷转换：array => map<string,string>（无效/null/undef 返回空 map）
pub fn (v ZVal) to_string_map() map[string]string {
	if !v.is_valid() || v.is_null() || v.is_undef() {
		return map[string]string{}
	}
	return v.to_v[map[string]string]() or { map[string]string{} }
}

// 便捷转换：array => []string（无效/null/undef 返回空数组）
pub fn (v ZVal) to_string_list() []string {
	if !v.is_valid() || v.is_null() || v.is_undef() {
		return []string{}
	}
	return v.to_v[[]string]() or { []string{} }
}

// 将 Zend Value 转换为明确的 V 类型（严格校验类型）
pub fn (v ZVal) to_v[T]() !T {
	$if T is ZVal {
		return v
	}
	$if T is bool {
		if !v.is_bool() {
			return error('type mismatch: expected bool, got ${v.type_name()}')
		}
		return v.to_bool()
	}
	$if T is int {
		if !v.is_numeric() {
			return error('type mismatch: expected int, got ${v.type_name()}')
		}
		return v.to_int()
	}
	$if T is i64 {
		if !v.is_numeric() {
			return error('type mismatch: expected i64, got ${v.type_name()}')
		}
		return v.to_i64()
	}
	$if T is f64 {
		if !v.is_numeric() {
			return error('type mismatch: expected f64, got ${v.type_name()}')
		}
		return v.to_f64()
	}
	$if T is string {
		if !v.is_string() {
			return error('type mismatch: expected string, got ${v.type_name()}')
		}
		return v.to_string()
	}
	$if T is []string {
		if !v.is_array() {
			return error('type mismatch: expected array<string>, got ${v.type_name()}')
		}
		mut out := []string{}
		for i in 0 .. v.array_count() {
			item := v.array_get(i)
			out << item.to_v[string]()!
		}
		return out
	}
	$if T is []int {
		if !v.is_array() {
			return error('type mismatch: expected array<int>, got ${v.type_name()}')
		}
		mut out := []int{}
		for i in 0 .. v.array_count() {
			item := v.array_get(i)
			out << item.to_v[int]()!
		}
		return out
	}
	$if T is []i64 {
		if !v.is_array() {
			return error('type mismatch: expected array<i64>, got ${v.type_name()}')
		}
		mut out := []i64{}
		for i in 0 .. v.array_count() {
			item := v.array_get(i)
			out << item.to_v[i64]()!
		}
		return out
	}
	$if T is []f64 {
		if !v.is_array() {
			return error('type mismatch: expected array<f64>, got ${v.type_name()}')
		}
		mut out := []f64{}
		for i in 0 .. v.array_count() {
			item := v.array_get(i)
			out << item.to_v[f64]()!
		}
		return out
	}
	$if T is []bool {
		if !v.is_array() {
			return error('type mismatch: expected array<bool>, got ${v.type_name()}')
		}
		mut out := []bool{}
		for i in 0 .. v.array_count() {
			item := v.array_get(i)
			out << item.to_v[bool]()!
		}
		return out
	}
	$if T is map[string]string {
		if !v.is_array() {
			return error('type mismatch: expected map<string,string>, got ${v.type_name()}')
		}
		mut out := map[string]string{}
		out = v.foreach_with_ctx[map[string]string](out, fn (key ZVal, val ZVal, mut m map[string]string) {
			m[key.to_string()] = val.to_string()
		})
		return out
	}
	$if T is map[string]int {
		if !v.is_array() {
			return error('type mismatch: expected map<string,int>, got ${v.type_name()}')
		}
		mut out := map[string]int{}
		out = v.foreach_with_ctx[map[string]int](out, fn (key ZVal, val ZVal, mut m map[string]int) {
			m[key.to_string()] = val.to_int()
		})
		return out
	}
	$if T is map[string]f64 {
		if !v.is_array() {
			return error('type mismatch: expected map<string,f64>, got ${v.type_name()}')
		}
		mut out := map[string]f64{}
		out = v.foreach_with_ctx[map[string]f64](out, fn (key ZVal, val ZVal, mut m map[string]f64) {
			m[key.to_string()] = val.to_f64()
		})
		return out
	}
	return error('unsupported to_v conversion for requested type')
}

// 将 V 类型写入 Zend Value
pub fn (v ZVal) from_v[T](value T) ! {
	$if T is ZVal {
		return error('from_v[ZVal] is not supported; convert to a concrete V type first')
	}
	$if T is bool {
		v.set_bool(value)
		return
	}
	$if T is int || T is i64 {
		v.set_int(i64(value))
		return
	}
	$if T is f64 {
		v.set_double(value)
		return
	}
	$if T is string {
		v.set_string(value)
		return
	}
	$if T is []string {
		v.array_init()
		for item in value {
			v.push_string(item)
		}
		return
	}
	$if T is []int || T is []i64 {
		v.array_init()
		for item in value {
			v.push_long(i64(item))
		}
		return
	}
	$if T is []f64 {
		v.array_init()
		for item in value {
			v.push_double(item)
		}
		return
	}
	$if T is []bool {
		v.array_init()
		for item in value {
			v.push_bool(item)
		}
		return
	}
	$if T is map[string]string {
		v.array_init()
		for key, item in value {
			v.add_assoc_string(key, item)
		}
		return
	}
	$if T is map[string]int || T is map[string]i64 {
		v.array_init()
		for key, item in value {
			v.add_assoc_long(key, i64(item))
		}
		return
	}
	$if T is map[string]f64 {
		v.array_init()
		for key, item in value {
			v.add_assoc_double(key, item)
		}
		return
	}
	$if T is map[string]bool {
		v.array_init()
		for key, item in value {
			v.add_assoc_bool(key, item)
		}
		return
	}
	return error('unsupported from_v conversion for source type')
}

// 便捷工厂：从 V 类型直接创建 Zend Value 包装
pub fn new_zval_from[T](value T) !ZVal {
	mut out := ZVal{
		raw: C.vphp_new_zval()
		owned: true
	}
	autorelease_add(out.raw)
	out.from_v[T](value)!
	return out
}

pub fn ZVal.from[T](value T) !ZVal {
	return new_zval_from[T](value)!
}

// 兼容旧命名：建议改用 new_zval_from[T]
pub fn new_val_from[T](value T) !ZVal {
	return new_zval_from[T](value)
}

// ======== 高级：对象转换 ========

// 将 zval 对象转化为具体的 V 结构体指针
pub fn (v ZVal) to_object[T]() ?&T {
	if !v.is_object() {
		return none
	}
	ptr := C.vphp_get_v_ptr_from_zval(v.raw)
	if ptr == 0 {
		return none
	}
	return unsafe { &T(ptr) }
}

// ======== 高级：迭代器 foreach ========

pub type ForeachCb = fn (key ZVal, val ZVal)

fn vphp_foreach_wrapper(ctx voidptr, key &C.zval, val &C.zval) {
	unsafe {
		cb := *(&ForeachCb(ctx))
		cb(ZVal{ raw: key }, ZVal{
			raw: val
		})
	}
}

// 遍历当前 ZVal (对 array 和 object 有效)
pub fn (v ZVal) foreach(cb ForeachCb) {
	if !v.is_array() && !v.is_object() {
		return
	}
	C.vphp_zval_foreach(v.raw, &cb, vphp_foreach_wrapper)
}

// 语义化别名：更贴近日常遍历语义
pub fn (v ZVal) each(cb ForeachCb) {
	v.foreach(cb)
}

pub type ForeachWithCtxCb[T] = fn (key ZVal, val ZVal, mut ctx T)

fn vphp_foreach_with_ctx_wrapper[T](ctx voidptr, key &C.zval, val &C.zval) {
	unsafe {
		mut pack := &ForeachPack[T](ctx)
		cb := pack.cb
		cb(ZVal{ raw: key }, ZVal{
			raw: val
		}, mut pack.ctx)
	}
}

struct ForeachPack[T] {
	cb ForeachWithCtxCb[T] = unsafe { nil }
mut:
	ctx T
}

pub fn (v ZVal) foreach_with_ctx[T](ctx T, cb ForeachWithCtxCb[T]) T {
	if !v.is_array() && !v.is_object() {
		return ctx
	}
	mut pack := ForeachPack[T]{
		cb:  cb
		ctx: ctx
	}
	C.vphp_zval_foreach(v.raw, &pack, vphp_foreach_with_ctx_wrapper[T])
	return pack.ctx
}

// 语义化别名：带累积器的遍历
pub fn (v ZVal) fold[T](init T, cb ForeachWithCtxCb[T]) T {
	return v.foreach_with_ctx[T](init, cb)
}

// reduce 目前与 fold 保持同义；统一采用显式初始值版本
pub fn (v ZVal) reduce[T](init T, cb ForeachWithCtxCb[T]) T {
	return v.foreach_with_ctx[T](init, cb)
}
