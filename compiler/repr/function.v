module repr

pub struct PhpFuncRepr {
pub mut:
	name          string
	module_name   string
	original_name string // 原始 V 函数名
	return_spec   PhpReturnRepr
	args          []PhpArgRepr
	has_export    bool
	is_internal   bool
	uses_context  bool
}

pub fn (r PhpFuncRepr) qualified_original_name() string {
	name := if r.original_name != '' { r.original_name } else { r.name }
	if r.module_name == '' || r.module_name == 'main' {
		return name
	}
	return '${r.module_name.all_after_last('.')}.${name}'
}

pub fn new_func_repr() &PhpFuncRepr {
	return &PhpFuncRepr{}
}
