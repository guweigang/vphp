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
				lines << '    ctx.return_val[${ctx.return_type}](res)'
			}
			lines << ctx.render_object_return_lines()
			return lines
		}
	}
}
