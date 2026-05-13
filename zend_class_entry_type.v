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

pub fn (ce ZendClassEntry) raw_ptr() voidptr {
	return ce.raw
}

fn zend_class_set_static_long(ce ZendClassEntry, name string, val i64) {
	C.vphp_update_static_property_long(ce.raw, &char(name.str), int(name.len), val)
}

fn zend_class_set_static_string(ce ZendClassEntry, name string, val string) {
	C.vphp_update_static_property_string(ce.raw, &char(name.str), int(name.len), &char(val.str),
		int(val.len))
}

fn zend_class_set_static_bool(ce ZendClassEntry, name string, val bool) {
	C.vphp_update_static_property_bool(ce.raw, &char(name.str), int(name.len), int(val))
}

fn zend_class_static_long(ce ZendClassEntry, name string) i64 {
	return C.vphp_get_static_property_long(ce.raw, &char(name.str), int(name.len))
}

fn zend_class_static_string(ce ZendClassEntry, name string) string {
	res := C.vphp_get_static_property_string(ce.raw, &char(name.str), int(name.len))
	return unsafe { res.vstring() }
}

fn zend_class_static_bool(ce ZendClassEntry, name string) bool {
	return C.vphp_get_static_property_bool(ce.raw, &char(name.str), int(name.len)) != 0
}

pub fn (ce ZendClassEntry) set_static_prop[T](name string, val T) {
	if !ce.is_valid() {
		return
	}
	$if T is int {
		zend_class_set_static_long(ce, name, i64(val))
	} $else $if T is string {
		zend_class_set_static_string(ce, name, val)
	} $else $if T is bool {
		zend_class_set_static_bool(ce, name, val)
	}
}

pub fn (ce ZendClassEntry) static_prop[T](name string) T {
	if !ce.is_valid() {
		return T{}
	}
	$if T is int {
		return int(zend_class_static_long(ce, name))
	} $else $if T is string {
		return zend_class_static_string(ce, name)
	} $else $if T is bool {
		return zend_class_static_bool(ce, name)
	}
	return T{}
}
