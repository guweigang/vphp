module compiler

pub enum RuntimeReturnKind {
	scalar
	void_
	result
	option
	static_factory
	static_object
	instance_object
}

pub struct RuntimeReturnInfo {
pub mut:
	tm        TypeMap
	kind      RuntimeReturnKind
	class_key string
	owns_vptr string
}

pub fn is_constructor_method(name string) bool {
	return name == 'construct' || name == 'init'
}

pub fn php_method_name(name string) string {
	return match name {
		'construct', 'init' { '__construct' }
		'str' { '__toString' }
		else { name }
	}
}

pub fn effective_export_php_return_type(return_type string, php_return_type string, has_export bool) string {
	if php_return_type != '' {
		return php_return_type
	}
	if has_export && (return_type == '' || return_type == 'void') {
		return 'mixed'
	}
	return ''
}

fn base_runtime_return_info(return_type string) RuntimeReturnInfo {
	tm := TypeMap.get_type(return_type)
	if return_type.starts_with('!') {
		return RuntimeReturnInfo{
			tm:        tm
			kind:      .result
			owns_vptr: 'VPHP_OWNS_VPTR'
		}
	}
	if return_type.starts_with('?') {
		return RuntimeReturnInfo{
			tm:        tm
			kind:      .option
			owns_vptr: 'VPHP_OWNS_VPTR'
		}
	}
	if tm.v_type == 'void' {
		return RuntimeReturnInfo{
			tm:        tm
			kind:      .void_
			owns_vptr: 'VPHP_OWNS_VPTR'
		}
	}
	return RuntimeReturnInfo{
		tm:        tm
		kind:      .scalar
		owns_vptr: 'VPHP_OWNS_VPTR'
	}
}

pub fn method_runtime_return_info(owner_name string, method_name string, is_static bool, return_type string, borrowed_return bool) RuntimeReturnInfo {
	mut info := base_runtime_return_info(return_type)
	owner_key := normalize_export_type_key(owner_name)
	ret_key := normalize_export_type_key(return_type)
	if is_constructor_method(method_name) || (is_static && ret_key == owner_key) {
		info.kind = .static_factory
		info.class_key = owner_key
		return info
	}
	if !return_type.starts_with('&') {
		return info
	}
	info.class_key = ret_key
	if is_static {
		info.kind = .static_object
		return info
	}
	info.kind = .instance_object
	if borrowed_return {
		info.owns_vptr = 'VPHP_BORROWS_VPTR'
	}
	return info
}
