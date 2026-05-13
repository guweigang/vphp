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

pub fn (ctx Context) arg_meta(meta PhpArgMeta) PhpArg {
	return PhpArg.from_meta_zval(meta, ctx.arg_raw(meta.index))
}

pub fn (ctx Context) args() PhpArgs {
	return ctx.args_with_meta([]PhpArgMeta{})
}

pub fn (ctx Context) args_with_meta(metas []PhpArgMeta) PhpArgs {
	num := ctx.num_args()
	mut items := []PhpArg{cap: num}
	for index in 0 .. num {
		mut arg_meta := PhpArgMeta{
			index: index
		}
		for meta in metas {
			if meta.index == index {
				arg_meta = meta.with_attribute_target(.parameter)
				break
			}
		}
		items << ctx.arg_meta(arg_meta)
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
