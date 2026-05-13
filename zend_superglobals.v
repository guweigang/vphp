module vphp

import vphp.zend as _

enum ZendSuperglobal {
	env
	server
	get
	post
	cookie
	files
	request
}

fn zend_superglobal_box(kind ZendSuperglobal) RequestBorrowedZBox {
	return RequestBorrowedZBox.from_zval(ZVal{
		raw: zend_superglobal_raw(kind)
	})
}

fn zend_superglobal_array(kind ZendSuperglobal) PhpArray {
	return PhpArray.must_from_zval(ZVal{
		raw: zend_superglobal_raw(kind)
	}) or { panic(err) }
}

fn zend_superglobal_raw(kind ZendSuperglobal) &C.zval {
	return match kind {
		.env { zend_env_superglobal_raw() }
		.server { zend_server_superglobal_raw() }
		.get { zend_get_superglobal_raw() }
		.post { zend_post_superglobal_raw() }
		.cookie { zend_cookie_superglobal_raw() }
		.files { zend_files_superglobal_raw() }
		.request { zend_request_superglobal_raw() }
	}
}

fn zend_env_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_env()
}

fn zend_server_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_server()
}

fn zend_get_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_get()
}

fn zend_post_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_post()
}

fn zend_cookie_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_cookie()
}

fn zend_files_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_files()
}

fn zend_request_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_request()
}

fn zend_set_env_superglobal_string(name string, value string) {
	zend_set_env_superglobal_string_raw(name, value)
}

fn zend_set_server_superglobal_string(name string, value string) {
	zend_set_server_superglobal_string_raw(name, value)
}

fn zend_set_env_superglobal_string_raw(name string, value string) {
	C.vphp_superglobal_set_env_string(&char(name.str), &char(value.str))
}

fn zend_set_server_superglobal_string_raw(name string, value string) {
	C.vphp_superglobal_set_server_string(&char(name.str), &char(value.str))
}
