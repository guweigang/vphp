module builder

pub struct FuncBuilder {
pub mut:
	php_name    string
	c_func      string
	return_spec ReturnSpec
	args        []ClassMethodArg // reuse ClassMethodArg for function args
	uses_context bool
}

pub fn new_func_builder(php_name string, c_func string) &FuncBuilder {
	return &FuncBuilder{
		php_name:    php_name
		c_func:      c_func
		return_spec: new_return_spec('', '', '')
	}
}

pub fn new_func_builder_with_args(php_name string, c_func string, return_spec ReturnSpec, args []ClassMethodArg, uses_context bool) &FuncBuilder {
	return &FuncBuilder{
		php_name:    php_name
		c_func:      c_func
		return_spec: return_spec
		args:        args
		uses_context: uses_context
	}
}

pub fn (b &FuncBuilder) render_fe() string {
	return '    PHP_FE(${b.php_name}, arginfo_${b.c_func})'
}

pub fn (b &FuncBuilder) render_declaration() string {
	return 'PHP_FUNCTION(${b.php_name});'
}

pub fn (b &FuncBuilder) render_arginfo() string {
	if b.uses_context {
		return 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${b.c_func}, 0, 0, 0)\nZEND_ARG_VARIADIC_TYPE_INFO(0, args, IS_MIXED, 0)\nZEND_END_ARG_INFO()'
	}
	mut res := []string{}
	resolved_return_type := b.return_spec.resolved_type()
	validate_php_return_type_or_panic(resolved_return_type, b.php_name)
	type_info := arg_type_info(resolved_return_type)
	required_args := function_required_args(b.args)
	res << render_standard_arginfo_header(b.c_func, required_args, resolved_return_type,
		b.return_spec.arginfo_obj_type(), type_info)
	for arg in b.args {
		raw_type := if arg.php_type != '' { arg.php_type } else { arg.type_ }
		validate_php_arg_type_or_panic(raw_type, arg.name, b.php_name)
		res << render_arginfo_arg_line(arg.name, raw_type, arg.php_default)
	}
	res << 'ZEND_END_ARG_INFO()'
	return res.join('\n')
}

fn function_required_args(args []ClassMethodArg) int {
	mut required := args.len
	for required > 0 {
		if args[required - 1].is_optional {
			required--
			continue
		}
		break
	}
	return required
}

pub fn (b FuncBuilder) export_fragments() ExportFragments {
	return ExportFragments{
		declarations:   [b.render_declaration()]
		function_table: [b]
	}
}
