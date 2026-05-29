module compiler

import compiler.repr

struct ClassMethodCGluePlan {
	method_name             string
	is_static               bool
	has_export              bool
	method_return_type      string
	return_info             RuntimeReturnInfo
	uses_inherited_receiver bool
	uses_context_arg        bool
	vars                    map[string]string
}

fn (g CGenerator) gen_class_c(r &repr.PhpClassRepr) []string {
	mut c := []string{}
	c_class := r.c_name() // C macro safe: VPhp_Task
	has_init := r.methods.any(is_constructor_method(it.name))
	class_builder := g.build_class_type(r, has_init)
	uses_inherited_receiver := class_uses_inherited_receiver(r)

	c << class_builder.render_impl_prelude()

	// 2. 生成方法包装器 — 使用模板
	for m in r.methods {
		if m.is_abstract {
			continue
		}
		plan := g.build_class_method_c_glue_plan(r, m, c_class, uses_inherited_receiver)
		c << g.render_class_method_c(plan)
	}

	if !has_init && !uses_inherited_receiver {
		vars := {
			'CLASS':         c_class
			'HANDLER_CLASS': to_snake_case(r.name)
		}
		c << render_tpl(tpl_default_construct, vars)
	}

	// 3. 生成方法表 (zend_function_entry)
	c << class_builder.render_impl_postlude()

	return c
}

fn (g CGenerator) build_class_method_c_glue_plan(r &repr.PhpClassRepr, m repr.PhpMethodRepr, c_class string, uses_inherited_receiver bool) ClassMethodCGluePlan {
	php_name := php_method_name(m.name)
	glue_name := if m.v_name != '' { m.v_name } else { m.name }
	v_c_func := if m.has_export {
		m.v_c_func
	} else {
		'vphp_wrap_${to_snake_case(r.name)}_${glue_name}'
	}
	method_return_type := m.return_spec.effective_v_type()
	return_info := method_runtime_return_info(r.name, m.name, m.is_static, method_return_type,
		m.borrowed_return)
	uses_context_arg := method_uses_context_arg(m)
	vars := {
		'CLASS':         c_class
		'CLASS_CE':      g.ce_var_for_type(r.name)
		'HANDLER_CLASS': to_snake_case(r.name)
		'PHP_METHOD':    php_name
		'V_FUNC':        v_c_func
		'C_TYPE':        return_info.tm.c_type
		'PHP_RETURN':    return_info.tm.php_return
	}
	return ClassMethodCGluePlan{
		method_name:             m.name
		is_static:               m.is_static
		has_export:              m.has_export
		method_return_type:      method_return_type
		return_info:             return_info
		uses_inherited_receiver: uses_inherited_receiver
		uses_context_arg:        uses_context_arg
		vars:                    vars
	}
}

fn (g CGenerator) render_class_method_c(plan ClassMethodCGluePlan) []string {
	if plan.has_export {
		return g.render_exported_class_method_c(plan)
	}
	if is_constructor_method(plan.method_name) {
		return g.render_constructor_method_c(plan)
	}
	if plan.is_static {
		return g.render_static_method_c(plan)
	}
	return g.render_instance_method_c(plan)
}

fn (g CGenerator) render_exported_class_method_c(plan ClassMethodCGluePlan) []string {
	if plan.is_static {
		return [render_tpl(tpl_static_manual_ctx, plan.vars)]
	}
	return render_instance_template_c(plan, tpl_instance_method, tpl_inherited_instance_method,
		plan.vars)
}

fn (g CGenerator) render_constructor_method_c(plan ClassMethodCGluePlan) []string {
	if plan.uses_inherited_receiver {
		return []
	}
	if plan.uses_context_arg {
		return [render_tpl(tpl_construct_context, plan.vars)]
	}
	return [render_tpl(tpl_construct, plan.vars)]
}

fn (g CGenerator) render_static_method_c(plan ClassMethodCGluePlan) []string {
	if plan.uses_context_arg {
		return [render_tpl(tpl_static_context, plan.vars)]
	}
	if plan.return_info.kind == .static_factory {
		return [render_tpl(tpl_static_factory, plan.vars)]
	}
	if plan.return_info.kind == .static_object {
		return [render_tpl(tpl_static_object, g.vars_with_return_object(plan))]
	}
	if plan.return_info.kind in [.result, .option] {
		return render_static_result_method_c(plan)
	}
	if plan.return_info.kind == .void_ {
		return [render_tpl(tpl_static_void, plan.vars)]
	}
	return [render_tpl(tpl_static_scalar, plan.vars)]
}

fn (g CGenerator) render_instance_method_c(plan ClassMethodCGluePlan) []string {
	if plan.uses_context_arg {
		return render_instance_template_c(plan, tpl_instance_context,
			tpl_inherited_instance_context, plan.vars)
	}
	if plan.return_info.kind == .instance_object {
		vars := g.vars_with_return_object(plan)
		return render_instance_template_c(plan, tpl_instance_object, tpl_inherited_instance_object,
			vars)
	}
	if plan.return_info.kind in [.result, .option] {
		// Option 类型在 V glue 侧处理 or{}，C 侧等同 result 调用模式
		return render_instance_template_c(plan, tpl_instance_result, tpl_inherited_instance_result,
			plan.vars)
	}
	if plan.return_info.kind == .void_ {
		return render_instance_template_c(plan, tpl_instance_void, tpl_inherited_instance_void,
			plan.vars)
	}
	return render_instance_template_c(plan, tpl_instance_method, tpl_inherited_instance_method,
		plan.vars)
}

fn render_static_result_method_c(plan ClassMethodCGluePlan) []string {
	// Result/Option 类型在 V glue 侧处理 or{}，C 侧等同 void 调用
	payload_return := plan.method_return_type[1..]
	if payload_return == '' || payload_return == 'void' {
		return [render_tpl(tpl_static_void, plan.vars)]
	}
	return [render_tpl(tpl_static_scalar, plan.vars)]
}

fn render_instance_template_c(plan ClassMethodCGluePlan, tpl string, inherited_tpl string, vars map[string]string) []string {
	if plan.uses_inherited_receiver {
		return [render_tpl(inherited_tpl, vars)]
	}
	return [render_tpl(tpl, vars)]
}

fn (g CGenerator) vars_with_return_object(plan ClassMethodCGluePlan) map[string]string {
	mut vars := plan.vars.clone()
	vars['RET_CLASS'] = to_snake_case(plan.return_info.class_key)
	vars['RET_CLASS_CE'] = g.ce_var_for_type(plan.return_info.class_key)
	vars['RET_OWNS_VPTR'] = plan.return_info.owns_vptr
	return vars
}
