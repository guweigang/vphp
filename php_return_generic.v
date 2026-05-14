module vphp

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
	mut out := ret.to_zval()
	out.from_v[T](val) or {
		$if T is $struct {
			ret.struct_value(val)
		} $else {
			ret.null()
		}
	}
}
