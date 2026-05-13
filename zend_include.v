module vphp

import vphp.zend as _

fn zend_include_file(path string, once bool) ZVal {
	unsafe {
		retval := C.vphp_new_zval()
		once_flag := if once { 1 } else { 0 }
		res := C.vphp_include_file(&char(path.str), path.len, retval, once_flag)
		if res == -1 {
			zend_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_request)
	}
}
