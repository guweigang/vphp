module object

pub struct ObjectHandlers {
pub:
	raw voidptr
}

pub fn ObjectHandlers.from_ptr(raw voidptr) ObjectHandlers {
	return ObjectHandlers{
		raw: raw
	}
}

pub fn (h ObjectHandlers) raw_ptr() voidptr {
	return h.raw
}

pub fn (h ObjectHandlers) is_valid() bool {
	return h.raw != 0
}
