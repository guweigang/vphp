module vphp

// ============================================
// Val — PHP zval 的 V 侧完整封装
// 支持 PHP 的所有数据类型：
// null, bool, int, float, string, array, object, resource, callable
// ============================================

pub struct Val {
pub mut:
	raw &C.zval
}

// ======== 空值检查 ========

pub fn (v Val) is_valid() bool { return v.raw != 0 }

// ======== 类型判断 ========

pub fn (v Val) type_id() int    { return C.vphp_get_type(v.raw) }
pub fn (v Val) is_undef() bool  { return v.type_id() == int(PHPType.undef) }
pub fn (v Val) is_null() bool   { return v.type_id() == int(PHPType.null) }
pub fn (v Val) is_bool() bool {
	tid := v.type_id()
	return tid == int(PHPType.false_) || tid == int(PHPType.true_)
}
pub fn (v Val) is_long() bool     { return v.type_id() == int(PHPType.long) }
pub fn (v Val) is_double() bool   { return v.type_id() == int(PHPType.double) }
pub fn (v Val) is_numeric() bool  { return v.is_long() || v.is_double() }
pub fn (v Val) is_string() bool   { return v.type_id() == int(PHPType.string) }
pub fn (v Val) is_array() bool    { return v.type_id() == int(PHPType.array) }
pub fn (v Val) is_object() bool   { return v.type_id() == int(PHPType.object) }
pub fn (v Val) is_resource() bool { return v.type_id() == int(PHPType.resource) }

pub fn (v Val) type_name() string {
	tid := v.type_id()
	return match tid {
		int(PHPType.undef)    { 'undefined' }
		int(PHPType.null)     { 'null' }
		int(PHPType.false_)   { 'boolean' }
		int(PHPType.true_)    { 'boolean' }
		int(PHPType.long)     { 'integer' }
		int(PHPType.double)   { 'float' }
		int(PHPType.string)   { 'string' }
		int(PHPType.array)    { 'array' }
		int(PHPType.object)   { 'object' }
		int(PHPType.resource) { 'resource' }
		else                  { 'unknown' }
	}
}

// ======== 读取 — 标量类型 ========

// bool
pub fn (v Val) to_bool() bool {
	return v.type_id() == int(PHPType.true_)
}

pub fn (v Val) get_bool() bool {
	return unsafe { C.zval_get_long(v.raw) != 0 }
}

// int / i64
pub fn (v Val) to_int() int {
	return int(C.vphp_get_int(v.raw))
}

pub fn (v Val) to_i64() i64 {
	return i64(C.vphp_get_int(v.raw))
}

// 兼容旧 API
pub fn (v Val) as_int() i64 {
	return C.vphp_get_lval(v.raw)
}

pub fn (v Val) get_int() i64 {
	return unsafe { C.zval_get_long(v.raw) }
}

// float / f64
pub fn (v Val) to_f64() f64 {
	return C.vphp_get_double(v.raw)
}

pub fn (v Val) to_float() f64 {
	return C.vphp_get_double(v.raw)
}

// string
pub fn (v Val) to_string() string {
	unsafe {
		p := C.vphp_get_strval(v.raw)
		l := C.vphp_get_strlen(v.raw)
		return p.vstring_with_len(l)
	}
}

pub fn (v Val) get_string() string {
	unsafe {
		ptr := C.VPHP_Z_STRVAL(v.raw)
		len := C.VPHP_Z_STRLEN(v.raw)
		if ptr == 0 {
			return ''
		}
		return ptr.vstring_with_len(len)
	}
}

// resource
pub fn (v Val) to_res() voidptr {
	return C.vphp_fetch_res(v.raw)
}

// ======== 写入 — 标量类型 ========

pub fn (v Val) set_null() {
	unsafe { C.vphp_set_null(v.raw) }
}

pub fn (v Val) set_bool(b bool) {
	unsafe { C.vphp_set_bool(v.raw, b) }
}

pub fn (v Val) set_int(val i64) {
	unsafe { C.vphp_set_lval(v.raw, val) }
}

pub fn (v Val) set_double(val f64) {
	unsafe { C.vphp_set_double(v.raw, val) }
}

pub fn (v Val) set_float(val f64) {
	unsafe { C.vphp_set_double(v.raw, val) }
}

pub fn (v Val) set_string(s string) {
	unsafe { C.vphp_set_strval(v.raw, &char(s.str), s.len) }
}

// ======== 数组操作 ========

// 获取数组长度
pub fn (v Val) array_count() int {
	if !v.is_array() { return 0 }
	return C.vphp_array_count(v.raw)
}

