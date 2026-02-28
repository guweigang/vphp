module vphp

// ============================================
// Map 遍历回调 — 供 arg[T] 中各种 map 类型使用
// ============================================

// --- map[string]string ---

struct MapContext {
mut:
	m map[string]string
}

fn map_callback(p_ctx voidptr, key &char, val &C.zval) {
	mut ctx := unsafe { &MapContext(p_ctx) }
	v_key := unsafe { key.vstring() }
	v_val := unsafe { Val{ raw: val }.to_string() }
	ctx.m[v_key] = v_val
}

// --- map[string]f64 ---

struct MapF64Context {
mut:
	m map[string]f64
}

fn map_f64_callback(p_ctx voidptr, key &char, val &C.zval) {
	mut ctx := unsafe { &MapF64Context(p_ctx) }
	v_key := unsafe { key.vstring() }
	ctx.m[v_key] = C.vphp_get_double(val)
}

// --- map[string]int ---

struct MapIntContext {
mut:
	m map[string]int
}

fn map_int_callback(p_ctx voidptr, key &char, val &C.zval) {
	mut ctx := unsafe { &MapIntContext(p_ctx) }
	v_key := unsafe { key.vstring() }
	ctx.m[v_key] = int(C.vphp_get_int(val))
}
