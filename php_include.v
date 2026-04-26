module vphp

import vphp.zend as _

pub fn include(path string) ZVal {
	unsafe {
		mut retval := C.vphp_new_zval()
		res := C.vphp_include_file(&char(path.str), path.len, retval, 0)
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

pub fn include_once(path string) ZVal {
	unsafe {
		mut retval := C.vphp_new_zval()
		res := C.vphp_include_file(&char(path.str), path.len, retval, 1)
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
