module vphp

import vphp.zend as _

// get_globals returns the current request/thread extension globals declared
// with @[php_globals]. Field-level mutation is the intended write path.
pub fn get_globals[T]() &T {
	return unsafe { &T(C.vphp_get_active_globals()) }
}
