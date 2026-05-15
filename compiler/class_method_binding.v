module compiler

struct ClassMethodGlueContext {
	class_name              string
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
	return ['    mut recv := unsafe { &${ctx.class_name}(ptr) }']
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
			mut lines := ctx.return_binding.render_result_call_lines(ctx.call_expr, ctx.capture_list())
			lines << ctx.render_static_sync_to_php_lines()
			return lines
		}
		.option {
			mut lines := ctx.return_binding.render_option_call_lines(ctx.call_expr, ctx.capture_list())
			lines << ctx.render_static_sync_to_php_lines()
			return lines
		}
		.void_ {
			mut lines := ['    ${ctx.call_expr}']
			lines << ctx.render_inherited_sync_to_php_lines()
			lines << ctx.render_static_sync_to_php_lines()
			lines << ctx.render_object_return_lines()
			return lines
		}
		.closure {
			mut lines := ['    res := ${ctx.call_expr}']
			lines << ctx.render_inherited_sync_to_php_lines()
			lines << ctx.render_static_sync_to_php_lines()
			lines << ctx.return_binding.render_closure_value_lines(true)
			lines << ctx.render_object_return_lines()
			return lines
		}
		.value {
			mut lines := ['    res := ${ctx.call_expr}']
			lines << ctx.render_inherited_sync_to_php_lines()
			lines << ctx.render_static_sync_to_php_lines()
			if !ctx.returns_object {
				lines << ctx.return_binding.render_value_result_line('res')
			}
			lines << ctx.render_object_return_lines()
			return lines
		}
	}
}
