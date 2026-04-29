module vphp

import vphp.zend as _

// ============================================
// Context — PHP 函数调用上下文
// ============================================

pub struct Context {
pub:
	ex  ZExData
	ret PhpReturn
}

// ======== 构造与基础状态 ========

// 创建 Context 实例
pub fn Context.new(ex voidptr, ret &C.zval) Context {
	return Context{
		ex:  ZExData.from_voidptr(ex)
		ret: PhpReturn.new(ret)
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
	return ctx.ret
}

pub fn (ctx Context) num_args() int {
	return ctx.ex.num_args()
}

pub fn (ctx Context) get_ce() voidptr {
	return ctx.ex.active_ce()
}
