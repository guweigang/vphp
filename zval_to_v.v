module vphp

fn C.vphp_object_ce_equals(obj voidptr, ce voidptr) bool
fn C.vphp_object_is_instance_of(obj voidptr, ce voidptr) bool

type GetClassEntryFn = fn (string) voidptr

struct SumTypeLayout {
mut:
	ptr voidptr
	typ int
}

__global (
	vphp_get_class_entry_fn GetClassEntryFn
)

fn init() {
	// SAFETY: C interop block with valid pointer arguments
	unsafe {
		vphp_get_class_entry_fn = nil
	}
}

pub fn register_class_entry_lookup(f GetClassEntryFn) {
	// SAFETY: C interop block with valid pointer arguments
	unsafe {
		vphp_get_class_entry_fn = f
	}
}

fn cached_class_entry(name string) voidptr {
	return unsafe { vphp_get_class_entry_fn(name) }
}

// ======== Zend Value -> V 转换 API ========

// 便捷转换：array => map<string,string>（无效/null/undef 返回空 map）
pub fn (v ZVal) to_string_map() map[string]string {
	if !v.is_valid() || v.is_null() || v.is_undef() || !v.is_array() {
		return map[string]string{}
	}
	return v.foreach_with_ctx[map[string]string](map[string]string{}, fn (key ZVal, val ZVal, mut acc map[string]string) {
		acc[key.to_string()] = val.to_string()
	})
}

// 便捷转换：array => []string（无效/null/undef 返回空数组）
pub fn (v ZVal) to_string_list() []string {
	if !v.is_valid() || v.is_null() || v.is_undef() || !v.is_array() {
		return []string{}
	}
	return v.foreach_with_ctx[[]string]([]string{}, fn (_ ZVal, val ZVal, mut acc []string) {
		acc << val.to_string()
	})
}

