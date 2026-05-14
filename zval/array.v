module zval

import vphp.zend

pub fn array_init(handle Handle) {
	if !handle.is_valid() {
		return
	}
	zend.array_init_ptr(handle.raw_ptr())
}

pub fn array_add_assoc_string(handle Handle, key string, val string) {
	if !handle.is_valid() {
		return
	}
	zend.array_add_assoc_string_ptr(handle.raw_ptr(), key, val)
}

pub fn array_add_assoc_long(handle Handle, key string, val i64) {
	if !handle.is_valid() {
		return
	}
	zend.array_add_assoc_long_ptr(handle.raw_ptr(), key, val)
}

pub fn array_add_assoc_double(handle Handle, key string, val f64) {
	if !handle.is_valid() {
		return
	}
	zend.array_add_assoc_double_ptr(handle.raw_ptr(), key, val)
}

pub fn array_add_assoc_bool(handle Handle, key string, val bool) {
	if !handle.is_valid() {
		return
	}
	zend.array_add_assoc_bool_ptr(handle.raw_ptr(), key, val)
}

pub fn array_add_assoc_zval(handle Handle, key string, val Handle) {
	if !handle.is_valid() || !val.is_valid() {
		return
	}
	zend.array_add_assoc_zval_ptr(handle.raw_ptr(), key, val.raw_ptr())
}

pub fn array_push_string(handle Handle, s string) {
	if !handle.is_valid() {
		return
	}
	zend.array_push_string_ptr(handle.raw_ptr(), s)
}

pub fn array_push_long(handle Handle, val i64) {
	if !handle.is_valid() {
		return
	}
	zend.array_push_long_ptr(handle.raw_ptr(), val)
}

pub fn array_push_double(handle Handle, val f64) {
	if !handle.is_valid() {
		return
	}
	zend.array_push_double_ptr(handle.raw_ptr(), val)
}

pub fn array_push_bool(handle Handle, val bool) {
	if !handle.is_valid() {
		return
	}
	zend.array_push_bool_ptr(handle.raw_ptr(), val)
}

pub fn array_add_next_zval(handle Handle, val Handle) {
	if !handle.is_valid() || !val.is_valid() {
		return
	}
	zend.array_add_next_zval_ptr(handle.raw_ptr(), val.raw_ptr())
}

pub fn array_count(handle Handle) int {
	if !handle.is_valid() {
		return 0
	}
	return zend.array_count_ptr(handle.raw_ptr())
}

pub fn array_get_index(handle Handle, index int) Handle {
	if !handle.is_valid() {
		return Handle.invalid()
	}
	return Handle.from_ptr(zend.array_get_index_ptr(handle.raw_ptr(), index))
}

pub fn array_get_key(handle Handle, key string) Handle {
	if !handle.is_valid() {
		return Handle.invalid()
	}
	return Handle.from_ptr(zend.array_get_key_ptr(handle.raw_ptr(), key))
}

pub fn is_null(handle Handle) bool {
	if !handle.is_valid() {
		return true
	}
	return zend.zval_is_null_ptr(handle.raw_ptr())
}
