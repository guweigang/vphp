module compiler

import compiler.php_types
import compiler.repr

struct PhpArgSetup {
	lines []string
	names []string
}

enum PhpArgBindingKind {
	single
	params_struct
}

struct PhpArgBinding {
	kind          PhpArgBindingKind
	var_name      string
	arg           repr.PhpArgRepr
	params_struct ParamsStructBinding
	php_index     int
}

struct PhpSingleArgBinding {
	arg              repr.PhpArgRepr
	var_name         string
	index            int
	allow_raw_object bool
}

struct PhpArgDefaultValue {
	raw    string
	v_type string
}

fn v_single_quote(s string) string {
	return "'" + s.replace('\\', '\\\\').replace("'", "\\'") + "'"
}

fn needs_php_args(args []repr.PhpArgRepr) bool {
	for arg in args {
		if arg.v_type != 'Context' && arg.v_type != 'vphp.Context' {
			return true
		}
	}
	return false
}

fn gen_php_args_lines(args []repr.PhpArgRepr) []string {
	if !needs_php_args(args) {
		return []
	}
	mut lines := []string{}
	lines << '    php_args := ctx.args(['
	mut php_index := 0
	for arg in args {
		if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
			continue
		}
		lines << '        vphp.PhpInArgMeta{ index: ${php_index}, name: ${v_single_quote(arg.name)} },'
		php_index++
	}
	lines << '    ])'
	return lines
}

fn arg_return_stmt(returns_voidptr bool) string {
	return if returns_voidptr { 'return unsafe { nil }' } else { 'return' }
}

fn PhpSingleArgBinding.new(arg repr.PhpArgRepr, var_name string, index int, allow_raw_object bool) PhpSingleArgBinding {
	return PhpSingleArgBinding{
		arg:              arg
		var_name:         var_name
		index:            index
		allow_raw_object: allow_raw_object
	}
}

fn (binding PhpSingleArgBinding) arg_expr() string {
	return 'php_args.at_named_or_index(${binding.index}, ${v_single_quote(binding.arg.name)})'
}

fn (binding PhpSingleArgBinding) with_default(expr string) string {
	default_value := PhpArgDefaultValue.from_arg(binding.arg) or { return expr }
	default_expr := default_value.arg_expr() or { return expr }
	return 'if php_args.has_named_or_index(${binding.index}, ${v_single_quote(binding.arg.name)}) { ${expr} } else { ${default_expr} }'
}

fn (binding PhpSingleArgBinding) render_semantic_lines(returns_voidptr bool) ?[]string {
	v_type := binding.arg.v_type
	if v_type.starts_with('?') {
		inner := v_type[1..]
		spec := php_types.PhpTypeSpec.semantic_wrapper_for(inner) or { return none }
		if spec.is_total_arg {
			return [
				'    ${binding.var_name} := if php_args.has_named_or_index(${binding.index}, ${v_single_quote(binding.arg.name)}) { ?${inner}(${binding.arg_expr()}.value) } else { none }',
			]
		}
		return [
			'    ${binding.var_name} := ${binding.arg_expr()}.${spec.arg_method}()',
		]
	}
	spec := php_types.PhpTypeSpec.semantic_wrapper_for(v_type) or { return none }
	if spec.is_total_arg {
		return ['    ${binding.var_name} := ${binding.arg_expr()}.value']
	}
	return [
		'    ${binding.var_name} := ${binding.arg_expr()}.${spec.arg_method}() or {',
		"        vphp.throw_exception('argument ${binding.index} must be ${spec.arg_label}', 0)",
		'        ${arg_return_stmt(returns_voidptr)}',
		'    }',
	]
}

fn PhpArgDefaultValue.from_arg(arg repr.PhpArgRepr) ?PhpArgDefaultValue {
	if !arg.is_optional || arg.php_default == '' {
		return none
	}
	return PhpArgDefaultValue{
		raw:    arg.php_default.trim_space()
		v_type: arg.v_type
	}
}

