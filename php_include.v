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

pub fn (file PhpIncludeFile) load() ZVal {
	unsafe {
		mut retval := C.vphp_new_zval()
		res := C.vphp_include_file(&char(file.path.str), file.path.len, retval, 0)
		if res == -1 {
			C.vphp_release_zval(retval)
			return ZVal{
				raw: 0
			}
		}
		mut out := ZVal{
			raw:   retval
			owned: true
		}
		autorelease_add(out.raw)
		return out
	}
}

pub fn (file PhpIncludeFile) load_once() ZVal {
	unsafe {
		mut retval := C.vphp_new_zval()
		res := C.vphp_include_file(&char(file.path.str), file.path.len, retval, 1)
		if res == -1 {
			C.vphp_release_zval(retval)
			return ZVal{
				raw: 0
			}
		}
		mut out := ZVal{
			raw:   retval
			owned: true
		}
		autorelease_add(out.raw)
		return out
	}
}

pub fn include(path string) ZVal {
	return PhpIncludeFile.at(path).load()
}

pub fn include_once(path string) ZVal {
	return PhpIncludeFile.at(path).load_once()
}
