module builder

struct PhpTypeDecl {
	raw        string
	clean      string
	allow_null bool
}

struct PhpBuiltinTypeInfo {
	code           string
	mask           string
	mask_obj_class string
}

fn parse_php_type_decl(raw_type string) PhpTypeDecl {
	mut clean := raw_type.trim_space()
	mut allow_null := false
	if clean.starts_with('?') {
		allow_null = true
		clean = clean[1..]
	}
	clean = normalize_php_type_literal(clean)
	return PhpTypeDecl{
		raw:        raw_type
		clean:      clean
		allow_null: allow_null
	}
}

fn is_class_literal_type(raw_type string) bool {
	decl := parse_php_type_decl(raw_type)
	if decl.clean == '' {
		return false
	}
	if is_php_builtin_type(raw_type) {
		return false
	}
	if decl.clean in ['self', 'parent'] {
		return true
	}
	if decl.clean.contains('|') || decl.clean.contains('&') {
		return false
	}
	return is_php_class_name_literal(decl.clean)
}

fn is_php_builtin_type(raw_type string) bool {
	decl := parse_php_type_decl(raw_type)
	_ := php_builtin_type_info_from_clean(decl.clean) or {
		return false
	}
	return true
}

fn php_builtin_type_info(raw_type string) ?PhpBuiltinTypeInfo {
	decl := parse_php_type_decl(raw_type)
	return php_builtin_type_info_from_clean(decl.clean)
}

fn php_builtin_type_info_from_clean(clean string) ?PhpBuiltinTypeInfo {
	return match clean {
		'array' { PhpBuiltinTypeInfo{code: 'IS_ARRAY'} }
		'string' { PhpBuiltinTypeInfo{code: 'IS_STRING'} }
		'int', 'i64' { PhpBuiltinTypeInfo{code: 'IS_LONG'} }
		'bool' { PhpBuiltinTypeInfo{code: '_IS_BOOL'} }
		'f64', 'f32' { PhpBuiltinTypeInfo{code: 'IS_DOUBLE'} }
		'object' { PhpBuiltinTypeInfo{code: 'IS_OBJECT'} }
		'callable' { PhpBuiltinTypeInfo{code: 'IS_CALLABLE'} }
		'iterable' { PhpBuiltinTypeInfo{mask: 'MAY_BE_ARRAY', mask_obj_class: 'Traversable'} }
		'mixed' { PhpBuiltinTypeInfo{code: 'IS_MIXED'} }
		'null' { PhpBuiltinTypeInfo{code: 'IS_NULL'} }
		'false' { PhpBuiltinTypeInfo{code: 'IS_FALSE'} }
		'true' { PhpBuiltinTypeInfo{code: 'IS_TRUE'} }
		'static' { PhpBuiltinTypeInfo{code: 'IS_STATIC'} }
		'never' { PhpBuiltinTypeInfo{code: 'IS_NEVER'} }
		'void' { PhpBuiltinTypeInfo{code: 'IS_VOID'} }
		else { none }
	}
}

fn is_php_class_name_literal(name string) bool {
	mut value := name
	if value.starts_with('\\') {
		value = value[1..]
	}
	if value == '' {
		return false
	}
	for segment in value.split('\\') {
		if !is_php_identifier_literal(segment) {
			return false
		}
	}
	return true
}

fn is_php_identifier_literal(name string) bool {
	if name.len == 0 {
		return false
	}
	first := name[0]
	if !((first >= `A` && first <= `Z`) || (first >= `a` && first <= `z`) || first == `_`) {
		return false
	}
	for ch in name[1..].bytes() {
		if !((ch >= `A` && ch <= `Z`) || (ch >= `a` && ch <= `z`) || (ch >= `0` && ch <= `9`) || ch == `_`) {
			return false
		}
	}
	return true
}
