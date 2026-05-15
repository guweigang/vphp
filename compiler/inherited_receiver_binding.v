module compiler

import compiler.repr

struct InheritedReceiverGlue {
	class_name string
	lower_name string
	props      []repr.PhpClassPropRepr
}

struct InheritedReceiverFieldBinding {
	prop repr.PhpClassPropRepr
}

fn InheritedReceiverGlue.new(class_name string, lower_name string, props []repr.PhpClassPropRepr) InheritedReceiverGlue {
	return InheritedReceiverGlue{
		class_name: class_name
		lower_name: lower_name
		props:      props
	}
}

fn (glue InheritedReceiverGlue) render_lines() []string {
	mut lines := []string{}
	lines << glue.render_load_lines()
	lines << glue.render_sync_lines()
	return lines
}

fn (glue InheritedReceiverGlue) zval_fields() []repr.PhpClassPropRepr {
	return glue.props.filter(!it.is_property_only && !it.is_static && is_internal_parent_zval_field(it.v_type))
}

fn (glue InheritedReceiverGlue) render_load_lines() []string {
	mut out := []string{}
	out << 'fn ${glue.lower_name}_load_from_php(php_obj vphp.ZendObject) ${glue.class_name} {'
	zval_fields := glue.zval_fields()
	if zval_fields.len == 0 {
		out << '    mut recv := ${glue.class_name}{}'
	} else {
		out << '    mut recv := ${glue.class_name}{'
		for prop in zval_fields {
			out << '        ${prop.v_field_name}: vphp.ZVal.new_null()'
		}
		out << '    }'
	}
	out << '    if !php_obj.is_valid() {'
	out << '        return recv'
	out << '    }'
	for prop in glue.props {
		out << InheritedReceiverFieldBinding.new(prop).load_lines()
	}
	out << '    return recv'
	out << '}'
	return out
}

fn (glue InheritedReceiverGlue) render_sync_lines() []string {
	mut out := []string{}
	out << 'fn ${glue.lower_name}_sync_to_php(php_obj vphp.ZendObject, recv ${glue.class_name}) {'
	out << '    if !php_obj.is_valid() {'
	out << '        return'
	out << '    }'
	for prop in glue.props {
		out << InheritedReceiverFieldBinding.new(prop).sync_lines()
	}
	out << '}'
	return out
}

fn InheritedReceiverFieldBinding.new(prop repr.PhpClassPropRepr) InheritedReceiverFieldBinding {
	return InheritedReceiverFieldBinding{
		prop: prop
	}
}

fn (field InheritedReceiverFieldBinding) can_load() bool {
	prop := field.prop
	if prop.is_static || prop.is_property_only {
		return false
	}
	return is_internal_parent_scalar_field(prop.v_type) || is_internal_parent_zval_field(prop.v_type)
}

fn (field InheritedReceiverFieldBinding) can_sync() bool {
	prop := field.prop
	if prop.is_static || prop.is_property_only {
		return false
	}
	return is_internal_parent_scalar_field(prop.v_type)
}

fn (field InheritedReceiverFieldBinding) load_lines() []string {
	if !field.can_load() {
		return []
	}
	prop := field.prop
	mut out := []string{}
	match prop.v_type {
		'string' {
			out << "    recv.${prop.v_field_name} = php_obj.prop_string_or('${prop.name}', recv.${prop.v_field_name})"
		}
		'int' {
			out << "    recv.${prop.v_field_name} = int(php_obj.prop_i64_or('${prop.name}', i64(recv.${prop.v_field_name})))"
		}
		'i64' {
			out << "    recv.${prop.v_field_name} = php_obj.prop_i64_or('${prop.name}', recv.${prop.v_field_name})"
		}
		'bool' {
			out << "    recv.${prop.v_field_name} = php_obj.prop_bool_or('${prop.name}', recv.${prop.v_field_name})"
		}
		'f64' {
			out << "    recv.${prop.v_field_name} = php_obj.prop_f64_or('${prop.name}', recv.${prop.v_field_name})"
		}
		else {}
	}
	return out
}

fn (field InheritedReceiverFieldBinding) sync_lines() []string {
	if !field.can_sync() {
		return []
	}
	prop := field.prop
	mut out := []string{}
	match prop.v_type {
		'string' {
			out << '    mut prop_${prop.name} := vphp.RequestOwnedZBox.new_string(recv.${prop.v_field_name}).to_zval()'
			out << "    php_obj.set_prop('${prop.name}', prop_${prop.name})"
		}
		'int', 'i64' {
			out << '    mut prop_${prop.name} := vphp.RequestOwnedZBox.new_int(i64(recv.${prop.v_field_name})).to_zval()'
			out << "    php_obj.set_prop('${prop.name}', prop_${prop.name})"
		}
		'bool' {
			out << '    mut prop_${prop.name} := vphp.RequestOwnedZBox.new_bool(recv.${prop.v_field_name}).to_zval()'
			out << "    php_obj.set_prop('${prop.name}', prop_${prop.name})"
		}
		'f64' {
			out << '    mut prop_${prop.name} := vphp.RequestOwnedZBox.new_float(recv.${prop.v_field_name}).to_zval()'
			out << "    php_obj.set_prop('${prop.name}', prop_${prop.name})"
		}
		else {}
	}
	return out
}
