module compiler

import os
import strings
import compiler.builder
import compiler.repr

fn (c Compiler) collect_non_type_fragments() builder.ExportFragments {
	mut fragments := builder.ExportFragments{}
	c_emitter := CGenerator{
		ext_name:          c.ext_name
		class_ce_by_type:  c.class_ce_map()
		class_php_by_type: c.class_php_map()
		table:             c.table
	}

	for el in c.elements {
		if el is repr.PhpFuncRepr {
			fragments.merge(c_emitter.build_func_export(el))
		} else if el is repr.PhpConstRepr {
			if el.has_php_const && el.const_type != 'struct' {
				fragments.merge(c_emitter.build_global_constant(el).export_fragments())
			}
		}
	}

	return fragments
}

fn (c Compiler) collect_type_fragments() builder.ExportFragments {
	mut fragments := builder.ExportFragments{}
	c_emitter := CGenerator{
		ext_name:          c.ext_name
		class_ce_by_type:  c.class_ce_map()
		class_php_by_type: c.class_php_map()
		table:             c.table
	}

	for el in c.elements {
		if el is repr.PhpInterfaceRepr {
			fragments.merge(c_emitter.build_interface_export(el))
		}
	}

	for el in c.elements {
		if el is repr.PhpClassRepr && !el.is_trait {
			fragments.merge(c_emitter.build_class_export(el))
		} else if el is repr.PhpEnumRepr {
			fragments.merge(c_emitter.build_enum_export(el))
		}
	}

	return fragments
}

fn (c Compiler) class_ce_map() map[string]string {
	mut m := map[string]string{}
	for el in c.elements {
		if el is repr.PhpClassRepr {
			ce := '${el.c_name().to_lower()}_ce'
			m[el.name] = ce
			m[el.php_name] = ce
			m[el.c_name()] = ce
		}
	}
	return m
}

fn (c Compiler) class_php_map() map[string]string {
	mut m := map[string]string{}
	for el in c.elements {
		if el is repr.PhpClassRepr {
			m[el.name] = el.php_name
			m[el.php_name] = el.php_name
			m[el.c_name()] = el.php_name
		}
	}
	return m
}

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
	mut mod_builder := builder.new_module_builder(c.ext_name, c.ext_version, c.ext_description)
	mut fragments := c.collect_non_type_fragments()
	mut type_fragments := c.collect_type_fragments()
	for k, v in c.ini_entries {
		mod_builder.add_ini_entry(k, v)
	}
	mod_builder.globals = c.globals_repr

	res.write_string(mod_builder.render_declarations())

	// 1. 业务逻辑层：写入每个导出单元的实例实现
	for line in fragments.implementations {
		res.write_string(line + '\n')
	}
	for line in type_fragments.implementations {
		res.write_string(line + '\n')
	}

	for fn_builder in fragments.function_table {
		mod_builder.add_function(fn_builder)
	}

	// 注入 MINIT 内容
	for line in fragments.minit_lines {
		mod_builder.add_minit_line(line)
	}
	for line in type_fragments.minit_lines {
		mod_builder.add_minit_line(line)
	}
	for line in fragments.rinit_lines {
		mod_builder.add_rinit_line(line)
	}
	for line in type_fragments.rinit_lines {
		mod_builder.add_rinit_line(line)
	}

	// 3. 渲染各个 C 块
	res.write_string(mod_builder.render_globals_struct())
	res.write_string(mod_builder.render_ginit())
	res.write_string(mod_builder.render_ini_entries())
	res.write_string(mod_builder.render_functions_table())
	res.write_string(mod_builder.render_minit())
	res.write_string(mod_builder.render_mshutdown())
	res.write_string(mod_builder.render_rinit())
	res.write_string(mod_builder.render_rshutdown())
	res.write_string(mod_builder.render_minfo())
	res.write_string(mod_builder.render_globals_getter())
	res.write_string(mod_builder.render_module_entry())
	res.write_string(mod_builder.render_get_module())

	os.write_file('php_bridge.c', res.str())!
}

// ==========================================
// 3. 生成 V 胶水代码 (_task_glue.v)
// ==========================================
fn (mut c Compiler) generate_v_glue() ! {
	v_glue := VGenerator{
		ext_name:       c.ext_name
		globals_repr:   c.globals_repr
		params_structs: c.params_structs
		table:          c.table
	}
	v_code := v_glue.generate(mut c.elements)
	os.write_file(c.bridge_output_path(), v_code)!
	c.generate_module_glue_files(v_glue)!
}

fn (c Compiler) bridge_output_path() string {
	if c.target_files.len == 0 {
		return 'vphp_bridge.v'
	}
	mut target_dir := os.dir(c.target_files[0])
	for file in c.target_files[1..] {
		dir := os.dir(file)
		if dir.len < target_dir.len {
			target_dir = dir
		}
	}
	if target_dir == '' {
		return 'vphp_bridge.v'
	}
	return os.join_path(target_dir, 'vphp_bridge.v')
}


fn (c Compiler) module_dirs() map[string]string {
	mut dirs := map[string]string{}
	for file in c.target_files {
		source := os.read_file(file) or { continue }
		for line in source.split_into_lines() {
			trimmed := line.trim_space()
			if trimmed == '' || trimmed.starts_with('//') {
				continue
			}
			if trimmed.starts_with('module ') {
				module_name := trimmed['module '.len..].trim_space()
				if module_name != '' && module_name !in dirs {
					dirs[module_name] = os.dir(file)
				}
			}
			break
		}
	}
	return dirs
}

