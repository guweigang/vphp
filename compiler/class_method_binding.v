module compiler

import compiler.repr

struct ClassMethodGlue {
	glue_name    string
	helper_lines []string
	arg_setup    PhpArgSetup
	context      ClassMethodGlueContext
}

struct ClassMethodGlueContext {
	class_name              string
	type_ref                string
	lower_name              string
	shadow_static_name      string
	is_static               bool
	uses_inherited_receiver bool
	returns_object          bool
	return_type             string
	call_expr               string
	arg_names               []string
	return_binding          ReturnBinding
}

fn ClassMethodGlue.new(r &repr.PhpClassRepr, lower_name string, uses_inherited_receiver bool, method repr.PhpMethodRepr, params_structs map[string]repr.PhpParamsStruct, type_ref string) ?ClassMethodGlue {
	if method.has_export {
		return none
	}
	glue_name := if method.v_name != '' { method.v_name } else { method.name }
	return_type := method.return_spec.effective_v_type()
	struct_closure := StructClosureBinding.new('${r.name}_${glue_name}', return_type,
		params_structs)
	mut helper_lines := []string{}
	if closure_binding := struct_closure {
		helper_lines << closure_binding.render_helper_lines()
	}
	return_info := method_runtime_return_info(r.name, method.name, method.is_static, return_type,
		method.borrowed_return)
	return_binding := ReturnBinding.new_with_struct_closure(return_type, struct_closure)
	returns_object := return_info.kind in [.static_factory, .static_object, .instance_object]
	arg_setup := build_php_arg_setup(method.args, returns_object, true)
	arg_names := arg_setup.names
	call_expr := class_method_call_expr(type_ref, method, uses_inherited_receiver, arg_names)
	return ClassMethodGlue{
		glue_name:    glue_name
		helper_lines: helper_lines
		arg_setup:    arg_setup
		context:      ClassMethodGlueContext{
			class_name:              r.name
			type_ref:                type_ref
			lower_name:              lower_name
			shadow_static_name:      r.shadow_static_name
			is_static:               method.is_static
			uses_inherited_receiver: uses_inherited_receiver
			returns_object:          returns_object
			return_type:             return_type
			call_expr:               call_expr
			arg_names:               arg_names
			return_binding:          return_binding
		}
	}
}

fn class_method_call_expr(type_ref string, method repr.PhpMethodRepr, uses_inherited_receiver bool, arg_names []string) string {
	call_args := arg_names.join(', ')
	v_name := if method.v_name != '' { method.v_name } else { method.name }
	v_call_name := if is_v_keyword(v_name) { '@' + v_name } else { v_name }
	if method.is_static {
		return '${type_ref}.${v_call_name}(${call_args})'
	}
	if uses_inherited_receiver {
		return 'recv.${v_call_name}(${call_args})'
	}
	return 'recv.${v_call_name}(${call_args})'
}

fn (glue ClassMethodGlue) render_lines() []string {
	mut lines := []string{}
	lines << glue.helper_lines
	lines << glue.context.render_wrapper_start_lines(glue.glue_name)
	lines << glue.context.render_scope_lines()
	lines << glue.arg_setup.lines
	lines << glue.context.render_static_sync_from_php_lines()
	lines << glue.context.render_return_lines()
	lines << '}'
	return lines
}

fn (ctx ClassMethodGlueContext) capture_list() string {
	mut captures := ctx.arg_names.clone()
	if !ctx.is_static {
		captures << 'recv'
	}
	return ReturnBinding.capture_list(captures)
}

fn (ctx ClassMethodGlueContext) return_decl() string {
	return if ctx.returns_object { 'voidptr' } else { '' }
}

