module vphp

pub fn (v ZVal) make_resource(ptr voidptr, label string) {
	if !v.is_valid() {
		return
	}
	C.vphp_make_res(v.raw, ptr, &char(label.str))
}

pub fn (v ZVal) resource_ptr() voidptr {
	if !v.is_valid() || !v.is_resource() {
		return unsafe { nil }
	}
	return C.vphp_fetch_res(v.raw)
}

// Compatibility alias. Prefer `resource_ptr()` in new code.
pub fn (v ZVal) to_res() voidptr {
	return v.resource_ptr()
}
