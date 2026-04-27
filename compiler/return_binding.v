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
}

fn ReturnBinding.new(return_type string) ReturnBinding {
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
	}
}

fn ReturnBinding.is_closure_type(effective_return string) bool {
	return effective_return.contains('fn') || closure_universal_helper_for(effective_return) != ''
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
			return [
				'    res := ${v_call_name}(${call_args})',
				'    ctx.return_val[${binding.return_type}](res)',
			]
		}
	}
}

fn (binding ReturnBinding) render_result_lines(v_call_name string, call_args string, arg_names []string) []string {
	capture_list := ReturnBinding.capture_list(arg_names)
	return binding.render_result_call_lines('${v_call_name}(${call_args})', capture_list)
}

fn (binding ReturnBinding) render_result_call_lines(call_expr string, capture_list string) []string {
	if binding.effective_return == '' || binding.effective_return == 'void' {
		return [
			'    vphp.call_or_throw(fn [${capture_list}] () ! {',
			'        ${call_expr}!',
			'    })',
		]
	}
	return [
		'    vphp.call_or_throw_val[${binding.effective_return}](fn [${capture_list}] () !${binding.effective_return} {',
		'        return ${call_expr}!',
		'    }, ctx)',
	]
}

fn (binding ReturnBinding) render_option_lines(v_call_name string, call_args string, arg_names []string) []string {
	capture_list := ReturnBinding.capture_list(arg_names)
	return binding.render_option_call_lines('${v_call_name}(${call_args})', capture_list)
}

fn (binding ReturnBinding) render_option_call_lines(call_expr string, capture_list string) []string {
	if binding.effective_return == '' || binding.effective_return == 'void' {
		return [
			'    vphp.call_or_null(fn [${capture_list}] () ? {',
			'        ${call_expr}',
			'    }, ctx)',
		]
	}
	return [
		'    vphp.call_or_null_val[${binding.effective_return}](fn [${capture_list}] () ?${binding.effective_return} {',
		'        return ${call_expr}',
		'    }, ctx)',
	]
}

fn (binding ReturnBinding) render_closure_lines(call_expr string, include_method_comment bool) []string {
	helper := binding.closure_helper()
	mut lines := []string{}
	lines << '    res := ${call_expr}'
	if include_method_comment {
		lines << '    // Returned value is a closure type: wrap using concrete helper'
	}
	lines << '    // Wrap returned V closure using explicit helper: ${helper}'
	lines << '    ctx.${helper}(res)'
	return lines
}

fn (binding ReturnBinding) render_closure_value_lines(include_method_comment bool) []string {
	helper := binding.closure_helper()
	mut lines := []string{}
	if include_method_comment {
		lines << '    // Returned value is a closure type: wrap using concrete helper'
	}
	lines << '    // Wrap returned V closure using explicit helper: ${helper}'
	lines << '    ctx.${helper}(res)'
	return lines
}

fn (binding ReturnBinding) closure_helper() string {
	universal_helper := closure_universal_helper_for(binding.effective_return)
	if universal_helper != '' {
		return universal_helper
	}
	em_params := if binding.effective_return.contains('fn (') {
		binding.effective_return.all_after('fn (').all_before(')')
	} else {
		''
	}
	em_ret := if binding.effective_return.contains(') ') {
		binding.effective_return.all_after(') ').trim_space()
	} else {
		''
	}
	mut em_arity := if em_params.trim_space() == '' {
		0
	} else {
		em_params.split(',').len
	}
	if em_arity > 4 {
		em_arity = 4
	}
	mut helper := 'wrap_closure_universal_0'
	if em_ret == 'void' {
		helper = 'wrap_closure_universal_0_void'
	}
	if em_arity == 1 {
		helper = if em_ret == 'void' {
			'wrap_closure_universal_1_void'
		} else {
			'wrap_closure_universal_1'
		}
	} else if em_arity == 2 {
		helper = if em_ret == 'void' {
			'wrap_closure_universal_2_void'
		} else {
			'wrap_closure_universal_2'
		}
	} else if em_arity == 3 {
		helper = if em_ret == 'void' {
			'wrap_closure_universal_3_void'
		} else {
			'wrap_closure_universal_3'
		}
	} else if em_arity == 4 {
		helper = if em_ret == 'void' {
			'wrap_closure_universal_4_void'
		} else {
			'wrap_closure_universal_4'
		}
	}
	return helper
}
