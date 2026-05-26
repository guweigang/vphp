module compiler

import v.ast
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

fn build_php_arg_setup(args []repr.PhpArgRepr, returns_voidptr bool, allow_raw_object bool, table &ast.Table) PhpArgSetup {
	mut lines := gen_php_args_lines(args)
	mut names := []string{}
	for binding in build_php_arg_bindings(args) {
		lines << binding.render_lines(returns_voidptr, allow_raw_object, table)
		names << binding.call_name()
	}
	return PhpArgSetup{
		lines: lines
		names: names
	}
}

fn (binding PhpArgBinding) call_name() string {
	return match binding.kind {
		.single {
			if binding.arg.is_variadic {
				'...${binding.var_name}'
			} else {
				binding.var_name
			}
		}
		.params_struct { binding.params_struct.call_name() }
	}
}

fn (binding PhpArgBinding) render_lines(returns_voidptr bool, allow_raw_object bool, table &ast.Table) []string {
	return match binding.kind {
		.single {
			PhpSingleArgBinding.new(binding.arg, binding.var_name, binding.php_index,
				allow_raw_object).render_lines(returns_voidptr, table)
		}
		.params_struct {
			binding.params_struct.render_lines(returns_voidptr)
		}
	}
}

fn (binding PhpSingleArgBinding) render_lines(returns_voidptr bool, table &ast.Table) []string {
	arg := binding.arg
	if arg.is_variadic {
		return binding.render_v_value_lines()
	}
	if is_context_arg_type(arg.v_type) {
		return ['    ${binding.var_name} := ctx']
	}
	if lines := binding.render_direct_non_optional_lines() {
		return lines
	}
	if semantic_arg_lines := binding.render_semantic_lines(returns_voidptr) {
		return semantic_arg_lines
	}
	if lines := binding.render_direct_lines() {
		return lines
	}
	if lines := binding.render_optional_lines() {
		return lines
	}

	clean_type := arg.v_type.trim_left('?&')
	is_sumtype_or_enum := if table != unsafe { nil } {
		if sym := table.find_sym(clean_type) {
			sym.kind == .sum_type || sym.kind == .enum
		} else {
			false
		}
	} else {
		false
	}

	if !is_sumtype_or_enum {
		if lines := binding.render_raw_object_lines() {
			return lines
		}
		if lines := binding.render_ref_object_lines() {
			return lines
		}
	}
	return binding.render_v_value_lines()
}

fn (binding PhpSingleArgBinding) render_direct_non_optional_lines() ?[]string {
	arg := binding.arg
	if arg.v_type.starts_with('?') {
		return none
	}
	read := binding.read()
	direct_read_expr := read.direct_expr() or { return none }
	return ['    ${binding.var_name} := ${read.with_default(direct_read_expr)}']
}

fn (binding PhpSingleArgBinding) render_direct_lines() ?[]string {
	read := binding.read()
	direct_read_expr := read.direct_expr() or { return none }
	return ['    ${binding.var_name} := ${read.with_default(direct_read_expr)}']
}

fn (binding PhpSingleArgBinding) render_optional_lines() ?[]string {
	arg := binding.arg
	if !arg.v_type.starts_with('?') {
		return none
	}
	read := binding.read()
	return ['    ${binding.var_name} := ${read.with_default(read.v_expr())}']
}

fn (binding PhpSingleArgBinding) render_raw_object_lines() ?[]string {
	arg := binding.arg
	if binding.allow_raw_object {
		tm := php_types.TypeMap.get_type(arg.v_type)
		if tm.c_type == 'void*' {
			v_type := if arg.v_type.starts_with('&') { arg.v_type } else { '&' + arg.v_type }
			read := binding.read()
			return [
				'    ${binding.var_name} := ${read.with_default('unsafe { ${v_type}(${read.arg_expr()}.raw_obj()) }')}',
			]
		}
	}
	return none
}

fn (binding PhpSingleArgBinding) render_ref_object_lines() ?[]string {
	arg := binding.arg
	if arg.v_type.starts_with('&') {
		read := binding.read()
		return [
			'    ${binding.var_name} := ${read.with_default('unsafe { ${arg.v_type}(${read.arg_expr()}.raw_obj()) }')}',
		]
	}
	return none
}

fn (binding PhpSingleArgBinding) render_v_value_lines() []string {
	read := binding.read()
	return ['    ${binding.var_name} := ${read.with_default(read.v_expr())}']
}
