module vphp

pub struct RetainedObject {
mut:
	object ZendObject
}

pub fn RetainedObject.invalid() RetainedObject {
	return RetainedObject{
		object: ZendObject.invalid()
	}
}

pub fn RetainedObject.from_zval(z ZVal) ?RetainedObject {
	if !z.is_valid() || !z.is_object() {
		return none
	}
	obj := ZendObject.from_zval(z)
	if !obj.is_valid() {
		return none
	}
	obj.add_ref()
	return RetainedObject{
		object: obj
	}
}

pub fn (r RetainedObject) is_valid() bool {
	return r.object.is_valid()
}

pub fn (r RetainedObject) clone() RetainedObject {
	if !r.object.is_valid() {
		return RetainedObject.invalid()
	}
	r.object.add_ref()
	return RetainedObject{
		object: r.object
	}
}

pub fn (r RetainedObject) to_request_owned_zval() ZVal {
	return r.object.to_request_owned_zval()
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
	return r.with_request_zval[T](fn [run] [T](z ZVal) T {
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
	if !r.object.is_valid() {
		return
	}
	r.object.release()
	r.object = ZendObject.invalid()
}
