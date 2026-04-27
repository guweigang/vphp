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
pub fn Context.new(ex voidptr, ret &C.zval) Context {
	return unsafe {
		Context{
			ex:  &C.zend_execute_data(ex)
			ret: ret
		}
	}
}

pub fn new_context(ex voidptr, ret &C.zval) Context {
	// Backward-compat alias; prefer Context.new(...)
	return Context.new(ex, ret)
}

pub fn (ctx Context) arg_at(index int) PhpArg {
	return ctx.arg_named(index, '')
}

pub fn (ctx Context) arg_named(index int, name string) PhpArg {
	return PhpArg.from_zval(index, name, ctx.arg_raw(index))
}

pub fn (ctx Context) args(metas []PhpArgMeta) PhpArgs {
	num := ctx.num_args()
	mut items := []PhpArg{cap: num}
	for index in 0 .. num {
		mut name := ''
		for meta in metas {
			if meta.index == index {
				name = meta.name
				break
			}
		}
		items << ctx.arg_named(index, name)
	}
	return PhpArgs.new(items)
}

pub fn (ctx Context) @return() PhpReturn {
	return PhpReturn.new(ctx.ret)
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
