module builder

struct ArgTypeInfo {
	code           string
	mask           string
	mask_obj_class string
	allow_null     bool
}

fn validate_php_return_type_or_panic(raw_type string, owner_name string) {
	decl := parse_php_type_decl(raw_type)
	if decl.clean == 'never' && decl.allow_null {
		panic('php_return_type "?never" is invalid for ${owner_name}')
	}
}

fn validate_php_arg_type_or_panic(raw_type string, arg_name string, owner_name string) {
	decl := parse_php_type_decl(raw_type)
	if decl.clean == 'never' {
		panic('php_arg_type "never" is invalid for parameter ${arg_name} in ${owner_name}')
	}
}

fn render_class_type_init_literal(raw_type string) string {
	mut php_type := raw_type
	mut allow_null := '0'
	if php_type.starts_with('?') {
		php_type = php_type[1..]
		allow_null = '1'
	}
	escaped := c_string_escape(normalize_php_type_literal(php_type))
	return 'ZEND_TYPE_INIT_CLASS_CONST("${escaped}", ${allow_null}, _ZEND_ARG_INFO_FLAGS(0, 0, 0))'
}

fn render_array_arginfo_header(c_func string, required_args int, resolved_return_type string, return_obj_type string, type_info ArgTypeInfo) string {
	if is_class_literal_type(resolved_return_type) {
		return 'static const zend_internal_arg_info arginfo_${c_func}[] = {\n    { (const char*)(uintptr_t)(${required_args}), ${render_class_type_init_literal(resolved_return_type)}, NULL },'
	}
	if return_obj_type != '' {
		escaped := c_string_escape(normalize_php_type_literal(return_obj_type))
		return 'static const zend_internal_arg_info arginfo_${c_func}[] = {\n    { (const char*)(uintptr_t)(${required_args}), ZEND_TYPE_INIT_CLASS_CONST("${escaped}", 0, _ZEND_ARG_INFO_FLAGS(0, 0, 0)), NULL },'
	}
	if type_info.mask_obj_class != '' {
		mut mask := type_info.mask
		if type_info.allow_null {
			mask += '|MAY_BE_NULL'
		}
		return 'static const zend_internal_arg_info arginfo_${c_func}[] = {\n    { (const char*)(uintptr_t)(${required_args}), ZEND_TYPE_INIT_CLASS_CONST_MASK("${type_info.mask_obj_class}", ${mask} | _ZEND_ARG_INFO_FLAGS(0, 0, 0)), NULL },'
	}
	if type_info.mask != '' {
		mut mask := type_info.mask
		if type_info.allow_null {
			mask += '|MAY_BE_NULL'
		}
		return 'static const zend_internal_arg_info arginfo_${c_func}[] = {\n    { (const char*)(uintptr_t)(${required_args}), ZEND_TYPE_INIT_MASK(${mask} | _ZEND_ARG_INFO_FLAGS(0, 0, 0)), NULL },'
	}
	if type_info.code != '' && type_info.code != 'IS_CALLABLE' {
		allow_null := if type_info.allow_null { '1' } else { '0' }
		return 'static const zend_internal_arg_info arginfo_${c_func}[] = {\n    { (const char*)(uintptr_t)(${required_args}), ZEND_TYPE_INIT_CODE(${type_info.code}, ${allow_null}, _ZEND_ARG_INFO_FLAGS(0, 0, 0)), NULL },'
	}
	return 'static const zend_internal_arg_info arginfo_${c_func}[] = {\n    { (const char*)(uintptr_t)(${required_args}), ZEND_TYPE_INIT_NONE(_ZEND_ARG_INFO_FLAGS(0, 0, 0)), NULL },'
}

fn render_standard_arginfo_header(c_func string, required_args int, resolved_return_type string, return_obj_type string, type_info ArgTypeInfo) string {
	if is_class_literal_type(resolved_return_type) {
		return render_array_arginfo_header(c_func, required_args, resolved_return_type,
			return_obj_type, type_info)
	}
	if return_obj_type != '' {
		if return_obj_type.contains('\\') {
			return render_array_arginfo_header(c_func, required_args, resolved_return_type,
				return_obj_type, type_info)
		}
		return 'ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_${c_func}, 0, ${required_args}, ${return_obj_type}, 0)'
	}
	if type_info.mask_obj_class != '' {
		mut mask := type_info.mask
		if type_info.allow_null {
			mask += '|MAY_BE_NULL'
		}
		return 'ZEND_BEGIN_ARG_WITH_TENTATIVE_RETURN_OBJ_TYPE_MASK_EX(arginfo_${c_func}, 0, ${required_args}, ${type_info.mask_obj_class}, ${mask})'
	}
	if type_info.mask != '' {
		mut mask := type_info.mask
		if type_info.allow_null {
			mask += '|MAY_BE_NULL'
		}
		return 'ZEND_BEGIN_ARG_WITH_RETURN_TYPE_MASK_EX(arginfo_${c_func}, 0, ${required_args}, ${mask})'
	}
	if type_info.code != '' && type_info.code != 'IS_CALLABLE' {
		allow_null := if type_info.allow_null { '1' } else { '0' }
		return 'ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_${c_func}, 0, ${required_args}, ${type_info.code}, ${allow_null})'
	}
	return 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${c_func}, 0, 0, ${required_args})'
}

fn render_method_arginfo_header(c_func string, php_name string, required_args int, resolved_return_type string, return_obj_type string, type_info ArgTypeInfo, force_array bool) string {
	validate_php_return_type_or_panic(resolved_return_type, php_name)
	if php_name == '__toString' {
		return 'ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_${c_func}, 0, 0, IS_STRING, 0)'
	}
	if force_array {
		return render_array_arginfo_header(c_func, required_args, resolved_return_type,
			return_obj_type, type_info)
	}
	return render_standard_arginfo_header(c_func, required_args, resolved_return_type,
		return_obj_type, type_info)
}

fn render_arginfo_arg_line(arg_name string, raw_type string) string {
	arg_info := arg_type_info(raw_type)
	if is_class_literal_type(raw_type) {
		return '{ "${arg_name}", ${render_class_type_init_literal(raw_type)}, NULL },'
	}
	if arg_info.code == 'IS_CALLABLE' {
		return 'ZEND_ARG_CALLABLE_INFO(0, ${arg_name}, 0)'
	}
	if arg_info.mask_obj_class != '' {
		mut mask := arg_info.mask
		if arg_info.allow_null {
			mask += '|MAY_BE_NULL'
		}
		return 'ZEND_ARG_OBJ_TYPE_MASK(0, ${arg_name}, ${arg_info.mask_obj_class}, ${mask}, NULL)'
	}
	if arg_info.mask != '' {
		mut mask := arg_info.mask
		if arg_info.allow_null {
			mask += '|MAY_BE_NULL'
		}
		return 'ZEND_ARG_TYPE_MASK(0, ${arg_name}, ${mask}, NULL)'
	}
	if arg_info.code != '' {
		allow_null := if arg_info.allow_null { '1' } else { '0' }
		return 'ZEND_ARG_TYPE_INFO(0, ${arg_name}, ${arg_info.code}, ${allow_null})'
	}
	return 'ZEND_ARG_INFO(0, ${arg_name})'
}
