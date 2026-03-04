module repr

pub struct PhpFuncRepr {
pub mut:
	name            string
	original_name   string // 原始 V 函数名
	return_type     string // V 返回类型：'void', 'int', 'i64', 'bool', 'string', 'f64', 'map[string]string' 等
	args            []PhpArg
	is_internal     bool
}

pub fn new_func_repr() &PhpFuncRepr {
	return &PhpFuncRepr{}
}
