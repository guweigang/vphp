module compiler

import compiler.repr

fn (g CGenerator) gen_class_c(r &repr.PhpClassRepr) []string {
	mut c := []string{}
	c_class := r.c_name() // C macro safe: VPhp_Task
	has_init := r.methods.any(is_constructor_method(it.name))
	class_builder := g.build_class_type(r, has_init)

	c << class_builder.render_impl_prelude()

	// 2. 生成方法包装器 — 使用模板
	for m in r.methods {
		if m.is_abstract {
			continue
		}
		php_name := php_method_name(m.name)
		glue_name := if m.v_name != '' { m.v_name } else { m.name }

		v_c_func := if m.has_export { m.v_c_func } else { 'vphp_wrap_${r.name}_${glue_name}' }

		method_return_type := m.return_spec.effective_v_type()
		return_info := method_runtime_return_info(r.name, m.name, m.is_static, method_return_type,
			m.borrowed_return)
		uses_inherited_receiver := class_uses_inherited_receiver(r)
		uses_context_arg := method_uses_context_arg(m)

		vars := {
			'CLASS':         c_class
			'CLASS_CE':      g.ce_var_for_type(r.name)
			'HANDLER_CLASS': r.name
			'PHP_METHOD':    php_name
			'V_FUNC':        v_c_func
			'C_TYPE':        return_info.tm.c_type
			'PHP_RETURN':    return_info.tm.php_return
		}

		if m.has_export {
			if m.is_static {
				c << render_tpl(tpl_static_manual_ctx, vars)
			} else if uses_inherited_receiver {
				c << render_tpl(tpl_inherited_instance_method, vars)
			} else {
				c << render_tpl(tpl_instance_method, vars)
			}
			continue
		}

		if is_constructor_method(m.name) {
			if class_uses_inherited_receiver(r) {
				continue
			}
			if uses_context_arg {
				c << render_tpl(tpl_construct_context, vars)
			} else {
				c << render_tpl(tpl_construct, vars)
			}
		} else if m.is_static {
			if uses_context_arg {
				c << render_tpl(tpl_static_context, vars)
			} else if return_info.kind == .static_factory {
				c << render_tpl(tpl_static_factory, vars)
			} else if return_info.kind == .static_object {
				mut obj_vars := vars.clone()
				obj_vars['RET_CLASS'] = return_info.class_key
				obj_vars['RET_CLASS_CE'] = g.ce_var_for_type(return_info.class_key)
				obj_vars['RET_OWNS_VPTR'] = return_info.owns_vptr
				c << render_tpl(tpl_static_object, obj_vars)
			} else if return_info.kind in [.result, .option] {
				// Result/Option 类型在 V glue 侧处理 or{}，C 侧等同 void 调用
				payload_return := method_return_type[1..]
				if payload_return == '' || payload_return == 'void' {
					c << render_tpl(tpl_static_void, vars)
				} else {
					c << render_tpl(tpl_static_scalar, vars)
				}
			} else if return_info.kind == .void_ {
				c << render_tpl(tpl_static_void, vars)
			} else {
				c << render_tpl(tpl_static_scalar, vars)
			}
		} else {
			if uses_context_arg {
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_context, vars)
				} else {
					c << render_tpl(tpl_instance_context, vars)
				}
			} else if return_info.kind == .instance_object {
				mut obj_vars := vars.clone()
				obj_vars['RET_CLASS'] = return_info.class_key
				obj_vars['RET_CLASS_CE'] = g.ce_var_for_type(return_info.class_key)
				obj_vars['RET_OWNS_VPTR'] = return_info.owns_vptr
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_object, obj_vars)
				} else {
					c << render_tpl(tpl_instance_object, obj_vars)
				}
			} else if return_info.kind == .result {
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_result, vars)
				} else {
					c << render_tpl(tpl_instance_result, vars)
				}
			} else if return_info.kind == .option {
				// Option 类型在 V glue 侧处理 or{}，C 侧等同 result 调用模式
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_result, vars)
				} else {
					c << render_tpl(tpl_instance_result, vars)
				}
			} else if return_info.kind == .void_ {
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_void, vars)
				} else {
					c << render_tpl(tpl_instance_void, vars)
				}
			} else {
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_method, vars)
				} else {
					c << render_tpl(tpl_instance_method, vars)
				}
			}
		}
	}

	if !has_init && !class_uses_inherited_receiver(r) {
		vars := {
			'CLASS':         c_class
			'HANDLER_CLASS': r.name
		}
		c << render_tpl(tpl_default_construct, vars)
	}

	// 3. 生成方法表 (zend_function_entry)
	c << class_builder.render_impl_postlude()

	return c
}
