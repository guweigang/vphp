module vphp

import vphp.zend as _

pub struct PhpIncludeFile {
	path string
}

pub fn PhpIncludeFile.at(path string) PhpIncludeFile {
	return PhpIncludeFile{
		path: path
	}
}

pub fn (file PhpIncludeFile) path() string {
	return file.path
}

fn (file PhpIncludeFile) load_with_once_flag(once bool) ZVal {
	unsafe {
		retval := C.vphp_new_zval()
		once_flag := if once { 1 } else { 0 }
		res := C.vphp_include_file(&char(file.path.str), file.path.len, retval, once_flag)
		if res == -1 {
			C.vphp_release_zval(retval)
			return invalid_zval()
		}
		return adopt_raw_with_ownership(retval, .owned_request)
	}
}

pub fn (file PhpIncludeFile) load() ZVal {
	return file.load_with_once_flag(false)
}

pub fn (file PhpIncludeFile) load_once() ZVal {
	return file.load_with_once_flag(true)
}

pub fn include(path string) ZVal {
	return PhpIncludeFile.at(path).load()
}

pub fn include_once(path string) ZVal {
	return PhpIncludeFile.at(path).load_once()
}
