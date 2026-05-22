module compiler

import compiler.repr

struct ClassLifecycleGlue {
	class_name         string
	type_ref           string
	lower_name         string
	has_cleanup_method bool
	has_free_method    bool
}

fn ClassLifecycleGlue.new(class_name string, type_ref string, lower_name string, r &repr.PhpClassRepr) ClassLifecycleGlue {
	return ClassLifecycleGlue{
		class_name:         class_name
		type_ref:           type_ref
		lower_name:         lower_name
		has_cleanup_method: r.has_cleanup_method
		has_free_method:    r.has_free_method
	}
}

fn (glue ClassLifecycleGlue) render_lines() []string {
	mut lines := []string{}
	lines << glue.render_new_raw_lines()
	lines << glue.render_free_raw_lines()
	lines << glue.render_cleanup_raw_lines()
	return lines
}

fn (glue ClassLifecycleGlue) render_new_raw_lines() []string {
	return [
		"@[export: '${glue.lower_name}_new_raw']",
		'pub fn ${glue.lower_name}_new_raw() voidptr {',
		'    return vphp.generic_new_raw[${glue.type_ref}]()',
		'}',
	]
}

fn (glue ClassLifecycleGlue) render_free_raw_lines() []string {
	return [
		"@[export: '${glue.lower_name}_free_raw']",
		'pub fn ${glue.lower_name}_free_raw(ptr voidptr) {',
		'    if ptr == 0 {',
		'        return',
		'    }',
		'    vphp.generic_free_raw[${glue.type_ref}](ptr)',
		'}',
	]
}

fn (glue ClassLifecycleGlue) render_cleanup_raw_lines() []string {
	mut out := []string{}
	out << "@[export: '${glue.lower_name}_cleanup_raw']"
	out << 'pub fn ${glue.lower_name}_cleanup_raw(ptr voidptr) {'
	out << '    if ptr == 0 {'
	out << '        return'
	out << '    }'
	if glue.has_cleanup_method || glue.has_free_method {
		out << '    unsafe {'
		out << '        mut obj := &${glue.type_ref}(ptr)'
		if glue.has_cleanup_method {
			out << '        obj.cleanup()'
		}
		if glue.has_free_method {
			out << '        obj.free()'
		}
		out << '    }'
	}
	out << '}'
	return out
}
