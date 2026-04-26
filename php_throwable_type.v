module vphp

pub struct PhpThrowable {
	object PhpObject
}

pub fn PhpThrowable.from_zval(z ZVal) ?PhpThrowable {
	if !z.is_object() || !z.is_instance_of('Throwable') {
		return none
	}
	return PhpThrowable{
		object: PhpObject.must_from_zval(z) or { return none }
	}
}

pub fn PhpThrowable.must_from_zval(z ZVal) !PhpThrowable {
	t := PhpThrowable.from_zval(z) or { return error('zval is not Throwable') }
	return t
}

pub fn (t PhpThrowable) to_zval() ZVal {
	return t.object.to_zval()
}

pub fn (t PhpThrowable) to_object() PhpObject {
	return t.object
}

pub fn (t PhpThrowable) class_name() string {
	return t.object.class_name()
}

pub fn (t PhpThrowable) message() string {
	return t.object.method_v[string]('getMessage', []) or { '' }
}

pub fn (t PhpThrowable) code() int {
	return t.object.method_v[int]('getCode', []) or { 0 }
}

pub fn (t PhpThrowable) file() string {
	return t.object.method_v[string]('getFile', []) or { '' }
}

pub fn (t PhpThrowable) line() int {
	return t.object.method_v[int]('getLine', []) or { 0 }
}

pub fn (t PhpThrowable) trace_as_string() string {
	return t.object.method_v[string]('getTraceAsString', []) or { '' }
}

pub fn (t PhpThrowable) throw() {
	mut z := t.to_zval().dup()
	throw_exception_object(mut z)
}
