module vphp

pub type PhpArgInput = PhpArray
	| PhpArg
	| PhpBool
	| PhpCallable
	| PhpClosure
	| PhpDouble
	| PhpEnumCase
	| PhpInt
	| PhpIterable
	| PhpIterator
	| PhpNull
	| PhpObject
	| PhpReference
	| PhpResource
	| PhpScalar
	| PhpString
	| PhpThrowable
	| PhpValue

pub fn (arg PhpArgInput) to_zval() ZVal {
	return match arg {
		PhpArray { arg.to_zval() }
		PhpArg { arg.to_zval() }
		PhpBool { arg.to_zval() }
		PhpCallable { arg.to_zval() }
		PhpClosure { arg.to_zval() }
		PhpDouble { arg.to_zval() }
		PhpEnumCase { arg.to_zval() }
		PhpInt { arg.to_zval() }
		PhpIterable { arg.to_zval() }
		PhpIterator { arg.to_zval() }
		PhpNull { arg.to_zval() }
		PhpObject { arg.to_zval() }
		PhpReference { arg.to_zval() }
		PhpResource { arg.to_zval() }
		PhpScalar { arg.to_zval() }
		PhpString { arg.to_zval() }
		PhpThrowable { arg.to_zval() }
		PhpValue { arg.to_zval() }
	}
}

pub fn (arg PhpArgInput) to_value() PhpValue {
	return PhpValue.from_zval(arg.to_zval())
}

pub fn (arg PhpArgInput) value_at(key string) PhpValue {
	return PhpValue.from_zval(arg.to_zval().value_at(key))
}

pub fn php_arg_inputs_to_zvals(args []PhpArgInput) []ZVal {
	mut out := []ZVal{cap: args.len}
	for arg in args {
		out << arg.to_zval()
	}
	return out
}

fn php_call_result_as[T](z ZVal) !T {
	$if T is PhpValue {
		return PhpValue.from_zval(z)
	} $else $if T is PhpNull {
		return PhpNull.must_from_zval(z)!
	} $else $if T is PhpBool {
		return PhpBool.must_from_zval(z)!
	} $else $if T is PhpInt {
		return PhpInt.must_from_zval(z)!
	} $else $if T is PhpDouble {
		return PhpDouble.must_from_zval(z)!
	} $else $if T is PhpString {
		return PhpString.must_from_zval(z)!
	} $else $if T is PhpScalar {
		return PhpScalar.must_from_zval(z)!
	} $else $if T is PhpArray {
		return PhpArray.must_from_zval(z)!
	} $else $if T is PhpObject {
		return PhpObject.must_from_zval(z)!
	} $else $if T is PhpCallable {
		return PhpCallable.must_from_zval(z)!
	} $else $if T is PhpClosure {
		return PhpClosure.must_from_zval(z)!
	} $else $if T is PhpResource {
		return PhpResource.must_from_zval(z)!
	} $else $if T is PhpIterable {
		return PhpIterable.must_from_zval(z)!
	} $else $if T is PhpIterator {
		return PhpIterator.must_from_zval(z)!
	} $else $if T is PhpReference {
		return PhpReference.must_from_zval(z)!
	} $else $if T is PhpThrowable {
		return PhpThrowable.must_from_zval(z)!
	} $else $if T is PhpEnumCase {
		return PhpEnumCase.must_from_zval(z)!
	} $else {
		return error('unsupported PHP call result type')
	}
}

fn php_call_copied_result_as[T](z ZVal) !T {
	$if T is PhpNull {
		_ := PhpNull.must_from_zval(z)!
		return PhpNull.value()
	} $else $if T is PhpBool {
		return PhpBool.of(z.to_bool())
	} $else $if T is PhpInt {
		return PhpInt.of(z.to_i64())
	} $else $if T is PhpDouble {
		return PhpDouble.of(z.to_f64())
	} $else $if T is PhpString {
		return PhpString.of(z.to_string())
	} $else {
		return error('call[T] only supports copied scalar PHP result wrappers; use with_result[T, R] or lifecycle APIs for borrowed values')
	}
}
