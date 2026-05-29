module compiler

import os
import strings
import compiler.repr

pub fn (v_glue VGenerator) generate_modules(elements []repr.PhpRepr, target_files []string) ! {
	module_dirs := v_glue.module_dirs(target_files)
	mut classes_by_module := map[string][]repr.PhpClassRepr{}
	mut funcs_by_module := map[string][]repr.PhpFuncRepr{}
	mut enums_by_module := map[string][]repr.PhpEnumRepr{}
	for el in elements {
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
		for imported in v_glue.module_glue_imports(classes, funcs, module_name, module_dirs) {
			out.write_string('import ${imported}\n')
		}
		if v_glue.module_glue_imports(classes, funcs, module_name, module_dirs).len > 0 {
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
			out.write_string('    return \'${class.php_name.replace("'", "\\'")}\'\n')
			out.write_string('}\n\n')
		}
		for func in funcs {
			out.write_string(v_glue.gen_func_glue_for_module(func, module_name).join('\n'))
			out.write_string('\n\n')
		}
		for enum_el in enums {
			out.write_string('pub fn (val ${enum_el.name}) php_class_name() string {\n')
			out.write_string('    return \'${enum_el.php_name.replace("'", "\\'")}\'\n')
			out.write_string('}\n\n')
		}
		os.write_file(os.join_path(module_dir, 'vphp_bridge.v'), out.str())!
	}
}

fn (v_glue VGenerator) module_dirs(target_files []string) map[string]string {
	mut dirs := map[string]string{}
	for file in target_files {
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

fn (v_glue VGenerator) module_glue_imports(classes []repr.PhpClassRepr, funcs []repr.PhpFuncRepr, current_module string, module_dirs map[string]string) []string {
	mut imports := []string{}
	for class in classes {
		for prop in class.properties {
			imports << v_glue.modules_in_type_ref(prop.v_type, current_module, module_dirs)
		}
		for method in class.methods {
			imports << v_glue.modules_in_type_ref(method.return_spec.effective_v_type(),
				current_module, module_dirs)
			for arg in method.args {
				imports << v_glue.modules_in_type_ref(arg.v_type, current_module, module_dirs)
				if arg.source.params_type != '' {
					imports << v_glue.modules_in_type_ref(arg.source.params_type, current_module,
						module_dirs)
				}
			}
		}
	}
	for func in funcs {
		imports << v_glue.modules_in_type_ref(func.return_spec.effective_v_type(), current_module,
			module_dirs)
		for arg in func.args {
			imports << v_glue.modules_in_type_ref(arg.v_type, current_module, module_dirs)
			if arg.source.params_type != '' {
				imports << v_glue.modules_in_type_ref(arg.source.params_type, current_module,
					module_dirs)
			}
		}
	}
	imports.sort()
	return uniq_lines(imports)
}

fn (v_glue VGenerator) modules_in_type_ref(type_ref string, current_module string, module_dirs map[string]string) []string {
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

pub fn (c Compiler) class_ce_map() map[string]string {
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

pub fn (c Compiler) class_php_map() map[string]string {
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
