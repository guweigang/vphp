module vphp

import vphp.zval

@[inline]
fn zbox_view_state(z ZVal) ZValViewState {
	return ZValViewState{
		z: z
	}
}

@[inline]
fn borrowed_zbox_from_zval(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox{
		ZValViewState: zbox_view_state(z)
	}
}

@[inline]
fn request_owned_zbox_from_adopted_zval(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox{
		ZValViewState: zbox_view_state(z)
	}
}

pub fn borrow_zbox(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox.of(z)
}

pub fn own_request_zbox(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.of(z)
}

pub fn RequestBorrowedZBox.from_zval(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_handle(z.handle())
}

pub fn RequestBorrowedZBox.of(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_zval(z)
}

pub fn RequestBorrowedZBox.from_ptr(raw voidptr) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_handle(zval.Handle.from_ptr(raw))
}

pub fn RequestBorrowedZBox.from_handle(handle zval.Handle) RequestBorrowedZBox {
	return borrowed_zbox_from_zval(ZVal.from_handle(handle))
}

// null borrowed helper for call-site ergonomics; lifetime is request-scoped.
pub fn RequestBorrowedZBox.null() RequestBorrowedZBox {
	return RequestOwnedZBox.new_null().borrowed()
}

pub fn RequestOwnedZBox.from_zval(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.from_handle(z.handle())
}

pub fn RequestOwnedZBox.of(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.from_zval(z)
}

pub fn RequestOwnedZBox.from_ptr(raw voidptr) RequestOwnedZBox {
	return RequestOwnedZBox.from_handle(zval.Handle.from_ptr(raw))
}

pub fn RequestOwnedZBox.from_handle(handle zval.Handle) RequestOwnedZBox {
	return request_owned_zbox_from_adopted_zval(ZVal.from_handle(handle).dup())
}

pub fn RequestOwnedZBox.adopt_zval(z ZVal) RequestOwnedZBox {
	return request_owned_zbox_from_adopted_zval(z)
}

pub fn RequestOwnedZBox.new_null() RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(ZVal.new_null())
}

pub fn RequestOwnedZBox.new_int(n i64) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(ZVal.new_int(n))
}

pub fn RequestOwnedZBox.new_float(f f64) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(ZVal.new_float(f))
}

pub fn RequestOwnedZBox.new_bool(b bool) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(ZVal.new_bool(b))
}

pub fn RequestOwnedZBox.new_string(s string) RequestOwnedZBox {
	return RequestOwnedZBox.adopt_zval(ZVal.new_string(s))
}

pub fn RequestOwnedZBox.new_array() RequestOwnedZBox {
	mut value := RequestOwnedZBox.new_null()
	value.to_zval().array_init()
	return value
}
