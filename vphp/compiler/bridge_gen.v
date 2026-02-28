module compiler

import os
import strings

// ==========================================
// 1. 总入口：由外部 build.v 调用
// ==========================================
pub fn (mut c Compiler) generate_all() ! {
    c.generate_h()!
    c.generate_c()!
    c.generate_v_glue()!
}

// ==========================================
// 2. 生成 C 源文件 (php_bridge.c)
// ==========================================
fn (mut c Compiler) generate_c() ! {
	mut res := strings.new_builder(2048)
	res.write_string('/* ⚠️ VPHP Compiler Generated for ${c.ext_name} */\n')
	res.write_string('#include "php_bridge.h"\n\n')
	res.write_string('#include "../vphp/v_bridge.h"\n\n')

	// 0. 全局类型定义
	res.write_string('typedef struct { void* ex; void* ret; } vphp_context_internal;\n')
	// V 的 string ABI: { u8* str; int len; int is_lit; }
	res.write_string('typedef struct { void* str; int len; int is_lit; } v_string;\n\n')

	// 1. 显式声明，解决 -Wimplicit-function-declaration
	res.write_string('extern void vphp_framework_init(int module_number);\n')
	res.write_string('extern void vphp_task_auto_startup();\n\n')

	// 2. 写入每个元素的实现 (Wrapper / ArgInfo)
	c_gen := CGenerator{ ext_name: c.ext_name }
	for line in c_gen.gen_c_code(mut c.elements) {
		res.write_string(line + '\n')
	}

	// 3. VPhp\Task 类 — 框架内置
	c_ns := '\\\\' // V '\\\\' → 输出到 C 文件为 '\\' → C 运行时为单个 '\'
	res.write_string('/* === VPhp' + c_ns + 'Task built-in class === */\n')
	res.write_string('extern void vphp_task_spawn(zend_execute_data *execute_data, zval *return_value);\n')
	res.write_string('extern void vphp_task_wait(zend_execute_data *execute_data, zval *return_value);\n\n')
	res.write_string('ZEND_BEGIN_ARG_INFO_EX(arginfo_vphp_task_spawn, 0, 0, 2)\n')
	res.write_string('ZEND_END_ARG_INFO()\n')
	res.write_string('ZEND_BEGIN_ARG_INFO_EX(arginfo_vphp_task_wait, 0, 0, 1)\n')
	res.write_string('ZEND_END_ARG_INFO()\n\n')
	res.write_string('PHP_METHOD(VPhp_Task, spawn) { vphp_task_spawn(execute_data, return_value); }\n')
	res.write_string('PHP_METHOD(VPhp_Task, wait)  { vphp_task_wait(execute_data, return_value); }\n\n')
	res.write_string('static const zend_function_entry vphp_task_methods[] = {\n')
	res.write_string('    PHP_ME(VPhp_Task, spawn, arginfo_vphp_task_spawn, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)\n')
	res.write_string('    PHP_ME(VPhp_Task, wait,  arginfo_vphp_task_wait,  ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)\n')
	res.write_string('    PHP_FE_END\n')
	res.write_string('};\n\n')

	// 4. 函数表 (使用 ${c.ext_name}_functions) — 不再包含 v_spawn/v_wait
	res.write_string('static const zend_function_entry ${c.ext_name}_functions[] = {\n')
	for mut el in c.elements {
		if mut el is PhpFuncRepr {
			f := el
			res.write_string('    PHP_FE(${f.name}, arginfo_${f.name})\n')
		}
	}
	res.write_string('    PHP_FE_END\n};\n\n')

	// 5. MINIT
	res.write_string('PHP_MINIT_FUNCTION(${c.ext_name}) {\n')
	res.write_string('    vphp_framework_init(module_number);\n')
	for line in c_gen.gen_minit_lines(mut c.elements) {
		res.write_string(line + '\n')
	}
	// 注册 VPhp\Task 类
	res.write_string('    {\n')
	res.write_string('        zend_class_entry ce_task;\n')
	res.write_string('        INIT_CLASS_ENTRY(ce_task, "VPhp' + c_ns + 'Task", vphp_task_methods);\n')
	res.write_string('        zend_register_internal_class(&ce_task);\n')
	res.write_string('    }\n')
	res.write_string('    vphp_task_auto_startup();\n')
	res.write_string('    return SUCCESS;\n}\n\n')

	// 6. 模块入口
	res.write_string('zend_module_entry ${c.ext_name}_module_entry = {\n')
	res.write_string('    STANDARD_MODULE_HEADER, "${c.ext_name}", ${c.ext_name}_functions,\n')
	res.write_string('    PHP_MINIT(${c.ext_name}), NULL, NULL, NULL, NULL, "1.0.0",\n')
	res.write_string('    STANDARD_MODULE_PROPERTIES\n};\n\n')

  // 7. 核心：写入 ZEND_GET_MODULE 宏
  res.write_string('#ifndef COMPILE_DL_${c.ext_name.to_upper()}\n')
	res.write_string('#define COMPILE_DL_${c.ext_name.to_upper()}\n\n')
  res.write_string('ZEND_GET_MODULE(${c.ext_name})\n')
  res.write_string('#endif\n')

  os.write_file('php_bridge.c', res.str())!
}

// ==========================================
// 3. 生成 V 胶水代码 (_task_glue.v)
// ==========================================
fn (mut c Compiler) generate_v_glue() ! {
    v_gen := VGenerator{ ext_name: c.ext_name }
    v_code := v_gen.generate(mut c.elements)
    os.write_file('bridge.v', v_code)!
}

// ==========================================
// 4. 生成头文件 (php_bridge.h)
// ==========================================
fn (mut c Compiler) generate_h() ! {
	mut res := strings.new_builder(1024)

	// 1. 写入文件头和头文件保护 (Header Guard)
	res.write_string('/* ⚠️ VPHP Compiler Generated，请勿手动修改 */\n')
	res.write_string('#ifndef VPHP_BRIDGE_H\n')
	res.write_string('#define VPHP_BRIDGE_H\n\n')

	// 2. 引入必要的 PHP 内核头文件
	res.write_string('#include <php.h>\n\n')

	// 3. 写入扩展模块入口声明
	res.write_string('extern zend_module_entry ${c.ext_name}_module_entry;\n')
	res.write_string('#define phpext_${c.ext_name}_ptr &${c.ext_name}_module_entry\n\n')

	c_gen := CGenerator{ ext_name: c.ext_name }
	for line in c_gen.gen_h_defs(mut c.elements) {
		res.write_string(line + '\n')
	}

	// 6. 写入头文件保护结束
	res.write_string('#endif\n')

	// 7. 物理写入文件
	os.write_file('php_bridge.h', res.str()) or {
		return error('无法写入 php_bridge.h: $err')
	}

	println('  - [Generator] 已生成 php_bridge.h')
}
