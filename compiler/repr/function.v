module repr

pub struct PhpFuncRepr {
pub mut:
	name          string
	original_name string // 原始 V 函数名
	return_spec   PhpReturnRepr
	args          []PhpArgRepr
	has_export    bool
	is_internal   bool
	uses_context  bool
}

pub fn new_func_repr() &PhpFuncRepr {
	return &PhpFuncRepr{}
}
