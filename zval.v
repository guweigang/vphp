module vphp

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

fn C.vphp_release_zval(z &C.zval)
fn C.vphp_release_zval_persistent(z &C.zval)
fn C.vphp_disown_zval(z &C.zval)

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
		RequestScope.autorelease_add(out.raw)
		if out.is_object() {
			RequestScope.autorelease_forget(out.raw)
		}
	}
	return out
}

fn clone_raw_with_ownership(src &C.zval, ownership OwnershipKind) ZVal {
	if src == 0 {
		return invalid_zval()
	}
	mut out := ZVal{
		raw:           if ownership == .owned_persistent {
			C.vphp_new_persistent_zval()
		} else {
			C.vphp_new_zval()
		}
		owned:         true
		is_persistent: ownership == .owned_persistent
	}
	C.ZVAL_COPY(out.raw, src)
	if ownership == .owned_request {
		RequestScope.autorelease_add(out.raw)
		if out.is_object() {
			RequestScope.autorelease_forget(out.raw)
		}
	}
	return out
}

fn adopt_read_result(rv &C.zval, res &C.zval, ownership OwnershipKind) ZVal {
	if rv == 0 {
		return invalid_zval()
	}
	if res == 0 {
		C.vphp_release_zval(rv)
		return invalid_zval()
	}
	if usize(res) == usize(rv) {
		return adopt_raw_with_ownership(rv, ownership)
	}
	C.vphp_release_zval(rv)
	if ownership == .borrowed {
		return unsafe {
			ZVal{
				raw: res
			}
		}
	}
	return clone_raw_with_ownership(res, ownership)
}

pub fn runtime_counters() RuntimeCounters {
	mut ar := 0
	mut owned := 0
	mut obj_reg := u32(0)
	mut rev_reg := u32(0)
	C.vphp_runtime_counters(&ar, &owned, &obj_reg, &rev_reg)
	return RuntimeCounters{
		autorelease_len:              ar
		owned_len:                    owned
		obj_registry_len:             obj_reg
		rev_registry_len:             rev_reg
		persistent_fallback_zval_len: persistent_fallback_zval_count()
	}
}
