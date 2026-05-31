module parser

fn test_normalize_attr_value_trims_spaces() {
	assert normalize_attr_value('  hello  ') == 'hello'
}

fn test_normalize_attr_value_trims_quotes() {
	assert normalize_attr_value("\"quoted\"") == 'quoted'
	assert normalize_attr_value("'single'") == 'single'
}

fn test_normalize_attr_value_handles_empty() {
	assert normalize_attr_value('') == ''
	assert normalize_attr_value('   ') == ''
}

fn test_parse_attr_list_simple() {
	result := parse_attr_list('a, b, c')
	assert result.len == 3
	assert result[0] == 'a'
	assert result[1] == 'b'
	assert result[2] == 'c'
}

fn test_parse_attr_list_with_spaces_and_quotes() {
	result := parse_attr_list("'Foo', \"Bar\"")
	assert result.len == 2
	assert result[0] == 'Foo'
	assert result[1] == 'Bar'
}

fn test_parse_attr_list_empty_input() {
	assert parse_attr_list('').len == 0
}

fn test_parse_php_arg_types_simple() {
	result := parse_php_arg_types('name=string, age=int')
	assert result.len == 2
	assert result['name'] == 'string'
	assert result['age'] == 'int'
}

fn test_parse_php_arg_types_with_spaces() {
	result := parse_php_arg_types('  name  =  string  ,  age  =  int  ')
	assert result.len == 2
	assert result['name'] == 'string'
	assert result['age'] == 'int'
}

fn test_parse_php_arg_types_empty_input() {
	assert parse_php_arg_types('').len == 0
}

fn test_parse_php_prop_map_simple() {
	result := parse_php_prop_map('v_field=php_prop')
	assert result.len == 1
	assert result['v_field'] == 'php_prop'
}

fn test_parse_php_prop_map_multiple() {
	result := parse_php_prop_map('name=Name, age=Age, email=Email')
	assert result.len == 3
	assert result['name'] == 'Name'
	assert result['age'] == 'Age'
	assert result['email'] == 'Email'
}

fn test_parse_php_prop_map_empty_input() {
	assert parse_php_prop_map('').len == 0
}

fn test_parse_php_prop_attr_basic() {
	result := parse_php_prop_attr('property_name')
	assert result != none
	assert (result or { panic('expected result') }).name == 'property_name'
	assert (result or { panic('expected result') }).v_type == 'mixed'
}

fn test_parse_php_prop_attr_with_type() {
	result := parse_php_prop_attr('count: int')
	assert result != none
	assert (result or { panic('expected result') }).name == 'count'
	assert (result or { panic('expected result') }).v_type == 'int'
}

fn test_parse_php_prop_attr_quoted() {
	result := parse_php_prop_attr("'my_prop: string'")
	assert result != none
	assert (result or { panic('expected result') }).name == 'my_prop'
	assert (result or { panic('expected result') }).v_type == 'string'
}

fn test_parse_php_prop_attr_empty_input() {
	assert parse_php_prop_attr('') == none
	assert parse_php_prop_attr('   ') == none
}

fn test_parse_php_attr_simple_name() {
	result := parse_php_attr('MyAttribute')
	assert result != none
	assert (result or { panic('expected result') }).name == 'MyAttribute'
	assert (result or { panic('expected result') }).args.len == 0
}

fn test_parse_php_attr_with_args() {
	result := parse_php_attr('MyAttribute(arg1, arg2=42)')
	assert result != none
	assert (result or { panic('expected result') }).name == 'MyAttribute'
	assert (result or { panic('expected result') }).args.len == 2
}

fn test_parse_php_attr_empty_input() {
	assert parse_php_attr('') == none
	assert parse_php_attr('   ') == none
}

fn test_parse_attr_args_positional() {
	result := parse_attr_args('hello, world')
	assert result.len == 2
	assert result[0].kind == 'string'
	assert result[0].value == 'hello'
	assert result[1].kind == 'string'
	assert result[1].value == 'world'
}

fn test_parse_attr_args_named() {
	result := parse_attr_args('name: world')
	assert result.len == 1
	assert result[0].name == 'name'
	assert result[0].value == 'world'
}

fn test_parse_attr_args_int_value() {
	result := parse_attr_args('count: 42')
	assert result.len == 1
	assert result[0].name == 'count'
	assert result[0].kind == 'int'
	assert result[0].value == '42'
}

fn test_parse_attr_args_bool_value() {
	result := parse_attr_args('flag: true')
	assert result.len == 1
	assert result[0].name == 'flag'
	assert result[0].kind == 'bool'
	assert result[0].value == 'true'
}

fn test_parse_attr_args_null_value() {
	result := parse_attr_args('value: null')
	assert result.len == 1
	assert result[0].name == 'value'
	assert result[0].kind == 'null'
}

fn test_parse_attr_args_empty_input() {
	assert parse_attr_args('').len == 0
}
