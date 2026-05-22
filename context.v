module vphp

import vphp.zend as _

// ============================================
// Context — PHP 函数调用上下文
// ============================================

pub struct Context {
pub:
	ex  ZendExecuteData
	ret PhpReturn
}

// ======== 构造与基础状态 ========

pub fn Context.from_ptr(ex voidptr, ret voidptr) Context {
	return Context{
		ex:  ZendExecuteData.from_ptr(ex)
		ret: PhpReturn.from_ptr(ret)
	}
}

pub fn (ctx Context) arg_at(index int) PhpArg {
	return ctx.arg_named(index, '')
}

pub fn (ctx Context) arg_named(index int, name string) PhpArg {
	return ctx.ex.php_arg(index, name)
}

pub fn (ctx Context) arg_meta(meta PhpArgMeta) PhpArg {
	return ctx.ex.php_arg_meta(meta)
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

pub fn (ctx Context) active_class_entry() ZendClassEntry {
	return ctx.ex.active_class_entry()
}
