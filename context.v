module vphp

import vphp.zend as _

// ============================================
// Context — PHP 函数调用上下文
// ============================================

pub struct Context {
pub:
	ex  &C.zend_execute_data
	ret &C.zval
}

// ======== 构造与基础状态 ========

// 创建 Context 实例
pub fn Context.new(ex &C.zend_execute_data, ret &C.zval) Context {
	return unsafe {
		Context{
			ex:  ex
			ret: ret
		}
	}
}

pub fn new_context(ex &C.zend_execute_data, ret &C.zval) Context {
	// Backward-compat alias; prefer Context.new(...)
	return Context.new(ex, ret)
}

pub fn (ctx Context) num_args() int {
	return int(C.vphp_get_num_args(ctx.ex))
}

pub fn (ctx Context) has_exception() bool {
	return C.vphp_has_exception()
}

pub fn (ctx Context) get_ce() voidptr {
	return C.vphp_get_active_ce(ctx.ex)
}
