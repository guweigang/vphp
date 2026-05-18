module compiler

struct ClassObjectBindingGlue {
	class_name string
	c_name     string
	lower_name string
}

fn ClassObjectBindingGlue.new(class_name string, c_name string, lower_name string) ClassObjectBindingGlue {
	return ClassObjectBindingGlue{
		class_name: class_name
		c_name:     c_name
		lower_name: lower_name
	}
}

fn (glue ClassObjectBindingGlue) render_lines() []string {
	return [
		'pub fn ${glue.class_name}.php_class_entry() vphp.ZendClassEntry {',
		'    return vphp.ZendClassEntry.from_ptr(C.${glue.c_name.to_lower()}_ce)',
		'}',
		'',
		'pub fn ${glue.class_name}.php_object_handlers() voidptr {',
		'    return ${glue.lower_name}_handlers()',
		'}',
		'',
		'pub fn ${glue.class_name}.php_object_zval(v_ptr voidptr, ownership vphp.OwnershipKind) vphp.ZVal {',
		'    mut value := vphp.PhpValue.null()',
		'    binding := vphp.PhpObjectBinding.new[${glue.class_name}]()',
		'    if v_ptr == 0 || !binding.is_valid() {',
		'        return value.take_zval()',
		'    }',
		'    vphp.PhpReturn.from_zval(value.to_zval()).bound_object(v_ptr, binding.class_entry, binding.handlers, ownership)',
		'    return value.take_zval()',
		'}',
		'',
		'pub fn (obj &${glue.class_name}) bind_php_object() vphp.ZVal {',
		'    return ${glue.class_name}.php_object_zval(obj, .borrowed)',
		'}',
		'',
		'pub fn (obj &${glue.class_name}) bind_php_object_value() vphp.PhpValue {',
		'    return vphp.PhpValue.adopt_zval(obj.bind_php_object())',
		'}',
		'',
		'pub fn (obj &${glue.class_name}) bind_owned_php_object() vphp.ZVal {',
		'    return ${glue.class_name}.php_object_zval(obj, .owned_request)',
		'}',
		'',
		'pub fn (obj &${glue.class_name}) bind_owned_php_object_value() vphp.PhpValue {',
		'    return vphp.PhpValue.adopt_zval(obj.bind_owned_php_object())',
		'}',
	]
}
