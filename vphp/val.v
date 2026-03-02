module vphp

// ============================================
// Val[T] — V 风格强类型值封装（主路径）
// ============================================

pub struct Val[T] {
pub:
	value T
}

// 主入口：由 V 值构造 Val[T]
pub fn val_of[T](value T) Val[T] {
	return Val[T]{
		value: value
	}
}

// 主入口：由 ZVal 解码并构造 Val[T]
pub fn val_from_zval[T](z ZVal) !Val[T] {
	decoded := z.to_v[T]()!
	return val_of[T](decoded)
}

// Val[T] -> DynVal
pub fn val_to_dyn[T](value T) !DynVal {
	$if T is bool {
		return dyn_bool(value)
	} $else $if T is int {
		return dyn_int(i64(value))
	} $else $if T is i64 {
		return dyn_int(value)
	} $else $if T is f64 {
		return dyn_float(value)
	} $else $if T is string {
		return dyn_string(value)
	} $else $if T is []string {
		mut out := []DynVal{}
		for item in value {
			out << dyn_string(item)
		}
		return dyn_list(out)
	} $else $if T is []int {
		mut out := []DynVal{}
		for item in value {
			out << dyn_int(i64(item))
		}
		return dyn_list(out)
	} $else $if T is []i64 {
		mut out := []DynVal{}
		for item in value {
			out << dyn_int(item)
		}
		return dyn_list(out)
	} $else $if T is []f64 {
		mut out := []DynVal{}
		for item in value {
			out << dyn_float(item)
		}
		return dyn_list(out)
	} $else $if T is []bool {
		mut out := []DynVal{}
		for item in value {
			out << dyn_bool(item)
		}
		return dyn_list(out)
	} $else $if T is map[string]string {
		mut out := map[string]DynVal{}
		for k, item in value {
			out[k] = dyn_string(item)
		}
		return dyn_map(out)
	} $else $if T is map[string]int {
		mut out := map[string]DynVal{}
		for k, item in value {
			out[k] = dyn_int(i64(item))
		}
		return dyn_map(out)
	} $else $if T is map[string]i64 {
		mut out := map[string]DynVal{}
		for k, item in value {
			out[k] = dyn_int(item)
		}
		return dyn_map(out)
	} $else $if T is map[string]f64 {
		mut out := map[string]DynVal{}
		for k, item in value {
			out[k] = dyn_float(item)
		}
		return dyn_map(out)
	} $else $if T is map[string]bool {
		mut out := map[string]DynVal{}
		for k, item in value {
			out[k] = dyn_bool(item)
		}
		return dyn_map(out)
	} $else {
		return error('unsupported Val[T] -> DynVal conversion for type ${typeof(value).name}')
	}
}

// DynVal -> Val[T]
pub fn val_from_dyn[T](dv DynVal) !Val[T] {
	z := new_zval_from_val(dv)!
	return val_from_zval[T](z)
}

pub fn (v Val[T]) unwrap() T {
	return v.value
}

// 对齐链式风格；Val[T] 恒有值，因此直接返回当前值。
pub fn (v Val[T]) or(default_value T) T {
	_ = default_value
	return v.value
}

pub fn (v Val[T]) map[U](f fn (T) U) Val[U] {
	return val_of[U](f(v.value))
}

pub fn (v Val[T]) flat_map[U](f fn (T) !Val[U]) !Val[U] {
	return f(v.value)
}

pub fn (v Val[T]) ensure(check fn (T) bool, msg string) !Val[T] {
	if !check(v.value) {
		return error(msg)
	}
	return v
}

pub fn (v Val[T]) tap(side_effect fn (T)) Val[T] {
	side_effect(v.value)
	return v
}

pub fn (v Val[T]) to_zval() !ZVal {
	return new_zval_from[T](v.value)
}

pub fn (v Val[T]) into_zval(mut out ZVal) ! {
	out.from_v[T](v.value)!
}

pub fn (v Val[T]) to_dyn() !DynVal {
	return val_to_dyn[T](v.value)
}

// ============================================
// DynVal — 动态语义值模型（兜底路径）
// ============================================

