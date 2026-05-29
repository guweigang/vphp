module compiler

struct ClassObjectBindingGlue {
	class_name string
	type_ref   string
	c_name     string
	lower_name string
}

fn ClassObjectBindingGlue.new(class_name string, type_ref string, c_name string, lower_name string) ClassObjectBindingGlue {
	return ClassObjectBindingGlue{
		class_name: class_name
		type_ref:   type_ref
		c_name:     c_name
		lower_name: lower_name
	}
}

fn (glue ClassObjectBindingGlue) render_lines() []string {
	if glue.type_ref != glue.class_name {
		return []
	}
	return [
		'pub fn ${glue.class_name}.php_class_entry() vphp.ZendClassEntry {',
		'    return vphp.ZendClassEntry.from_ptr(C.${glue.c_name.to_lower()}_ce)',
		'}',
		'',
		'pub fn ${glue.class_name}.php_object_handlers() object.ObjectHandlers {',
		'    return object.ObjectHandlers.from_ptr(${glue.lower_name}_handlers())',
		'}',
		'',
		'pub fn ${glue.class_name}.php_object_zval(v_ptr voidptr, ownership vphp.OwnershipKind) vphp.ZVal {',
		'    return vphp.bind_object_zval[${glue.class_name}](v_ptr, ownership)',
		'}',
		'',
		'pub fn (obj &${glue.class_name}) bind_php_object() vphp.ZVal {',
		'    return vphp.bind_borrowed_object_zval[${glue.class_name}](obj)',
		'}',
		'',
		'pub fn (obj &${glue.class_name}) bind_php_object_value() vphp.PhpValue {',
		'    return vphp.bind_borrowed_object_value[${glue.class_name}](obj)',
		'}',
		'',
		'pub fn (obj &${glue.class_name}) bind_owned_php_object() vphp.ZVal {',
		'    return vphp.bind_owned_object_zval[${glue.class_name}](obj)',
		'}',
		'',
		'pub fn (obj &${glue.class_name}) bind_owned_php_object_value() vphp.PhpValue {',
		'    return vphp.bind_owned_object_value[${glue.class_name}](obj)',
		'}',
	]
}
