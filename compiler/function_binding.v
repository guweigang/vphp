module compiler

import compiler.repr

struct FunctionGlue {
	name           string
	v_call_name    string
	helper_lines   []string
	arg_setup      PhpArgSetup
	return_binding ReturnBinding
}

fn FunctionGlue.new(f &repr.PhpFuncRepr, params_structs map[string]repr.PhpParamsStruct) FunctionGlue {
	return_type := f.return_spec.effective_v_type()
	struct_closure := StructClosureBinding.new(f.name, return_type, params_structs)
	mut helper_lines := []string{}
	if closure_binding := struct_closure {
		helper_lines << closure_binding.render_helper_lines()
	}
	v_func_name := f.qualified_original_name()
	v_call_name := if is_v_keyword(v_func_name) { '@' + v_func_name } else { v_func_name }
	return FunctionGlue{
		name:           f.name
		v_call_name:    v_call_name
		helper_lines:   helper_lines
		arg_setup:      build_php_arg_setup(f.args, false, false)
		return_binding: ReturnBinding.new_with_struct_closure(return_type, struct_closure)
	}
}

fn (glue FunctionGlue) render_lines() []string {
	mut lines := []string{}
	lines << glue.helper_lines
	lines << "@[export: 'vphp_wrap_${glue.name}']"
	lines << 'fn vphp_wrap_${glue.name}(ctx vphp.Context) {'
	lines << '    mut vphp_scope := vphp.PhpScope.once()'
	lines << '    defer { vphp_scope.close() }'
	lines << glue.arg_setup.lines
	call_args := glue.arg_setup.names.join(', ')
	lines << glue.return_binding.render_function_lines(glue.v_call_name, call_args,
		glue.arg_setup.names)
	lines << '}'
	return lines
}
