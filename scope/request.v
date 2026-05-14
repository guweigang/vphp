module scope

import vphp.zend

pub fn request_mark() int {
	return zend.autorelease_mark()
}

pub fn request_enter() int {
	return request_mark()
}

pub fn request_leave(mark int) {
	zend.autorelease_drain(mark)
}
