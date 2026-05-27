module vphp

import os
import vphp.zend

// 框架核心入口
@[export: 'vphp_framework_init']
pub fn vphp_framework_init(module_number int) {
	// 自动初始化资源系统
	init_framework(module_number)
}

pub fn init_framework(module_number int) {
	zend.framework_init(module_number)
}

fn framework_debug_enabled() bool {
	return os.getenv('VSLIM_CLI_DEBUG') != '' || os.getenv('VSLIM_CLI_DEBUG_FILE') != ''
}

fn framework_debug_log(message string) {
	if !framework_debug_enabled() {
		return
	}
	debug_file := os.getenv('VSLIM_CLI_DEBUG_FILE').trim_space()
	if debug_file != '' {
		line := '[vphp-framework-debug] ' + message + '\n'
		mut file := os.open_file(debug_file, 'a') or {
			mut created := os.create(debug_file) or { return }
			created.write_string(line) or {}
			created.close()
			return
		}
		file.write_string(line) or {}
		file.close()
		return
	}
	eprintln('[vphp-framework-debug] ${message}')
}

@[export: 'vphp_framework_shutdown']
pub fn vphp_framework_shutdown() {
	framework_debug_log('framework_shutdown enter')
	framework_debug_log('framework_shutdown uninstall_runtime_hooks begin')
	zend.uninstall_runtime_binding_hooks()
	framework_debug_log('framework_shutdown uninstall_runtime_hooks done')
	framework_debug_log('framework_shutdown autorelease_shutdown begin')
	zend.autorelease_shutdown()
	framework_debug_log('framework_shutdown autorelease_shutdown done')
	framework_debug_log('framework_shutdown shutdown_registry begin')
	zend.shutdown_registry()
	framework_debug_log('framework_shutdown shutdown_registry done')
	framework_debug_log('framework_shutdown exit')
}

@[export: 'vphp_framework_request_startup']
pub fn vphp_framework_request_startup() {
	zend.request_startup()
}

@[export: 'vphp_framework_request_shutdown']
pub fn vphp_framework_request_shutdown() {
	zend.request_shutdown()
}
