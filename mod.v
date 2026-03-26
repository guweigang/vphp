module vphp

#include <php.h>
#include "v_bridge.h" // 统一在这里 include，确保全局可见

// 这里可以放 ExtensionConfig 等定义
pub struct ExtensionConfig {
pub:
	name        string
	version     string
	description string
	ini_entries map[string]string
}

pub fn get_globals[T]() &T {
    return unsafe { &T(C.vphp_get_active_globals()) }
}

pub fn bind_class_interface(class_name string, iface_name string) bool {
	return C.vphp_bind_class_interface(&char(class_name.str), class_name.len, &char(iface_name.str),
		iface_name.len) != 0
}

pub fn register_auto_interface_binding(class_name string, iface_name string) {
	C.vphp_register_auto_interface_binding(&char(class_name.str), class_name.len,
		&char(iface_name.str), iface_name.len)
}

@[export: 'vphp_framework_init']// 框架核心入口
pub fn vphp_framework_init(module_number int) {
	// ... 目前占位
  // 自动初始化资源系统
  init_framework(module_number)
  // 这里的并发任务注册逻辑也可以放在这里
  // println('VPHP Framework initialized.')
}

pub fn init_framework(module_number int) {
  unsafe {
    C.vphp_init_registry()
    C.vphp_init_resource_system(module_number)
    C.vphp_install_runtime_binding_hooks()
  }
}

@[export: 'vphp_framework_shutdown']
pub fn vphp_framework_shutdown() {
	unsafe {
		C.vphp_uninstall_runtime_binding_hooks()
		C.vphp_autorelease_shutdown()
		C.vphp_shutdown_registry()
	}
}

@[export: 'vphp_framework_request_startup']
pub fn vphp_framework_request_startup() {
	unsafe {
		C.vphp_request_startup()
	}
}

@[export: 'vphp_framework_request_shutdown']
pub fn vphp_framework_request_shutdown() {
	unsafe {
		C.vphp_request_shutdown()
	}
}
