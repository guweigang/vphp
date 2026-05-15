module vphp

import vphp.zval

// ============================================
// ZVal — low-level bridge wrapper around Zend zval
// NOTE:
// - This type is intended for vphp bridge internals.
// - Extension/framework code should prefer ownership-aware wrappers in
//   lifecycle.v, with `RequestBorrowedZBox` / `RequestOwnedZBox` /
//   `PersistentOwnedZBox` as the primary public naming.
// ============================================

pub struct ZVal {
pub mut:
	raw           &C.zval
	owned         bool
	is_persistent bool
}

pub fn ZVal.from_ptr(raw voidptr) ZVal {
	return unsafe {
		ZVal{
			raw: &C.zval(raw)
		}
	}
}

pub fn ZVal.from_handle(handle zval.Handle) ZVal {
	if !handle.is_valid() {
		return invalid_zval()
	}
	return ZVal.from_ptr(handle.raw_ptr())
}

pub fn (v ZVal) handle() zval.Handle {
	return zval.Handle.from_ptr(v.raw)
}

pub fn (v ZVal) raw_ptr() voidptr {
	return v.handle().raw_ptr()
}

// Callable — semantic alias for ZVal used as a PHP callable parameter.
// When used as a method parameter type, the compiler emits ZEND_ARG_CALLABLE_INFO
// so PHP reflection sees the parameter as 'callable' typed.
pub type Callable = ZVal

pub struct RuntimeCounters {
pub:
	autorelease_len              int
	owned_len                    int
	obj_registry_len             u32
	rev_registry_len             u32
	persistent_fallback_zval_len int
}

fn ZVal.new_request_slot() ZVal {
	return request_owned_zval_slot_from_handle(zval.new_request())
}

fn ZVal.new_persistent_slot() ZVal {
	return persistent_owned_zval_from_handle(zval.new_persistent())
}

fn invalid_zval() ZVal {
	return unsafe {
		ZVal{
			raw: 0
		}
	}
}

pub fn ZVal.invalid() ZVal {
	return invalid_zval()
}

fn adopt_raw_with_ownership(raw &C.zval, ownership OwnershipKind) ZVal {
	if raw == 0 {
		return invalid_zval()
	}
	mut out := unsafe {
		ZVal{
			raw:   raw
			owned: true
		}
	}
	if ownership == .owned_request {
		RequestScope.autorelease_add_handle(out.handle())
		if out.is_object() {
			RequestScope.autorelease_forget_handle(out.handle())
		}
	}
	return out
}

fn adopt_handle_with_ownership(handle zval.Handle, ownership OwnershipKind) ZVal {
	if !handle.is_valid() {
		return invalid_zval()
	}
	return adopt_raw_with_ownership(ZVal.from_handle(handle).raw, ownership)
}

fn clone_raw_with_ownership(src &C.zval, ownership OwnershipKind) ZVal {
	if src == 0 {
		return invalid_zval()
	}
	mut out := if ownership == .owned_persistent {
		ZVal.new_persistent_slot()
	} else {
		ZVal.new_request_slot()
	}
	zval.copy(out.handle(), zval.Handle.from_ptr(src))
	if ownership == .owned_request {
		RequestScope.autorelease_add_handle(out.handle())
		if out.is_object() {
			RequestScope.autorelease_forget_handle(out.handle())
		}
	}
	return out
}

fn adopt_read_result(rv &C.zval, res &C.zval, ownership OwnershipKind) ZVal {
	if rv == 0 {
		return invalid_zval()
	}
	if res == 0 {
		zval.release_request(zval.Handle.from_ptr(rv))
		return invalid_zval()
	}
	if usize(res) == usize(rv) {
		return adopt_raw_with_ownership(rv, ownership)
	}
	zval.release_request(zval.Handle.from_ptr(rv))
	if ownership == .borrowed {
		return unsafe {
			ZVal{
				raw: res
			}
		}
	}
	return clone_raw_with_ownership(res, ownership)
}

fn adopt_read_result_handles(result zval.ReadResult, ownership OwnershipKind) ZVal {
	if !result.rv.is_valid() {
		return invalid_zval()
	}
	return adopt_read_result(ZVal.from_handle(result.rv).raw, ZVal.from_handle(result.res).raw,
		ownership)
}

pub fn runtime_counters() RuntimeCounters {
	state := zval.runtime_state()
	return RuntimeCounters{
		autorelease_len:              state.autorelease_len
		owned_len:                    state.owned_len
		obj_registry_len:             state.obj_registry_len
		rev_registry_len:             state.rev_registry_len
		persistent_fallback_zval_len: persistent_fallback_zval_count()
	}
}
