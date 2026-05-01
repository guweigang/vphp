module vphp

pub struct PhpResource {
mut:
	value PhpValueZBox
}

pub fn PhpResource.from_zval(z ZVal) ?PhpResource {
	if !z.is_resource() {
		return none
	}
	return PhpResource{
		value: PhpValueZBox.from_zval(z)
	}
}

pub fn PhpResource.must_from_zval(z ZVal) !PhpResource {
	res := PhpResource.from_zval(z) or { return error('zval is not resource') }
	return res
}

pub fn PhpResource.from_request_owned_zbox(value RequestOwnedZBox) ?PhpResource {
	if !value.is_resource() {
		return none
	}
	return PhpResource{
		value: PhpValueZBox.request_owned(value)
	}
}

pub fn PhpResource.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpResource {
	if !value.is_resource() {
		return none
	}
	return PhpResource{
		value: PhpValueZBox.persistent_owned(value)
	}
}

pub fn PhpResource.from_persistent_zval(z ZVal) ?PhpResource {
	return PhpResource.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn (r PhpResource) to_zval() ZVal {
	return r.value.to_zval()
}

pub fn (r PhpResource) to_borrowed() PhpResource {
	return PhpResource.from_zval(r.value.to_borrowed_zbox().to_zval()) or { r }
}

pub fn (r PhpResource) to_borrowed_zbox() RequestBorrowedZBox {
	return r.value.to_borrowed_zbox()
}

pub fn (r PhpResource) to_request_owned() PhpResource {
	return PhpResource.from_request_owned_zbox(r.value.to_request_owned_zbox()) or { r.to_borrowed() }
}

pub fn (r PhpResource) to_request_owned_zbox() RequestOwnedZBox {
	return r.value.to_request_owned_zbox()
}

pub fn (r PhpResource) to_persistent_owned() PhpResource {
	return PhpResource.from_persistent_owned_zbox(r.value.to_persistent_owned_zbox()) or {
		r.to_borrowed()
	}
}

pub fn (r PhpResource) to_persistent_owned_zbox() PersistentOwnedZBox {
	return r.value.to_persistent_owned_zbox()
}

pub fn (mut r PhpResource) take_zval() ZVal {
	return r.value.take_zval()
}

pub fn (mut r PhpResource) release() {
	r.value.release()
}

pub fn (r PhpResource) ptr() voidptr {
	return r.to_zval().to_res()
}

pub fn (r PhpResource) type_name() string {
	return r.to_zval().resource_type() or { '' }
}

pub fn (r PhpResource) is_stream() bool {
	return r.to_zval().is_stream_resource()
}

pub fn (r PhpResource) stream_metadata() ?StreamMetadata {
	return r.to_zval().stream_metadata()
}

pub fn (r PhpResource) rewind() bool {
	return r.to_zval().stream_rewind()
}

pub fn (r PhpResource) contents() ?string {
	return r.to_zval().stream_get_contents()
}

pub fn (r PhpResource) eof() bool {
	return r.to_zval().stream_eof()
}

pub fn (r PhpResource) read_line() ?string {
	return r.to_zval().stream_read_line()
}

pub fn (r PhpResource) close() bool {
	return r.to_zval().stream_close()
}
