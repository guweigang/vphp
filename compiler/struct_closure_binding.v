module compiler

import compiler.repr

enum StructClosureBindingKind {
	params_struct
	variadic
}

struct StructClosureBinding {
	unique            string
	alias             string
	bridge            string
	wrap              string
	arg_type          string
	ret_type          string
	fields            []repr.PhpParamsField
	kind              StructClosureBindingKind
	variadic_arg_type string
}

fn StructClosureBinding.new(unique string, return_type string, params_structs map[string]repr.PhpParamsStruct) ?StructClosureBinding {
	if !return_type.starts_with('fn (') || !return_type.contains(')') {
		return none
	}
	param_text := return_type.all_after('fn (').all_before(')').trim_space()
	ret_type := if return_type.contains(') ') {
		return_type.all_after(') ').trim_space()
	} else {
		'void'
	}
	if param_text == '' || param_text.contains(',') || ret_type == '' {
		return none
	}
	alias_name := pascal_struct_closure_name(sanitize_struct_closure_token(unique))
	safe := sanitize_struct_closure_token(unique).to_lower()
	if param_text.starts_with('...') {
		variadic_arg_type := normalize_struct_closure_type(param_text[3..])
		if is_supported_variadic_closure_arg(variadic_arg_type) {
			return StructClosureBinding{
				unique:            safe
				alias:             'VPhpVariadicClosure${alias_name}'
				bridge:            'vphp_variadic_closure_bridge_${safe}'
				wrap:              'vphp_wrap_variadic_closure_${safe}'
				arg_type:          variadic_arg_type
				ret_type:          ret_type
				kind:              .variadic
				variadic_arg_type: variadic_arg_type
			}
		}
		return none
	}
	arg_type := normalize_struct_closure_type(param_text)
	if params_struct := params_structs[arg_type] {
		return StructClosureBinding{
			unique:   safe
			alias:    'VPhpStructClosure${alias_name}'
			bridge:   'vphp_struct_closure_bridge_${safe}'
			wrap:     'vphp_wrap_struct_closure_${safe}'
			arg_type: arg_type
			ret_type: ret_type
			fields:   params_struct.fields
			kind:     .params_struct
		}
	}
	return none
}

fn normalize_struct_closure_type(type_name string) string {
	return type_name.trim_space().replace('main.', '')
}

fn sanitize_struct_closure_token(name string) string {
	mut out := []u8{cap: name.len}
	for ch in name {
		if (ch >= `a` && ch <= `z`) || (ch >= `A` && ch <= `Z`) || (ch >= `0` && ch <= `9`) {
			out << u8(ch)
		} else {
			out << `_`
		}
	}
	safe := out.bytestr().trim('_')
	if safe == '' {
		return 'closure'
	}
	return safe
}

fn pascal_struct_closure_name(name string) string {
	mut parts := []string{}
	for part in name.split('_') {
		if part == '' {
			continue
		}
		parts << part[0].ascii_str().to_upper() + part[1..]
	}
	return parts.join('')
}

fn is_supported_variadic_closure_arg(type_name string) bool {
	return type_name in ['PhpValue', 'vphp.PhpValue', 'ZVal', 'vphp.ZVal', 'RequestBorrowedZBox',
		'vphp.RequestBorrowedZBox', 'VScalarValue', 'vphp.VScalarValue']
}

