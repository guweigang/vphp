module vphp

pub struct RetainedObject {
pub mut:
	raw &C.zend_object = unsafe { nil }
}

pub fn RetainedObject.invalid() RetainedObject {
	return RetainedObject{}
}

pub fn RetainedObject.from_zval(z ZVal) ?RetainedObject {
	if !z.is_valid() || !z.is_object() {
		return none
	}
	obj := C.vphp_get_obj_from_zval(z.raw)
	if isnil(obj) {
		return none
	}
	C.vphp_object_addref(obj)
	return RetainedObject{
		raw: obj
	}
}

pub fn (r RetainedObject) is_valid() bool {
	return r.raw != unsafe { nil }
}

pub fn (r RetainedObject) clone() RetainedObject {
	if r.raw == unsafe { nil } {
		return RetainedObject.invalid()
	}
	C.vphp_object_addref(r.raw)
	return RetainedObject{
		raw: r.raw
	}
}

pub fn (r RetainedObject) to_request_owned_zval() ZVal {
	if r.raw == unsafe { nil } {
		return invalid_zval()
	}
	unsafe {
		mut out := C.vphp_new_zval()
		if out == 0 {
			return invalid_zval()
		}
		C.vphp_wrap_existing_object(out, r.raw)
		return adopt_raw_with_ownership(out, .owned_request)
	}
}

pub fn (r RetainedObject) with_request_zval[T](run fn (ZVal) T) T {
	mut out := RequestOwnedZBox{
		ZValViewState: ZValViewState{
			z: r.to_request_owned_zval()
		}
	}
	defer {
		out.release()
	}
	return run(out.to_zval())
}

pub fn (r RetainedObject) with_request_value[T](run fn (PhpValue) T) T {
	return r.with_request_zval[T](fn [run] [T] (z ZVal) T {
		return run(PhpValue.from_zval(z))
	})
}

pub fn (r RetainedObject) with_request_object[T](run fn (PhpObject) T) ?T {
	mut out := RequestOwnedZBox{
		ZValViewState: ZValViewState{
			z: r.to_request_owned_zval()
		}
	}
	defer {
		out.release()
	}
	obj := PhpObject.from_zval(out.to_zval()) or { return none }
	return run(obj)
}

pub fn (mut r RetainedObject) release() {
	if r.raw == unsafe { nil } {
		return
	}
	C.vphp_object_release(r.raw)
	r.raw = unsafe { nil }
}