// 将 Zend Value 转换为明确的 V 类型（严格校验类型）
pub fn (v ZVal) to_v[T]() !T {
	$if T is $enum {
		if v.is_numeric() {
			return unsafe { T(v.to_int()) }
		}
		if v.is_object() {
			obj := PhpObject.from_zval(v) or {
				return error('expected enum object, failed to cast')
			}
			val_prop := obj.prop('value')
			if val_prop.is_numeric() {
				return unsafe { T(val_prop.to_int()) }
			}
			return error('expected BackedEnum with integer value, got non-numeric value')
		}
		return error('type mismatch: expected enum (int or BackedEnum), got ${v.type_name()}')
	}
	$if T is $struct {
		if v.is_object() {
			mut v_name := typeof(T).name
			if v_name.contains('.') {
				v_name = v_name.all_after_last('.')
			}
			ce := cached_class_entry(v_name)
			if ce != unsafe { nil } // SAFETY: nil literal in unsafe context
			  {
				zend_obj := ZendObject.from_zval(v)
				if C.vphp_object_is_instance_of(zend_obj.raw_ptr(), ce) {
					ptr := zend_obj.bound_v_ptr()
					if ptr != unsafe { nil } // SAFETY: nil literal in unsafe context
					  {
						return unsafe { *(&T(ptr)) }
					}
				}
			}
		}
		return error('type mismatch: expected object bound to struct ${typeof[T]().name}')
	}
	$if T is ZVal {
		return v
	}
	$if T is RequestBorrowedZBox {
		return RequestBorrowedZBox.of(v)
	}
	$if T is RequestOwnedZBox {
		return RequestOwnedZBox.of(v)
	}
	$if T is PersistentOwnedZBox {
		return PersistentOwnedZBox.of(v)
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
		out = v.foreach_with_ctx[[]string](out, fn (_ ZVal, val ZVal, mut acc []string) {
			acc << val.to_string()
		})
		return out
	}
	$if T is []int {
		if !v.is_array() {
			return error('type mismatch: expected array<int>, got ${v.type_name()}')
		}
		mut out := []int{}
		out = v.foreach_with_ctx[[]int](out, fn (_ ZVal, val ZVal, mut acc []int) {
			acc << val.to_int()
		})
		return out
	}
	$if T is []i64 {
		if !v.is_array() {
			return error('type mismatch: expected array<i64>, got ${v.type_name()}')
		}
		mut out := []i64{}
		out = v.foreach_with_ctx[[]i64](out, fn (_ ZVal, val ZVal, mut acc []i64) {
			acc << val.to_i64()
		})
		return out
	}
	$if T is []f64 {
		if !v.is_array() {
			return error('type mismatch: expected array<f64>, got ${v.type_name()}')
		}
		mut out := []f64{}
		out = v.foreach_with_ctx[[]f64](out, fn (_ ZVal, val ZVal, mut acc []f64) {
			acc << val.to_f64()
		})
		return out
	}
	$if T is []bool {
		if !v.is_array() {
			return error('type mismatch: expected array<bool>, got ${v.type_name()}')
		}
		mut out := []bool{}
		out = v.foreach_with_ctx[[]bool](out, fn (_ ZVal, val ZVal, mut acc []bool) {
			acc << val.to_bool()
		})
		return out
	}
	$if T is []ZVal {
		if !v.is_array() {
			return error('type mismatch: expected array<ZVal>, got ${v.type_name()}')
		}
		mut out := []ZVal{}
		out = v.foreach_with_ctx[[]ZVal](out, fn (_ ZVal, val ZVal, mut acc []ZVal) {
			acc << val
		})
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
	$if T is map[string]ZVal {
		if !v.is_array() {
			return error('type mismatch: expected map<string,ZVal>, got ${v.type_name()}')
		}
		mut out := map[string]ZVal{}
		out = v.foreach_with_ctx[map[string]ZVal](out, fn (key ZVal, val ZVal, mut m map[string]ZVal) {
			m[key.to_string()] = val
		})
		return out
	}
	$if T is $sumtype {
		$for variant in T.variants {
			$if variant.typ is bool {
				if v.is_bool() {
					return T(v.to_bool())
				}
			}
			$if variant.typ is int {
				if v.is_numeric() {
					return T(v.to_int())
				}
			}
			$if variant.typ is i64 {
				if v.is_numeric() {
					return T(v.to_i64())
				}
			}
			$if variant.typ is f64 {
				if v.is_numeric() {
					return T(v.to_f64())
				}
			}
			$if variant.typ is string {
				if v.is_string() {
					return T(v.to_string())
				}
			}
			$if variant.typ is []string {
				if v.is_array() {
					if list := v.to_v[[]string]() {
						return T(list)
					}
				}
			}
			$if variant.typ is []int {
				if v.is_array() {
					if list := v.to_v[[]int]() {
						return T(list)
					}
				}
			}
			$if variant.typ is []i64 {
				if v.is_array() {
					if list := v.to_v[[]i64]() {
						return T(list)
					}
				}
			}
			$if variant.typ is []f64 {
				if v.is_array() {
					if list := v.to_v[[]f64]() {
						return T(list)
					}
				}
			}
			$if variant.typ is []bool {
				if v.is_array() {
					if list := v.to_v[[]bool]() {
						return T(list)
					}
				}
			}
			$if variant.typ is PhpValue {
				return T(PhpValue.from_zval(v))
			}
			$if variant.typ is PhpObject {
				if obj := PhpObject.from_zval(v) {
					return T(obj)
				}
			}
			$if variant.typ is PhpArray {
				if arr := PhpArray.from_zval(v) {
					return T(arr)
				}
			}
			$if variant.typ is $struct {
				if v.is_object() {
					mut v_name := typeof(variant.typ).name
					if v_name.contains('.') {
						v_name = v_name.all_after_last('.')
					}
					ce := cached_class_entry(v_name)
					if ce != unsafe { nil } // SAFETY: nil literal in unsafe context
					  {
						zend_obj := ZendObject.from_zval(v)
						eq := C.vphp_object_is_instance_of(zend_obj.raw_ptr(), ce)
						if eq {
							ptr := zend_obj.bound_v_ptr()
							if ptr != unsafe { nil } // SAFETY: nil literal in unsafe context
							  {
								mut layout := SumTypeLayout{
									typ: variant.typ
									ptr: ptr
								}
								mut res := T{}
								// SAFETY: C interop block with valid pointer arguments
								unsafe {
									C.memcpy(&res, &layout, sizeof(T))
								}
								return res
							}
						}
					}
				}
			}
			$if variant.typ is $enum {
				mut enum_val_int := 0
				mut has_val := false
				if v.is_numeric() {
					enum_val_int = v.to_int()
					has_val = true
				} else if v.is_object() {
					if obj := PhpObject.from_zval(v) {
						val_prop := obj.prop('value')
						if val_prop.is_numeric() {
							enum_val_int = val_prop.to_int()
							has_val = true
						}
					}
				}
				if has_val {
					$for enum_case in variant.typ.values {
						if int(enum_case.value) == enum_val_int {
							return T(enum_case.value)
						}
					}
				}
			}
		}
		return error('no matching variant found in sumtype ${typeof[T]().name} for zval of type ${v.type_name()}')
	}
	return error('unsupported to_v conversion for requested type')
}
