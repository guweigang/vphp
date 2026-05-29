module vphp

import vphp.object
import vphp.zend as _
import vphp.zval as zvalmod

fn C.vphp_zend_enum_get_case(ce voidptr, name &char, len int) voidptr
fn C.vphp_zval_set_object_copy(z voidptr, zo voidptr)

// --- From php_return_type.v ---
pub struct PhpReturn {
	handle zvalmod.Handle
}

pub fn PhpReturn.from_ptr(raw voidptr) PhpReturn {
	return PhpReturn{
		handle: zvalmod.Handle.from_ptr(raw)
	}
}

pub fn PhpReturn.from_zval(z ZVal) PhpReturn {
	return PhpReturn{
		handle: z.handle()
	}
}

pub fn (ret PhpReturn) raw_ptr() voidptr {
	return ret.handle.raw_ptr()
}

pub fn (ret PhpReturn) handle() zvalmod.Handle {
	return ret.handle
}

pub fn (ret PhpReturn) to_zval() ZVal {
	return ZVal.from_handle(ret.handle)
}

// --- From php_return_scalar.v ---
pub fn (ret PhpReturn) null() {
	ret.to_zval().set_null()
}

pub fn (ret PhpReturn) bool_value(val bool) {
	ret.to_zval().set_bool(val)
}

pub fn (ret PhpReturn) int_value(val i64) {
	ret.to_zval().set_int(val)
}

pub fn (ret PhpReturn) double_value(val f64) {
	ret.to_zval().set_double(val)
}

pub fn (ret PhpReturn) string_value(val string) {
	ret.to_zval().set_string(val)
}

// --- From php_return_value.v ---
pub fn (ret PhpReturn) zval(val ZVal) {
	ret.to_zval().copy_from(val)
}

pub fn (ret PhpReturn) value(value PhpValue) {
	ret.zval(value.to_zval())
}

pub fn (ret PhpReturn) null_value(value PhpNull) {
	ret.zval(value.to_zval())
}

pub fn (ret PhpReturn) dyn_value(value DynValue) {
	mut owned := value.request_owned()
	defer {
		owned.release()
	}
	ret.zval(owned.to_zval())
}

pub fn (ret PhpReturn) request_owned(value RequestOwnedZBox) {
	ret.zval(value.to_zval())
	mut owned := value
	owned.release()
}

pub fn (ret PhpReturn) request_borrowed(value RequestBorrowedZBox) {
	ret.zval(value.to_zval())
}

pub fn (ret PhpReturn) persistent_owned(value PersistentOwnedZBox) {
	value.with_request_zval(fn [ret] (z ZVal) bool {
		ret.zval(z)
		return true
	})
}

// --- From php_return_object.v ---
pub fn (ret PhpReturn) resource(ptr voidptr, label string) {
	ret.to_zval().make_resource(ptr, label)
}

pub fn (ret PhpReturn) object(v_ptr voidptr, ce ZendClassEntry) {
	object.return_unbound(ret.raw_ptr(), v_ptr, ce.raw_ptr())
}

pub fn (ret PhpReturn) bound_object(v_ptr voidptr, ce ZendClassEntry, handlers voidptr, ownership OwnershipKind) {
	match ownership {
		.borrowed {
			object.return_bound(ret.raw_ptr(), v_ptr, ce.raw_ptr(), handlers, .borrowed)
		}
		.owned_request, .owned_persistent {
			object.return_bound(ret.raw_ptr(), v_ptr, ce.raw_ptr(), handlers, .owned)
		}
	}
}

pub fn (ret PhpReturn) owned_object(v_ptr voidptr, ce ZendClassEntry, handlers voidptr) {
	ret.bound_object(v_ptr, ce, handlers, .owned_request)
}

pub fn (ret PhpReturn) borrowed_object(v_ptr voidptr, ce ZendClassEntry, handlers voidptr) {
	ret.bound_object(v_ptr, ce, handlers, .borrowed)
}

// --- From php_return_compound.v ---
pub fn (ret PhpReturn) list[T](list []T) {
	out := ret.to_zval()
	out.array_init()
	for item in list {
		$if T is string {
			out.push_string(item)
		} $else $if T is f64 {
			out.push_double(item)
		} $else $if T is int || T is i64 {
			out.push_long(i64(item))
		} $else {
			out.push_struct(item)
		}
	}
}

pub fn (ret PhpReturn) map_value[T](m map[string]T) {
	out := ret.to_zval()
	out.array_init()
	for k, v in m {
		$if T is string {
			out.add_assoc_string(k, v)
		} $else $if T is int || T is i64 {
			out.add_assoc_long(k, i64(v))
		} $else $if T is f64 {
			out.add_assoc_double(k, v)
		} $else $if T is bool {
			out.add_assoc_bool(k, v)
		}
	}
}

pub fn (ret PhpReturn) object_props(props map[string]string) {
	out := ret.to_zval()
	out.object_init()
	for k, v in props {
		out.update_property_string(k, v)
	}
}

pub fn (ret PhpReturn) struct_value[T](s T) {
	out := ret.to_zval()
	out.array_init()
	$for field in T.fields {
		key := field.name
		$if field.typ is string {
			out.add_assoc_string(key, s.$(field.name))
		} $else $if field.typ is f64 {
			out.add_assoc_double(key, s.$(field.name))
		} $else $if field.typ is int || field.typ is i64 {
			out.add_assoc_long(key, i64(s.$(field.name)))
		} $else $if field.typ is bool {
			out.add_assoc_bool(key, s.$(field.name))
		}
	}
}

