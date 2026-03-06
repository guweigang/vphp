module builder

pub enum ClassType {
	class_
	interface_
	enum_
}

pub struct ClassProperty {
pub:
	name  string
	type_ string
	flags string
}

pub struct ClassConstant {
pub:
	name  string
	type_ string
	value string
}

pub struct ClassMethod {
pub:
	php_name    string
	c_func      string
	flags       string
	is_abstract bool
	args        []ClassMethodArg
}

pub struct ClassMethodArg {
pub:
	name  string
	type_ string
}

pub struct ClassBuilder {
pub mut:
	type          ClassType = .class_
	php_name      string
	c_name        string
	parent        string
	create_object bool = true
	class_flags   []string
	interfaces    []string
	properties    []ClassProperty
	constants     []ClassConstant
	methods       []ClassMethod
}

fn new_builder(type_ ClassType, php_name string, c_name string) &ClassBuilder {
	return &ClassBuilder{
		type: type_
		php_name: php_name
		c_name: c_name
	}
}

pub fn new_class_builder(php_name string, c_name string) &ClassBuilder {
	return new_builder(.class_, php_name, c_name)
}

pub fn new_interface_builder(php_name string, c_name string) &ClassBuilder {
	mut b := new_builder(.interface_, php_name, c_name)
	b.create_object = false
	return b
}

pub fn new_enum_builder(php_name string, c_name string) &ClassBuilder {
	mut b := new_builder(.enum_, php_name, c_name)
	b.create_object = false
	return b
}

pub fn (mut b ClassBuilder) set_parent(parent_name string) &ClassBuilder {
	b.parent = parent_name
	return b
}

pub fn (mut b ClassBuilder) set_create_object(enabled bool) &ClassBuilder {
	b.create_object = enabled
	return b
}

pub fn (mut b ClassBuilder) add_class_flag(flag string) &ClassBuilder {
	b.class_flags << flag
	return b
}

pub fn (mut b ClassBuilder) add_interface(interface_name string) &ClassBuilder {
	b.interfaces << interface_name
	return b
}

pub fn (mut b ClassBuilder) add_property(name string, type_ string, flags string) &ClassBuilder {
	b.properties << ClassProperty{name, type_, flags}
	return b
}

pub fn (mut b ClassBuilder) add_constant(name string, type_ string, value string) &ClassBuilder {
	b.constants << ClassConstant{name, type_, value}
	return b
}

pub fn (mut b ClassBuilder) add_method(php_name string, c_func string, flags string, args []ClassMethodArg) &ClassBuilder {
	b.methods << ClassMethod{
		php_name: php_name
		c_func: c_func
		flags: flags
		is_abstract: false
		args: args
	}
	return b
}

pub fn (mut b ClassBuilder) add_abstract_method(php_name string, c_func string, flags string, args []ClassMethodArg) &ClassBuilder {
	b.methods << ClassMethod{
		php_name: php_name
		c_func: c_func
		flags: flags
		is_abstract: true
		args: args
	}
	return b
}

pub fn (b &ClassBuilder) ce_var_name() string {
	return '${b.c_name.to_lower()}_ce'
}

pub fn (b &ClassBuilder) render_ce_declaration() string {
	return 'zend_class_entry *${b.ce_var_name()} = NULL;'
}

pub fn (b &ClassBuilder) render_ce_extern_declaration() string {
	return 'extern zend_class_entry *${b.ce_var_name()};'
}

pub fn (b &ClassBuilder) render_impl_prelude() string {
	return '${b.render_ce_declaration()}\n${b.render_arginfo_defs()}'
}

pub fn (b &ClassBuilder) render_impl_postlude() string {
	return b.render_methods_array()
}

fn arg_type_code(v_type string) string {
	return match v_type {
		'string' { 'IS_STRING' }
		'int', 'i64' { 'IS_LONG' }
		'bool' { '_IS_BOOL' }
		'f64', 'f32' { 'IS_DOUBLE' }
		else { '' }
	}
}

	pub fn (b &ClassBuilder) render_arginfo_defs() string {
		mut res := []string{}
		for m in b.methods {
			if m.php_name == '__toString' {
				res << 'ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_${m.c_func}, 0, 0, IS_STRING, 0)'
			} else {
				res << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${m.c_func}, 0, 0, ${m.args.len})'
			}
			for arg in m.args {
				type_code := arg_type_code(arg.type_)
				if type_code != '' {
					res << 'ZEND_ARG_TYPE_INFO(0, ${arg.name}, ${type_code}, 0)'
				} else {
					res << 'ZEND_ARG_INFO(0, ${arg.name})'
				}
			}
			res << 'ZEND_END_ARG_INFO()'
		}
		return res.join('\n')
	}

