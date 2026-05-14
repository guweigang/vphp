module vphp

import vphp.zend

pub struct ZendClassEntry {
	raw voidptr
}

pub fn ZendClassEntry.from_raw(raw voidptr) ZendClassEntry {
	return ZendClassEntry.from_ptr(raw)
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

fn zend_class_set_static_long(ce ZendClassEntry, name string, val i64) {
	zend.set_static_long(ce.raw_ptr(), name, val)
}

fn zend_class_set_static_string(ce ZendClassEntry, name string, val string) {
	zend.set_static_string(ce.raw_ptr(), name, val)
}

fn zend_class_set_static_bool(ce ZendClassEntry, name string, val bool) {
	zend.set_static_bool(ce.raw_ptr(), name, val)
}

fn zend_class_static_long(ce ZendClassEntry, name string) i64 {
	return zend.static_long(ce.raw_ptr(), name)
}

fn zend_class_static_string(ce ZendClassEntry, name string) string {
	return zend.static_string(ce.raw_ptr(), name)
}

fn zend_class_static_bool(ce ZendClassEntry, name string) bool {
	return zend.static_bool(ce.raw_ptr(), name)
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
