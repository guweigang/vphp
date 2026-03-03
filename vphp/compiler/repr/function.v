module repr

pub struct PhpFuncRepr {
pub mut:
	name            string
	original_name   string // 如果用了 @[php_function]，这是原有的 v 函数名
	return_type     string // V 返回类型：'void', 'int', 'i64', 'bool', 'string', 'f64', 'map[string]string' 等
	args            []PhpArg
	is_internal     bool
	uses_php_function bool // 如果是纯业务逻辑 (使用了 @[php_function])
}

pub fn new_func_repr() &PhpFuncRepr {
	return &PhpFuncRepr{}
}
