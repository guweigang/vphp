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

pub fn DynValue.persistent_owned_zbox[T](value T) PersistentOwnedZBox {
	$if T is DynValue {
		return PersistentOwnedZBox{
			ZValViewState: zbox_view_state(invalid_zval())
			kind:          .dyn_data
			dyn_data:      value
		}
	} $else $if T is RetainedObject {
		return PersistentOwnedZBox{
			ZValViewState: zbox_view_state(invalid_zval())
			kind:          .dyn_data
			dyn_data:      DynValue.retained_object(value)
		}
	} $else $if T is RetainedCallable {
		return PersistentOwnedZBox{
			ZValViewState: zbox_view_state(invalid_zval())
			kind:          .dyn_data
			dyn_data:      DynValue.retained_callable(value)
		}
	} $else {
		panic('DynValue.persistent_owned_zbox expects DynValue, RetainedObject, or RetainedCallable')
	}
}

fn persistent_owned_fallback_zval_box(z ZVal) PersistentOwnedZBox {
	if z.is_valid() {
		persistent_fallback_zval_inc()
	}
	return PersistentOwnedZBox{
		ZValViewState: zbox_view_state(z)
		kind:          .fallback_zval
	}
}

pub fn borrow_zbox(z ZVal) RequestBorrowedZBox {
	return RequestBorrowedZBox.of(z)
}

pub fn own_request_zbox(z ZVal) RequestOwnedZBox {
	return RequestOwnedZBox.of(z)
}

