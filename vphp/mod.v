module vphp

import vphp.zend

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

pub enum PHPType {
    undef     = zend.is_undef
    null      = zend.is_null
    false_    = zend.is_false
    true_     = zend.is_true
    long      = zend.is_long
    double    = zend.is_double
    string    = zend.is_string
    array     = zend.is_array
    object    = zend.is_object
    resource  = zend.is_resource
    reference = zend.is_reference
}



@[export: 'vphp_framework_init']
fn vphp_framework_init(module_number int) {
    // 自动初始化资源系统
    init_framework(module_number)
    // 这里的并发任务注册逻辑也可以放在这里
    // println('VPHP Framework initialized.')
}

pub fn init_framework(module_number int) {
  unsafe {
    C.vphp_init_resource_system(module_number)
  }
}
