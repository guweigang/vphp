module zend

// ============================================
// PHP Zend 引擎核心 C 类型绑定
// 所有 PHP 扩展开发中会用到的 Zend 内核类型
// ============================================

#include <php.h>

// --- 核心值类型 ---

@[typedef]
pub struct C.zval {
pub mut:
	value usize
	u1    C.zval_u1
}

@[typedef]
pub struct C.zval_u1 {
pub mut:
	type_info u32
}

// --- 字符串 ---

@[typedef]
pub struct C.zend_string {
pub mut:
	gc  usize
	h   u64
	len usize
	val [1]u8
}

// --- 数组 (HashTable) ---

@[typedef]
pub struct C.zend_array {
pub mut:
	nNumOfElements u32
}

// 也叫 HashTable，是 zend_array 的别名
pub type C.HashTable = C.zend_array

// --- 执行上下文 ---

@[typedef]
pub struct C.zend_execute_data {}

// --- 对象系统 ---

@[typedef]
pub struct C.zend_object {}

@[typedef]
pub struct C.zend_class_entry {}

@[typedef]
pub struct C.zend_object_handlers {}

// --- 函数/方法注册 ---

@[typedef]
pub struct C.zend_function_entry {}

@[typedef]
pub struct C.zend_internal_arg_info {}

// --- 模块系统 ---

@[typedef]
pub struct C.zend_module_entry {}

// --- 资源 ---

@[typedef]
pub struct C.zend_resource {}

// --- 引用 ---

@[typedef]
pub struct C.zend_reference {}

// --- VPHP 框架扩展类型 ---

// 统一的类 Handler 聚合结构体（对应 v_bridge.h 中的 C 定义）
@[typedef]
pub struct C.vphp_class_handlers {
pub mut:
	prop_handler  voidptr
	write_handler voidptr
	sync_handler  voidptr
	new_raw       voidptr
}
