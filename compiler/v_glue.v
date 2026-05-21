module compiler

import strings
import compiler.repr

pub struct VGenerator {
pub:
	ext_name       string
	globals_repr   repr.PhpGlobalsRepr
	params_structs map[string]repr.PhpParamsStruct
}

struct VGlueEmissionPlan {
mut:
	c_global_lines     []string
	glue_blocks        []string
	startup_lines      []string
	task_registrations []string
}

fn (g VGenerator) generate(mut elements []repr.PhpRepr) string {
	mut out := strings.new_builder(2048)
	out.write_string('module main\n\nimport vphp\n')
	for module_name in g.import_modules(elements) {
		out.write_string('import ${module_name}\n')
	}
	out.write_string('\n')
	out.write_string('#include "php_bridge.h"\n\n')
	plan := g.build_emission_plan(mut elements)
	if plan.c_global_lines.len > 0 {
		out.write_string(plan.c_global_lines.join('\n') + '\n\n')
	}

	for block in plan.glue_blocks {
		out.write_string(block + '\n\n')
	}

	startup_body := plan.startup_body()
	// A. 如果捕获到任何 module auto-startup 行，自动生成内部初始化注册函数
	if startup_body.len > 0 {
		out.write_string("@[export: 'vphp_ext_auto_startup']\n")
		out.write_string('fn vphp_ext_auto_startup() {\n')
		out.write_string(startup_body.join('\n\n'))
		out.write_string('\n}\n')
	}

	return out.str()
}

fn (g VGenerator) import_modules(elements []repr.PhpRepr) []string {
	mut modules := []string{}
	for el in elements {
		if el is repr.PhpFuncRepr {
			if el.module_name != '' && el.module_name != 'main' {
				modules << el.module_name
			}
		} else if el is repr.PhpClassRepr {
			if el.module_name != '' && el.module_name != 'main' {
				modules << el.module_name
			}
		}
	}
	modules.sort()
	return uniq_lines(modules)
}

fn (g VGenerator) build_emission_plan(mut elements []repr.PhpRepr) VGlueEmissionPlan {
	mut plan := VGlueEmissionPlan{
		c_global_lines: g.c_global_lines(elements)
	}
	for mut el in elements {
		if mut el is repr.PhpFuncRepr {
			// Closure returns are wrapped through compiler-generated concrete
			// bridges so the runtime only keeps the low-level closure storage API.
			if el.module_name == '' || el.module_name == 'main' {
				plan.glue_blocks << g.gen_func_glue(el).join('\n')
			}
		} else if mut el is repr.PhpClassRepr {
			if el.is_trait {
				continue
			}
			if el.module_name == '' || el.module_name == 'main' {
				plan.glue_blocks << g.gen_class_glue(el).join('\n')
			}
			plan.startup_lines << g.gen_class_startup(el)
		} else if mut el is repr.PhpTaskRepr {
			plan.task_registrations << g.gen_task_registration(el)
		} else if mut el is repr.PhpGlobalsRepr {
			// Already handled by standalone logic above for now, but good to mark as handled
		}
	}
	return plan
}

fn (plan VGlueEmissionPlan) startup_body() []string {
	mut body := uniq_lines(plan.startup_lines)
	if plan.task_registrations.len > 0 {
		body << plan.task_registrations
	}
	return body
}

fn (g VGenerator) c_global_lines(elements []repr.PhpRepr) []string {
	mut lines := []string{}
	for el in elements {
		if el is repr.PhpClassRepr {
			if el.is_trait || (el.module_name != '' && el.module_name != 'main') {
				continue
			}
			lines << '__global C.${el.c_name().to_lower()}_ce &C.zend_class_entry'
		} else if el is repr.PhpInterfaceRepr {
			lines << '__global C.${el.c_name().to_lower()}_ce &C.zend_class_entry'
		} else if el is repr.PhpEnumRepr {
			lines << '__global C.${el.c_name().to_lower()}_ce &C.zend_class_entry'
		}
	}
	return uniq_lines(lines)
}
