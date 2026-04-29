module vphp

import vphp.zend as _

pub struct ZExData {
	raw &C.zend_execute_data
}

pub fn ZExData.new(raw &C.zend_execute_data) ZExData {
	return unsafe {
		ZExData{
			raw: raw
		}
	}
}

pub fn ZExData.from_voidptr(raw voidptr) ZExData {
	return unsafe {
		ZExData{
			raw: &C.zend_execute_data(raw)
		}
	}
}

pub fn (ex ZExData) raw_ex() &C.zend_execute_data {
	return ex.raw
}

pub fn (ex ZExData) num_args() int {
	return int(C.vphp_get_num_args(ex.raw))
}

pub fn (ex ZExData) arg_raw(index int) ZVal {
	if index < 0 || index >= ex.num_args() {
		return invalid_zval()
	}
	raw := C.vphp_get_arg_ptr(ex.raw, u32(index + 1))
	if raw == 0 {
		return invalid_zval()
	}
	return ZVal{
		raw: raw
	}
}

pub fn (ex ZExData) args() []ZVal {
	num := ex.num_args()
	mut res := []ZVal{cap: num}
	for i in 0 .. num {
		res << ex.arg_raw(i)
	}
	return res
}

pub fn (ex ZExData) active_ce() voidptr {
	return C.vphp_get_active_ce(ex.raw)
}

pub fn (ex ZExData) this_object() voidptr {
	return C.vphp_get_this_object(ex.raw)
}
