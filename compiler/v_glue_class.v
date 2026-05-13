module compiler

import compiler.repr

// ---- Class V Glue ----
fn (g VGenerator) gen_class_glue(r &repr.PhpClassRepr) []string {
	mut out := []string{}
	lower_name := r.name.to_lower()
	uses_inherited_receiver := class_uses_inherited_receiver(r)

	// A. 堆分配器
	out << "@[export: '${r.name}_new_raw']"
	out << 'pub fn ${lower_name}_new_raw() voidptr {'
	out << '    return vphp.generic_new_raw[${r.name}]()'
	out << '}'
	out << "@[export: '${r.name}_free_raw']"
	out << 'pub fn ${lower_name}_free_raw(ptr voidptr) {'
	out << '    if ptr == 0 {'
	out << '        return'
	out << '    }'
	out << '    vphp.generic_free_raw[${r.name}](ptr)'
	out << '}'
	out << "@[export: '${r.name}_cleanup_raw']"
	out << 'pub fn ${lower_name}_cleanup_raw(ptr voidptr) {'
	out << '    if ptr == 0 {'
	out << '        return'
	out << '    }'
	if r.has_cleanup_method || r.has_free_method {
		out << '    unsafe {'
		out << '        mut obj := &${r.name}(ptr)'
		if r.has_cleanup_method {
			out << '        obj.cleanup()'
		}
		if r.has_free_method {
			out << '        obj.free()'
		}
		out << '    }'
	}
	out << '}'

	if uses_inherited_receiver {
		out << 'fn ${lower_name}_load_from_php(php_obj vphp.ZendObject) ${r.name} {'
		zval_fields := r.properties.filter(!it.is_property_only && !it.is_static
			&& is_internal_parent_zval_field(it.v_type))
		if zval_fields.len == 0 {
			out << '    mut recv := ${r.name}{}'
		} else {
			out << '    mut recv := ${r.name}{'
			for prop in zval_fields {
				out << '        ${prop.v_field_name}: vphp.ZVal.new_null()'
			}
			out << '    }'
		}
		out << '    if !php_obj.is_valid() {'
		out << '        return recv'
		out << '    }'
		for prop in r.properties {
			if prop.is_static {
				continue
			}
			if prop.is_property_only {
				continue
			}
			if !is_internal_parent_scalar_field(prop.v_type)
				&& !is_internal_parent_zval_field(prop.v_type) {
				continue
			}
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
				'vphp.ZVal', 'ZVal' {}
				else {}
			}
		}
		out << '    return recv'
		out << '}'
		out << 'fn ${lower_name}_sync_to_php(php_obj vphp.ZendObject, recv ${r.name}) {'
		out << '    if !php_obj.is_valid() {'
		out << '        return'
		out << '    }'
		for prop in r.properties {
			if prop.is_static {
				continue
			}
			if prop.is_property_only {
				continue
			}
			if !is_internal_parent_scalar_field(prop.v_type) {
				continue
			}
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
		}
		out << '}'
	}

	out << ClassPropertyGlue.new(r.name, lower_name, r.properties).render_lines()

	// F. 影子访问器
	if r.shadow_const_name != '' {
		ret_type := if r.shadow_const_type != '' { r.shadow_const_type } else { 'voidptr' }
		out << 'pub fn ${r.name}.consts() ${ret_type} {'
		out << '    return ${r.shadow_const_name}'
		out << '}'
	}
	if r.shadow_static_name != '' {
		type_name := if r.shadow_static_type != '' {
			r.shadow_static_type
		} else {
			r.shadow_static_name.title()
		}
		out << 'pub fn ${r.name}.statics() &${type_name} {'
		out << '    return &${r.shadow_static_name}'
		out << '}'

		// 生成同步器：利用 ctx 自动识别 CE

		out << 'pub fn ${r.name}.sync_statics_to_php(ctx vphp.Context) {'
		out << '    ce := ctx.active_class_entry()'
		out << '    if !ce.is_valid() { return }'
		for prop in r.properties {
			if prop.is_static {
				out << '    ce.set_static_prop("${prop.name}", ${r.shadow_static_name}.${prop.name})'
			}
		}
		out << '}'

		out << 'pub fn ${r.name}.sync_statics_from_php(ctx vphp.Context) {'
		out << '    ce := ctx.active_class_entry()'
		out << '    if !ce.is_valid() { return }'
		out << '    mut s := ${r.name}.statics()'
		for prop in r.properties {
			if prop.is_static {
				out << '    s.${prop.name} = ce.static_prop[${prop.v_type}]("${prop.name}")'
			}
		}
		out << '}'
	}

	// G. 方法的胶水包装
	for m in r.methods {
		if m.has_export {
			continue
		}

		glue_name := if m.v_name != '' { m.v_name } else { m.name }
		return_type := m.return_spec.effective_v_type()
		struct_closure := StructClosureBinding.new('${r.name}_${glue_name}', return_type,
			g.params_structs)
		if closure_binding := struct_closure {
			out << closure_binding.render_helper_lines()
		}

		return_info := method_runtime_return_info(r.name, m.name, m.is_static, return_type,
			m.borrowed_return)
		return_binding := ReturnBinding.new_with_struct_closure(return_type, struct_closure)
		returns_object := return_info.kind in [.static_factory, .static_object, .instance_object]
		ret_decl := if returns_object { 'voidptr' } else { '' }

		out << "@[export: 'vphp_wrap_${r.name}_${glue_name}']"
		if m.is_static {
			out << 'pub fn vphp_wrap_${lower_name}_${glue_name}(ctx vphp.Context) ${ret_decl} {'
		} else {
			out << 'pub fn vphp_wrap_${lower_name}_${glue_name}(ptr voidptr, ctx vphp.Context) ${ret_decl} {'
			if uses_inherited_receiver {
				out << '    this_obj := vphp.ZendObject.from_ptr(ptr)'
				out << '    mut recv := ${lower_name}_load_from_php(this_obj)'
			} else {
				out << '    mut recv := unsafe { &${r.name}(ptr) }'
			}
		}
		out << '    mut vphp_scope := vphp.PhpScope.once()'
		out << '    defer { vphp_scope.close() }'

		arg_setup := build_php_arg_setup(m.args, returns_object, true)
		out << arg_setup.lines
		arg_names := arg_setup.names

		call_args := arg_names.join(', ')
		v_name := if m.v_name != '' { m.v_name } else { m.name }
		v_call_name := if is_v_keyword(v_name) { '@' + v_name } else { v_name }

		call_str := if m.is_static {
			'${r.name}.${v_call_name}(${call_args})'
		} else {
			if uses_inherited_receiver {
				'recv.${v_call_name}(${call_args})'
			} else {
				'recv.${v_call_name}(${call_args})'
			}
		}

		if r.shadow_static_name != '' {
			out << '    ${r.name}.sync_statics_from_php(ctx)'
		}

		method_ctx := ClassMethodGlueContext{
			class_name:              r.name
			lower_name:              lower_name
			shadow_static_name:      r.shadow_static_name
			is_static:               m.is_static
			uses_inherited_receiver: uses_inherited_receiver
			returns_object:          returns_object
			return_type:             return_type
			call_expr:               call_str
			arg_names:               arg_names
			return_binding:          return_binding
		}
		out << method_ctx.render_return_lines()
		out << '}'
	}

	// F. Handlers 导出
	out << "@[export: '${r.name}_handlers']"
	out << 'pub fn ${lower_name}_handlers() voidptr {'
	out << '    return vphp.ZendClassHandlers.new('
	out << '        prop_handler: voidptr(${lower_name}_get_prop),'
	out << '        write_handler: voidptr(${lower_name}_set_prop),'
	out << '        sync_handler: voidptr(${lower_name}_sync_props),'
	out << '        new_raw: voidptr(${lower_name}_new_raw),'
	out << '        cleanup_raw: voidptr(${lower_name}_cleanup_raw),'
	out << '        free_raw: voidptr(${lower_name}_free_raw)'
	out << '    )'
	out << '}'

	return out
}
