// Module zval: Safe value handle layer.
//
// This module provides the Handle abstraction over raw Zend zval pointers.
// All operations delegate to the zend/ module for actual C interop — zval/
// never calls C functions directly.
//
// Dependency rule: zval/ imports zend/ for low-level operations, but zend/
// never imports zval/. Extension code should prefer zval.Handle over raw
// voidptr/&C.zval when possible.
//
// See docs/zend_wrapper_layers.md for the full layering strategy.
module zval

pub struct Handle {
	raw voidptr
}

pub fn Handle.invalid() Handle {
	return Handle{}
}

pub fn Handle.from_ptr(raw voidptr) Handle {
	return Handle{
		raw: raw
	}
}

pub fn (handle Handle) is_valid() bool {
	return handle.raw != 0
}

pub fn (handle Handle) raw_ptr() voidptr {
	return handle.raw
}
