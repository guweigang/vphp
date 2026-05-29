module zend

pub fn execute_num_args(ex &C.zend_execute_data) int {
	return int(C.vphp_get_num_args(ex))
}

pub fn execute_num_args_ptr(ex voidptr) int {
	return execute_num_args( // SAFETY: ex is a valid zend_execute_data pointer
	 unsafe { &C.zend_execute_data(ex) })
}

pub fn execute_arg(ex &C.zend_execute_data, index int) &C.zval {
	return C.vphp_get_arg_ptr(ex, u32(index + 1))
}

pub fn execute_arg_ptr(ex voidptr, index int) voidptr {
	return execute_arg( // SAFETY: ex is a valid zend_execute_data pointer
	 unsafe { &C.zend_execute_data(ex) }, index)
}

pub fn execute_active_class(ex &C.zend_execute_data) voidptr {
	return C.vphp_get_active_ce(ex)
}

pub fn execute_active_class_ptr(ex voidptr) voidptr {
	return execute_active_class( // SAFETY: ex is a valid zend_execute_data pointer
	 unsafe { &C.zend_execute_data(ex) })
}

pub fn execute_this_object(ex &C.zend_execute_data) voidptr {
	return C.vphp_get_this_object(ex)
}

pub fn execute_this_object_ptr(ex voidptr) voidptr {
	return execute_this_object( // SAFETY: ex is a valid zend_execute_data pointer
	 unsafe { &C.zend_execute_data(ex) })
}
