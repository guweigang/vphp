module zend

// 映射 PHP 内部函数
// 第三个参数 0 表示该字符串是临时分配在请求内存（Request-bound）中的
fn C.zend_string_init(str &u8, len usize, persistent int) &C.zend_string

// 映射 zval 初始化宏对应的函数
fn C.ZVAL_STR(z &C.zval, s &C.zend_string)
