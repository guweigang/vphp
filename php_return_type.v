module vphp

import vphp.zend as _

pub struct PhpReturn {
	raw &C.zval
}

pub fn PhpReturn.new(raw &C.zval) PhpReturn {
	return unsafe {
		PhpReturn{
			raw: raw
		}
	}
}

pub fn (ret PhpReturn) raw_zval() &C.zval {
	return ret.raw
}

pub fn (ret PhpReturn) null() {
	unsafe { C.vphp_set_null(ret.raw) }
}

pub fn (ret PhpReturn) bool_value(val bool) {
	unsafe { C.vphp_set_bool(ret.raw, val) }
}

pub fn (ret PhpReturn) int_value(val i64) {
	unsafe {
		ZVal{
			raw: ret.raw
		}.set_int(val)
	}
}

pub fn (ret PhpReturn) double_value(val f64) {
	unsafe { C.vphp_set_double(ret.raw, val) }
}

pub fn (ret PhpReturn) string_value(val string) {
	unsafe {
		ZVal{
			raw: ret.raw
		}.set_string(val)
	}
}

pub fn (ret PhpReturn) resource(ptr voidptr, label string) {
	C.vphp_make_res(ret.raw, ptr, &char(label.str))
}

pub fn (ret PhpReturn) object(v_ptr voidptr, ce voidptr) {
	C.vphp_return_obj(ret.raw, v_ptr, ce)
}

pub fn (ret PhpReturn) bound_object(v_ptr voidptr, ce voidptr, handlers voidptr, ownership OwnershipKind) {
	return_bound_object_raw(ret.raw, v_ptr, ce, handlers, ownership)
}

pub fn (ret PhpReturn) owned_object(v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_owned_object_raw(ret.raw, v_ptr, ce, handlers)
}

pub fn (ret PhpReturn) borrowed_object(v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_borrowed_object_raw(ret.raw, v_ptr, ce, handlers)
}

pub fn (ret PhpReturn) zval(val ZVal) {
	if !val.is_valid() {
		ret.null()
		return
	}
	unsafe { C.ZVAL_COPY(ret.raw, val.raw) }
}

pub fn (ret PhpReturn) value(value PhpValue) {
	ret.zval(value.to_zval())
}

pub fn (ret PhpReturn) null_value(value PhpNull) {
	ret.zval(value.to_zval())
}

pub fn (ret PhpReturn) dyn_value(value DynValue) {
	mut box := value.request_owned_box()
	defer {
		box.release()
	}
	ret.zval(box.to_zval())
}

pub fn (ret PhpReturn) request_owned(value RequestOwnedZBox) {
	ret.zval(value.to_zval())
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

pub fn (ret PhpReturn) any[T](val T) {
	ret.v[T](val)
}

pub fn (ret PhpReturn) v[T](val T) {
	$if T is PhpValue {
		ret.value(val)
		return
	} $else $if T is PersistentPhpValue {
		ret.persistent_owned(val.value)
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
	} $else $if T is PhpArray {
		ret.zval(val.to_zval())
		return
	} $else $if T is PersistentPhpArray {
		ret.persistent_owned(val.value)
		return
	} $else $if T is PhpObject {
		ret.zval(val.to_zval())
		return
	} $else $if T is PersistentPhpObject {
		ret.persistent_owned(val.value)
		return
	} $else $if T is PhpCallable {
		ret.zval(val.to_zval())
		return
	} $else $if T is PhpClosure {
		ret.zval(val.to_zval())
		return
	} $else $if T is PersistentPhpClosure {
		ret.persistent_owned(val.value)
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
	}
	mut out := ZVal{
		raw: ret.raw
	}
	out.from_v[T](val) or {
		$if T is $struct {
			ret.struct_value(val)
		} $else {
			ret.null()
		}
	}
}

pub fn (ret PhpReturn) list[T](list []T) {
	out := ZVal{
		raw: ret.raw
	}
	out.array_init()
	for item in list {
		$if T is string {
			out.push_string(item)
		} $else $if T is f64 {
			out.push_double(item)
		} $else $if T is int || T is i64 {
			out.push_long(i64(item))
		} $else {
			mut sub_raw := C.zval{}
			mut sub := ZVal{
				raw: &sub_raw
			}
			sub.array_init()
			$for field in T.fields {
				key := field.name
				$if field.typ is string {
					sub.add_assoc_string(key, item.$(field.name))
				} $else $if field.typ is f64 {
					sub.add_assoc_double(key, item.$(field.name))
				} $else $if field.typ is int || field.typ is i64 {
					sub.add_assoc_long(key, i64(item.$(field.name)))
				} $else $if field.typ is bool {
					sub.add_assoc_bool(key, item.$(field.name))
				}
			}
			C.vphp_array_add_next_zval(out.raw, sub.raw)
		}
	}
}

pub fn (ret PhpReturn) map_value[T](m map[string]T) {
	out := ZVal{
		raw: ret.raw
	}
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
	unsafe {
		C.vphp_object_init(ret.raw)
		for k, v in props {
			C.vphp_update_property_string(ret.raw, &char(k.str), k.len, &char(v.str))
		}
	}
}

pub fn (ret PhpReturn) struct_value[T](s T) {
	out := ZVal{
		raw: ret.raw
	}
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
