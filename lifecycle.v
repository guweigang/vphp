module vphp

__global (
	vphp_persistent_fallback_zval_count int
)

fn persistent_fallback_zval_count() int {
	unsafe {
		return vphp_persistent_fallback_zval_count
	}
}

fn persistent_fallback_zval_inc() {
	unsafe {
		vphp_persistent_fallback_zval_count++
	}
}

fn persistent_fallback_zval_dec() {
	unsafe {
		if vphp_persistent_fallback_zval_count > 0 {
			vphp_persistent_fallback_zval_count--
		}
	}
}
