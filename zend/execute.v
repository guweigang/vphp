module zend

pub fn execute_num_args(ex &C.zend_execute_data) int {
	return int(C.vphp_get_num_args(ex))
}

pub fn execute_arg(ex &C.zend_execute_data, index int) &C.zval {
	return C.vphp_get_arg_ptr(ex, u32(index + 1))
}

pub fn execute_active_class(ex &C.zend_execute_data) voidptr {
	return C.vphp_get_active_ce(ex)
}

pub fn execute_this_object(ex &C.zend_execute_data) voidptr {
	return C.vphp_get_this_object(ex)
}
