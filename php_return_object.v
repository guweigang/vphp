module vphp

import vphp.object

pub fn (ret PhpReturn) resource(ptr voidptr, label string) {
	ret.to_zval().make_resource(ptr, label)
}

pub fn (ret PhpReturn) object(v_ptr voidptr, ce ZendClassEntry) {
	object.return_unbound(ret.raw_ptr(), v_ptr, ce.raw_ptr())
}

pub fn (ret PhpReturn) bound_object(v_ptr voidptr, ce ZendClassEntry, handlers voidptr, ownership OwnershipKind) {
	match ownership {
		.borrowed {
			object.return_bound(ret.raw_ptr(), v_ptr, ce.raw_ptr(), handlers, .borrowed)
		}
		.owned_request, .owned_persistent {
			object.return_bound(ret.raw_ptr(), v_ptr, ce.raw_ptr(), handlers, .owned)
		}
	}
}

pub fn (ret PhpReturn) owned_object(v_ptr voidptr, ce ZendClassEntry, handlers voidptr) {
	ret.bound_object(v_ptr, ce, handlers, .owned_request)
}

pub fn (ret PhpReturn) borrowed_object(v_ptr voidptr, ce ZendClassEntry, handlers voidptr) {
	ret.bound_object(v_ptr, ce, handlers, .borrowed)
}
