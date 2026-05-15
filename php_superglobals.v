module vphp

import vphp.zval

pub struct PhpSuperglobals {}

pub fn PhpSuperglobals.env_box() RequestBorrowedZBox {
	return php_superglobal_box(.env)
}

pub fn PhpSuperglobals.env() PhpArray {
	return PhpArray.must_from_zval(PhpSuperglobals.env_box().to_zval()) or { panic(err) }
}

pub fn PhpSuperglobals.set_env(name string, value string) {
	zval.set_env_superglobal_string(name, value)
}

pub fn PhpSuperglobals.env_value(name string) ?RequestBorrowedZBox {
	value := PhpSuperglobals.env_box().to_zval().get(name) or { return none }
	return RequestBorrowedZBox.from_zval(value)
}

pub fn PhpSuperglobals.server_box() RequestBorrowedZBox {
	return php_superglobal_box(.server)
}

pub fn PhpSuperglobals.server() PhpArray {
	return PhpArray.must_from_zval(PhpSuperglobals.server_box().to_zval()) or { panic(err) }
}

pub fn PhpSuperglobals.set_server(name string, value string) {
	zval.set_server_superglobal_string(name, value)
}

pub fn PhpSuperglobals.server_value(name string) ?RequestBorrowedZBox {
	value := PhpSuperglobals.server_box().to_zval().get(name) or { return none }
	return RequestBorrowedZBox.from_zval(value)
}

pub fn PhpSuperglobals.get() PhpArray {
	return php_superglobal_array(.get)
}

pub fn PhpSuperglobals.post() PhpArray {
	return php_superglobal_array(.post)
}

pub fn PhpSuperglobals.cookie() PhpArray {
	return php_superglobal_array(.cookie)
}

pub fn PhpSuperglobals.files() PhpArray {
	return php_superglobal_array(.files)
}

pub fn PhpSuperglobals.request() PhpArray {
	return php_superglobal_array(.request)
}

fn php_superglobal_box(kind zval.Superglobal) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_zval(ZVal.from_handle(zval.superglobal(kind)))
}

fn php_superglobal_array(kind zval.Superglobal) PhpArray {
	return PhpArray.must_from_zval(ZVal.from_handle(zval.superglobal(kind))) or { panic(err) }
}

pub fn get_env_superglobal() RequestBorrowedZBox {
	return PhpSuperglobals.env_box()
}

pub fn env_superglobal() PhpArray {
	return PhpSuperglobals.env()
}

pub fn set_env_superglobal(name string, value string) {
	PhpSuperglobals.set_env(name, value)
}

pub fn get_env_superglobal_value(name string) ?RequestBorrowedZBox {
	return PhpSuperglobals.env_value(name)
}

pub fn get_server_superglobal() RequestBorrowedZBox {
	return PhpSuperglobals.server_box()
}

pub fn server_superglobal() PhpArray {
	return PhpSuperglobals.server()
}

pub fn set_server_superglobal(name string, value string) {
	PhpSuperglobals.set_server(name, value)
}

pub fn get_server_superglobal_value(name string) ?RequestBorrowedZBox {
	return PhpSuperglobals.server_value(name)
}

pub fn get_superglobal() PhpArray {
	return PhpSuperglobals.get()
}

pub fn post_superglobal() PhpArray {
	return PhpSuperglobals.post()
}

pub fn cookie_superglobal() PhpArray {
	return PhpSuperglobals.cookie()
}

pub fn files_superglobal() PhpArray {
	return PhpSuperglobals.files()
}

pub fn request_superglobal() PhpArray {
	return PhpSuperglobals.request()
}
