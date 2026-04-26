module vphp

import vphp.zend as _

// ======== 类与静态属性辅助 ========

pub fn set_static_prop[T](ce voidptr, name string, val T) {
	$if T is int {
		C.vphp_update_static_property_long(ce, &char(name.str), int(name.len), i64(val))
	} $else $if T is string {
		C.vphp_update_static_property_string(ce, &char(name.str), int(name.len), &char(val.str),
			int(val.len))
	} $else $if T is bool {
		C.vphp_update_static_property_bool(ce, &char(name.str), int(name.len), int(val))
	}
}

pub fn get_static_prop[T](ce voidptr, name string) T {
	$if T is int {
		return int(C.vphp_get_static_property_long(ce, &char(name.str), int(name.len)))
	} $else $if T is string {
		res := C.vphp_get_static_property_string(ce, &char(name.str), int(name.len))
		return unsafe { res.vstring() }
	} $else $if T is bool {
		return C.vphp_get_static_property_bool(ce, &char(name.str), int(name.len)) != 0
	}
	return T{}
}
