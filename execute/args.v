module execute

import vphp.zend
import vphp.zval

pub fn (handle Handle) num_args() int {
	return zend.execute_num_args_ptr(handle.raw_ptr())
}

pub fn (handle Handle) arg_ptr(index int) voidptr {
	return zend.execute_arg_ptr(handle.raw_ptr(), index)
}

pub fn (handle Handle) arg_handle(index int) zval.Handle {
	return zval.Handle.from_ptr(handle.arg_ptr(index))
}
