module compiler

import compiler.builder
import compiler.repr

fn (g CGenerator) build_func_return_spec(f &repr.PhpFuncRepr) builder.ReturnSpec {
	return_type := f.return_spec.effective_v_type()
	return builder.new_return_spec(return_type, effective_export_php_return_type(return_type,
		f.return_spec.php_type, f.has_export), g.php_name_for_type(return_type))
}

fn (g CGenerator) build_method_return_spec(php_name string, m &repr.PhpMethodRepr) builder.ReturnSpec {
	raw_return_type := m.return_spec.effective_v_type()
	return_type := if php_name == '__construct' { '' } else { raw_return_type }
	return builder.new_return_spec(return_type, effective_export_php_return_type(return_type,
		m.return_spec.php_type, m.has_export), g.php_name_for_type(return_type))
}

fn (g CGenerator) build_func(f &repr.PhpFuncRepr) builder.FuncBuilder {
	mut args := []builder.ClassMethodArg{}
	for arg in f.args {
		if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
			continue
		}
		args << builder.ClassMethodArg{
			name:        arg.name
			type_:       arg.v_type
			php_type:    arg.php_type
			is_optional: arg.is_optional
			is_variadic: arg.is_variadic
			php_default: arg.php_default
			attributes:  php_attributes_to_builder(arg.attributes)
		}
	}
	spec := g.build_func_return_spec(f)
	mut func_builder := builder.new_func_builder_with_args(f.name, f.name, spec, args, f.uses_context)
	func_builder.table = g.table
	return *func_builder
}

fn (g CGenerator) build_global_constant(c &repr.PhpConstRepr) builder.ConstantBuilder {
	return builder.new_constant_builder(c.name, c.const_type, c.value)
}

fn class_uses_inherited_receiver(r &repr.PhpClassRepr) bool {
	return r.direct_internal_parent || r.uses_inherited_object
}

fn class_needs_inherited_object_wrapper(r &repr.PhpClassRepr, has_init bool) bool {
	if !class_uses_inherited_receiver(r) {
		return false
	}
	if has_init || r.has_free_method {
		return true
	}
	for prop in r.properties {
		if prop.is_static || prop.is_property_only {
			continue
		}
		return true
	}
	return false
}

fn visibility_to_method_flags(visibility string) string {
	return match visibility {
		'protected' { 'ZEND_ACC_PROTECTED' }
		'private' { 'ZEND_ACC_PRIVATE' }
		else { 'ZEND_ACC_PUBLIC' }
	}
}

fn visibility_to_property_flags(prop repr.PhpClassPropRepr) string {
	mut flags := visibility_to_method_flags(prop.visibility)
	if prop.is_static {
		flags += ' | ZEND_ACC_STATIC'
	}
	if !prop.is_static && !prop.is_mut {
		flags += ' | ZEND_ACC_READONLY'
	}
	return flags
}

fn method_args_to_builder(args []repr.PhpArgRepr) []builder.ClassMethodArg {
	mut out := []builder.ClassMethodArg{}
	for arg in args {
		if is_context_v_type(arg.v_type) {
			continue
		}
		php_type := if arg.php_type != '' { arg.php_type } else { '' }
		out << builder.ClassMethodArg{
			name:        arg.name
			type_:       arg.v_type
			php_type:    php_type
			is_optional: arg.is_optional
			is_variadic: arg.is_variadic
			php_default: arg.php_default
			attributes:  php_attributes_to_builder(arg.attributes)
		}
	}
	return out
}

fn is_context_v_type(v_type string) bool {
	return v_type == 'Context' || v_type == 'vphp.Context'
}

fn method_uses_context_arg(m &repr.PhpMethodRepr) bool {
	for arg in m.args {
		if is_context_v_type(arg.v_type) {
			return true
		}
	}
	return false
}

fn interface_method_args_to_builder(_iface &repr.PhpInterfaceRepr, args []repr.PhpArgRepr) []builder.ClassMethodArg {
	mut out := []builder.ClassMethodArg{}
	for i, arg in args {
		// V interface AST can carry an implicit first arg `x` (self-like placeholder).
		// Never expose it to PHP interface signatures.
		if i == 0 && arg.name == 'x' {
			continue
		}
		out << builder.ClassMethodArg{
			name:        arg.name
			type_:       arg.v_type
			php_type:    arg.php_type
			is_optional: arg.is_optional
			is_variadic: arg.is_variadic
			php_default: arg.php_default
			attributes:  php_attributes_to_builder(arg.attributes)
		}
	}
	return out
}

