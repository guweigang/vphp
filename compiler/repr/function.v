module repr

pub struct PhpFuncRepr {
pub mut:
	name          string
	original_name string // 原始 V 函数名
	return_spec   PhpReturnSpec
	args          []PhpArg
	has_export    bool
	is_internal   bool
}

pub fn new_func_repr() &PhpFuncRepr {
	return &PhpFuncRepr{}
}