fn (default_value PhpArgDefaultValue) string_value() string {
	trimmed := default_value.raw
	if trimmed.len >= 2 {
		if trimmed[0] == `"` && trimmed[trimmed.len - 1] == `"` {
			return trimmed[1..trimmed.len - 1]
		}
		if trimmed[0] == `'` && trimmed[trimmed.len - 1] == `'` {
			return trimmed[1..trimmed.len - 1]
		}
	}
	return trimmed
}

fn (default_value PhpArgDefaultValue) is_numeric_literal() bool {
	if default_value.raw == '' {
		return false
	}
	first := default_value.raw[0]
	return (first >= `0` && first <= `9`) || first == `-`
}

fn (default_value PhpArgDefaultValue) zval_expr() ?string {
	if default_value.raw == '' {
		return none
	}
	return match default_value.raw {
		'null' {
			'vphp.ZVal.new_null()'
		}
		'true' {
			'vphp.ZVal.new_bool(true)'
		}
		'false' {
			'vphp.ZVal.new_bool(false)'
		}
		'[]' {
			'vphp.PhpArray.empty().to_zval()'
		}
		else {
			if (default_value.raw.starts_with('"') && default_value.raw.ends_with('"'))
				|| (default_value.raw.starts_with("'") && default_value.raw.ends_with("'")) {
				return 'vphp.ZVal.new_string(${v_single_quote(default_value.string_value())})'
			}
			if default_value.raw.contains('.') {
				return 'vphp.ZVal.new_float(${default_value.raw})'
			}
			if default_value.is_numeric_literal() {
				return 'vphp.ZVal.new_int(i64(${default_value.raw}))'
			}
			return 'vphp.php_const(${v_single_quote(default_value.raw)})'
		}
	}
}

fn (default_value PhpArgDefaultValue) arg_expr() ?string {
	clean := php_types.normalize_export_type_key(default_value.v_type)
	if default_value.v_type.starts_with('?') {
		if default_value.raw == 'null' {
			return 'none'
		}
	}
	return match clean {
		'RequestBorrowedZBox' {
			zexpr := default_value.zval_expr() or { return none }
			'vphp.RequestBorrowedZBox.from_zval(${zexpr})'
		}
		'RequestOwnedZBox' {
			zexpr := default_value.zval_expr() or { return none }
			'vphp.RequestOwnedZBox.from_zval(${zexpr})'
		}
		'PersistentOwnedZBox' {
			zexpr := default_value.zval_expr() or { return none }
			'vphp.PersistentOwnedZBox.from_zval(${zexpr})'
		}
		'ZVal' {
			default_value.zval_expr() or { return none }
		}
		'string' {
			v_single_quote(default_value.string_value())
		}
		'int', 'i64', 'f64', 'bool' {
			default_value.raw
		}
		else {
			none
		}
	}
}

fn build_php_arg_bindings(args []repr.PhpArgRepr) []PhpArgBinding {
	mut bindings := []PhpArgBinding{}
	mut i := 0
	mut php_index := 0
	for i < args.len {
		arg := args[i]
		if arg.source.kind == .params_field {
			params_var := 'arg_${i}_params'
			params_arg_name := arg.source.params_arg_name
			mut fields := []repr.PhpArgRepr{}
			for i < args.len && args[i].source.kind == .params_field
				&& args[i].source.params_arg_name == params_arg_name {
				fields << args[i]
				i++
				php_index++
			}
			bindings << PhpArgBinding{
				kind:          .params_struct
				var_name:      params_var
				arg:           arg
				params_struct: ParamsStructBinding.new(params_var, arg.source.params_type,
					fields, php_index - fields.len)
				php_index:     php_index - fields.len
			}
			continue
		}
		var_name := 'arg_${i}'
		bindings << PhpArgBinding{
			kind:      .single
			var_name:  var_name
			arg:       arg
			php_index: php_index
		}
		if arg.v_type != 'Context' && arg.v_type != 'vphp.Context' {
			php_index++
		}
		i++
	}
	return bindings
}