fn (ctx ClassMethodGlueContext) render_wrapper_start_lines(glue_name string) []string {
	mut lines := []string{}
	lines << "@[export: 'vphp_wrap_${ctx.class_name}_${glue_name}']"
	if ctx.is_static {
		lines << 'pub fn vphp_wrap_${ctx.lower_name}_${glue_name}(ctx vphp.Context) ${ctx.return_decl()} {'
	} else {
		lines << 'pub fn vphp_wrap_${ctx.lower_name}_${glue_name}(ptr voidptr, ctx vphp.Context) ${ctx.return_decl()} {'
		lines << ctx.render_receiver_lines()
	}
	return lines
}

fn (ctx ClassMethodGlueContext) render_receiver_lines() []string {
	if ctx.is_static {
		return []
	}
	if ctx.uses_inherited_receiver {
		return [
			'    this_obj := vphp.ZendObject.from_ptr(ptr)',
			'    mut recv := ${ctx.lower_name}_load_from_php(this_obj)',
		]
	}
	return ['    mut recv := unsafe { &${ctx.type_ref}(ptr) }']
}

fn (ctx ClassMethodGlueContext) render_scope_lines() []string {
	return [
		'    mut vphp_scope := vphp.PhpScope.once()',
		'    defer { vphp_scope.close() }',
	]
}

fn (ctx ClassMethodGlueContext) render_static_sync_from_php_lines() []string {
	if ctx.shadow_static_name == '' {
		return []
	}
	return ['    ${ctx.class_name}.sync_statics_from_php(ctx)']
}

fn (ctx ClassMethodGlueContext) render_static_sync_to_php_lines() []string {
	if ctx.shadow_static_name == '' {
		return []
	}
	return ['    ${ctx.class_name}.sync_statics_to_php(ctx)']
}

fn (ctx ClassMethodGlueContext) render_inherited_sync_to_php_lines() []string {
	if !ctx.uses_inherited_receiver || ctx.is_static {
		return []
	}
	return ['    ${ctx.lower_name}_sync_to_php(this_obj, recv)']
}

fn (ctx ClassMethodGlueContext) render_result_sync_lines() []string {
	return ctx.render_static_sync_to_php_lines()
}

fn (ctx ClassMethodGlueContext) render_direct_call_sync_lines() []string {
	mut lines := []string{}
	lines << ctx.render_inherited_sync_to_php_lines()
	lines << ctx.render_static_sync_to_php_lines()
	return lines
}

fn (ctx ClassMethodGlueContext) render_object_return_lines() []string {
	if !ctx.returns_object {
		return []
	}
	if ctx.return_binding.kind != .void_ {
		return ['    return voidptr(res)']
	}
	if ctx.is_static {
		return ['    return voidptr(0)']
	}
	if ctx.uses_inherited_receiver {
		return ['    return voidptr(this_obj)']
	}
	return ['    return ptr']
}

fn (ctx ClassMethodGlueContext) render_return_lines() []string {
	match ctx.return_binding.kind {
		.result {
			mut lines := ctx.return_binding.render_result_call_lines(ctx.call_expr,
				ctx.capture_list())
			lines << ctx.render_result_sync_lines()
			return lines
		}
		.option {
			mut lines := ctx.return_binding.render_option_call_lines(ctx.call_expr,
				ctx.capture_list())
			lines << ctx.render_result_sync_lines()
			return lines
		}
		.void_ {
			mut lines := ['    ${ctx.call_expr}']
			lines << ctx.render_direct_call_sync_lines()
			lines << ctx.render_object_return_lines()
			return lines
		}
		.closure {
			mut lines := ['    res := ${ctx.call_expr}']
			lines << ctx.render_direct_call_sync_lines()
			lines << ctx.return_binding.render_closure_value_lines(true)
			lines << ctx.render_object_return_lines()
			return lines
		}
		.value {
			mut lines := ['    res := ${ctx.call_expr}']
			lines << ctx.render_direct_call_sync_lines()
			if !ctx.returns_object {
				lines << ctx.return_binding.render_value_result_line('res')
			}
			lines << ctx.render_object_return_lines()
			return lines
		}
	}
}
