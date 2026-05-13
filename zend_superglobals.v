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
		.env { C.vphp_superglobal_get_env() }
		.server { C.vphp_superglobal_get_server() }
		.get { C.vphp_superglobal_get_get() }
		.post { C.vphp_superglobal_get_post() }
		.cookie { C.vphp_superglobal_get_cookie() }
		.files { C.vphp_superglobal_get_files() }
		.request { C.vphp_superglobal_get_request() }
	}
}

fn zend_set_env_superglobal_string(name string, value string) {
	C.vphp_superglobal_set_env_string(&char(name.str), &char(value.str))
}

fn zend_set_server_superglobal_string(name string, value string) {
	C.vphp_superglobal_set_server_string(&char(name.str), &char(value.str))
}
