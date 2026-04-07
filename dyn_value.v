module vphp

pub enum DynValueType {
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

pub union DynValueData {
	b   bool
	i   i64
	f   f64
	s   string
	ptr voidptr
}

// DynValue is a detached dynamic value tree for unknown/mixed PHP payloads.
// It does not preserve Zend ownership semantics.
pub struct DynValue {
pub:
	type DynValueType
pub mut:
	data DynValueData
	list []DynValue
	map  map[string]DynValue
}

pub fn dyn_value_null() DynValue {
	return DynValue{
		type: .null_
	}
}

pub fn dyn_value_bool(v bool) DynValue {
	return DynValue{
		type: .bool_
		data: DynValueData{
			b: v
		}
	}
}

pub fn dyn_value_int(v i64) DynValue {
	return DynValue{
		type: .int_
		data: DynValueData{
			i: v
		}
	}
}

pub fn dyn_value_float(v f64) DynValue {
	return DynValue{
		type: .float_
		data: DynValueData{
			f: v
		}
	}
}

pub fn dyn_value_string(v string) DynValue {
	return DynValue{
		type: .string_
		data: DynValueData{
			s: v
		}
	}
}

pub fn dyn_value_list(v []DynValue) DynValue {
	return DynValue{
		type: .list_
		list: v
	}
}

pub fn dyn_value_map(v map[string]DynValue) DynValue {
	return DynValue{
		type: .map_
		map:  v
	}
}

pub fn dyn_value_object_ref(ptr voidptr) DynValue {
	return DynValue{
		type: .object_ref
		data: DynValueData{
			ptr: ptr
		}
	}
}

pub fn dyn_value_resource_ref(ptr voidptr) DynValue {
	return DynValue{
		type: .resource_ref
		data: DynValueData{
			ptr: ptr
		}
	}
}

pub fn (v DynValue) bool_value() bool {
	return unsafe { v.data.b }
}

pub fn (v DynValue) int_value() i64 {
	return unsafe { v.data.i }
}

pub fn (v DynValue) float_value() f64 {
	return unsafe { v.data.f }
}

pub fn (v DynValue) string_value() string {
	return unsafe { v.data.s }
}

pub fn (v DynValue) pointer_value() voidptr {
	return unsafe { v.data.ptr }
}

// decode_dyn_value detaches a ZVal into a plain dynamic value tree.
pub fn decode_dyn_value(z ZVal) !DynValue {
	if !z.is_valid() || z.is_null() || z.is_undef() {
		return dyn_value_null()
	}
	if z.is_bool() {
		return dyn_value_bool(z.to_bool())
	}
	if z.is_long() {
		return dyn_value_int(z.to_i64())
	}
	if z.is_double() {
		return dyn_value_float(z.to_f64())
	}
	if z.is_string() {
		return dyn_value_string(z.to_string())
	}
	if z.is_array() {
		mut out := map[string]DynValue{}
		out = z.foreach_with_ctx[map[string]DynValue](out, fn (key ZVal, v ZVal, mut m map[string]DynValue) {
			decoded := decode_dyn_value(v) or { dyn_value_null() }
			m[key.to_string()] = decoded
		})
		return dyn_value_map(out)
	}
	if z.is_object() {
		ptr := C.vphp_get_v_ptr_from_zval(z.raw)
		return dyn_value_object_ref(ptr)
	}
	if z.is_resource() {
		return dyn_value_resource_ref(z.to_res())
	}
	return error('unsupported zval type: ${z.type_name()}')
}

// encode_dyn_value writes a detached dynamic value tree back into a ZVal.
pub fn encode_dyn_value(v DynValue, mut out ZVal) ! {
	match v.type {
		.null_ {
			out.set_null()
		}
		.bool_ {
			unsafe {
				out.set_bool(v.data.b)
			}
		}
		.int_ {
			unsafe {
				out.set_int(v.data.i)
			}
		}
		.float_ {
			unsafe {
				out.set_double(v.data.f)
			}
		}
		.string_ {
			unsafe {
				out.set_string(v.data.s)
			}
		}
		.list_ {
			out.array_init()
			for item in v.list {
				mut sub_raw := C.zval{}
				mut sub := ZVal{
					raw: &sub_raw
				}
				encode_dyn_value(item, mut sub)!
				out.add_next_val(sub)
			}
		}
		.map_ {
			out.array_init()
			for k, item in v.map {
				mut sub_raw := C.zval{}
				mut sub := ZVal{
					raw: &sub_raw
				}
				encode_dyn_value(item, mut sub)!
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

pub fn new_zval_from_dyn_value(v DynValue) !ZVal {
	framework_debug_log('dyn_value.new_zval enter type=${v.type}')
	mut out := ZVal{
		raw:   C.vphp_new_zval()
		owned: true
	}
	autorelease_add(out.raw)
	framework_debug_log('dyn_value.new_zval allocated raw=${usize(out.raw)}')
	encode_dyn_value(v, mut out)!
	framework_debug_log('dyn_value.new_zval exit raw=${usize(out.raw)} valid=${out.is_valid()} type=${out.type_name()}')
	return out
}
