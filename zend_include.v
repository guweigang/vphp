module vphp

import vphp.zval

fn zend_include_file(path string, once bool) ZVal {
	retval := zval.include_file(path, once)
	if !retval.is_valid() {
		return invalid_zval()
	}
	return adopt_handle_with_ownership(retval, .owned_request)
}
