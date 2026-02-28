module zend

pub const is_undef     = 0
pub const is_null      = 1
pub const is_false     = 2
pub const is_true      = 3
pub const is_long      = 4
pub const is_double    = 5
pub const is_string    = 6
pub const is_array     = 7
pub const is_object    = 8
pub const is_resource  = 9
pub const is_reference = 10

// 错误级别常量映射
pub const e_error   = 1     // E_ERROR (会导致 PHP 脚本中止)
pub const e_warning = 2     // E_WARNING
pub const e_notice  = 8     // E_NOTICE