pub fn own_persistent_zbox(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.of(z)
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
	return unsafe {
		RequestBorrowedZBox.from_raw_zval(ZVal{
			raw:   raw
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

pub fn RequestOwnedZBox.adopt_zval(z ZVal) RequestOwnedZBox {
	return request_owned_zbox_from_adopted_zval(z)
}

pub fn own_persistent_zbox_raw(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_raw_zval(z)
}

pub fn PersistentOwnedZBox.from_raw_zval(z ZVal) PersistentOwnedZBox {
	if z.is_valid() && z.is_callable() {
		if retained_callable := RetainedCallable.from_zval(z) {
			return DynValue.persistent_owned_zbox(retained_callable)
		}
	}
	if z.is_valid() && z.is_object() {
		if retained := RetainedObject.from_zval(z) {
			return DynValue.persistent_owned_zbox(retained)
		}
	}
	if dyn := DynValue.from_zval(z) {
		if dyn.is_persistent_safe() {
			return DynValue.persistent_owned_zbox(dyn)
		}
	}
	// Keep raw zval fallback as a narrow compatibility path only.
	// Safe long-lived values should prefer detached DynValue/string data or
	// retained object handles above.
	return persistent_owned_fallback_zval_box(z.dup_persistent())
}

pub fn PersistentOwnedZBox.from_callable_zval(z ZVal) PersistentOwnedZBox {
	if retained_callable := RetainedCallable.from_zval(z) {
		return DynValue.persistent_owned_zbox(retained_callable)
	}
	if retained := RetainedObject.from_zval(z) {
		return DynValue.persistent_owned_zbox(retained)
	}
	return PersistentOwnedZBox.from_raw_zval(z)
}

pub fn PersistentOwnedZBox.of_callable(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_callable_zval(z)
}

// from_object_zval is the explicit long-lived path for PHP objects.
// Prefer this over generic value routing when the input is known to be object-like.
pub fn PersistentOwnedZBox.from_object_zval(z ZVal) PersistentOwnedZBox {
	if retained := RetainedObject.from_zval(z) {
		return DynValue.persistent_owned_zbox(retained)
	}
	return PersistentOwnedZBox.from_raw_zval(z)
}

pub fn PersistentOwnedZBox.of_object(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_object_zval(z)
}

pub fn own_persistent_dyn(value DynValue) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_dyn(value)
}

pub fn PersistentOwnedZBox.from_zval(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_raw_zval(z)
}

// from_persistent_zval keeps the original zval payload as a persistent duplicate
// without routing through detached DynValue decoding.
pub fn PersistentOwnedZBox.from_persistent_zval(z ZVal) PersistentOwnedZBox {
	if !z.is_valid() || z.is_undef() {
		return PersistentOwnedZBox.new_null()
	}
	return persistent_owned_fallback_zval_box(z.dup_persistent())
}

// of is the friendly long-lived entry point for a general PHP value.
// It will route safe data into detached storage and objects into retained
// handles, only falling back to raw persistent zval compatibility when needed.
pub fn PersistentOwnedZBox.of(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_zval(z)
}

pub fn PersistentOwnedZBox.from_dyn(value DynValue) PersistentOwnedZBox {
	return DynValue.persistent_owned_zbox(value)
}

// of_data is the preferred long-lived entry point when the caller already has
// detached V-side data instead of a Zend value.
pub fn PersistentOwnedZBox.of_data(value DynValue) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_dyn(value)
}

pub fn PersistentOwnedZBox.from_detached_zval(z ZVal) ?PersistentOwnedZBox {
	detached := DynValue.from_zval(z) or { return none }
	if !detached.is_persistent_safe() {
		return none
	}
	return PersistentOwnedZBox.from_dyn(detached)
}

// try_of_detached requires the input zval to be safely detachable pure data.
pub fn PersistentOwnedZBox.try_of_detached(z ZVal) ?PersistentOwnedZBox {
	return PersistentOwnedZBox.from_detached_zval(z)
}

// from_mixed_zval is the explicit "general long-lived input" path.
// It prefers detached data first, then falls back to the smart routing used by of().
pub fn PersistentOwnedZBox.from_mixed_zval(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_detached_zval(z) or { PersistentOwnedZBox.from_zval(z) }
}

// from_value_zval is kept as a narrow compatibility alias.
// New code should prefer from_mixed_zval(...).
pub fn PersistentOwnedZBox.from_value_zval(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_mixed_zval(z)
}

// of_mixed prefers detached long-lived data, then falls back to the general
// long-lived route for mixed values. Use of_callable/of_object when the input
// kind is already known, so mixed fallback stays a narrow compatibility path.
pub fn PersistentOwnedZBox.of_mixed(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_mixed_zval(z)
}

// of_value is kept as a narrow compatibility alias.
// New code should prefer of_mixed(...).
pub fn PersistentOwnedZBox.of_value(z ZVal) PersistentOwnedZBox {
	return PersistentOwnedZBox.of_mixed(z)
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

pub fn PersistentOwnedZBox.new_null() PersistentOwnedZBox {
	return PersistentOwnedZBox.from_dyn(DynValue.null())
}

pub fn PersistentOwnedZBox.invalid() PersistentOwnedZBox {
	return PersistentOwnedZBox{
		ZValViewState: zbox_view_state(invalid_zval())
		kind:          .fallback_zval
	}
}

pub fn release_persistent_boxes(mut list []PersistentOwnedZBox) {
	PersistentOwnedZBox.release_all(mut list)
}

pub fn PersistentOwnedZBox.release_all(mut list []PersistentOwnedZBox) {
	for i in 0 .. list.len {
		list[i].release()
	}
	unsafe {
		list.free()
	}
}

pub fn PersistentOwnedZBox.new_int(n i64) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_dyn(DynValue.of_int(n))
}

pub fn PersistentOwnedZBox.new_float(f f64) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_dyn(DynValue.of_float(f))
}

pub fn PersistentOwnedZBox.new_bool(b bool) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_dyn(DynValue.of_bool(b))
}

pub fn PersistentOwnedZBox.new_string(s string) PersistentOwnedZBox {
	return PersistentOwnedZBox.from_dyn(DynValue.of_string(s))
}

pub fn borrowed_zbox_from_raw(raw &C.zval) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_raw(raw)
}
