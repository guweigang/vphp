module vphp

import vphp.zval

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
	RequestScope.autorelease_forget_handle(v.handle())
	if v.is_persistent {
		zval.release_persistent(v.handle())
	} else {
		zval.release_request(v.handle())
	}
	v.raw = unsafe { nil }
	v.owned = false
	v.is_persistent = false
}

pub fn (mut v ZVal) disown() {
	if v.raw == 0 {
		return
	}
	RequestScope.autorelease_forget_handle(v.handle())
	zval.disown(v.handle())
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
	RequestScope.autorelease_forget_handle(out.handle())
	return out
}

// current_this_owned_request captures the current PHP `$this` object as a
// request-owned ZVal so framework code can safely re-enter user-visible
// methods without hand-constructing object wrappers.
pub fn current_this_owned_request() ZVal {
	return PhpObject.current_request_owned_zval()
}
