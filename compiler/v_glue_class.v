module compiler

import compiler.repr

// ---- Class V Glue ----
fn (g VGenerator) gen_class_glue(r &repr.PhpClassRepr) []string {
	mut out := []string{}
	lower_name := r.name.to_lower()
	uses_inherited_receiver := class_uses_inherited_receiver(r)

	// A. 堆分配器
	out << ClassLifecycleGlue.new(r.name, lower_name, r).render_lines()

	if uses_inherited_receiver {
		out << InheritedReceiverGlue.new(r.name, lower_name, r.properties).render_lines()
	}

	out << ClassPropertyGlue.new(r.name, lower_name, r.properties).render_lines()

	// F. 影子访问器
	out << ClassShadowGlue.new(r).render_lines()

	// G. 方法的胶水包装
	for m in r.methods {
		if m.has_export {
			continue
		}

		glue_name := if m.v_name != '' { m.v_name } else { m.name }
		return_type := m.return_spec.effective_v_type()
		struct_closure := StructClosureBinding.new('${r.name}_${glue_name}', return_type,
			g.params_structs)
		if closure_binding := struct_closure {
			out << closure_binding.render_helper_lines()
		}

		return_info := method_runtime_return_info(r.name, m.name, m.is_static, return_type,
			m.borrowed_return)
		return_binding := ReturnBinding.new_with_struct_closure(return_type, struct_closure)
		returns_object := return_info.kind in [.static_factory, .static_object, .instance_object]

		arg_setup := build_php_arg_setup(m.args, returns_object, true)
		arg_names := arg_setup.names

		call_args := arg_names.join(', ')
		v_name := if m.v_name != '' { m.v_name } else { m.name }
		v_call_name := if is_v_keyword(v_name) { '@' + v_name } else { v_name }

		call_str := if m.is_static {
			'${r.name}.${v_call_name}(${call_args})'
		} else {
			if uses_inherited_receiver {
				'recv.${v_call_name}(${call_args})'
			} else {
				'recv.${v_call_name}(${call_args})'
			}
		}

		method_ctx := ClassMethodGlueContext{
			class_name:              r.name
			lower_name:              lower_name
			shadow_static_name:      r.shadow_static_name
			is_static:               m.is_static
			uses_inherited_receiver: uses_inherited_receiver
			returns_object:          returns_object
			return_type:             return_type
			call_expr:               call_str
			arg_names:               arg_names
			return_binding:          return_binding
		}
		out << method_ctx.render_wrapper_start_lines(glue_name)
		out << method_ctx.render_scope_lines()
		out << arg_setup.lines
		out << method_ctx.render_static_sync_from_php_lines()
		out << method_ctx.render_return_lines()
		out << '}'
	}

	// F. Handlers 导出
	out << ClassHandlersGlue.new(r.name, lower_name).render_lines()

	return out
}
