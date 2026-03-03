module compiler

pub struct FuncBuilder {
pub mut:
	php_name string
	c_func   string
}

pub fn new_func_builder(php_name string, c_func string) &FuncBuilder {
	return &FuncBuilder{
		php_name: php_name
		c_func: c_func
	}
}

pub fn (b &FuncBuilder) render_fe() string {
	return '    PHP_FE(${b.php_name}, arginfo_${b.c_func})'
}

pub fn (b &FuncBuilder) render_declaration() string {
	return 'PHP_FUNCTION(${b.php_name});'
}

pub fn (b &FuncBuilder) render_arginfo() string {
	return 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${b.c_func}, 0, 0, 0)\nZEND_END_ARG_INFO()'
}

pub fn (b FuncBuilder) export_fragments() ExportFragments {
	return ExportFragments{
		declarations: [b.render_declaration()]
		function_table: [b]
	}
}
