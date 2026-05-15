module vphp

import vphp.zend

// get_globals returns the current request/thread extension globals declared
// with @[php_globals]. Field-level mutation is the intended write path.
pub fn get_globals[T]() &T {
	return unsafe { &T(zend.active_globals_ptr()) }
}

// with_globals makes mutation intent explicit while still using Zend's active
// request/thread extension globals storage.
pub fn with_globals[T](run fn (mut T)) {
	mut globals := get_globals[T]()
	run(mut globals)
}
