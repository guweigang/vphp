module vphp

import vphp.object

pub fn register_vptr_root(ptr voidptr) {
	object.register_root(ptr)
}

pub fn ensure_vptr_root(ptr voidptr) {
	object.ensure_root(ptr)
}

pub fn unregister_vptr_root(ptr voidptr) {
	object.unregister_root(ptr)
}