fn build_php_arg_setup(args []repr.PhpArgRepr, returns_voidptr bool, allow_raw_object bool) PhpArgSetup {
	mut lines := gen_php_args_lines(args)
	mut names := []string{}
	for binding in build_php_arg_bindings(args) {
		lines << binding.render_lines(returns_voidptr, allow_raw_object)
		names << binding.call_name()
	}
	return PhpArgSetup{
		lines: lines
		names: names
	}
}

fn (binding PhpArgBinding) call_name() string {
	return match binding.kind {
		.single { binding.var_name }
		.params_struct { binding.params_struct.call_name() }
	}
}

fn (binding PhpArgBinding) render_lines(returns_voidptr bool, allow_raw_object bool) []string {
	return match binding.kind {
		.single {
			PhpSingleArgBinding.new(binding.arg, binding.var_name, binding.php_index,
				allow_raw_object).render_lines(returns_voidptr)
		}
		.params_struct {
			binding.params_struct.render_lines(returns_voidptr)
		}
	}
}

fn (binding PhpSingleArgBinding) render_lines(returns_voidptr bool) []string {
	arg := binding.arg
	if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
		return ['    ${binding.var_name} := ctx']
	}
	if arg.v_type == 'vphp.ZVal' || arg.v_type == 'ZVal' {
		return [
			'    ${binding.var_name} := ${binding.with_default('${binding.arg_expr()}.zval()')}',
		]
	}
	if arg.v_type == 'Callable' || arg.v_type == 'vphp.Callable' {
		return [
			'    ${binding.var_name} := ${binding.with_default('${binding.arg_expr()}.zval()')}',
		]
	}
	if arg.v_type == 'RequestBorrowedZBox' || arg.v_type == 'vphp.RequestBorrowedZBox' {
		return [
			'    ${binding.var_name} := ${binding.with_default('${binding.arg_expr()}.zbox()')}',
		]
	}
	if arg.v_type == 'RequestOwnedZBox' || arg.v_type == 'vphp.RequestOwnedZBox' {
		return [
			'    ${binding.var_name} := ${binding.with_default('${binding.arg_expr()}.request_owned_zbox()')}',
		]
	}
	if arg.v_type == 'PersistentOwnedZBox' || arg.v_type == 'vphp.PersistentOwnedZBox' {
		return [
			'    ${binding.var_name} := ${binding.with_default('${binding.arg_expr()}.persistent_owned_zbox()')}',
		]
	}
	if semantic_arg_lines := binding.render_semantic_lines(returns_voidptr) {
		return semantic_arg_lines
	}
	if arg.v_type == '?RequestBorrowedZBox' || arg.v_type == '?vphp.RequestBorrowedZBox' {
		return [
			'    ${binding.var_name} := ${binding.with_default('${binding.arg_expr()}.zbox_opt()')}',
		]
	}
	if arg.v_type.starts_with('?') {
		return [
			'    ${binding.var_name} := ${binding.with_default('${binding.arg_expr()}.as_v_opt[${arg.v_type[1..]}]()')}',
		]
	}
	if binding.allow_raw_object {
		tm := php_types.TypeMap.get_type(arg.v_type)
		if tm.c_type == 'void*' {
			v_type := if arg.v_type.starts_with('&') { arg.v_type } else { '&' + arg.v_type }
			return [
				'    ${binding.var_name} := ${binding.with_default('unsafe { ${v_type}(${binding.arg_expr()}.raw_obj()) }')}',
			]
		}
	}
	if arg.v_type.starts_with('&') {
		return [
			'    ${binding.var_name} := ${binding.with_default('unsafe { ${arg.v_type}(${binding.arg_expr()}.raw_obj()) }')}',
		]
	}
	return [
		'    ${binding.var_name} := ${binding.with_default('${binding.arg_expr()}.as_v[${arg.v_type}]()')}',
	]
}
