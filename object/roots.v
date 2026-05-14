module object

__global (
	vphp_vptr_roots &map[voidptr]int
)

pub fn register_root(ptr voidptr) {
	if ptr == 0 {
		return
	}
	unsafe {
		if isnil(vphp_vptr_roots) {
			vphp_vptr_roots = &map[voidptr]int{}
		}
		mut m := vphp_vptr_roots
		count := m[ptr] or { 0 }
		m[ptr] = count + 1
	}
}

pub fn ensure_root(ptr voidptr) {
	if ptr == 0 {
		return
	}
	unsafe {
		if isnil(vphp_vptr_roots) {
			vphp_vptr_roots = &map[voidptr]int{}
		}
		mut m := vphp_vptr_roots
		if ptr !in m {
			m[ptr] = 1
		}
	}
}

pub fn unregister_root(ptr voidptr) {
	if ptr == 0 {
		return
	}
	unsafe {
		if !isnil(vphp_vptr_roots) {
			mut m := vphp_vptr_roots
			count := m[ptr] or { 0 }
			if count > 1 {
				m[ptr] = count - 1
			} else {
				m.delete(ptr)
			}
		}
	}
}
