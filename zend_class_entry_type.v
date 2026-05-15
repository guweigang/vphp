module vphp

import vphp.zend

pub struct ZendClassEntry {
	raw voidptr
}

pub fn ZendClassEntry.from_ptr(raw voidptr) ZendClassEntry {
	return ZendClassEntry{
		raw: raw
	}
}

pub fn (ce ZendClassEntry) is_valid() bool {
	return ce.raw_ptr() != 0
}

pub fn (ce ZendClassEntry) raw_ptr() voidptr {
	return ce.raw
}

pub fn (ce ZendClassEntry) set_static_prop[T](name string, val T) {
	if !ce.is_valid() {
		return
	}
	$if T is int {
		zend.set_static_long(ce.raw_ptr(), name, i64(val))
	} $else $if T is string {
		zend.set_static_string(ce.raw_ptr(), name, val)
	} $else $if T is bool {
		zend.set_static_bool(ce.raw_ptr(), name, val)
	}
}

pub fn (ce ZendClassEntry) static_prop[T](name string) T {
	if !ce.is_valid() {
		return T{}
	}
	$if T is int {
		return int(zend.static_long(ce.raw_ptr(), name))
	} $else $if T is string {
		return zend.static_string(ce.raw_ptr(), name)
	} $else $if T is bool {
		return zend.static_bool(ce.raw_ptr(), name)
	}
	return T{}
}
