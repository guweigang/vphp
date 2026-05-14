module execute

import vphp.zend

pub struct Data {
	raw voidptr
}

pub fn Data.from_ptr(raw voidptr) Data {
	return Data{
		raw: raw
	}
}

pub fn (ex Data) raw_ptr() voidptr {
	return ex.raw
}

pub fn (ex Data) num_args() int {
	return zend.execute_num_args_ptr(ex.raw)
}

pub fn (ex Data) arg_ptr(index int) voidptr {
	return zend.execute_arg_ptr(ex.raw, index)
}

pub fn (ex Data) active_class_ptr() voidptr {
	return zend.execute_active_class_ptr(ex.raw)
}

pub fn (ex Data) this_object_ptr() voidptr {
	return zend.execute_this_object_ptr(ex.raw)
}
