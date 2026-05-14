module zval

pub struct Handle {
	raw voidptr
}

pub fn Handle.invalid() Handle {
	return Handle{}
}

pub fn Handle.from_ptr(raw voidptr) Handle {
	return Handle{
		raw: raw
	}
}

pub fn (handle Handle) is_valid() bool {
	return handle.raw != 0
}

pub fn (handle Handle) raw_ptr() voidptr {
	return handle.raw
}