fn (binding StructClosureBinding) render_helper_lines() []string {
	if binding.kind == .variadic {
		return binding.render_variadic_helper_lines()
	}
	mut lines := []string{}
	struct_signature := if binding.ret_type == 'void' {
		'fn (${binding.arg_type})'
	} else {
		'fn (${binding.arg_type}) ${binding.ret_type}'
	}
	lines << 'pub type ${binding.alias} = ${struct_signature}'
	lines << ''
	lines << 'fn ${binding.bridge}(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {'
	lines << '    unsafe {'
	lines << '        ctx := vphp.Context{'
	lines << '            ex:  vphp.ZExData.new(ex)'
	lines << '            ret: vphp.PhpReturn.new(ret)'
	lines << '        }'
	lines << '        cb := *(&${binding.alias}(v_ptr))'
	lines << '        args := ${binding.arg_type}{'
	for i, field in binding.fields {
		lines << '            ${field.name}: ${binding.field_arg_expr(field, i)}'
	}
	lines << '        }'
	if binding.ret_type == 'void' {
		lines << '        cb(args)'
		lines << '        ctx.return_null()'
	} else {
		lines << '        res := cb(args)'
		lines << '        ctx.return_val[${binding.ret_type}](res)'
	}
	lines << '    }'
	lines << '}'
	lines << ''
	lines << 'fn ${binding.wrap}(ctx vphp.Context, cb ${binding.alias}) {'
	lines << '    ctx.create_saved_closure[${binding.alias}](cb, voidptr(${binding.bridge}), ${binding.fields.len})'
	lines << '}'
	lines << ''
	return lines
}

fn (binding StructClosureBinding) render_variadic_helper_lines() []string {
	mut lines := []string{}
	variadic_signature := if binding.ret_type == 'void' {
		'fn (...${binding.variadic_arg_type})'
	} else {
		'fn (...${binding.variadic_arg_type}) ${binding.ret_type}'
	}
	lines << 'pub type ${binding.alias} = ${variadic_signature}'
	lines << ''
	lines << 'fn ${binding.bridge}(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {'
	lines << '    unsafe {'
	lines << '        ctx := vphp.Context{'
	lines << '            ex:  vphp.ZExData.new(ex)'
	lines << '            ret: vphp.PhpReturn.new(ret)'
	lines << '        }'
	lines << '        cb := *(&${binding.alias}(v_ptr))'
	lines << '        mut args := []${binding.variadic_arg_type}{cap: ctx.num_args()}'
	lines << '        for i in 0 .. ctx.num_args() {'
	lines << '            args << ${binding.variadic_arg_expr('i')}'
	lines << '        }'
	if binding.ret_type == 'void' {
		lines << '        cb(...args)'
		lines << '        ctx.return_null()'
	} else {
		lines << '        res := cb(...args)'
		lines << '        ctx.return_val[${binding.ret_type}](res)'
	}
	lines << '    }'
	lines << '}'
	lines << ''
	lines << 'fn ${binding.wrap}(ctx vphp.Context, cb ${binding.alias}) {'
	lines << '    ctx.create_saved_variadic_closure[${binding.alias}](cb, voidptr(${binding.bridge}))'
	lines << '}'
	lines << ''
	return lines
}

fn (binding StructClosureBinding) variadic_arg_expr(index string) string {
	match binding.variadic_arg_type {
		'PhpValue', 'vphp.PhpValue' {
			return 'ctx.arg_value(${index})'
		}
		'ZVal', 'vphp.ZVal' {
			return 'ctx.arg_val(${index})'
		}
		'RequestBorrowedZBox', 'vphp.RequestBorrowedZBox' {
			return 'ctx.arg_borrowed_zbox(${index})'
		}
		'VScalarValue', 'vphp.VScalarValue' {
			return 'ctx.arg_v_scalar(${index}) or { vphp.throw_exception(err.msg(), 0); return }'
		}
		else {
			return 'ctx.arg_value(${index})'
		}
	}
}

fn (binding StructClosureBinding) field_arg_expr(field repr.PhpParamsField, index int) string {
	match field.v_type {
		'string' {
			return 'ctx.arg[string](${index})'
		}
		'int' {
			return 'ctx.arg[int](${index})'
		}
		'i64' {
			return 'ctx.arg[i64](${index})'
		}
		'bool' {
			return 'ctx.arg[bool](${index})'
		}
		'f64' {
			return 'ctx.arg[f64](${index})'
		}
		'ZVal', 'vphp.ZVal' {
			return 'ctx.arg_val(${index})'
		}
		'RequestBorrowedZBox', 'vphp.RequestBorrowedZBox' {
			return 'ctx.arg_borrowed_zbox(${index})'
		}
		'PhpValue', 'vphp.PhpValue' {
			return 'ctx.arg_value(${index})'
		}
		else {
			return 'ctx.arg[${field.v_type}](${index})'
		}
	}
}
