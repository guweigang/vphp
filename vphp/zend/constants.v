module zend

pub const (
    is_undef     = 0
    is_null      = 1
    is_false     = 2
    is_true      = 3
    is_long      = 4
    is_double    = 5
    is_string    = 6
    is_array     = 7
    is_object    = 8
    is_resource  = 9
    is_reference = 10
)


// 错误级别常量映射
pub const e_error   = 1     // E_ERROR (会导致 PHP 脚本中止)
pub const e_warning = 2     // E_WARNING
pub const e_notice  = 8     // E_NOTICE
