module builder

fn test_parse_php_type_decl_simple() {
	decl := parse_php_type_decl('string')
	assert decl.clean == 'string'
	assert decl.allow_null == false
}

fn test_parse_php_type_decl_nullable() {
	decl := parse_php_type_decl('?int')
	assert decl.clean == 'int'
	assert decl.allow_null == true
}

fn test_parse_php_type_decl_with_spaces() {
	decl := parse_php_type_decl('  array  ')
	assert decl.clean == 'array'
}

fn test_is_php_builtin_type_primitives() {
	assert is_php_builtin_type('string')
	assert is_php_builtin_type('int')
	assert is_php_builtin_type('i64')
	assert is_php_builtin_type('bool')
	assert is_php_builtin_type('f64')
	assert is_php_builtin_type('f32')
	assert is_php_builtin_type('array')
	assert is_php_builtin_type('object')
	assert is_php_builtin_type('callable')
	assert is_php_builtin_type('iterable')
	assert is_php_builtin_type('mixed')
	assert is_php_builtin_type('null')
	assert is_php_builtin_type('void')
	assert is_php_builtin_type('never')
	assert is_php_builtin_type('false')
	assert is_php_builtin_type('true')
	assert is_php_builtin_type('static')
}

fn test_is_php_builtin_type_custom_class() {
	assert !is_php_builtin_type('MyClass')
	assert !is_php_builtin_type('Foo\\Bar')
}

fn test_is_php_builtin_type_nullable() {
	assert is_php_builtin_type('?string')
	assert is_php_builtin_type('?array')
}

fn test_php_builtin_type_info_string() {
	result := php_builtin_type_info('string')
	assert result != none
	assert (result or { panic('expected') }).code == 'IS_STRING'
}

fn test_php_builtin_type_info_int() {
	result := php_builtin_type_info('int')
	assert result != none
	assert (result or { panic('expected') }).code == 'IS_LONG'
}

fn test_php_builtin_type_info_array() {
	result := php_builtin_type_info('array')
	assert result != none
	assert (result or { panic('expected') }).code == 'IS_ARRAY'
}

fn test_php_builtin_type_info_bool() {
	result := php_builtin_type_info('bool')
	assert result != none
	assert (result or { panic('expected') }).code == '_IS_BOOL'
}

fn test_php_builtin_type_info_float() {
	result := php_builtin_type_info('f64')
	assert result != none
	assert (result or { panic('expected') }).code == 'IS_DOUBLE'
}

fn test_php_builtin_type_info_object() {
	result := php_builtin_type_info('object')
	assert result != none
	assert (result or { panic('expected') }).code == 'IS_OBJECT'
}

fn test_php_builtin_type_info_null() {
	result := php_builtin_type_info('null')
	assert result != none
	assert (result or { panic('expected') }).code == 'IS_NULL'
}

fn test_php_builtin_type_info_iterable() {
	result := php_builtin_type_info('iterable')
	assert result != none
	info := result or { panic('expected') }
	assert info.mask == 'MAY_BE_ARRAY'
	assert info.mask_obj_class == 'Traversable'
}

fn test_php_builtin_type_info_unknown() {
	assert php_builtin_type_info('UnknownType') == none
}

fn test_is_php_class_name_literal_simple() {
	assert is_php_class_name_literal('MyClass')
	assert is_php_class_name_literal('Foo')
}

fn test_is_php_class_name_literal_namespaced() {
	assert is_php_class_name_literal('Foo\\Bar')
	assert is_php_class_name_literal('App\\Models\\User')
}

fn test_is_php_class_name_literal_leading_backslash() {
	assert is_php_class_name_literal('\\MyClass')
	assert is_php_class_name_literal('\\App\\Models\\User')
}

fn test_is_php_class_name_literal_invalid() {
	assert !is_php_class_name_literal('')
	assert !is_php_class_name_literal('123')
	assert !is_php_class_name_literal('my-class')
}

fn test_parse_php_type_decl_class_name() {
	decl := parse_php_type_decl('MyClass')
	assert decl.clean == 'MyClass'
	assert decl.allow_null == false
}

fn test_parse_php_type_decl_nullable_class() {
	decl := parse_php_type_decl('?MyClass')
	assert decl.clean == 'MyClass'
	assert decl.allow_null == true
}
