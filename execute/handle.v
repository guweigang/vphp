module execute

pub struct Handle {
	raw voidptr
}

pub fn Handle.from_ptr(raw voidptr) Handle {
	return Handle{
		raw: raw
	}
}

pub fn (handle Handle) raw_ptr() voidptr {
	return handle.raw
}
