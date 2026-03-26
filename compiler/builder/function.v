module builder

pub struct FuncBuilder {
pub mut:
	php_name string
	c_func   string
	args     []ClassMethodArg // reuse ClassMethodArg for function args
}

pub fn new_func_builder(php_name string, c_func string) &FuncBuilder {
	return &FuncBuilder{
		php_name: php_name
		c_func: c_func
	}
}

pub fn new_func_builder_with_args(php_name string, c_func string, args []ClassMethodArg) &FuncBuilder {
	return &FuncBuilder{
		php_name: php_name
		c_func: c_func
		args: args
	}
}

pub fn (b &FuncBuilder) render_fe() string {
	return '    PHP_FE(${b.php_name}, arginfo_${b.c_func})'
}

pub fn (b &FuncBuilder) render_declaration() string {
	return 'PHP_FUNCTION(${b.php_name});'
}

pub fn (b &FuncBuilder) render_arginfo() string {
	mut res := []string{}
	res << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${b.c_func}, 0, 0, ${b.args.len})'
	for arg in b.args {
		type_code := arg_type_code(arg.type_)
		if type_code == 'IS_CALLABLE' {
			res << 'ZEND_ARG_CALLABLE_INFO(0, ${arg.name}, 0)'
		} else if type_code != '' {
			res << 'ZEND_ARG_TYPE_INFO(0, ${arg.name}, ${type_code}, 0)'
		} else {
			res << 'ZEND_ARG_INFO(0, ${arg.name})'
		}
	}
	res << 'ZEND_END_ARG_INFO()'
	return res.join('\n')
}

pub fn (b FuncBuilder) export_fragments() ExportFragments {
	return ExportFragments{
		declarations: [b.render_declaration()]
		function_table: [b]
	}
}
