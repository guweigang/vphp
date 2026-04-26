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

	mut arg_names := []string{}
	for i, arg in f.args {
		var_name := 'arg_${i}'
		// 如果是 Context 类型，直接传递
		if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
			out << '    ${var_name} := ctx'
		} else if arg.v_type == 'vphp.ZVal' || arg.v_type == 'ZVal' {
			out << '    ${var_name} := ctx.arg_raw(${i})'
		} else if arg.v_type == 'Callable' || arg.v_type == 'vphp.Callable' {
			// Callable is a ZVal alias — read as raw ZVal
			out << '    ${var_name} := ctx.arg_raw(${i})'
		} else if arg.v_type == 'RequestBorrowedZBox' || arg.v_type == 'vphp.RequestBorrowedZBox' {
			out << '    ${var_name} := ctx.arg_borrowed_zbox(${i})'
		} else if arg.v_type == 'RequestOwnedZBox' || arg.v_type == 'vphp.RequestOwnedZBox' {
			out << '    ${var_name} := ctx.arg_owned_request_zbox(${i})'
		} else if arg.v_type == 'PersistentOwnedZBox' || arg.v_type == 'vphp.PersistentOwnedZBox' {
			out << '    ${var_name} := ctx.arg_owned_persistent_zbox(${i})'
		} else if semantic_arg_lines := gen_semantic_arg_lines(var_name, arg.v_type, i,
			false)
		{
			out << semantic_arg_lines
		} else if arg.v_type.starts_with('?') {
			out << '    ${var_name} := ctx.arg_opt[${arg.v_type[1..]}](${i})'
		} else if arg.v_type.starts_with('&') {
			out << '    ${var_name} := unsafe { ${arg.v_type}(ctx.arg_raw_obj(${i})) }'
		} else {
			out << '    ${var_name} := ctx.arg[${arg.v_type}](${i})'
		}
		arg_names << var_name
	}

	call_args := arg_names.join(', ')
	// 注意：如果是导出到 PHP 的函数，其原始名可能由 r.name (符号名) 或 r.original_name (V 名) 提供
	// 这里统一使用原始 V 名来调用
	v_func_name := if f.original_name != '' { f.original_name } else { f.name }
	v_call_name := if is_v_keyword(v_func_name) { '@' + v_func_name } else { v_func_name }
	return_type := f.return_spec.effective_v_type()

	is_result := return_type.starts_with('!')
	is_option := return_type.starts_with('?')
	effective_return := if is_result {
		return_type[1..]
	} else if is_option {
		return_type[1..]
	} else {
		return_type
	}

	if is_result {
		// Result 类型：通过运行时 helper 桥接 V error → PHP exception
		capture_list := if arg_names.len > 0 { arg_names.join(', ') } else { '' }

		if effective_return == '' || effective_return == 'void' {
			// !void
			out << '    vphp.call_or_throw(fn [${capture_list}] () ! {'
			out << '        ${v_call_name}(${call_args})!'
			out << '    })'
		} else {
			// !T
			out << '    vphp.call_or_throw_val[${effective_return}](fn [${capture_list}] () !${effective_return} {'
			out << '        return ${v_call_name}(${call_args})!'
			out << '    }, ctx)'
		}
	} else if is_option {
		// Option 类型：通过运行时 helper 桥接 V none → PHP null
		capture_list := if arg_names.len > 0 { arg_names.join(', ') } else { '' }

		if effective_return == '' || effective_return == 'void' {
			// ?void — V option 自动传播，无需 ? 后缀
			out << '    vphp.call_or_null(fn [${capture_list}] () ? {'
			out << '        ${v_call_name}(${call_args})'
			out << '    }, ctx)'
		} else {
			// ?T — V option 自动传播，无需 ? 后缀
			out << '    vphp.call_or_null_val[${effective_return}](fn [${capture_list}] () ?${effective_return} {'
			out << '        return ${v_call_name}(${call_args})'
			out << '    }, ctx)'
		}
	} else if return_type == 'void' {
		out << '    ${v_call_name}(${call_args})'
	} else {
		universal_helper := closure_universal_helper_for(effective_return)
		// Special-case: if the function returns a V closure type (fn ...),
		// wrap the returned V closure into a PHP closure before returning it.
		// We prefer ctx.wrap_closure[T] when the effective return type is a
		// concrete function type so the runtime can perform comptime arity
		// inspection. This avoids the emitter needing to generate many
		// monomorphized N-suffixed helpers.
		if effective_return.contains('fn') || universal_helper != '' {
			// Avoid generating complex generic function type parameters in the
			// emitted V glue (some V compiler versions have trouble with
			// post-processing generic function signatures). Instead, parse the
			// function type string to select the appropriate universal alias
			// (ClosureUniversal0..4 or the Void variants) and call the
			// stable ctx.wrap_closure_universal[...] helper. This keeps the
			// generated glue simple and avoids triggering compiler bugs.
			out << '    res := ${v_call_name}(${call_args})'
			mut helper := universal_helper
			if helper == '' {
				// parse arity from a shape like: fn (T1, T2) Ret
				// default to 0 if parsing fails
				// NOTE: emitted string uses literal ClosureUniversal aliases under vphp namespace
				// We generate code that selects the alias statically based on the
				// textual function signature discovered at emit time.
				// Extract the param list between the first 'fn (' and the following ')'
				// and count commas to determine arity.
				// Example: "fn (ZVal, ZVal) ZVal" -> params "ZVal, ZVal" -> arity 2
				// Example void return: "fn (ZVal) void" -> use ClosureUniversal1Void
				// Fallback: use ClosureUniversal0
				// We perform this parsing at emitter-time (string-level) to avoid
				// depending on V comptime reflection in generated code.
				em_params := if effective_return.contains('fn (') {
					effective_return.all_after('fn (').all_before(')')
				} else {
					''
				}
				em_ret := if effective_return.contains(') ') {
					effective_return.all_after(') ').trim_space()
				} else {
					''
				}
				mut em_arity := if em_params.trim_space() == '' {
					0
				} else {
					em_params.split(',').len
				}
				// Cap arity to 4 — runtime supports 0..4
				if em_arity > 4 {
					em_arity = 4
				}
				// Choose a concrete helper name (avoid emitting generic bracket form)
				helper = 'wrap_closure_universal_0'
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
			}
			out << '    // Wrap returned V closure using explicit helper: ${helper}'
			out << '    ctx.${helper}(res)'
		} else {
			out << '    res := ${v_call_name}(${call_args})'
			out << '    ctx.return_val[${return_type}](res)'
		}
	}
	out << '}'

	return out
}
