module vphp

// ======== Class entry static property helpers ========

pub fn set_static_prop[T](ce voidptr, name string, val T) {
	ZendClassEntry.from_raw(ce).set_static_prop[T](name, val)
}

pub fn get_static_prop[T](ce voidptr, name string) T {
	return ZendClassEntry.from_raw(ce).static_prop[T](name)
}