fn (c Compiler) generate_module_glue_files(v_glue VGenerator) ! {
	module_dirs := c.module_dirs()
	mut classes_by_module := map[string][]repr.PhpClassRepr{}
	mut funcs_by_module := map[string][]repr.PhpFuncRepr{}
	mut enums_by_module := map[string][]repr.PhpEnumRepr{}
	for el in c.elements {
		if el is repr.PhpClassRepr {
			if el.is_trait || el.module_name == '' || el.module_name == 'main' {
				continue
			}
			classes_by_module[el.module_name] << el
		} else if el is repr.PhpFuncRepr {
			if el.module_name == '' || el.module_name == 'main' {
				continue
			}
			funcs_by_module[el.module_name] << el
		} else if el is repr.PhpEnumRepr {
			if el.module_name == '' || el.module_name == 'main' {
				continue
			}
			enums_by_module[el.module_name] << el
		}
	}
	// 合并所有需要生成 glue 的模块
	mut all_modules := map[string]bool{}
	for m, _ in classes_by_module {
		all_modules[m] = true
	}
	for m, _ in funcs_by_module {
		all_modules[m] = true
	}
	for m, _ in enums_by_module {
		all_modules[m] = true
	}
	for module_name, _ in all_modules {
		classes := classes_by_module[module_name] or { []repr.PhpClassRepr{} }
		funcs := funcs_by_module[module_name] or { []repr.PhpFuncRepr{} }
		enums := enums_by_module[module_name] or { []repr.PhpEnumRepr{} }
		module_dir := module_dirs[module_name] or { continue }
		mut out := strings.new_builder(1024)
		out.write_string('module ${module_name}\n\n')
		out.write_string('import vphp\n\n')
		for imported in module_glue_imports(classes, funcs, module_name, module_dirs) {
			out.write_string('import ${imported}\n')
		}
		if module_glue_imports(classes, funcs, module_name, module_dirs).len > 0 {
			out.write_string('\n')
		}
		out.write_string('#include "php_bridge.h"\n\n')
		for class in classes {
			out.write_string('__global C.${class.c_name().to_lower()}_ce &C.zend_class_entry\n')
		}
		if classes.len > 0 {
			out.write_string('\n')
		}
		for class in classes {
			out.write_string(v_glue.gen_class_glue_for_module(class, module_name).join('\n'))
			out.write_string('\n\n')
			out.write_string('pub fn (val ${class.name}) php_class_name() string {\n')
			out.write_string('    return \'${class.php_name.replace("\'", "\\\'")}\'\n')
			out.write_string('}\n\n')
		}
		for func in funcs {
			out.write_string(v_glue.gen_func_glue_for_module(func, module_name).join('\n'))
			out.write_string('\n\n')
		}
		for enum_el in enums {
			out.write_string('pub fn (val ${enum_el.name}) php_class_name() string {\n')
			out.write_string('    return \'${enum_el.php_name.replace("\'", "\\\'")}\'\n')
			out.write_string('}\n\n')
		}
		os.write_file(os.join_path(module_dir, 'vphp_bridge.v'), out.str())!
	}
}

fn module_glue_imports(classes []repr.PhpClassRepr, funcs []repr.PhpFuncRepr, current_module string, module_dirs map[string]string) []string {
	mut imports := []string{}
	for class in classes {
		for prop in class.properties {
			imports << modules_in_type_ref(prop.v_type, current_module, module_dirs)
		}
		for method in class.methods {
			imports << modules_in_type_ref(method.return_spec.effective_v_type(), current_module,
				module_dirs)
			for arg in method.args {
				imports << modules_in_type_ref(arg.v_type, current_module, module_dirs)
				if arg.source.params_type != '' {
					imports << modules_in_type_ref(arg.source.params_type, current_module,
						module_dirs)
				}
			}
		}
	}
	for func in funcs {
		imports << modules_in_type_ref(func.return_spec.effective_v_type(), current_module,
			module_dirs)
		for arg in func.args {
			imports << modules_in_type_ref(arg.v_type, current_module, module_dirs)
			if arg.source.params_type != '' {
				imports << modules_in_type_ref(arg.source.params_type, current_module,
					module_dirs)
			}
		}
	}
	imports.sort()
	return uniq_lines(imports)
}

fn modules_in_type_ref(type_ref string, current_module string, module_dirs map[string]string) []string {
	mut imports := []string{}
	for module_name, _ in module_dirs {
		if module_name == '' || module_name == 'main' || module_name == current_module {
			continue
		}
		if type_ref.contains('${module_name}.') {
			imports << module_name
		}
	}
	return imports
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
	res.write_string('#include <php.h>\n')
	res.write_string('#include <Zend/zend_attributes.h>\n')
	res.write_string('#include <Zend/zend_enum.h>\n')
	res.write_string('#include <ext/standard/info.h>\n\n')
	res.write_string('#ifndef ZEND_ACC_READONLY_CLASS\n')
	res.write_string('#define ZEND_ACC_READONLY_CLASS 0\n')
	res.write_string('#endif\n\n')

	// 3. 写入扩展模块入口声明
	res.write_string('extern zend_module_entry ${c.ext_name}_module_entry;\n')
	res.write_string('#define phpext_${c.ext_name}_ptr &${c.ext_name}_module_entry\n\n')
	res.write_string('extern void* vphp_get_active_globals();\n\n')

	fragments := c.collect_non_type_fragments()
	type_fragments := c.collect_type_fragments()
	for line in fragments.declarations {
		res.write_string(line + '\n')
	}
	for line in type_fragments.declarations {
		res.write_string(line + '\n')
	}

	// 6. 写入头文件保护结束
	res.write_string('#endif\n')

	// 7. 物理写入文件
	os.write_file('php_bridge.h', res.str()) or { return error('无法写入 php_bridge.h: $err') }

	println('  - [Generator] 已生成 php_bridge.h')
}
