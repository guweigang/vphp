module compiler

import compiler.repr

struct ClassShadowGlue {
	class_name         string
	shadow_const_name  string
	shadow_static_name string
	shadow_const_type  string
	shadow_static_type string
	props              []repr.PhpClassPropRepr
}

fn ClassShadowGlue.new(r &repr.PhpClassRepr) ClassShadowGlue {
	return ClassShadowGlue{
		class_name:         r.name
		shadow_const_name:  r.shadow_const_name
		shadow_static_name: r.shadow_static_name
		shadow_const_type:  r.shadow_const_type
		shadow_static_type: r.shadow_static_type
		props:              r.properties
	}
}

fn (glue ClassShadowGlue) render_lines() []string {
	mut lines := []string{}
	lines << glue.render_const_accessor_lines()
	lines << glue.render_static_accessor_lines()
	return lines
}

fn (glue ClassShadowGlue) render_const_accessor_lines() []string {
	if glue.shadow_const_name == '' {
		return []
	}
	ret_type := if glue.shadow_const_type != '' { glue.shadow_const_type } else { 'voidptr' }
	return [
		'pub fn ${glue.class_name}.consts() ${ret_type} {',
		'    return ${glue.shadow_const_name}',
		'}',
	]
}

fn (glue ClassShadowGlue) render_static_accessor_lines() []string {
	if glue.shadow_static_name == '' {
		return []
	}
	type_name := if glue.shadow_static_type != '' {
		glue.shadow_static_type
	} else {
		glue.shadow_static_name.title()
	}
	mut out := []string{}
	out << 'pub fn ${glue.class_name}.statics() &${type_name} {'
	out << '    return &${glue.shadow_static_name}'
	out << '}'
	out << 'pub fn ${glue.class_name}.sync_statics_to_php(ctx vphp.Context) {'
	out << '    ce := ctx.active_class_entry()'
	out << '    if !ce.is_valid() { return }'
	for prop in glue.props {
		if prop.is_static {
			out << '    ce.set_static_prop("${prop.name}", ${glue.shadow_static_name}.${prop.name})'
		}
	}
	out << '}'
	out << 'pub fn ${glue.class_name}.sync_statics_from_php(ctx vphp.Context) {'
	out << '    ce := ctx.active_class_entry()'
	out << '    if !ce.is_valid() { return }'
	out << '    mut s := ${glue.class_name}.statics()'
	for prop in glue.props {
		if prop.is_static {
			out << '    s.${prop.name} = ce.static_prop[${prop.v_type}]("${prop.name}")'
		}
	}
	out << '}'
	return out
}
