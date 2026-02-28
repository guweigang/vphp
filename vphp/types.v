module vphp

// ZifHandler: PHP 内核的函数签名 (extern "C")
// 对应 void name(zend_execute_data *execute_data, zval *return_value)
pub type ZifHandler = fn (ex &C.zend_execute_data, ret &C.zval)

// 用户方法签名 (强类型)
pub type VoidMethod[T] = fn (obj T, ctx Context)
pub type ValMethod[T]  = fn (obj T, ctx Context) Val

// 用于传递给 C 层的结构体
pub struct MethodDef {
	name    &char
	handler ZifHandler
}