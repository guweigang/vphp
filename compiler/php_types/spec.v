module php_types

pub struct PhpTypeSpec {
pub:
	v_key          string
	php_code       string
	php_mask       string
	mask_obj_class string
	arg_method     string
	arg_label      string
	is_total_arg   bool
}

pub fn normalize_v_type_key(v_type string) string {
	mut clean_type := v_type.trim_space().replace('vphp.ZVal', 'ZVal')
	if clean_type.starts_with('&') || clean_type.starts_with('!') || clean_type.starts_with('?') {
		clean_type = clean_type[1..]
	}
	if !clean_type.starts_with('[]') && !clean_type.starts_with('map[') && clean_type.contains('.') {
		clean_type = clean_type.all_after('.')
	}
	return clean_type
}

pub fn PhpTypeSpec.from_v_type(v_type string) ?PhpTypeSpec {
	clean := normalize_v_type_key(v_type)
	return match clean {
		'ZVal', 'RequestBorrowedZBox', 'RequestOwnedZBox', 'PersistentOwnedZBox' {
			PhpTypeSpec{
				v_key:    clean
				php_code: 'IS_MIXED'
			}
		}
		'[]string', '[]int', '[]i64', '[]bool', '[]f64', '[]f32', '[]', '[]ZVal',
		'map[string]string', 'map[string]int', 'map[string]i64', 'map[string]bool',
		'map[string]f64', 'map[string][]string', 'map[string]ZVal' {
			PhpTypeSpec{
				v_key:    clean
				php_code: 'IS_ARRAY'
			}
		}
		'PhpValue' {
			PhpTypeSpec{
				v_key:        clean
				php_code:     'IS_MIXED'
				arg_method:   'value'
				arg_label:    'value'
				is_total_arg: true
			}
		}
		'PhpNull' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_NULL'
				arg_method: 'null_value'
				arg_label:  'null'
			}
		}
		'PhpBool' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   '_IS_BOOL'
				arg_method: 'bool_value'
				arg_label:  'bool'
			}
		}
		'PhpInt' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_LONG'
				arg_method: 'int_value'
				arg_label:  'int'
			}
		}
		'PhpDouble' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_DOUBLE'
				arg_method: 'double_value'
				arg_label:  'double'
			}
		}
		'PhpString' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_STRING'
				arg_method: 'string_value'
				arg_label:  'string'
			}
		}
		'PhpScalar' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_MIXED'
				arg_method: 'scalar'
				arg_label:  'scalar'
			}
		}
		'PhpArray' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_ARRAY'
				arg_method: 'array'
				arg_label:  'array'
			}
		}
		'PhpObject' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_OBJECT'
				arg_method: 'object'
				arg_label:  'object'
			}
		}
		'PhpCallable' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_CALLABLE'
				arg_method: 'callable'
				arg_label:  'callable'
			}
		}
		'PhpResource' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_MIXED'
				arg_method: 'resource'
				arg_label:  'resource'
			}
		}
		'PhpReference' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_MIXED'
				arg_method: 'reference'
				arg_label:  'reference'
			}
		}
		'PhpIterable' {
			PhpTypeSpec{
				v_key:          clean
				php_mask:       'MAY_BE_ARRAY'
				mask_obj_class: 'Traversable'
				arg_method:     'iterable'
				arg_label:      'iterable'
			}
		}
		'PhpThrowable' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_OBJECT'
				arg_method: 'throwable'
				arg_label:  'throwable'
			}
		}
		'PhpEnumCase' {
			PhpTypeSpec{
				v_key:      clean
				php_code:   'IS_MIXED'
				arg_method: 'enum_case'
				arg_label:  'enum case'
			}
		}
		'callable', 'Callable' {
			PhpTypeSpec{
				v_key:    clean
				php_code: 'IS_CALLABLE'
			}
		}
		else {
			none
		}
	}
}

pub fn PhpTypeSpec.semantic_wrapper_for(v_type string) ?PhpTypeSpec {
	spec := PhpTypeSpec.from_v_type(v_type) or { return none }
	if spec.arg_method == '' {
		return none
	}
	return spec
}
