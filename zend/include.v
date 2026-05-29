module zend

pub fn include_file_raw(path string, retval &C.zval, once bool) int {
	once_flag := if once { 1 } else { 0 }
	return C.vphp_include_file(&char(path.str), path.len, retval, once_flag)
}

pub fn include_file_ptr(path string, retval voidptr, once bool) int {
	return include_file_raw(path, // SAFETY: retval is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(retval) }, once)
}