pub fn (b &ClassBuilder) render_methods_array() string {
	mut res := []string{}
	lower_name := b.c_name.to_lower()
	res << 'static const zend_function_entry ${lower_name}_methods[] = {'
	for m in b.methods {
		if m.is_abstract {
			res << '    ZEND_RAW_FENTRY("${m.php_name}", NULL, arginfo_${m.c_func}, ${m.flags}, NULL, NULL)'
		} else {
			res << '    PHP_ME(${b.c_name}, ${m.php_name}, arginfo_${m.c_func}, ${m.flags})'
		}
	}
	res << '    PHP_FE_END\n};\n'
	return res.join('\n')
}

pub fn (b &ClassBuilder) render_minit() string {
	mut res := []string{}
	lower_name := b.c_name.to_lower()
	ce_ptr := b.ce_var_name()

	res << '{   zend_class_entry ce;'
	res << '        INIT_CLASS_ENTRY(ce, "${b.php_name}", ${lower_name}_methods);'

	match b.type {
		.interface_ {
			res << '        ${ce_ptr} = zend_register_internal_interface(&ce);'
		}
		else {
			if b.parent != '' {
				lower_parent := b.parent.to_lower()
				parent_display := b.parent.replace('\\', '\\\\')
				res << '        zend_class_entry *parent_ce = zend_hash_str_find_ptr(CG(class_table), "${lower_parent}", sizeof("${lower_parent}")-1);'
				res << '        if (!parent_ce) {'
				res << '            vphp_throw("parent class ${parent_display} not found for ${b.php_name}", 0);'
				res << '            return FAILURE;'
				res << '        }'
				res << '        ${ce_ptr} = zend_register_internal_class_ex(&ce, parent_ce);'
			} else {
				res << '        ${ce_ptr} = zend_register_internal_class(&ce);'
			}
		}
	}

	if b.class_flags.len > 0 {
		res << '        ${ce_ptr}->ce_flags |= ${b.class_flags.join(' | ')};'
	}
	if b.create_object {
		res << '        ${ce_ptr}->create_object = vphp_create_object_handler;'
	}
	if b.interfaces.len > 0 {
		mut args := []string{}
		for i, iface in b.interfaces {
			lower_iface := iface.to_lower()
			iface_display := iface.replace('\\', '\\\\')
			iface_var := 'iface_${i}_ce'
			res << '        zend_class_entry *${iface_var} = zend_hash_str_find_ptr(CG(class_table), "${lower_iface}", sizeof("${lower_iface}")-1);'
			res << '        if (!${iface_var}) {'
			res << '            vphp_throw("interface ${iface_display} not found for ${b.php_name}", 0);'
			res << '            return FAILURE;'
			res << '        }'
			args << iface_var
		}
		res << '        zend_class_implements(${ce_ptr}, ${b.interfaces.len}, ${args.join(', ')});'
	}

	if b.type != .interface_ {
		for con in b.constants {
			match con.type_ {
				'string' {
					res << '        zend_declare_class_constant_string(${ce_ptr}, "${con.name}", sizeof("${con.name}")-1, "${con.value}");'
				}
				'double' {
					res << '        zend_declare_class_constant_double(${ce_ptr}, "${con.name}", sizeof("${con.name}")-1, ${con.value});'
				}
				'long', 'int' {
					res << '        zend_declare_class_constant_long(${ce_ptr}, "${con.name}", sizeof("${con.name}")-1, ${con.value});'
				}
				'bool' {
					res << '        zend_declare_class_constant_bool(${ce_ptr}, "${con.name}", sizeof("${con.name}")-1, ${con.value});'
				}
				else {}
			}
		}
		for prop in b.properties {
			match prop.type_ {
				'long', 'int' {
					res << '        zend_declare_property_long(${ce_ptr}, "${prop.name}", sizeof("${prop.name}")-1, 0, ${prop.flags});'
				}
				'double', 'f64' {
					res << '        zend_declare_property_double(${ce_ptr}, "${prop.name}", sizeof("${prop.name}")-1, 0.0, ${prop.flags});'
				}
				'bool' {
					res << '        zend_declare_property_bool(${ce_ptr}, "${prop.name}", sizeof("${prop.name}")-1, 0, ${prop.flags});'
				}
				'string' {
					res << '        zend_declare_property_string(${ce_ptr}, "${prop.name}", sizeof("${prop.name}")-1, "", ${prop.flags});'
				}
				else {
					res << '        zend_declare_property_null(${ce_ptr}, "${prop.name}", sizeof("${prop.name}")-1, ${prop.flags});'
				}
			}
		}
	}

	res << '    }'
	return res.join('\n')
}

pub fn (b ClassBuilder) export_fragments() ExportFragments {
	return ExportFragments{
		declarations: [b.render_ce_extern_declaration()]
		minit_lines: [b.render_minit()]
	}
}
