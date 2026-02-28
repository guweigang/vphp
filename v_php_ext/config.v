module main

import vphp

const ext_config = vphp.ExtensionConfig{
    name: 'vphptest'
    version: '0.1.0'
    description: 'PHP Bindings for V'
    ini_entries: {
        'vphptest.enable_cache': '1'
        'vphptest.max_threads': '4'
    }
}

@[php_const]
const app_version = '1.0.0'

@[php_const]
const max_retry = 3

@[php_const]
const pi_value = 3.14159

@[php_const]
const debug_mode = false
