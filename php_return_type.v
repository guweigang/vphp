module vphp

import vphp.zend as _
import vphp.zval as zvalmod

pub struct PhpReturn {
	handle zvalmod.Handle
}

pub fn PhpReturn.from_ptr(raw voidptr) PhpReturn {
	return PhpReturn{
		handle: zvalmod.Handle.from_ptr(raw)
	}
}

pub fn PhpReturn.from_zval(z ZVal) PhpReturn {
	return PhpReturn{
		handle: z.handle()
	}
}

pub fn (ret PhpReturn) raw_ptr() voidptr {
	return ret.handle.raw_ptr()
}

pub fn (ret PhpReturn) handle() zvalmod.Handle {
	return ret.handle
}

pub fn (ret PhpReturn) to_zval() ZVal {
	return ZVal.from_handle(ret.handle)
}
