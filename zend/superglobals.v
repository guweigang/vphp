module zend

pub enum Superglobal {
	env
	server
	get
	post
	cookie
	files
	request
}

pub fn superglobal_raw(kind Superglobal) &C.zval {
	return match kind {
		.env { env_superglobal_raw() }
		.server { server_superglobal_raw() }
		.get { get_superglobal_raw() }
		.post { post_superglobal_raw() }
		.cookie { cookie_superglobal_raw() }
		.files { files_superglobal_raw() }
		.request { request_superglobal_raw() }
	}
}

pub fn superglobal_ptr(kind Superglobal) voidptr {
	return superglobal_raw(kind)
}

pub fn env_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_env()
}

pub fn server_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_server()
}

pub fn get_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_get()
}

pub fn post_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_post()
}

pub fn cookie_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_cookie()
}

pub fn files_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_files()
}

pub fn request_superglobal_raw() &C.zval {
	return C.vphp_superglobal_get_request()
}

pub fn set_env_superglobal_string(name string, value string) {
	C.vphp_superglobal_set_env_string(&char(name.str), &char(value.str))
}

pub fn set_server_superglobal_string(name string, value string) {
	C.vphp_superglobal_set_server_string(&char(name.str), &char(value.str))
}
