module zend

#include <php.h>

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
// ... 剩下的 zend_string, zend_array 定义保持不变

@[typedef]
pub struct C.zend_string {
pub mut:
    gc  usize
    h   u64   // 这里直接用 u64 避开类型引用问题
    len usize
    val [1]u8
}

@[typedef]
pub struct C.zend_array {
pub mut:
    nNumOfElements u32
}
