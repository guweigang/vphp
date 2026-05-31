module zval

import vphp.zend

pub fn include_file(path string, once bool) !Handle {
	retval := new_request()
	if !retval.is_valid() {
		return error('include_file: failed to allocate retval for ${path}')
	}
	res := zend.include_file_ptr(path, retval.raw_ptr(), once)
	if res == -1 {
		release_request(retval)
		return error('include_file: failed to include ${path}')
	}
	return retval
}
