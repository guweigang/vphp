module builder

fn test_new_return_spec() {
	s := new_return_spec('int', 'int', '')
	assert s.return_type == 'int'
	assert s.php_return_type == 'int'
	assert s.return_obj_type == ''
}

fn test_resolved_type_php_return() {
	s := new_return_spec('string', 'string', '')
	assert s.resolved_type() == 'string'
}

fn test_resolved_type_v_return() {
	s := new_return_spec('string', '', '')
	assert s.resolved_type() == 'string'
}

fn test_resolved_type_php_overrides_v() {
	s := new_return_spec('int', 'i64', '')
	assert s.resolved_type() == 'i64'
}

fn test_arginfo_obj_type_empty() {
	s := new_return_spec('string', 'string', '')
	assert s.arginfo_obj_type() == ''
}

fn test_arginfo_obj_type_with_value() {
	s := new_return_spec('MyClass', '', 'MyClass')
	assert s.arginfo_obj_type() == 'MyClass'
}

fn test_arginfo_obj_type_php_return_suppresses_obj() {
	s := new_return_spec('MyClass', 'object', 'MyClass')
	assert s.arginfo_obj_type() == ''
}
