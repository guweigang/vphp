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
	return_spec ReturnSpec
	flags       string
	is_abstract bool
	args        []ClassMethodArg
}

pub struct ClassMethodArg {
pub:
	name        string
	type_       string
	php_type    string
	is_optional bool
}

pub struct ClassAttributeArg {
pub:
	kind  string
	value string
}

pub struct ClassAttribute {
pub:
	name string
	args []ClassAttributeArg
}

pub struct ClassBuilder {
pub mut:
	type                  ClassType = .class_
	php_name              string
	c_name                string
	parent                string
	create_object         bool = true
	uses_inherited_object bool
	class_flags           []string
	interfaces            []string
	properties            []ClassProperty
	constants             []ClassConstant
	methods               []ClassMethod
	attributes            []ClassAttribute
}

fn new_builder(type_ ClassType, php_name string, c_name string) &ClassBuilder {
	return &ClassBuilder{
		type:     type_
		php_name: php_name
		c_name:   c_name
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

pub fn (mut b ClassBuilder) set_uses_inherited_object(enabled bool) &ClassBuilder {
	b.uses_inherited_object = enabled
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

pub fn (mut b ClassBuilder) add_method(php_name string, c_func string, return_type string, php_return_type string, flags string, args []ClassMethodArg) &ClassBuilder {
	return b.add_method_spec(php_name, c_func, new_return_spec(return_type, php_return_type,
		''), flags, args)
}

pub fn (mut b ClassBuilder) add_method_with_return_obj(php_name string, c_func string, return_type string, php_return_type string, return_obj_type string, flags string, args []ClassMethodArg) &ClassBuilder {
	return b.add_method_spec(php_name, c_func, new_return_spec(return_type, php_return_type,
		return_obj_type), flags, args)
}

pub fn (mut b ClassBuilder) add_method_spec(php_name string, c_func string, return_spec ReturnSpec, flags string, args []ClassMethodArg) &ClassBuilder {
	b.methods << ClassMethod{
		php_name:    php_name
		c_func:      c_func
		return_spec: return_spec
		flags:       flags
		is_abstract: false
		args:        args
	}
	return b
}

pub fn (mut b ClassBuilder) add_attribute(name string, args []ClassAttributeArg) &ClassBuilder {
	b.attributes << ClassAttribute{
		name: name
		args: args
	}
	return b
}

pub fn (mut b ClassBuilder) add_abstract_method(php_name string, c_func string, return_type string, php_return_type string, flags string, args []ClassMethodArg) &ClassBuilder {
	return b.add_abstract_method_spec(php_name, c_func, new_return_spec(return_type, php_return_type,
		''), flags, args)
}

pub fn (mut b ClassBuilder) add_abstract_method_with_return_obj(php_name string, c_func string, return_type string, php_return_type string, return_obj_type string, flags string, args []ClassMethodArg) &ClassBuilder {
	return b.add_abstract_method_spec(php_name, c_func, new_return_spec(return_type, php_return_type,
		return_obj_type), flags, args)
}

pub fn (mut b ClassBuilder) add_abstract_method_spec(php_name string, c_func string, return_spec ReturnSpec, flags string, args []ClassMethodArg) &ClassBuilder {
	b.methods << ClassMethod{
		php_name:    php_name
		c_func:      c_func
		return_spec: return_spec
		flags:       flags
		is_abstract: true
		args:        args
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

fn (b &ClassBuilder) registration_func_name() string {
	return '${b.c_name.to_lower()}_register_class'
}

fn (b &ClassBuilder) render_registration_function() string {
	mut res := []string{}
	lower_name := b.c_name.to_lower()
	ce_ptr := b.ce_var_name()
	self_name := c_string_escape(normalize_php_type_literal(b.php_name))

	res << 'static int ${b.registration_func_name()}(void) {'
	res << '    if (${ce_ptr} != NULL) {'
	res << '        return SUCCESS;'
	res << '    }'
	res << '    ${ce_ptr} = vphp_find_loaded_class_entry("${self_name}", sizeof("${self_name}")-1);'
	res << '    if (${ce_ptr} != NULL) {'
	res << '        return SUCCESS;'
	res << '    }'

	match b.type {
		.enum_ {
			res << '    ${ce_ptr} = zend_register_internal_enum("${b.php_name}", IS_LONG, NULL);'
			for con in b.constants {
				res << '    { zval _ev; ZVAL_LONG(&_ev, ${con.value}); zend_enum_add_case_cstr(${ce_ptr}, "${con.name}", &_ev); }'
			}
			res << '    return SUCCESS;'
			res << '}'
			return res.join('\n')
		}
		else {
			res << '    {   zend_class_entry ce;'
			res << '        INIT_CLASS_ENTRY(ce, "${b.php_name}", ${lower_name}_methods);'

			match b.type {
				.interface_ {
					res << '        ${ce_ptr} = zend_register_internal_interface(&ce);'
				}
				else {
					if b.parent != '' {
						parent_display := b.parent.replace('\\', '\\\\')
						parent_name := c_string_escape(normalize_php_type_literal(b.parent))
						res << '        zend_class_entry *parent_ce = vphp_require_class_entry("${parent_name}", sizeof("${parent_name}")-1, 0);'
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
		}
	}

	if b.class_flags.len > 0 {
		res << '        ${ce_ptr}->ce_flags |= ${b.class_flags.join(' | ')};'
	}
	if b.create_object {
		res << '        ${ce_ptr}->create_object = vphp_create_object_handler;'
	} else if b.type == .class_ && b.uses_inherited_object {
		res << '        ${ce_ptr}->create_object = vphp_create_inherited_object_handler;'
	}
	if b.interfaces.len > 0 {
		mut args := []string{}
		for i, iface in b.interfaces {
			iface_display := iface.replace('\\', '\\\\')
			iface_name := c_string_escape(normalize_php_type_literal(iface))
			iface_var := 'iface_${i}_ce'
			res << '        zend_class_entry *${iface_var} = vphp_require_class_entry("${iface_name}", sizeof("${iface_name}")-1, 0);'
			res << '        if (!${iface_var}) {'
			res << '            vphp_throw("interface ${iface_display} not found for ${b.php_name}", 0);'
			res << '            return FAILURE;'
			res << '        }'
			args << iface_var
		}
		if args.len == 1 {
			res << '        zend_class_implements(${ce_ptr}, 1, ${args[0]});'
		} else {
			res << '        zend_class_implements(${ce_ptr}, ${args.len}, ${args.join(', ')});'
		}
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
		for i, attr in b.attributes {
			attr_var := 'attribute_${lower_name}_${i}'
			attr_name_var := '${attr_var}_name'
			res << '        zend_string *${attr_name_var} = zend_string_init_interned("${c_string_escape(attr.name)}", sizeof("${c_string_escape(attr.name)}")-1, 1);'
			res << '        zend_attribute *${attr_var} = zend_add_class_attribute(${ce_ptr}, ${attr_name_var}, ${attr.args.len});'
			res << '        zend_string_release(${attr_name_var});'
			for j, arg in attr.args {
				match arg.kind {
					'string' {
						res << '        ZVAL_STR(&${attr_var}->args[${j}].value, zend_string_init_interned("${c_string_escape(arg.value)}", sizeof("${c_string_escape(arg.value)}")-1, 1));'
					}
					'bool' {
						res << '        ZVAL_BOOL(&${attr_var}->args[${j}].value, ${if arg.value == 'true' {
							'1'
						} else {
							'0'
						}});'
					}
					'float' {
						res << '        ZVAL_DOUBLE(&${attr_var}->args[${j}].value, ${arg.value});'
					}
					'int' {
						res << '        ZVAL_LONG(&${attr_var}->args[${j}].value, ${arg.value});'
					}
					'null' {
						res << '        ZVAL_NULL(&${attr_var}->args[${j}].value);'
					}
					else {
						res << '        ZVAL_STR(&${attr_var}->args[${j}].value, zend_string_init_interned("${c_string_escape(arg.value)}", sizeof("${c_string_escape(arg.value)}")-1, 1));'
					}
				}
			}
		}
	}

	res << '    }'
	res << '    return SUCCESS;'
	res << '}'
	return res.join('\n')
}

pub fn (b &ClassBuilder) render_impl_prelude() string {
	return '${b.render_ce_declaration()}\n${b.render_arginfo_defs()}'
}

pub fn (b &ClassBuilder) render_impl_postlude() string {
	return '${b.render_methods_array()}\n${b.render_registration_function()}'
}

fn arg_type_info(v_type string) ArgTypeInfo {
	decl := parse_php_type_decl(v_type)
	clean := decl.clean
	allow_null := decl.allow_null
	if builtin := php_builtin_type_info(v_type) {
		return ArgTypeInfo{
			code:           builtin.code
			mask:           builtin.mask
			mask_obj_class: builtin.mask_obj_class
			allow_null:     allow_null
		}
	}
	code := match clean {
		'[]string', '[]int', '[]i64', '[]bool', '[]f64', '[]f32', '[]', '[]vphp.ZVal', '[]ZVal' {
			'IS_ARRAY'
		}
		'map[string]string', 'map[string]int', 'map[string]i64', 'map[string]bool',
		'map[string]f64', 'map[string][]string', 'map[string]vphp.ZVal', 'map[string]ZVal' {
			'IS_ARRAY'
		}
		'vphp.ZVal', 'ZVal', 'vphp.RequestBorrowedZBox', 'RequestBorrowedZBox',
		'vphp.RequestOwnedZBox', 'RequestOwnedZBox', 'vphp.PersistentOwnedZBox',
		'PersistentOwnedZBox' {
			'IS_MIXED'
		}
		'callable', 'Callable', 'vphp.Callable' {
			'IS_CALLABLE'
		}
		else {
			''
		}
	}
	return ArgTypeInfo{
		code:           code
		mask:           ''
		mask_obj_class: ''
		allow_null:     allow_null
	}
}

fn method_has_literal_class_arg(m ClassMethod) bool {
	for arg in m.args {
		raw_type := if arg.php_type != '' { arg.php_type } else { arg.type_ }
		if is_class_literal_type(raw_type) {
			return true
		}
	}
	return false
}

fn method_arginfo_header(m ClassMethod) string {
	resolved_return_type := m.return_spec.resolved_type()
	type_info := arg_type_info(resolved_return_type)
	return render_method_arginfo_header(m.c_func, m.php_name, method_required_args(m),
		resolved_return_type, m.return_spec.arginfo_obj_type(), type_info, method_has_literal_class_arg(m))
}

fn method_required_args(m ClassMethod) int {
	mut required := m.args.len
	for required > 0 {
		last := m.args[required - 1]
		if last.is_optional {
			required--
			continue
		}
		break
	}
	return required
}

fn c_string_escape(s string) string {
	return s.replace('\\', '\\\\').replace('"', '\\"')
}

fn normalize_php_type_literal(name string) string {
	if name == '' {
		return name
	}
	return name.replace('\\\\', '\\')
}

pub fn (b &ClassBuilder) render_arginfo_defs() string {
	mut res := []string{}
	for m in b.methods {
		res << method_arginfo_header(m)
		for arg in m.args {
			raw_type := if arg.php_type != '' { arg.php_type } else { arg.type_ }
			validate_php_arg_type_or_panic(raw_type, arg.name, m.php_name)
			res << render_arginfo_arg_line(arg.name, raw_type)
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
	return 'if (${b.registration_func_name()}() != SUCCESS) { return FAILURE; }'
}

pub fn (b &ClassBuilder) export_fragments() ExportFragments {
	return ExportFragments{
		declarations: [b.render_ce_extern_declaration()]
		minit_lines:  [b.render_minit()]
	}
}
