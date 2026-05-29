module vphp

__global (
	vphp_persistent_fallback_zval_count int
)

fn persistent_fallback_zval_count() int {
	// SAFETY: C interop block with valid pointer arguments
	unsafe {
		return vphp_persistent_fallback_zval_count
	}
}

fn persistent_fallback_zval_inc() {
	// SAFETY: C interop block with valid pointer arguments
	unsafe {
		vphp_persistent_fallback_zval_count++
	}
}

fn persistent_fallback_zval_dec() {
	// SAFETY: C interop block with valid pointer arguments
	unsafe {
		if vphp_persistent_fallback_zval_count > 0 {
			vphp_persistent_fallback_zval_count--
		}
	}
}
