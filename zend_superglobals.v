module vphp

import vphp.zend

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
	return zend.superglobal_raw(zend_superglobal_kind(kind))
}

fn zend_superglobal_kind(kind ZendSuperglobal) zend.Superglobal {
	return match kind {
		.env { zend.Superglobal.env }
		.server { zend.Superglobal.server }
		.get { zend.Superglobal.get }
		.post { zend.Superglobal.post }
		.cookie { zend.Superglobal.cookie }
		.files { zend.Superglobal.files }
		.request { zend.Superglobal.request }
	}
}

fn zend_set_env_superglobal_string(name string, value string) {
	zend_set_env_superglobal_string_raw(name, value)
}

fn zend_set_server_superglobal_string(name string, value string) {
	zend_set_server_superglobal_string_raw(name, value)
}

fn zend_set_env_superglobal_string_raw(name string, value string) {
	zend.set_env_superglobal_string(name, value)
}

fn zend_set_server_superglobal_string_raw(name string, value string) {
	zend.set_server_superglobal_string(name, value)
}
