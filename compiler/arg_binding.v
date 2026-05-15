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

fn v_single_quote(s string) string {
	return "'" + s.replace('\\', '\\\\').replace("'", "\\'") + "'"
}

fn php_attribute_arg_literal(arg repr.PhpAttributeArg) string {
	mut call := match arg.kind {
		'string' { 'string(${v_single_quote(arg.value)})' }
		'bool' { 'bool_value(${arg.value})' }
		'null' { 'null_value()' }
		'float' { 'f64(${arg.value})' }
		'int' { 'i64(${arg.value})' }
		else { 'string(${v_single_quote(arg.value)})' }
	}
	if arg.name != '' {
		call = match arg.kind {
			'string' { 'named_string(${v_single_quote(arg.name)}, ${v_single_quote(arg.value)})' }
			'bool' { 'named_bool(${v_single_quote(arg.name)}, ${arg.value})' }
			'null' { 'named_null(${v_single_quote(arg.name)})' }
			'float' { 'named_f64(${v_single_quote(arg.name)}, ${arg.value})' }
			'int' { 'named_i64(${v_single_quote(arg.name)}, ${arg.value})' }
			else { 'named_string(${v_single_quote(arg.name)}, ${v_single_quote(arg.value)})' }
		}
	}
	return call
}

fn php_attribute_literal(attr repr.PhpAttributeRepr) string {
	mut out := 'vphp.PhpAttribute.named(${v_single_quote(attr.name)}).for_parameter()'
	for arg in attr.args {
		out += '.${php_attribute_arg_literal(arg)}'
	}
	return out
}

fn php_attributes_literal(attrs []repr.PhpAttributeRepr) string {
	if attrs.len == 0 {
		return '[]vphp.PhpAttribute{}'
	}
	return '[' + attrs.map(php_attribute_literal(it)).join(', ') + ']'
}

fn is_context_arg_type(v_type string) bool {
	return v_type == 'Context' || v_type == 'vphp.Context'
}

fn needs_php_args(args []repr.PhpArgRepr) bool {
	for arg in args {
		if !is_context_arg_type(arg.v_type) {
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
	lines << '    php_args := ctx.args_with_meta(['
	mut php_index := 0
	for arg in args {
		if is_context_arg_type(arg.v_type) {
			continue
		}
		lines << '        vphp.PhpArgMeta{ index: ${php_index}, name: ${v_single_quote(arg.name)}, attributes: ${php_attributes_literal(arg.attributes)} },'
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

fn (binding PhpSingleArgBinding) read() PhpArgRead {
	return PhpArgRead.new(binding.arg, binding.index)
}

fn (binding PhpSingleArgBinding) render_semantic_lines(returns_voidptr bool) ?[]string {
	return binding.read().semantic_lines(binding.var_name, returns_voidptr)
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
				params_struct: ParamsStructBinding.new(params_var, arg.source.params_type, fields,
					php_index - fields.len)
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
		if !is_context_arg_type(arg.v_type) {
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
	if is_context_arg_type(arg.v_type) {
		return ['    ${binding.var_name} := ctx']
	}
	read := binding.read()
	if direct_read_expr := read.direct_expr() {
		if !arg.v_type.starts_with('?') {
			return [
				'    ${binding.var_name} := ${read.with_default(direct_read_expr)}',
			]
		}
	}
	if semantic_arg_lines := binding.render_semantic_lines(returns_voidptr) {
		return semantic_arg_lines
	}
	if direct_read_expr := read.direct_expr() {
		return [
			'    ${binding.var_name} := ${read.with_default(direct_read_expr)}',
		]
	}
	if arg.v_type.starts_with('?') {
		return [
			'    ${binding.var_name} := ${read.with_default(read.v_expr())}',
		]
	}
	if binding.allow_raw_object {
		tm := php_types.TypeMap.get_type(arg.v_type)
		if tm.c_type == 'void*' {
			v_type := if arg.v_type.starts_with('&') { arg.v_type } else { '&' + arg.v_type }
			return [
				'    ${binding.var_name} := ${read.with_default('unsafe { ${v_type}(${read.arg_expr()}.raw_obj()) }')}',
			]
		}
	}
	if arg.v_type.starts_with('&') {
		return [
			'    ${binding.var_name} := ${read.with_default('unsafe { ${arg.v_type}(${read.arg_expr()}.raw_obj()) }')}',
		]
	}
	return [
		'    ${binding.var_name} := ${read.with_default(read.v_expr())}',
	]
}
