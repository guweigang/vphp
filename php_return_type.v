module vphp

import vphp.zend as _

pub struct PhpReturn {
	raw &C.zval
}

pub fn PhpReturn.new(raw &C.zval) PhpReturn {
	return unsafe {
		PhpReturn{
			raw: raw
		}
	}
}

pub fn (ret PhpReturn) raw_zval() &C.zval {
	return ret.raw
}
