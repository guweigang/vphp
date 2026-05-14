module zend

pub fn include_file_raw(path string, retval &C.zval, once bool) int {
	once_flag := if once { 1 } else { 0 }
	return C.vphp_include_file(&char(path.str), path.len, retval, once_flag)
}
