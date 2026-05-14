module zval

import vphp.zend

pub fn new_request() Handle {
	return Handle.from_ptr(zend.new_zval_ptr())
}

pub fn new_persistent() Handle {
	return Handle.from_ptr(zend.new_persistent_zval_ptr())
}

pub fn release_request(handle Handle) {
	if !handle.is_valid() {
		return
	}
	zend.release_zval_ptr(handle.raw_ptr())
}

pub fn release_persistent(handle Handle) {
	if !handle.is_valid() {
		return
	}
	zend.release_persistent_zval_ptr(handle.raw_ptr())
}

pub fn disown(handle Handle) {
	if !handle.is_valid() {
		return
	}
	zend.disown_zval_ptr(handle.raw_ptr())
}

pub fn copy(dst Handle, src Handle) {
	if !dst.is_valid() || !src.is_valid() {
		return
	}
	zend.copy_zval_ptr(dst.raw_ptr(), src.raw_ptr())
}
