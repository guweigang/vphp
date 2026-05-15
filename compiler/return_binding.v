module compiler

enum ReturnBindingKind {
	void_
	value
	result
	option
	closure
}

struct ReturnBinding {
	return_type      string
	effective_return string
	kind             ReturnBindingKind
	struct_closure   ?StructClosureBinding
}

fn ReturnBinding.new(return_type string) ReturnBinding {
	return ReturnBinding.new_with_struct_closure(return_type, none)
}

fn ReturnBinding.new_with_struct_closure(return_type string, struct_closure ?StructClosureBinding) ReturnBinding {
	is_result := return_type.starts_with('!')
	is_option := return_type.starts_with('?')
	effective_return := if is_result {
		return_type[1..]
	} else if is_option {
		return_type[1..]
	} else {
		return_type
	}
	kind := if is_result {
		ReturnBindingKind.result
	} else if is_option {
		ReturnBindingKind.option
	} else if return_type == 'void' {
		ReturnBindingKind.void_
	} else if ReturnBinding.is_closure_type(effective_return) {
		ReturnBindingKind.closure
	} else {
		ReturnBindingKind.value
	}
	return ReturnBinding{
		return_type:      return_type
		effective_return: effective_return
		kind:             kind
		struct_closure:   struct_closure
	}
}

fn ReturnBinding.is_closure_type(effective_return string) bool {
	return effective_return.contains('fn')
}

fn ReturnBinding.capture_list(names []string) string {
	return if names.len > 0 { names.join(', ') } else { '' }
}

fn (binding ReturnBinding) render_function_lines(v_call_name string, call_args string, arg_names []string) []string {
	match binding.kind {
		.result {
			return binding.render_result_lines(v_call_name, call_args, arg_names)
		}
		.option {
			return binding.render_option_lines(v_call_name, call_args, arg_names)
		}
		.void_ {
			return ['    ${v_call_name}(${call_args})']
		}
		.closure {
			return binding.render_closure_lines('${v_call_name}(${call_args})', false)
		}
		.value {
			return binding.render_value_call_lines('${v_call_name}(${call_args})')
		}
	}
}

fn (binding ReturnBinding) render_value_call_lines(call_expr string) []string {
	mut lines := []string{}
	lines << '    res := ${call_expr}'
	lines << binding.render_value_result_line('res')
	return lines
}

fn (binding ReturnBinding) render_value_result_line(result_name string) string {
	return '    ctx.return().v[${binding.effective_return}](${result_name})'
}

fn (binding ReturnBinding) render_result_lines(v_call_name string, call_args string, arg_names []string) []string {
	capture_list := ReturnBinding.capture_list(arg_names)
	return binding.render_result_call_lines('${v_call_name}(${call_args})', capture_list)
}

fn (binding ReturnBinding) render_result_call_lines(call_expr string, capture_list string) []string {
	if binding.effective_return == '' || binding.effective_return == 'void' {
		return [
			'    ctx.return().from_result_void(fn [${capture_list}] () ! {',
			'        ${call_expr}!',
			'    })',
		]
	}
	return [
		'    ctx.return().from_result[${binding.effective_return}](fn [${capture_list}] () !${binding.effective_return} {',
		'        return ${call_expr}!',
		'    })',
	]
}

fn (binding ReturnBinding) render_option_lines(v_call_name string, call_args string, arg_names []string) []string {
	capture_list := ReturnBinding.capture_list(arg_names)
	return binding.render_option_call_lines('${v_call_name}(${call_args})', capture_list)
}

fn (binding ReturnBinding) render_option_call_lines(call_expr string, capture_list string) []string {
	if binding.effective_return == '' || binding.effective_return == 'void' {
		return [
			'    ctx.return().from_option_void(fn [${capture_list}] () ? {',
			'        ${call_expr}',
			'    })',
		]
	}
	return [
		'    ctx.return().from_option[${binding.effective_return}](fn [${capture_list}] () ?${binding.effective_return} {',
		'        return ${call_expr}',
		'    })',
	]
}

fn (binding ReturnBinding) render_closure_lines(call_expr string, include_method_comment bool) []string {
	if struct_closure := binding.struct_closure {
		mut lines := []string{}
		lines << '    res := ${call_expr}'
		if include_method_comment {
			lines << '    // Returned value is a struct-param closure: wrap using generated bridge'
		}
		lines << '    ${struct_closure.wrap}(ctx, res)'
		return lines
	}
	mut lines := []string{}
	lines << '    _ := ${call_expr}'
	lines << "    vphp.throw_exception('unsupported closure return type: ${binding.effective_return}', 0)"
	return lines
}

fn (binding ReturnBinding) render_closure_value_lines(include_method_comment bool) []string {
	if struct_closure := binding.struct_closure {
		mut lines := []string{}
		if include_method_comment {
			lines << '    // Returned value is a struct-param closure: wrap using generated bridge'
		}
		lines << '    ${struct_closure.wrap}(ctx, res)'
		return lines
	}
	mut lines := []string{}
	lines << "    vphp.throw_exception('unsupported closure return type: ${binding.effective_return}', 0)"
	return lines
}
