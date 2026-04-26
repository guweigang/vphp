module vphp

pub struct PhpResource {
	value RequestBorrowedZBox
}

pub fn PhpResource.from_zval(z ZVal) ?PhpResource {
	if !z.is_resource() {
		return none
	}
	return PhpResource{
		value: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpResource.must_from_zval(z ZVal) !PhpResource {
	res := PhpResource.from_zval(z) or { return error('zval is not resource') }
	return res
}

pub fn (r PhpResource) to_zval() ZVal {
	return r.value.to_zval()
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
