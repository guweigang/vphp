module vphp

import vphp.zend as _

pub fn set_env_superglobal(name string, value string) {
	C.vphp_superglobal_set_env_string(&char(name.str), &char(value.str))
}

pub fn set_server_superglobal(name string, value string) {
	C.vphp_superglobal_set_server_string(&char(name.str), &char(value.str))
}
