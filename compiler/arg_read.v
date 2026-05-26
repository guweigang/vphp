module compiler

import compiler.php_types
import compiler.repr

struct PhpArgRead {
	arg   repr.PhpArgRepr
	index int
}

fn PhpArgRead.new(arg repr.PhpArgRepr, index int) PhpArgRead {
	return PhpArgRead{
		arg:   arg
		index: index
	}
}

fn (read PhpArgRead) name_literal() string {
	return v_single_quote(read.arg.name)
}

fn (read PhpArgRead) arg_expr() string {
	return 'php_args.at_named_or_index(${read.index}, ${read.name_literal()})'
}

fn (read PhpArgRead) has_arg_expr() string {
	return 'php_args.has_named_or_index(${read.index}, ${read.name_literal()})'
}

fn (read PhpArgRead) direct_expr() ?string {
	if read.arg.is_variadic {
		return none
	}
	return php_arg_direct_read_expr(read.arg_expr(), read.arg.v_type)
}

fn (read PhpArgRead) v_expr() string {
	if read.arg.is_variadic {
		mut inner_type := read.arg.v_type
		if inner_type.starts_with('[]') {
			inner_type = inner_type[2..]
		}
		return 'php_args.as_variadic_v[${inner_type}](${read.index})'
	}
	return php_arg_v_read_expr(read.arg_expr(), read.arg.v_type)
}

fn (read PhpArgRead) with_default(expr string) string {
	if read.arg.is_variadic {
		return expr
	}
	default_value := PhpArgDefaultValue.from_arg(read.arg) or { return expr }
	default_expr := default_value.arg_expr() or { return expr }
	return 'if ${read.has_arg_expr()} { ${expr} } else { ${default_expr} }'
}

fn (read PhpArgRead) semantic_lines(var_name string, returns_voidptr bool) ?[]string {
	if read.arg.is_variadic {
		return none
	}
	v_type := read.arg.v_type
	if v_type.starts_with('?') {
		inner := v_type[1..]
		spec := php_types.PhpTypeSpec.semantic_wrapper_for(inner) or { return none }
		if spec.is_total_arg {
			return [
				'    ${var_name} := if ${read.has_arg_expr()} { ?${inner}(${read.arg_expr()}.value) } else { none }',
			]
		}
		return [
			'    ${var_name} := ${read.arg_expr()}.${spec.arg_method}()',
		]
	}
	spec := php_types.PhpTypeSpec.semantic_wrapper_for(v_type) or { return none }
	if spec.is_total_arg {
		return ['    ${var_name} := ${read.arg_expr()}.value']
	}
	return [
		'    ${var_name} := ${read.arg_expr()}.${spec.arg_method}() or {',
		"        vphp.throw_exception('argument ${read.index} must be ${spec.arg_label}', 0)",
		'        ${arg_return_stmt(returns_voidptr)}',
		'    }',
	]
}

fn (read PhpArgRead) semantic_or_default_lines(var_name string, default_expr string, returns_voidptr bool) ?[]string {
	if read.arg.is_variadic {
		return none
	}
	spec := php_types.PhpTypeSpec.semantic_wrapper_for(read.arg.v_type) or { return none }
	if spec.is_total_arg {
		return none
	}
	return [
		'    ${var_name} := if ${read.has_arg_expr()} {',
		'        ${read.arg_expr()}.${spec.arg_method}() or {',
		"            vphp.throw_exception('argument ${read.index} must be ${spec.arg_label}', 0)",
		'            ${arg_return_stmt(returns_voidptr)}',
		'        }',
		'    } else {',
		'        ${default_expr}',
		'    }',
	]
}

fn php_arg_direct_read_expr(arg_expr string, v_type string) ?string {
	return match v_type {
		'vphp.ZVal', 'ZVal', 'Callable', 'vphp.Callable' {
			'${arg_expr}.zval()'
		}
		'RequestBorrowedZBox', 'vphp.RequestBorrowedZBox' {
			'${arg_expr}.zbox()'
		}
		'RequestOwnedZBox', 'vphp.RequestOwnedZBox' {
			'${arg_expr}.request_owned_zbox()'
		}
		'PersistentOwnedZBox', 'vphp.PersistentOwnedZBox' {
			'${arg_expr}.persistent_owned_zbox()'
		}
		'?RequestBorrowedZBox', '?vphp.RequestBorrowedZBox' {
			'${arg_expr}.zbox_opt()'
		}
		else {
			none
		}
	}
}

fn php_arg_v_read_expr(arg_expr string, v_type string) string {
	if v_type.starts_with('?') {
		return '${arg_expr}.as_v_opt[${v_type[1..]}]()'
	}
	return '${arg_expr}.as_v[${v_type}]()'
}

fn php_context_arg_expr(v_type string, index int) string {
	return match v_type {
		'string' {
			'ctx.arg[string](${index})'
		}
		'int' {
			'ctx.arg[int](${index})'
		}
		'i64' {
			'ctx.arg[i64](${index})'
		}
		'bool' {
			'ctx.arg[bool](${index})'
		}
		'f64' {
			'ctx.arg[f64](${index})'
		}
		'ZVal', 'vphp.ZVal' {
			'ctx.arg_val(${index})'
		}
		'RequestBorrowedZBox', 'vphp.RequestBorrowedZBox' {
			'ctx.arg_borrowed_zbox(${index})'
		}
		'PhpValue', 'vphp.PhpValue' {
			'ctx.arg_value(${index})'
		}
		else {
			'ctx.arg[${v_type}](${index})'
		}
	}
}
