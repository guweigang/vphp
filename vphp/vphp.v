module vphp
import vphp.zend as _

// ============================================
// vphp 核心：入口函数、全局工具、Map 回调
// ============================================

// 主动向 PHP 报告错误
pub fn report_error(level int, msg string) {
	unsafe {
		C.vphp_error(level, &char(msg.str))
	}
}

// 获取当前 PHP 函数调用的所有参数
pub fn get_args(ex &C.zend_execute_data) []Val {
	num := int(C.vphp_get_num_args(ex))
	mut res := []Val{}
	for i in 1 .. (num + 1) { // PHP 参数从 1 开始
		res << Val{ raw: C.vphp_get_arg_ptr(ex, u32(i)) }
	}
	return res
}

// 创建 Context 实例
pub fn new_context(ex &C.zend_execute_data, ret &C.zval) Context {
	return unsafe {
		Context{
			ex: ex
			ret: ret
		}
	}
}

// 抛出 PHP 异常
pub fn throw_exception(msg string, code int) {
	unsafe { C.vphp_throw(&char(msg.str), code) }
}

// 调用 PHP 全局函数
pub fn call_php(name string, args []Val) Val {
	unsafe {
		mut retval := C.zval{}
		mut p_args := &&C.zval(nil)
		if args.len > 0 {
			p_args = &args[0].raw
		}
		C.vphp_call_php_func(&char(name.str), name.len, &retval, args.len, p_args)
		return Val{ raw: &retval }
	}
}

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
