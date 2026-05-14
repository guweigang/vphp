module zval

import vphp.zend

pub enum Superglobal {
	env
	server
	get
	post
	cookie
	files
	request
}

pub fn superglobal(kind Superglobal) Handle {
	return Handle.from_ptr(zend.superglobal_ptr(zend_superglobal(kind)))
}

pub fn set_env_superglobal_string(name string, value string) {
	zend.set_env_superglobal_string(name, value)
}

pub fn set_server_superglobal_string(name string, value string) {
	zend.set_server_superglobal_string(name, value)
}

fn zend_superglobal(kind Superglobal) zend.Superglobal {
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
