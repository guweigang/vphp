module scope

import vphp.zend

pub fn autorelease_add_ptr(z voidptr) {
	if z == 0 {
		return
	}
	zend.autorelease_add_ptr(z)
}

pub fn autorelease_forget_ptr(z voidptr) {
	if z == 0 {
		return
	}
	zend.autorelease_forget_ptr(z)
}

pub fn autorelease_drain(mark int) {
	zend.autorelease_drain(mark)
}
