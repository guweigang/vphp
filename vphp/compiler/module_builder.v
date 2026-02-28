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
	functions     []string // 全局函数名列表
	minit_content []string // 注入到 MINIT 中的代码行
	ini_entries   []IniEntry
}

pub fn new_module_builder(ext_name string) &ModuleBuilder {
	return &ModuleBuilder{
		ext_name: ext_name
		version: '1.0.0'
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

// 渲染模块结构体定义
pub fn (b &ModuleBuilder) render_module_entry() string {
	mut res := strings.new_builder(512)
	mshutdown := if b.ini_entries.len > 0 { 'PHP_MSHUTDOWN(${b.ext_name})' } else { 'NULL' }
	
	res.write_string('zend_module_entry ${b.ext_name}_module_entry = {\n')
	res.write_string('    STANDARD_MODULE_HEADER, "${b.ext_name}", ${b.ext_name}_functions,\n')
	res.write_string('    PHP_MINIT(${b.ext_name}), ${mshutdown}, NULL, NULL, NULL, "${b.version}",\n')
	res.write_string('    STANDARD_MODULE_PROPERTIES\n};\n')
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

// 渲染所需的显示声明，防止编译器警告
pub fn (b &ModuleBuilder) render_declarations() string {
	return '
typedef struct { void* ex; void* ret; } vphp_context_internal;
typedef struct { void* str; int len; int is_lit; } v_string;

extern void vphp_framework_init(int module_number);
'
}