// 按数字索引取值
pub fn (v Val) array_get(index int) Val {
	if !v.is_array() { return unsafe { Val{ raw: 0 } } }
	res := C.vphp_array_get_index(v.raw, u32(index))
	return Val{ raw: res }
}

// 按字符串 key 取值（带错误处理）
pub fn (v Val) get(key string) !Val {
	if v.raw == 0 || C.vphp_is_null(v.raw) {
		return error('invalid zval or not an array')
	}
	unsafe {
		res := C.vphp_array_get_key(v.raw, &char(key.str), key.len)
		if res == 0 || C.vphp_is_null(res) {
			return error('key "${key}" not found')
		}
		return Val{ raw: res }
	}
}

// 按字符串 key 取值（返回默认值）
pub fn (v Val) get_or(key string, default_val string) string {
	val := v.get(key) or { return default_val }
	return val.to_string()
}

// ======== 对象属性操作 ========

// 通用属性获取：返回一个新的 Val
pub fn (v Val) get_prop(name string) Val {
	if !v.is_object() {
		return unsafe { Val{ raw: 0 } }
	}
	obj := C.vphp_get_obj_from_zval(v.raw)
	mut rv := C.zval{}
	res := C.vphp_read_property_compat(obj, &char(name.str), name.len, &rv)
	return Val{ raw: res }
}

// 快捷方式：属性 → string
pub fn (v Val) get_prop_string(name string) string {
	prop := v.get_prop(name)
	if prop.raw == 0 || prop.is_null() { return '' }
	return prop.to_string()
}

// 快捷方式：属性 → int
pub fn (v Val) get_prop_int(name string) int {
	prop := v.get_prop(name)
	if prop.raw == 0 { return 0 }
	return int(C.vphp_get_int(prop.raw))
}

// 快捷方式：属性 → i64
pub fn (v Val) get_prop_i64(name string) i64 {
	prop := v.get_prop(name)
	if prop.raw == 0 { return 0 }
	return i64(C.vphp_get_int(prop.raw))
}

// 快捷方式：属性 → f64
pub fn (v Val) get_prop_float(name string) f64 {
	prop := v.get_prop(name)
	if prop.raw == 0 { return 0.0 }
	return C.vphp_get_double(prop.raw)
}

// 快捷方式：属性 → bool
pub fn (v Val) get_prop_bool(name string) bool {
	prop := v.get_prop(name)
	if prop.raw == 0 { return false }
	return prop.to_bool()
}

// ======== 方法调用 ========

// 调用对象方法 $obj->method(args...)
pub fn (v Val) call(method string, args []Val) Val {
	if v.raw == 0 || !v.is_object() {
		return unsafe { Val{ raw: 0 } }
	}

	unsafe {
		mut retval := &C.zval(malloc(int(sizeof(C.zval))))
		mut p_args := &&C.zval(nil)
		if args.len > 0 {
			p_args = &args[0].raw
		}

		res := C.vphp_call_method(v.raw, &char(method.str), method.len, retval, args.len, p_args)
		if res == -1 {
			return Val{ raw: 0 }
		}
		return Val{ raw: retval }
	}
}

// 调用 callable（闭包、匿名函数等）
pub fn (v Val) invoke(args []Val) Val {
	if v.raw == 0 { return unsafe { Val{ raw: 0 } } }

	unsafe {
		mut retval := &C.zval(malloc(int(sizeof(C.zval))))
		mut p_args := &&C.zval(nil)
		if args.len > 0 {
			p_args = &args[0].raw
		}

		res := C.vphp_call_callable(v.raw, retval, args.len, p_args)
		if res == -1 {
			return Val{ raw: 0 }
		}
		return Val{ raw: retval }
	}
}

// ======== 工厂方法 ========

// 创建一个 null Val
pub fn new_val_null() Val {
	unsafe {
		z := C.vphp_new_zval()
		C.vphp_set_null(z)
		return Val{ raw: z }
	}
}

// 创建一个 int Val
pub fn new_val_int(n i64) Val {
	unsafe {
		z := C.vphp_new_zval()
		C.vphp_set_lval(z, n)
		return Val{ raw: z }
	}
}

// 创建一个 float Val
pub fn new_val_float(f f64) Val {
	unsafe {
		z := C.vphp_new_zval()
		C.vphp_set_double(z, f)
		return Val{ raw: z }
	}
}

// 创建一个 bool Val
pub fn new_val_bool(b bool) Val {
	unsafe {
		z := C.vphp_new_zval()
		C.vphp_set_bool(z, b)
		return Val{ raw: z }
	}
}

// 创建一个 string Val
pub fn new_val_string(s string) Val {
	unsafe {
		return Val{ raw: C.vphp_new_str(s.str) }
	}
}
