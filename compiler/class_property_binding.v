module compiler

import compiler.repr

struct ClassPropertyGlue {
	class_name string
	lower_name string
	props      []repr.PhpClassPropRepr
}

fn ClassPropertyGlue.new(class_name string, lower_name string, props []repr.PhpClassPropRepr) ClassPropertyGlue {
	return ClassPropertyGlue{
		class_name: class_name
		lower_name: lower_name
		props:      props
	}
}

fn (glue ClassPropertyGlue) render_lines() []string {
	mut lines := []string{}
	lines << glue.render_getter_lines()
	lines << glue.render_setter_lines()
	lines << glue.render_sync_lines()
	return lines
}

fn (glue ClassPropertyGlue) has_readable_props() bool {
	for prop in glue.props {
		if is_public_instance_sync_prop(prop) {
			return true
		}
	}
	return false
}

fn (glue ClassPropertyGlue) has_writable_props() bool {
	for prop in glue.props {
		if is_public_instance_sync_prop(prop) && prop.is_mut {
			return true
		}
	}
	return false
}

fn (glue ClassPropertyGlue) render_getter_lines() []string {
	mut out := []string{}
	out << "@[export: '${glue.class_name}_get_prop']"
	out << 'pub fn ${glue.lower_name}_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {'
	if !glue.has_readable_props() {
		out << '    _ = ptr'
		out << '    _ = name_ptr'
		out << '    _ = name_len'
		out << '    _ = rv'
		out << '}'
		return out
	}
	out << '    unsafe {'
	out << '        name := name_ptr.vstring_with_len(name_len).clone()'
	out << '        obj := &${glue.class_name}(ptr)'
	for prop in glue.props {
		out << render_prop_getter_case(prop)
	}
	out << '    }'
	out << '}'
	return out
}

fn render_prop_getter_case(prop repr.PhpClassPropRepr) []string {
	if !is_public_instance_sync_prop(prop) {
		return []
	}
	mut out := []string{}
	match prop.v_type {
		'string' {
			out << "        if name == '${prop.name}' {"
			out << '            vphp.return_val_raw(rv, obj.${prop.v_field_name})'
			out << '            return'
			out << '        }'
		}
		'int' {
			out << "        if name == '${prop.name}' {"
			out << '            vphp.return_val_raw(rv, i64(obj.${prop.v_field_name}))'
			out << '            return'
			out << '        }'
		}
		'i64' {
			out << "        if name == '${prop.name}' {"
			out << '            vphp.return_val_raw(rv, obj.${prop.v_field_name})'
			out << '            return'
			out << '        }'
		}
		'bool' {
			out << "        if name == '${prop.name}' {"
			out << '            vphp.return_val_raw(rv, obj.${prop.v_field_name})'
			out << '            return'
			out << '        }'
		}
		'f64' {
			out << "        if name == '${prop.name}' {"
			out << '            vphp.return_val_raw(rv, obj.${prop.v_field_name})'
			out << '            return'
			out << '        }'
		}
		else {}
	}
	return out
}

fn (glue ClassPropertyGlue) render_setter_lines() []string {
	mut out := []string{}
	out << "@[export: '${glue.class_name}_set_prop']"
	out << 'pub fn ${glue.lower_name}_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {'
	if !glue.has_writable_props() {
		out << '    _ = ptr'
		out << '    _ = name_ptr'
		out << '    _ = name_len'
		out << '    _ = value'
		out << '}'
		return out
	}
	out << '    unsafe {'
	out << '        name := name_ptr.vstring_with_len(name_len).clone()'
	out << '        mut obj := &${glue.class_name}(ptr)'
	out << '        arg := vphp.ZVal{ raw: value }'
	for prop in glue.props {
		out << render_prop_setter_case(prop)
	}
	out << '    }'
	out << '}'
	return out
}

fn render_prop_setter_case(prop repr.PhpClassPropRepr) []string {
	if !is_public_instance_sync_prop(prop) || !prop.is_mut {
		return []
	}
	mut out := []string{}
	match prop.v_type {
		'string' {
			out << "        if name == '${prop.name}' {"
			out << '            obj.${prop.v_field_name} = arg.get_string()'
			out << '            return'
			out << '        }'
		}
		'int' {
			out << "        if name == '${prop.name}' {"
			out << '            obj.${prop.v_field_name} = int(arg.get_int())'
			out << '            return'
			out << '        }'
		}
		'i64' {
			out << "        if name == '${prop.name}' {"
			out << '            obj.${prop.v_field_name} = arg.get_int()'
			out << '            return'
			out << '        }'
		}
		'bool' {
			out << "        if name == '${prop.name}' {"
			out << '            obj.${prop.v_field_name} = arg.get_bool()'
			out << '            return'
			out << '        }'
		}
		'f64' {
			out << "        if name == '${prop.name}' {"
			out << '            obj.${prop.v_field_name} = C.vphp_get_double(value)'
			out << '            return'
			out << '        }'
		}
		else {}
	}
	return out
}

fn (glue ClassPropertyGlue) render_sync_lines() []string {
	mut out := []string{}
	out << "@[export: '${glue.class_name}_sync_props']"
	out << 'pub fn ${glue.lower_name}_sync_props(ptr voidptr, zv &C.zval) {'
	if !glue.has_readable_props() {
		out << '    _ = ptr'
		out << '    _ = zv'
		out << '}'
		return out
	}
	out << '    unsafe {'
	out << '        obj := &${glue.class_name}(ptr)'
	out << '        out := vphp.ZVal{ raw: zv }'
	for prop in glue.props {
		out << render_prop_sync_case(prop)
	}
	out << '    }'
	out << '}'
	return out
}

fn render_prop_sync_case(prop repr.PhpClassPropRepr) []string {
	if !is_public_instance_sync_prop(prop) {
		return []
	}
	mut out := []string{}
	match prop.v_type {
		'string' {
			out << "        out.add_property_string('${prop.name}', obj.${prop.v_field_name})"
		}
		'int', 'i64' {
			out << "        out.add_property_long('${prop.name}', i64(obj.${prop.v_field_name}))"
		}
		'f64' {
			out << "        out.add_property_double('${prop.name}', obj.${prop.v_field_name})"
		}
		'bool' {
			out << "        out.add_property_bool('${prop.name}', obj.${prop.v_field_name})"
		}
		else {}
	}
	return out
}

fn is_public_instance_sync_prop(prop repr.PhpClassPropRepr) bool {
	if prop.is_static || prop.visibility != 'public' || prop.is_property_only {
		return false
	}
	return prop.v_type in ['string', 'int', 'i64', 'bool', 'f64']
}
