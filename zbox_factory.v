module vphp

@[inline]
fn zbox_view_state(z ZVal) ZValViewState {
	return ZValViewState{
		z: z
	}
}

@[inline]
fn borrowed_zbox_from_raw_zval(z ZVal) RequestBorrowedZBox {
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

pub fn borrow_zbox_raw(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_raw_zval(z)
}

pub fn RequestBorrowedZBox.from_zval(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_raw_zval(z)
}

pub fn RequestBorrowedZBox.of(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_zval(z)
}

pub fn RequestBorrowedZBox.from_raw_zval(z ZVal) RequestBorrowedZBox {
	return borrowed_zbox_from_raw_zval(z)
}

pub fn RequestBorrowedZBox.from_raw(raw &C.zval) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_ptr(raw)
}

pub fn RequestBorrowedZBox.from_ptr(raw voidptr) RequestBorrowedZBox {
	return unsafe {
		RequestBorrowedZBox.from_raw_zval(ZVal{
			raw:   &C.zval(raw)
			owned: false
		})
	}
}

// null borrowed helper for call-site ergonomics; lifetime is request-scoped.
pub fn RequestBorrowedZBox.null() RequestBorrowedZBox {
	return RequestOwnedZBox.new_null().borrowed()
}

pub fn own_request_zbox_raw(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.from_raw_zval(z)
}

pub fn RequestOwnedZBox.from_zval(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.from_raw_zval(z)
}

pub fn RequestOwnedZBox.of(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.from_zval(z)
}

pub fn RequestOwnedZBox.from_raw_zval(z ZVal) RequestOwnedZBox {
	return request_owned_zbox_from_adopted_zval(z.dup())
}

pub fn RequestOwnedZBox.from_ptr(raw voidptr) RequestOwnedZBox {
	return RequestOwnedZBox.from_raw_zval(unsafe {
		ZVal{
			raw:   &C.zval(raw)
			owned: false
		}
	})
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

pub fn borrowed_zbox_from_raw(raw &C.zval) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_raw(raw)
}
