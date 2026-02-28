module compiler

import strings

// INI 配置项
pub struct IniEntry {
pub:
	name          string
	default_value string
	// 后续可以增加类型校验回调逻辑
}

// 模块构建器：负责 zend_module_entry 相关的 C 代码生成
pub struct ModuleBuilder {
pub mut:
	ext_name      string
	version       string
	description   string
	functions     []string // 全局函数名列表
	minit_content []string // 注入到 MINIT 中的代码行
	ini_entries   []IniEntry
	globals       PhpGlobalsRepr
}

pub fn new_module_builder(ext_name string, version string, description string) &ModuleBuilder {
	return &ModuleBuilder{
		ext_name: ext_name
		version: if version != '' { version } else { '1.0.0' }
		description: description
	}
}

pub fn (mut b ModuleBuilder) add_function(name string) {
	b.functions << name
}

pub fn (mut b ModuleBuilder) add_minit_line(line string) {
	b.minit_content << line
}

pub fn (mut b ModuleBuilder) add_ini_entry(name string, def_val string) {
	b.ini_entries << IniEntry{name, def_val}
}

// 渲染函数表 (zend_function_entry)
pub fn (b &ModuleBuilder) render_functions_table() string {
	mut res := strings.new_builder(512)
	res.write_string('static const zend_function_entry ${b.ext_name}_functions[] = {\n')
	for f in b.functions {
		res.write_string('    PHP_FE(${f}, arginfo_${f})\n')
	}
	res.write_string('    PHP_FE_END\n};\n')
	return res.str()
}

// 渲染 INI 定义
pub fn (b &ModuleBuilder) render_ini_entries() string {
	if b.ini_entries.len == 0 { return '' }
	mut res := strings.new_builder(256)
	res.write_string('PHP_INI_BEGIN()\n')
	for entry in b.ini_entries {
		// 目前简单处理为字面量字符串配置
		res.write_string('    PHP_INI_ENTRY("${entry.name}", "${entry.default_value}", PHP_INI_ALL, NULL)\n')
	}
	res.write_string('PHP_INI_END()\n')
	return res.str()
}

// 渲染 Zend Globals 结构体
pub fn (b &ModuleBuilder) render_globals_struct() string {
	if b.globals.name == '' { return '' }
	mut res := strings.new_builder(256)
	res.write_string('ZEND_BEGIN_MODULE_GLOBALS(${b.ext_name})\n')
	for field in b.globals.fields {
		c_type := match field.v_type {
			'int' { 'zend_long' }
			'string' { 'v_string' }
			'i64' { 'zend_long' }
			'f64' { 'double' }
			'bool' { 'zend_bool' }
			else { 'void*' }
		}
		res.write_string('    ${c_type} ${field.name};\n')
	}
	res.write_string('ZEND_END_MODULE_GLOBALS(${b.ext_name})\n\n')
	
	res.write_string('ZEND_DECLARE_MODULE_GLOBALS(${b.ext_name})\n')
	res.write_string('#define VPHP_G(v) ZEND_MODULE_GLOBALS_ACCESSOR(${b.ext_name}, v)\n')
	return res.str()
}

// 渲染 GINIT (Globals Initialization)
pub fn (b &ModuleBuilder) render_ginit() string {
	if b.globals.name == '' { return '' }
	mut res := strings.new_builder(256)
	res.write_string('static void php_${b.ext_name}_init_globals(zend_${b.ext_name}_globals *globals) {\n')
	for field in b.globals.fields {
		// 默认初始化为 0 或空
		if field.v_type == 'string' {
			res.write_string('    globals->${field.name} = (v_string){0};\n')
		} else {
			res.write_string('    globals->${field.name} = 0;\n')
		}
	}
	res.write_string('}\n')
	return res.str()
}

