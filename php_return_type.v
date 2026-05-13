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
	ZVal.from_raw(ret.raw).set_null()
}

pub fn (ret PhpReturn) bool_value(val bool) {
	ZVal.from_raw(ret.raw).set_bool(val)
}

pub fn (ret PhpReturn) int_value(val i64) {
	ZVal.from_raw(ret.raw).set_int(val)
}

pub fn (ret PhpReturn) double_value(val f64) {
	ZVal.from_raw(ret.raw).set_double(val)
}

pub fn (ret PhpReturn) string_value(val string) {
	ZVal.from_raw(ret.raw).set_string(val)
}

pub fn (ret PhpReturn) resource(ptr voidptr, label string) {
	ZVal.from_raw(ret.raw).make_resource(ptr, label)
}

pub fn (ret PhpReturn) object(v_ptr voidptr, ce voidptr) {
	return_unbound_object_to(ret.raw, v_ptr, ce)
}

pub fn (ret PhpReturn) bound_object(v_ptr voidptr, ce voidptr, handlers voidptr, ownership OwnershipKind) {
	return_bound_object_to(ret.raw, v_ptr, ce, handlers, ownership)
}

pub fn (ret PhpReturn) owned_object(v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_owned_object_raw(ret.raw, v_ptr, ce, handlers)
}

pub fn (ret PhpReturn) borrowed_object(v_ptr voidptr, ce voidptr, handlers voidptr) {
	return_borrowed_object_raw(ret.raw, v_ptr, ce, handlers)
}

pub fn (ret PhpReturn) zval(val ZVal) {
	ZVal.from_raw(ret.raw).copy_from(val)
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
	mut out := ZVal.from_raw(ret.raw)
	out.from_v[T](val) or {
		$if T is $struct {
			ret.struct_value(val)
		} $else {
			ret.null()
		}
	}
}

pub fn (ret PhpReturn) list[T](list []T) {
	out := ZVal.from_raw(ret.raw)
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
			mut sub := ZVal.from_raw(&sub_raw)
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
			out.add_next_val(sub)
		}
	}
}

pub fn (ret PhpReturn) map_value[T](m map[string]T) {
	out := ZVal.from_raw(ret.raw)
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
	out := ZVal.from_raw(ret.raw)
	out.object_init()
	for k, v in props {
		out.update_property_string(k, v)
	}
}

pub fn (ret PhpReturn) struct_value[T](s T) {
	out := ZVal.from_raw(ret.raw)
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
