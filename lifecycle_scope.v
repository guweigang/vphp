module vphp

pub struct PhpScope {}

// RequestScope gives a structured, nestable request arena on top of
// autorelease marks. It is intentionally tiny and can be used with `defer`.
pub struct RequestScope {
pub:
	mark int
mut:
	active bool
}

pub struct FrameScope {
mut:
	boxes []RequestOwnedZBox
}

fn RequestScope.autorelease_mark() int {
	return C.vphp_autorelease_mark()
}

fn RequestScope.autorelease_add(z &C.zval) {
	if z == 0 {
		return
	}
	C.vphp_autorelease_add(z)
}

fn RequestScope.autorelease_forget(z &C.zval) {
	if z == 0 {
		return
	}
	C.vphp_autorelease_forget(z)
}

fn RequestScope.autorelease_drain(mark int) {
	C.vphp_autorelease_drain(mark)
}

pub fn RequestScope.enter() int {
	return RequestScope.autorelease_mark()
}

pub fn RequestScope.leave(mark int) {
	RequestScope.autorelease_drain(mark)
}

pub fn RequestScope.open() RequestScope {
	return RequestScope{
		mark:   RequestScope.enter()
		active: true
	}
}

pub fn (mut s RequestScope) close() {
	if !s.active {
		return
	}
	RequestScope.leave(s.mark)
	s.active = false
}

pub fn PhpScope.request() RequestScope {
	return RequestScope.open()
}

pub fn PhpScope.once() RequestScope {
	return RequestScope.open()
}

pub fn PhpScope.frame() FrameScope {
	return FrameScope{}
}

fn (mut s FrameScope) push_box(value RequestOwnedZBox) ZVal {
	s.boxes << value
	return s.boxes[s.boxes.len - 1].to_zval()
}

pub fn (mut s FrameScope) null() PhpNull {
	return PhpNull.must_from_zval(s.push_box(RequestOwnedZBox.new_null())) or {
		panic('FrameScope.null produced a non-null zval')
	}
}

pub fn (mut s FrameScope) bool(value bool) PhpBool {
	return PhpBool.must_from_zval(s.push_box(RequestOwnedZBox.new_bool(value))) or {
		panic('FrameScope.bool produced a non-bool zval')
	}
}

pub fn (mut s FrameScope) int(value i64) PhpInt {
	return PhpInt.must_from_zval(s.push_box(RequestOwnedZBox.new_int(value))) or {
		panic('FrameScope.int produced a non-int zval')
	}
}

pub fn (mut s FrameScope) double(value f64) PhpDouble {
	return PhpDouble.must_from_zval(s.push_box(RequestOwnedZBox.new_float(value))) or {
		panic('FrameScope.double produced a non-double zval')
	}
}

pub fn (mut s FrameScope) string(value string) PhpString {
	return PhpString.must_from_zval(s.push_box(RequestOwnedZBox.new_string(value))) or {
		panic('FrameScope.string produced a non-string zval')
	}
}

pub fn (mut s FrameScope) value(value ZVal) PhpValue {
	return PhpValue.from_zval(s.push_box(RequestOwnedZBox.from_zval(value)))
}

pub fn (mut s FrameScope) request_owned(value RequestOwnedZBox) PhpValue {
	return PhpValue.from_zval(s.push_box(value))
}

pub fn (mut s FrameScope) adopt_zval(value ZVal) PhpValue {
	return PhpValue.from_zval(s.push_box(RequestOwnedZBox.adopt_zval(value)))
}

pub fn (mut s FrameScope) args_from_zvals(values []ZVal) []PhpFnArg {
	mut out := []PhpFnArg{cap: values.len}
	for value in values {
		out << s.adopt_zval(value)
	}
	return out
}

pub fn (mut s FrameScope) args_from_persistent_owned(values []PersistentOwnedZBox) []PhpFnArg {
	mut out := []PhpFnArg{cap: values.len}
	for value in values {
		out << s.request_owned(value.clone_request_owned())
	}
	return out
}

pub fn (mut s FrameScope) release() {
	for mut box in s.boxes {
		box.release()
	}
	s.boxes.clear()
}
