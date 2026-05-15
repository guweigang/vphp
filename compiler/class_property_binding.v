module compiler

import compiler.repr

struct ClassPropertyGlue {
	class_name string
	lower_name string
	props      []repr.PhpClassPropRepr
}

struct ClassPropertyFieldBinding {
	prop repr.PhpClassPropRepr
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
		if ClassPropertyFieldBinding.new(prop).is_readable() {
			return true
		}
	}
	return false
}

fn (glue ClassPropertyGlue) has_writable_props() bool {
	for prop in glue.props {
		if ClassPropertyFieldBinding.new(prop).is_writable() {
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
	out << '    ret := vphp.PhpObjectPropertyHandler.return_from_ptr(rv)'
	out << '    unsafe {'
	out << '        name := vphp.PhpObjectPropertyHandler.name_from_ptr(name_ptr, name_len)'
	out << '        obj := &${glue.class_name}(ptr)'
	for prop in glue.props {
		out << ClassPropertyFieldBinding.new(prop).getter_lines()
	}
	out << '    }'
	out << '}'
	return out
}

fn ClassPropertyFieldBinding.new(prop repr.PhpClassPropRepr) ClassPropertyFieldBinding {
	return ClassPropertyFieldBinding{
		prop: prop
	}
}

fn (field ClassPropertyFieldBinding) is_readable() bool {
	return field.is_syncable()
}

fn (field ClassPropertyFieldBinding) is_writable() bool {
	return field.is_syncable() && field.prop.is_mut
}

fn (field ClassPropertyFieldBinding) is_syncable() bool {
	prop := field.prop
	if prop.is_static || prop.visibility != 'public' || prop.is_property_only {
		return false
	}
	return prop.v_type in ['string', 'int', 'i64', 'bool', 'f64']
}

fn (field ClassPropertyFieldBinding) getter_lines() []string {
	if !field.is_readable() {
		return []
	}
	prop := field.prop
	mut out := []string{}
	match prop.v_type {
		'string' {
			out << "        if name == '${prop.name}' {"
			out << '            ret.v[string](obj.${prop.v_field_name})'
			out << '            return'
			out << '        }'
		}
		'int' {
			out << "        if name == '${prop.name}' {"
			out << '            ret.v[i64](i64(obj.${prop.v_field_name}))'
			out << '            return'
			out << '        }'
		}
		'i64' {
			out << "        if name == '${prop.name}' {"
			out << '            ret.v[i64](obj.${prop.v_field_name})'
			out << '            return'
			out << '        }'
		}
		'bool' {
			out << "        if name == '${prop.name}' {"
			out << '            ret.v[bool](obj.${prop.v_field_name})'
			out << '            return'
			out << '        }'
		}
		'f64' {
			out << "        if name == '${prop.name}' {"
			out << '            ret.v[f64](obj.${prop.v_field_name})'
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
	out << '    arg := vphp.PhpObjectPropertyHandler.value_from_ptr(value)'
	out << '    unsafe {'
	out << '        name := vphp.PhpObjectPropertyHandler.name_from_ptr(name_ptr, name_len)'
	out << '        mut obj := &${glue.class_name}(ptr)'
	for prop in glue.props {
		out << ClassPropertyFieldBinding.new(prop).setter_lines()
	}
	out << '    }'
	out << '}'
	return out
}

fn (field ClassPropertyFieldBinding) setter_lines() []string {
	if !field.is_writable() {
		return []
	}
	prop := field.prop
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
			out << '            obj.${prop.v_field_name} = arg.to_f64()'
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
	out << '    out := vphp.PhpObjectPropertyHandler.value_from_ptr(zv)'
	out << '    unsafe {'
	out << '        obj := &${glue.class_name}(ptr)'
	for prop in glue.props {
		out << ClassPropertyFieldBinding.new(prop).sync_lines()
	}
	out << '    }'
	out << '}'
	return out
}

fn (field ClassPropertyFieldBinding) sync_lines() []string {
	if !field.is_readable() {
		return []
	}
	prop := field.prop
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
