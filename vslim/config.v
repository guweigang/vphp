module main

import vphp

const ext_config = vphp.ExtensionConfig{
	name: 'vslim'
	version: '0.1.0'
	description: 'Slim-inspired PHP extension powered by vphp'
}

@[php_globals]
pub struct ExtGlobals {
pub mut:
	request_count int
}
