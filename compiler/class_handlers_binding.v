module compiler

struct ClassHandlersGlue {
	class_name string
	lower_name string
}

fn ClassHandlersGlue.new(class_name string, lower_name string) ClassHandlersGlue {
	return ClassHandlersGlue{
		class_name: class_name
		lower_name: lower_name
	}
}

fn (glue ClassHandlersGlue) render_lines() []string {
	return [
		"@[export: '${glue.class_name}_handlers']",
		'pub fn ${glue.lower_name}_handlers() voidptr {',
		'    return vphp.ZendClassHandlers.new(',
		'        prop_handler: voidptr(${glue.lower_name}_get_prop),',
		'        write_handler: voidptr(${glue.lower_name}_set_prop),',
		'        sync_handler: voidptr(${glue.lower_name}_sync_props),',
		'        new_raw: voidptr(${glue.lower_name}_new_raw),',
		'        cleanup_raw: voidptr(${glue.lower_name}_cleanup_raw),',
		'        free_raw: voidptr(${glue.lower_name}_free_raw)',
		'    )',
		'}',
	]
}
