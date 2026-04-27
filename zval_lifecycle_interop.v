module vphp

pub fn (v ZVal) dup() ZVal {
	if v.raw == 0 {
		return invalid_zval()
	}
	return clone_raw_with_ownership(v.raw, .owned_request)
}

pub fn (mut v ZVal) release() {
	if v.raw == 0 || !v.owned {
		return
	}
	autorelease_forget(v.raw)
	unsafe {
		if v.is_persistent {
			C.vphp_release_zval_persistent(v.raw)
		} else {
			C.vphp_release_zval(v.raw)
		}
	}
	v.raw = unsafe { nil }
	v.owned = false
	v.is_persistent = false
}

pub fn (v ZVal) dup_persistent() ZVal {
	if v.raw == 0 {
		return invalid_zval()
	}
	return clone_raw_with_ownership(v.raw, .owned_persistent)
}

// Duplicate and keep beyond current autorelease scope.
// dup_escaped creates an emalloc'd copy that escapes the current autorelease
// scope. The zval is still request-scoped memory — it will NOT survive across
// PHP requests. Use dup_persistent() for truly long-lived storage.
pub fn (v ZVal) dup_escaped() ZVal {
	mut out := v.dup()
	autorelease_forget(out.raw)
	return out
}

// current_this_owned_request captures the current PHP `$this` object as a
// request-owned ZVal so framework code can safely re-enter user-visible
// methods without hand-constructing object wrappers.
pub fn current_this_owned_request() ZVal {
	return PhpObject.current_request_owned_zval()
}
