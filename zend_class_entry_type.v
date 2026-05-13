module vphp

import vphp.zend as _

pub struct ZendClassEntry {
	raw voidptr
}

pub fn ZendClassEntry.from_raw(raw voidptr) ZendClassEntry {
	return ZendClassEntry{
		raw: raw
	}
}

pub fn (ce ZendClassEntry) is_valid() bool {
	return ce.raw != 0
}

pub fn (ce ZendClassEntry) set_static_prop[T](name string, val T) {
	if !ce.is_valid() {
		return
	}
	$if T is int {
		C.vphp_update_static_property_long(ce.raw, &char(name.str), int(name.len), i64(val))
	} $else $if T is string {
		C.vphp_update_static_property_string(ce.raw, &char(name.str), int(name.len),
			&char(val.str), int(val.len))
	} $else $if T is bool {
		C.vphp_update_static_property_bool(ce.raw, &char(name.str), int(name.len), int(val))
	}
}

pub fn (ce ZendClassEntry) static_prop[T](name string) T {
	if !ce.is_valid() {
		return T{}
	}
	$if T is int {
		return int(C.vphp_get_static_property_long(ce.raw, &char(name.str), int(name.len)))
	} $else $if T is string {
		res := C.vphp_get_static_property_string(ce.raw, &char(name.str), int(name.len))
		return unsafe { res.vstring() }
	} $else $if T is bool {
		return C.vphp_get_static_property_bool(ce.raw, &char(name.str), int(name.len)) != 0
	}
	return T{}
}
