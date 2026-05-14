module vphp

import vphp.zval

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
	return RequestBorrowedZBox.from_zval(ZVal.from_handle(zend_superglobal_handle(kind)))
}

fn zend_superglobal_array(kind ZendSuperglobal) PhpArray {
	return PhpArray.must_from_zval(ZVal.from_handle(zend_superglobal_handle(kind))) or {
		panic(err)
	}
}

fn zend_superglobal_handle(kind ZendSuperglobal) zval.Handle {
	return zval.superglobal(zend_superglobal_kind(kind))
}

fn zend_superglobal_kind(kind ZendSuperglobal) zval.Superglobal {
	return match kind {
		.env { zval.Superglobal.env }
		.server { zval.Superglobal.server }
		.get { zval.Superglobal.get }
		.post { zval.Superglobal.post }
		.cookie { zval.Superglobal.cookie }
		.files { zval.Superglobal.files }
		.request { zval.Superglobal.request }
	}
}

fn zend_set_env_superglobal_string(name string, value string) {
	zend_set_env_superglobal_string_raw(name, value)
}

fn zend_set_server_superglobal_string(name string, value string) {
	zend_set_server_superglobal_string_raw(name, value)
}

fn zend_set_env_superglobal_string_raw(name string, value string) {
	zval.set_env_superglobal_string(name, value)
}

fn zend_set_server_superglobal_string_raw(name string, value string) {
	zval.set_server_superglobal_string(name, value)
}
