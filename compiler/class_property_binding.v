module compiler

import compiler.repr

struct ClassPropertyGlue {
	class_name string
	type_ref   string
	lower_name string
	props      []repr.PhpClassPropRepr
}

struct ClassPropertyFieldBinding {
	prop repr.PhpClassPropRepr
}

fn ClassPropertyGlue.new(class_name string, type_ref string, lower_name string, props []repr.PhpClassPropRepr) ClassPropertyGlue {
	return ClassPropertyGlue{
		class_name: class_name
		type_ref:   type_ref
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

fn (glue ClassPropertyGlue) readable_fields() []ClassPropertyFieldBinding {
	mut fields := []ClassPropertyFieldBinding{}
	for prop in glue.props {
		field := ClassPropertyFieldBinding.new(prop)
		if field.is_readable() {
			fields << field
		}
	}
	return fields
}

fn (glue ClassPropertyGlue) writable_fields() []ClassPropertyFieldBinding {
	mut fields := []ClassPropertyFieldBinding{}
	for prop in glue.props {
		field := ClassPropertyFieldBinding.new(prop)
		if field.is_writable() {
			fields << field
		}
	}
	return fields
}

fn (glue ClassPropertyGlue) render_getter_lines() []string {
	mut out := []string{}
	out << "@[export: '${glue.class_name}_get_prop']"
	out << property_getter_signature(glue.lower_name)
	readable_fields := glue.readable_fields()
	if readable_fields.len == 0 {
		out << unused_arg_lines(['ptr', 'name_ptr', 'name_len', 'rv'])
		out << '}'
		return out
	}
	out << '    ret := vphp.PhpObjectPropertyHandler.return_from_ptr(rv)'
	out << '    unsafe {'
	out << '        name := vphp.PhpObjectPropertyHandler.name_from_ptr(name_ptr, name_len)'
	out << '        obj := &${glue.type_ref}(ptr)'
	for field in readable_fields {
		out << field.getter_lines()
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
	expr := field.getter_expr() or { return [] }
	return property_name_guard_lines(prop.name, expr)
}

fn (field ClassPropertyFieldBinding) getter_expr() ?string {
	prop := field.prop
	return match prop.v_type {
		'string' { 'ret.v[string](obj.${prop.v_field_name})' }
		'int' { 'ret.v[i64](i64(obj.${prop.v_field_name}))' }
		'i64' { 'ret.v[i64](obj.${prop.v_field_name})' }
		'bool' { 'ret.v[bool](obj.${prop.v_field_name})' }
		'f64' { 'ret.v[f64](obj.${prop.v_field_name})' }
		else { none }
	}
}

fn (glue ClassPropertyGlue) render_setter_lines() []string {
	mut out := []string{}
	out << "@[export: '${glue.class_name}_set_prop']"
	out << property_setter_signature(glue.lower_name)
	writable_fields := glue.writable_fields()
	if writable_fields.len == 0 {
		out << unused_arg_lines(['ptr', 'name_ptr', 'name_len', 'value'])
		out << '}'
		return out
	}
	out << '    arg := vphp.PhpObjectPropertyHandler.value_from_ptr(value)'
	out << '    unsafe {'
	out << '        name := vphp.PhpObjectPropertyHandler.name_from_ptr(name_ptr, name_len)'
	out << '        mut obj := &${glue.type_ref}(ptr)'
	for field in writable_fields {
		out << field.setter_lines()
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
	expr := field.setter_expr() or { return [] }
	return property_name_guard_lines(prop.name, expr)
}

fn (field ClassPropertyFieldBinding) setter_expr() ?string {
	prop := field.prop
	return match prop.v_type {
		'string' { 'obj.${prop.v_field_name} = arg.get_string()' }
		'int' { 'obj.${prop.v_field_name} = int(arg.get_int())' }
		'i64' { 'obj.${prop.v_field_name} = arg.get_int()' }
		'bool' { 'obj.${prop.v_field_name} = arg.get_bool()' }
		'f64' { 'obj.${prop.v_field_name} = arg.to_f64()' }
		else { none }
	}
}

fn (glue ClassPropertyGlue) render_sync_lines() []string {
	mut out := []string{}
	out << "@[export: '${glue.class_name}_sync_props']"
	out << property_sync_signature(glue.lower_name)
	readable_fields := glue.readable_fields()
	if readable_fields.len == 0 {
		out << unused_arg_lines(['ptr', 'zv'])
		out << '}'
		return out
	}
	out << '    out := vphp.PhpObjectPropertyHandler.value_from_ptr(zv)'
	out << '    unsafe {'
	out << '        obj := &${glue.type_ref}(ptr)'
	for field in readable_fields {
		out << field.sync_lines()
	}
	out << '    }'
	out << '}'
	return out
}

fn property_getter_signature(lower_name string) string {
	return 'pub fn ${lower_name}_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {'
}

fn property_setter_signature(lower_name string) string {
	return 'pub fn ${lower_name}_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {'
}

fn property_sync_signature(lower_name string) string {
	return 'pub fn ${lower_name}_sync_props(ptr voidptr, zv &C.zval) {'
}

fn unused_arg_lines(names []string) []string {
	mut out := []string{}
	for name in names {
		out << '    _ = ${name}'
	}
	return out
}

fn (field ClassPropertyFieldBinding) sync_lines() []string {
	if !field.is_readable() {
		return []
	}
	expr := field.sync_expr() or { return [] }
	return ['        ${expr}']
}

fn (field ClassPropertyFieldBinding) sync_expr() ?string {
	prop := field.prop
	return match prop.v_type {
		'string' { "out.add_property_string('${prop.name}', obj.${prop.v_field_name})" }
		'int', 'i64' { "out.add_property_long('${prop.name}', i64(obj.${prop.v_field_name}))" }
		'f64' { "out.add_property_double('${prop.name}', obj.${prop.v_field_name})" }
		'bool' { "out.add_property_bool('${prop.name}', obj.${prop.v_field_name})" }
		else { none }
	}
}

fn property_name_guard_lines(name string, expr string) []string {
	mut out := []string{}
	out << "        if name == '${name}' {"
	out << '            ${expr}'
	out << '            return'
	out << '        }'
	return out
}
