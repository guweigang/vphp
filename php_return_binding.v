module vphp

import vphp.object
import vphp.zend as _
import vphp.zval as zvalmod

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
	}
	mut out := ret.to_zval()
	out.from_v[T](val) or {
		$if T is $struct {
			ret.struct_value(val)
		} $else {
			ret.null()
		}
	}
}