fn php_attributes_to_builder(attrs []repr.PhpAttributeRepr) []builder.ClassAttribute {
	mut out := []builder.ClassAttribute{}
	for attr in attrs {
		mut args := []builder.ClassAttributeArg{}
		for arg in attr.args {
			args << builder.ClassAttributeArg{
				kind:  arg.kind
				name:  arg.name
				value: arg.value
			}
		}
		out << builder.ClassAttribute{
			name: attr.name
			args: args
		}
	}
	return out
}

fn (g CGenerator) build_interface_type(r &repr.PhpInterfaceRepr) &builder.ClassBuilder {
	mut class_builder := builder.new_interface_builder(r.php_name, r.c_name())
	class_builder.table = g.table
	for iface in r.extends {
		class_builder.add_interface(iface)
	}
	for m in r.methods {
		c_func := if m.v_c_func != '' {
			m.v_c_func.to_lower()
		} else {
			'${r.c_name().to_lower()}_${m.v_name}'
		}
		php_name := php_method_name(m.name)
		spec := g.build_method_return_spec(php_name, m)
		class_builder.add_abstract_method_spec(php_name, c_func, spec,

			visibility_to_method_flags(m.visibility) + ' | ZEND_ACC_ABSTRACT', interface_method_args_to_builder(r,
			m.args))
	}
	return class_builder
}

fn (g CGenerator) build_enum_type(r &repr.PhpEnumRepr) &builder.ClassBuilder {
	mut class_builder := builder.new_enum_builder(r.php_name, r.c_name())
	class_builder.set_v_name(r.name)
	class_builder.table = g.table
	// PHP 8.1 native enum: no ZEND_ACC_FINAL, no __construct, no class constants.
	// Cases are added via zend_enum_add_case_cstr() in MINIT (see builder render_minit).
	// We store cases as constants in the builder so render_minit can iterate them.
	for case_ in r.cases {
		class_builder.add_constant(case_.name, 'int', case_.value)
	}
	return class_builder
}

fn (g CGenerator) build_class_type(r &repr.PhpClassRepr, has_init bool) &builder.ClassBuilder {
	mut class_builder := builder.new_class_builder(r.php_name, r.c_name())
	class_builder.table = g.table
	needs_inherited_wrapper := class_needs_inherited_object_wrapper(r, has_init)
	class_builder.set_parent(r.parent)
	class_builder.set_uses_inherited_object(needs_inherited_wrapper)
	if class_uses_inherited_receiver(r) {
		class_builder.set_create_object(false)
	}
	if r.is_abstract {
		class_builder.add_class_flag('ZEND_ACC_EXPLICIT_ABSTRACT_CLASS')
	}
	mut has_non_static := false
	mut all_readonly := true
	for prop in r.properties {
		if prop.is_static {
			continue
		}
		has_non_static = true
		if prop.is_mut {
			all_readonly = false
			break
		}
	}
	if has_non_static && all_readonly {
		class_builder.add_class_flag('ZEND_ACC_READONLY_CLASS')
	}
	for iface in r.internal_implements {
		class_builder.add_interface(iface)
	}
	for con in r.constants {
		class_builder.add_constant(con.name, con.const_type, con.value)
	}
	for prop in r.properties {
		class_builder.add_property(prop.name, prop.v_type, visibility_to_property_flags(prop))
	}
	if !has_init && !class_uses_inherited_receiver(r) {
		class_builder.add_method('__construct', '${r.c_name().to_lower()}___construct', '', '',
			'ZEND_ACC_PUBLIC', []builder.ClassMethodArg{})
	}
	for m in r.methods {
		php_name := php_method_name(m.name)
		mut flags := visibility_to_method_flags(m.visibility)
		if m.is_static {
			flags += ' | ZEND_ACC_STATIC'
		}
		c_func := if m.v_c_func != '' {
			m.v_c_func.to_lower()
		} else {
			'${r.c_name().to_lower()}_${m.v_name}'
		}
		spec := g.build_method_return_spec(php_name, m)
		uses_context_arg := method_uses_context_arg(m)
		if m.is_abstract {
			class_builder.add_abstract_method_spec_with_context(php_name, c_func, spec, flags +
				' | ZEND_ACC_ABSTRACT', method_args_to_builder(m.args), uses_context_arg)
		} else {
			class_builder.add_method_spec_with_context(php_name, c_func, spec, flags,
				method_args_to_builder(m.args), uses_context_arg)
		}
	}
	for attr in r.attributes {
		mut args := []builder.ClassAttributeArg{}
		for arg in attr.args {
			args << builder.ClassAttributeArg{
				kind:  arg.kind
				value: arg.value
			}
		}
		class_builder.add_attribute(attr.name, args)
	}
	return class_builder
}
