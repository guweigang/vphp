module vphp

import vphp.zval

pub struct PhpObjectPropertyHandler {}

pub fn PhpObjectPropertyHandler.name_from_ptr(name_ptr &char, name_len int) string {
	unsafe {
		return name_ptr.vstring_with_len(name_len).clone()
	}
}

pub fn PhpObjectPropertyHandler.return_from_ptr(rv voidptr) PhpReturn {
	return PhpReturn.from_ptr(rv)
}

pub fn PhpObjectPropertyHandler.value_from_ptr(value voidptr) ZVal {
	return ZVal.from_handle(zval.Handle.from_ptr(value))
}