// --- From php_return_flow.v ---
pub fn (ret PhpReturn) from_result_void(f fn () !) {
	f() or {
		throw_exception(err.msg(), 0)
		return
	}
}

pub fn (ret PhpReturn) from_result[T](f fn () !T) {
	res := f() or {
		throw_exception(err.msg(), 0)
		return
	}
	ret.v[T](res)
}

pub fn (ret PhpReturn) from_option_void(f fn () ?) {
	f() or {
		ret.null()
		return
	}
}

pub fn (ret PhpReturn) from_option[T](f fn () ?T) {
	res := f() or {
		ret.null()
		return
	}
	ret.v[T](res)
}

// --- From php_return_generic.v ---
pub fn (ret PhpReturn) any[T](val T) {
	ret.v[T](val)
}

pub fn (ret PhpReturn) v[T](val T) {
	$if T is PhpValue {
		ret.value(val)
		return
	} $else $if T is PhpNull {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpBool {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpInt {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpDouble {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpString {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpScalar {
		ret.zval(val.to_zval())
		return
	} $else $if T is VScalarValue {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpArray {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpObject {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpCallable {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpClosure {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpResource {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpReference {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpIterable {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpIterator {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpThrowable {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpEnumCase {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpClass {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpFunction {
		ret.zval(val.to_zval())
		return
	} $else $if T is DynValue {
		ret.dyn_value(val)
		return
	} $else $if T is RequestOwnedZBox {
		ret.request_owned(val)
		return
	} $else $if T is RequestBorrowedZBox {
		ret.request_borrowed(val)
		return
	} $else $if T is PersistentOwnedZBox {
		ret.persistent_owned(val)
		return
	} $else $if T is $sumtype {
		$for variant in T.variants {
			$if variant.typ is bool {
				if val is bool {
					ret.zval(ZVal.new_bool(val))
					return
				}
			}
			$if variant.typ is int {
				if val is int {
					ret.zval(ZVal.new_int(val))
					return
				}
			}
			$if variant.typ is i64 {
				if val is i64 {
					ret.zval(ZVal.new_int(val))
					return
				}
			}
			$if variant.typ is f64 {
				if val is f64 {
					ret.zval(ZVal.new_float(val))
					return
				}
			}
			$if variant.typ is string {
				if val is string {
					ret.zval(ZVal.new_string(val))
					return
				}
			}
			$if variant.typ is []string {
				if val is []string {
					mut z := ZVal.new_array()
					z.from_v[[]string](val) or {}
					ret.zval(z)
					return
				}
			}
			$if variant.typ is []int {
				if val is []int {
					mut z := ZVal.new_array()
					z.from_v[[]int](val) or {}
					ret.zval(z)
					return
				}
			}
			$if variant.typ is []i64 {
				if val is []i64 {
					mut z := ZVal.new_array()
					z.from_v[[]i64](val) or {}
					ret.zval(z)
					return
				}
			}
			$if variant.typ is []f64 {
				if val is []f64 {
					mut z := ZVal.new_array()
					z.from_v[[]f64](val) or {}
					ret.zval(z)
					return
				}
			}
			$if variant.typ is []bool {
				if val is []bool {
					mut z := ZVal.new_array()
					z.from_v[[]bool](val) or {}
					ret.zval(z)
					return
				}
			}
			$if variant.typ is PhpValue {
				if val is PhpValue {
					ret.value(val)
					return
				}
			}
			$if variant.typ is PhpObject {
				if val is PhpObject {
					ret.zval(val.to_zval())
					return
				}
			}
			$if variant.typ is PhpArray {
				if val is PhpArray {
					ret.zval(val.to_zval())
					return
				}
			}
			$if variant.typ is $struct {
				match val {
					variant.typ {
						mut v_name := typeof(variant.typ).name
						if v_name.contains('.') {
							v_name = v_name.all_after_last('.')
						}
						ce := unsafe { vphp_get_class_entry_fn(v_name) }
						if ce != unsafe { nil } {
							mut layout := SumTypeLayout{}
							unsafe {
								C.memcpy(&layout, &val, sizeof(SumTypeLayout))
							}
							ret.object(layout.ptr, ZendClassEntry.from_ptr(ce))
							return
						}
					}
					else {}
				}
			}
			$if variant.typ is $enum {
				match val {
					variant.typ {
						$for enum_case in variant.typ.values {
							if val == T(enum_case.value) {
								mut v_name := typeof(variant.typ).name
								if v_name.contains('.') {
									v_name = v_name.all_after_last('.')
								}
								ce := unsafe { vphp_get_class_entry_fn(v_name) }
								if ce != unsafe { nil } {
									case_zo := C.vphp_zend_enum_get_case(ce,
										&char(enum_case.name.str), enum_case.name.len)
									if case_zo != unsafe { nil } {
										mut out := ret.to_zval()
										C.vphp_zval_set_object_copy(out.raw_ptr(), case_zo)
										return
									}
								}
							}
						}
					}
					else {}
				}
			}
		}
		ret.null()
		return
	}
	mut out := ret.to_zval()
	out.from_v[T](val) or {
		$if T is $struct {
			ret.struct_value(val)
		} $else {
			throw_exception(err.msg(), 0)
			ret.null()
		}
	}
}