pub enum ValType {
	null_
	bool_
	int_
	float_
	string_
	list_
	map_
	object_ref
	resource_ref
}

pub union DynValData {
	b   bool
	i   i64
	f   f64
	s   string
	ptr voidptr
}

pub struct DynVal {
pub:
	type ValType
pub mut:
	data DynValData
	list []DynVal
	map  map[string]DynVal
}

pub fn dyn_null() DynVal {
	return DynVal{
		type: .null_
	}
}

pub fn dyn_bool(v bool) DynVal {
	return DynVal{
		type: .bool_
		data: DynValData{
			b: v
		}
	}
}

pub fn dyn_int(v i64) DynVal {
	return DynVal{
		type: .int_
		data: DynValData{
			i: v
		}
	}
}

pub fn dyn_float(v f64) DynVal {
	return DynVal{
		type: .float_
		data: DynValData{
			f: v
		}
	}
}

pub fn dyn_string(v string) DynVal {
	return DynVal{
		type: .string_
		data: DynValData{
			s: v
		}
	}
}

pub fn dyn_list(v []DynVal) DynVal {
	return DynVal{
		type: .list_
		list: v
	}
}

pub fn dyn_map(v map[string]DynVal) DynVal {
	return DynVal{
		type: .map_
		map:  v
	}
}

pub fn dyn_object_ref(ptr voidptr) DynVal {
	return DynVal{
		type: .object_ref
		data: DynValData{
			ptr: ptr
		}
	}
}

pub fn dyn_resource_ref(ptr voidptr) DynVal {
	return DynVal{
		type: .resource_ref
		data: DynValData{
			ptr: ptr
		}
	}
}

// 将 ZVal 解码为动态语义值（兜底场景）
pub fn decode_val(z ZVal) !DynVal {
	if !z.is_valid() || z.is_null() || z.is_undef() {
		return dyn_null()
	}
	if z.is_bool() {
		return dyn_bool(z.to_bool())
	}
	if z.is_long() {
		return dyn_int(z.to_i64())
	}
	if z.is_double() {
		return dyn_float(z.to_f64())
	}
	if z.is_string() {
		return dyn_string(z.to_string())
	}
	if z.is_array() {
		mut out := map[string]DynVal{}
		out = z.foreach_with_ctx[map[string]DynVal](out, fn (key ZVal, v ZVal, mut m map[string]DynVal) {
			decoded := decode_val(v) or { dyn_null() }
			m[key.to_string()] = decoded
		})
		return dyn_map(out)
	}
	if z.is_object() {
		ptr := C.vphp_get_v_ptr_from_zval(z.raw)
		return dyn_object_ref(ptr)
	}
	if z.is_resource() {
		return dyn_resource_ref(z.to_res())
	}
	return error('unsupported zval type: ${z.type_name()}')
}

// 将动态语义值编码到 ZVal（兜底场景）
pub fn encode_val(v DynVal, mut out ZVal) ! {
	match v.type {
		.null_ {
			out.set_null()
		}
		.bool_ {
			out.set_bool(v.data.b)
		}
		.int_ {
			out.set_int(v.data.i)
		}
		.float_ {
			out.set_double(v.data.f)
		}
		.string_ {
			out.set_string(v.data.s)
		}
		.list_ {
			out.array_init()
			for item in v.list {
				mut sub := ZVal{
					raw: C.vphp_new_zval()
				}
				encode_val(item, mut sub)!
				out.add_next_val(sub)
			}
		}
		.map_ {
			out.array_init()
			for k, item in v.map {
				mut sub := ZVal{
					raw: C.vphp_new_zval()
				}
				encode_val(item, mut sub)!
				C.vphp_array_add_assoc_zval(out.raw, &char(k.str), sub.raw)
			}
		}
		.object_ref {
			return error('encode object_ref is not supported by generic encoder')
		}
		.resource_ref {
			return error('encode resource_ref is not supported by generic encoder')
		}
	}
}

pub fn new_zval_from_val(v DynVal) !ZVal {
	mut out := ZVal{
		raw: C.vphp_new_zval()
	}
	encode_val(v, mut out)!
	return out
}
