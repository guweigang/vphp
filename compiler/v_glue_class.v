module compiler

import compiler.repr

// ---- Class V Glue ----
fn (g VGenerator) gen_class_glue(r &repr.PhpClassRepr) []string {
	return g.gen_class_glue_for_module(r, 'main')
}

fn (g VGenerator) gen_class_glue_for_module(r &repr.PhpClassRepr, module_name string) []string {
	mut out := []string{}
	lower_name := to_snake_case(r.name)
	type_ref := if module_name == r.module_name { r.name } else { r.type_ref() }
	uses_inherited_receiver := class_uses_inherited_receiver(r)

	// A. 堆分配器
	out << ClassLifecycleGlue.new(r.name, type_ref, lower_name, r).render_lines()

	if uses_inherited_receiver {
		out << InheritedReceiverGlue.new(r.name, type_ref, lower_name, r.properties).render_lines()
	}

	out << ClassPropertyGlue.new(r.name, type_ref, lower_name, r.properties).render_lines()

	// F. 影子访问器
	out << ClassShadowGlue.new(r).render_lines()

	// G. 方法的胶水包装
	for m in r.methods {
		method_glue := ClassMethodGlue.new(r, lower_name, uses_inherited_receiver, m,
			g.params_structs, type_ref) or { continue }
		out << method_glue.render_lines()
	}

	// F. Handlers 导出
	out << ClassHandlersGlue.new(r.name, lower_name).render_lines()
	if !r.is_trait {
		out << ClassObjectBindingGlue.new(r.name, type_ref, r.c_name(), lower_name).render_lines()
	}

	return out
}
