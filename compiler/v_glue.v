module compiler

import strings
import compiler.repr

pub struct VGenerator {
pub:
	ext_name       string
	globals_repr   repr.PhpGlobalsRepr
	params_structs map[string]repr.PhpParamsStruct
}

fn (g VGenerator) generate(mut elements []repr.PhpRepr) string {
	mut out := strings.new_builder(2048)
	out.write_string('module main\n\nimport vphp\n\n')
	out.write_string('#include "php_bridge.h"\n\n')
	c_global_lines := g.c_global_lines(elements)
	if c_global_lines.len > 0 {
		out.write_string(c_global_lines.join('\n') + '\n\n')
	}

	mut task_registrations := []string{}
	mut startup_lines := []string{}
	// 生成每个 repr 的 V 胶水
	for mut el in elements {
		if mut el is repr.PhpFuncRepr {
			// Closure returns are wrapped through compiler-generated concrete
			// bridges so the runtime only keeps the low-level closure storage API.
			out.write_string(g.gen_func_glue(el).join('\n') + '\n\n')
		} else if mut el is repr.PhpClassRepr {
			if el.is_trait {
				continue
			}
			out.write_string(g.gen_class_glue(el).join('\n') + '\n\n')
			startup_lines << g.gen_class_startup(el)
		} else if mut el is repr.PhpTaskRepr {
			task_registrations << g.gen_task_registration(el)
		} else if mut el is repr.PhpGlobalsRepr {
			// Already handled by standalone logic above for now, but good to mark as handled
		}
	}

	mut startup_body := uniq_lines(startup_lines)
	if task_registrations.len > 0 {
		startup_body << task_registrations
	}
	// A. 如果捕获到任何 module auto-startup 行，自动生成内部初始化注册函数
	if startup_body.len > 0 {
		out.write_string("@[export: 'vphp_ext_auto_startup']\n")
		out.write_string('fn vphp_ext_auto_startup() {\n')
		out.write_string(startup_body.join('\n\n'))
		out.write_string('\n}\n')
	}

	return out.str()
}

fn (g VGenerator) c_global_lines(elements []repr.PhpRepr) []string {
	mut lines := []string{}
	for el in elements {
		if el is repr.PhpClassRepr {
			if el.is_trait {
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
