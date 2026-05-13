module vphp

import vphp.zend as _

@[params]
pub struct ZendClassHandlersConfig {
pub:
	prop_handler  voidptr
	write_handler voidptr
	sync_handler  voidptr
	new_raw       voidptr
	cleanup_raw   voidptr
	free_raw      voidptr
}

pub struct ZendClassHandlers {}

pub fn ZendClassHandlers.new(config ZendClassHandlersConfig) voidptr {
	return unsafe {
		&C.vphp_class_handlers{
			prop_handler:  config.prop_handler
			write_handler: config.write_handler
			sync_handler:  config.sync_handler
			new_raw:       config.new_raw
			cleanup_raw:   config.cleanup_raw
			free_raw:      config.free_raw
		}
	}
}
