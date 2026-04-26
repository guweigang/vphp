module vphp

import vphp.zend as _

pub fn get_env_superglobal() RequestBorrowedZBox {
	return RequestBorrowedZBox.from_zval(ZVal{
		raw: C.vphp_superglobal_get_env()
	})
}

pub fn env_superglobal() PhpArray {
	return PhpArray.must_from_zval(get_env_superglobal().to_zval()) or { panic(err) }
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

pub fn server_superglobal() PhpArray {
	return PhpArray.must_from_zval(get_server_superglobal().to_zval()) or { panic(err) }
}

pub fn set_server_superglobal(name string, value string) {
	C.vphp_superglobal_set_server_string(&char(name.str), &char(value.str))
}

pub fn get_server_superglobal_value(name string) ?RequestBorrowedZBox {
	value := get_server_superglobal().to_zval().get(name) or { return none }
	return RequestBorrowedZBox.from_zval(value)
}

pub fn get_superglobal() PhpArray {
	return PhpArray.must_from_zval(ZVal{
		raw: C.vphp_superglobal_get_get()
	}) or { panic(err) }
}

pub fn post_superglobal() PhpArray {
	return PhpArray.must_from_zval(ZVal{
		raw: C.vphp_superglobal_get_post()
	}) or { panic(err) }
}

pub fn cookie_superglobal() PhpArray {
	return PhpArray.must_from_zval(ZVal{
		raw: C.vphp_superglobal_get_cookie()
	}) or { panic(err) }
}

pub fn files_superglobal() PhpArray {
	return PhpArray.must_from_zval(ZVal{
		raw: C.vphp_superglobal_get_files()
	}) or { panic(err) }
}

pub fn request_superglobal() PhpArray {
	return PhpArray.must_from_zval(ZVal{
		raw: C.vphp_superglobal_get_request()
	}) or { panic(err) }
}
