module compiler

import compiler.repr

// ---- Func V Glue ----
fn (g VGenerator) gen_func_glue(f &repr.PhpFuncRepr) []string {
	mut out := []string{}

	// 基础包装器
	out << "@[export: 'vphp_wrap_${f.name}']"
	out << 'fn vphp_wrap_${f.name}(ctx vphp.Context) {'
	out << '    vphp_ar_mark := vphp.autorelease_mark()'
	out << '    defer { vphp.autorelease_drain(vphp_ar_mark) }'

	arg_setup := build_php_arg_setup(f.args, false, false)
	out << arg_setup.lines
	arg_names := arg_setup.names

	call_args := arg_names.join(', ')
	// 注意：如果是导出到 PHP 的函数，其原始名可能由 r.name (符号名) 或 r.original_name (V 名) 提供
	// 这里统一使用原始 V 名来调用
	v_func_name := if f.original_name != '' { f.original_name } else { f.name }
	v_call_name := if is_v_keyword(v_func_name) { '@' + v_func_name } else { v_func_name }
	return_type := f.return_spec.effective_v_type()
	return_binding := ReturnBinding.new(return_type)
	out << return_binding.render_function_lines(v_call_name, call_args, arg_names)
	out << '}'

	return out
}
