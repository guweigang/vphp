module object

import vphp.zend

pub enum ReturnOwnership {
	borrowed
	owned
}

pub fn return_unbound(ret voidptr, v_ptr voidptr, ce voidptr) {
	zend.return_unbound_object_ptr(ret, v_ptr, ce)
}

pub fn return_bound(ret voidptr, v_ptr voidptr, ce voidptr, handlers ObjectHandlers, ownership ReturnOwnership) {
	match ownership {
		.borrowed {
			zend.return_borrowed_object_ptr(ret, v_ptr, ce, handlers.raw_ptr())
		}
		.owned {
			register_root(v_ptr)
			zend.return_owned_object_ptr(ret, v_ptr, ce, handlers.raw_ptr())
		}
	}
}
