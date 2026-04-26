module vphp

import vphp.zend as _

pub fn get_env_superglobal() RequestBorrowedZBox {
	return RequestBorrowedZBox.from_zval(ZVal{
		raw: C.vphp_superglobal_get_env()
	})
}

pub fn set_env_superglobal(name string, value string) {
	C.vphp_superglobal_set_env_string(&char(name.str), &char(value.str))
}

pub fn get_env_superglobal_value(name string) ?RequestBorrowedZBox {
	value := get_env_superglobal().to_zval().get(name) or { return none }
	return RequestBorrowedZBox.from_zval(value)
}

pub fn get_server_superglobal() RequestBorrowedZBox {
	return RequestBorrowedZBox.from_zval(ZVal{
		raw: C.vphp_superglobal_get_server()
	})
}

pub fn set_server_superglobal(name string, value string) {
	C.vphp_superglobal_set_server_string(&char(name.str), &char(value.str))
}

pub fn get_server_superglobal_value(name string) ?RequestBorrowedZBox {
	value := get_server_superglobal().to_zval().get(name) or { return none }
	return RequestBorrowedZBox.from_zval(value)
}
