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

	// 2. 模块层：初始化 ModuleBuilder 并收集功能点
	mut mod_builder := new_module_builder(c.ext_name)
	for k, v in c.ini_entries {
		mod_builder.add_ini_entry(k, v)
	}

	res.write_string(mod_builder.render_declarations())

	// 1. 业务逻辑层：写入每个元素的实例实现 (Wrapper / ArgInfo)
	c_gen := CGenerator{ ext_name: c.ext_name }
	for line in c_gen.gen_c_code(mut c.elements) {
		res.write_string(line + '\n')
	}

	for mut el in c.elements {
		if mut el is PhpFuncRepr {
			mod_builder.add_function(el.name)
		}
	}

	// 注入 MINIT 内容
	for line in c_gen.gen_minit_lines(mut c.elements) {
		mod_builder.add_minit_line(line)
	}

	// 3. 渲染各个 C 块
	res.write_string(mod_builder.render_ini_entries())
	res.write_string(mod_builder.render_functions_table())
	res.write_string(mod_builder.render_minit())
	res.write_string(mod_builder.render_mshutdown())
	res.write_string(mod_builder.render_module_entry())
	res.write_string(mod_builder.render_get_module())

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
	guard := 'VPHP_EXT_${c.ext_name.to_upper()}_BRIDGE_H'
	res.write_string('#ifndef ${guard}\n')
	res.write_string('#define ${guard}\n\n')

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