// 渲染 MINIT 函数
pub fn (b &ModuleBuilder) render_minit() string {
	mut res := strings.new_builder(1024)
	res.write_string('PHP_MINIT_FUNCTION(${b.ext_name}) {\n')
	res.write_string('    vphp_framework_init(module_number);\n')
	res.write_string('    extern void vphp_ext_startup() __attribute__((weak));\n')
	res.write_string('    if (vphp_ext_startup) vphp_ext_startup();\n')
	
	if b.ini_entries.len > 0 {
		res.write_string('    REGISTER_INI_ENTRIES();\n')
	}

	for line in b.minit_content {
		res.write_string('    ${line}\n')
	}

	res.write_string('    return SUCCESS;\n}\n')
	return res.str()
}

// 渲染 MSHUTDOWN (如果需要卸载 INI)
pub fn (b &ModuleBuilder) render_mshutdown() string {
	if b.ini_entries.len == 0 { return '' }
	mut res := strings.new_builder(256)
	res.write_string('PHP_MSHUTDOWN_FUNCTION(${b.ext_name}) {\n')
	res.write_string('    UNREGISTER_INI_ENTRIES();\n')
	res.write_string('    return SUCCESS;\n}\n')
	return res.str()
}

// 渲染 MINFO 函数
pub fn (b &ModuleBuilder) render_minfo() string {
	mut res := strings.new_builder(1024)
	res.write_string('PHP_MINFO_FUNCTION(${b.ext_name}) {\n')
	res.write_string('    php_info_print_table_start();\n')
	res.write_string('    php_info_print_table_header(2, "${b.ext_name} support", "enabled");\n')
	res.write_string('    php_info_print_table_row(2, "Version", "${b.version}");\n')
	if b.description != '' {
		res.write_string('    php_info_print_table_row(2, "Description", "${b.description}");\n')
	}
	res.write_string('    php_info_print_table_end();\n')
	if b.ini_entries.len > 0 {
		res.write_string('    DISPLAY_INI_ENTRIES();\n')
	}
	res.write_string('}\n')
	return res.str()
}

// 渲染模块结构体定义
pub fn (b &ModuleBuilder) render_module_entry() string {
	mut res := strings.new_builder(512)
	mshutdown := if b.ini_entries.len > 0 { 'PHP_MSHUTDOWN(${b.ext_name})' } else { 'NULL' }
	ginit := if b.globals.name != '' { 'php_${b.ext_name}_init_globals' } else { 'NULL' }
	
	res.write_string('zend_module_entry ${b.ext_name}_module_entry = {\n')
	res.write_string('    STANDARD_MODULE_HEADER, "${b.ext_name}", ${b.ext_name}_functions,\n')
	res.write_string('    PHP_MINIT(${b.ext_name}), ${mshutdown}, NULL, NULL, PHP_MINFO(${b.ext_name}), "${b.version}",\n')
	res.write_string('    PHP_MODULE_GLOBALS(${b.ext_name}),\n')
	res.write_string('    (void (*)(void*)) ${ginit},\n')
	res.write_string('    NULL,\n') // GSHUTDOWN
	res.write_string('    NULL,\n') // post_deactivate
	res.write_string('    STANDARD_MODULE_PROPERTIES_EX\n};\n')
	return res.str()
}

// 渲染最终的模块导出宏
pub fn (b &ModuleBuilder) render_get_module() string {
	res := '
#ifdef COMPILE_DL_${b.ext_name.to_upper()}
ZEND_GET_MODULE(${b.ext_name})
#endif
'
	return res
}

// 渲染供 V 调用的全局变量获取器
pub fn (b &ModuleBuilder) render_globals_getter() string {
    if b.globals.name == '' { return '' }
    return '
void* vphp_get_active_globals() {
#ifdef ZTS
    return TSRMG(${b.ext_name}_globals_id, zend_${b.ext_name}_globals *, 0);
#else
    return &${b.ext_name}_globals;
#endif
}
'
}

// 渲染所需的显示声明，防止编译器警告
pub fn (b &ModuleBuilder) render_declarations() string {
	return '
typedef struct { void* ex; void* ret; } vphp_context_internal;
typedef struct { void* str; int len; int is_lit; } v_string;

extern void vphp_framework_init(int module_number);
'
}

