module vphp

import vphp.zend as _

fn zend_include_file_raw(path string, retval &C.zval, once bool) int {
	once_flag := if once { 1 } else { 0 }
	return C.vphp_include_file(&char(path.str), path.len, retval, once_flag)
}

fn zend_include_file(path string, once bool) ZVal {
	unsafe {
		retval := zend_new_zval()
		res := zend_include_file_raw(path, retval, once)
		if res == -1 {
			zend_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_request)
	}
}
