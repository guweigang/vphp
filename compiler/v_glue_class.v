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
		out << 'fn ${lower_name}_load_from_php(obj &C.zend_object) ${r.name} {'
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
		out << '    if obj == 0 {'
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
			out << '    mut rv_${prop.name} := C.zval{}'
			out << "    prop_${prop.name} := C.vphp_read_property_compat(obj, c'${prop.name}', '${prop.name}'.len, &rv_${prop.name})"
			out << '    if prop_${prop.name} != 0 {'
			out << '        value_${prop.name} := vphp.ZVal{ raw: prop_${prop.name} }'
			match prop.v_type {
				'string' {
					out << '        if !value_${prop.name}.is_null() && !value_${prop.name}.is_undef() {'
					out << '            recv.${prop.v_field_name} = value_${prop.name}.to_string()'
					out << '        }'
				}
				'int' {
					out << '        if !value_${prop.name}.is_null() && !value_${prop.name}.is_undef() {'
					out << '            recv.${prop.v_field_name} = int(value_${prop.name}.to_i64())'
					out << '        }'
				}
				'i64' {
					out << '        if !value_${prop.name}.is_null() && !value_${prop.name}.is_undef() {'
					out << '            recv.${prop.v_field_name} = value_${prop.name}.to_i64()'
					out << '        }'
				}
				'bool' {
					out << '        if !value_${prop.name}.is_null() && !value_${prop.name}.is_undef() {'
					out << '            recv.${prop.v_field_name} = value_${prop.name}.to_bool()'
					out << '        }'
				}
				'f64' {
					out << '        if !value_${prop.name}.is_null() && !value_${prop.name}.is_undef() {'
					out << '            recv.${prop.v_field_name} = value_${prop.name}.to_f64()'
					out << '        }'
				}
				'vphp.ZVal', 'ZVal' {}
				else {}
			}
			out << '    }'
		}
		out << '    return recv'
		out << '}'
		out << 'fn ${lower_name}_sync_to_php(obj &C.zend_object, recv ${r.name}) {'
		out << '    if obj == 0 {'
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
					out << "    C.vphp_write_property_compat(obj, c'${prop.name}', '${prop.name}'.len, prop_${prop.name}.raw)"
				}
				'int', 'i64' {
					out << '    mut prop_${prop.name} := vphp.RequestOwnedZBox.new_int(i64(recv.${prop.v_field_name})).to_zval()'
					out << "    C.vphp_write_property_compat(obj, c'${prop.name}', '${prop.name}'.len, prop_${prop.name}.raw)"
				}
				'bool' {
					out << '    mut prop_${prop.name} := vphp.RequestOwnedZBox.new_bool(recv.${prop.v_field_name}).to_zval()'
					out << "    C.vphp_write_property_compat(obj, c'${prop.name}', '${prop.name}'.len, prop_${prop.name}.raw)"
				}
				'f64' {
					out << '    mut prop_${prop.name} := vphp.RequestOwnedZBox.new_float(recv.${prop.v_field_name}).to_zval()'
					out << "    C.vphp_write_property_compat(obj, c'${prop.name}', '${prop.name}'.len, prop_${prop.name}.raw)"
				}
				else {}
			}
		}
		out << '}'
	}

	mut has_readable_props := false
	mut has_writable_props := false
	mut has_syncable_props := false
	for prop in r.properties {
		if prop.is_static || prop.visibility != 'public' {
			continue
		}
		if prop.is_property_only {
			continue
		}
		match prop.v_type {
			'string', 'int', 'i64', 'bool', 'f64' {
				has_readable_props = true
				has_syncable_props = true
				if prop.is_mut {
					has_writable_props = true
				}
			}
			else {}
		}
	}

	// B. 属性读取
	out << "@[export: '${r.name}_get_prop']"
	out << 'pub fn ${lower_name}_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {'
	if !has_readable_props {
		out << '    _ = ptr'
		out << '    _ = name_ptr'
		out << '    _ = name_len'
		out << '    _ = rv'
	} else {
		out << '    unsafe {'
		out << '        name := name_ptr.vstring_with_len(name_len).clone()'
		out << '        obj := &${r.name}(ptr)'
		for prop in r.properties {
			if prop.is_static || prop.visibility != 'public' || prop.is_property_only {
				continue
			}
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
		}
		out << '    }'
	}
	out << '}'

	// C. 属性写入
	out << "@[export: '${r.name}_set_prop']"
	out << 'pub fn ${lower_name}_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {'
	if !has_writable_props {
		out << '    _ = ptr'
		out << '    _ = name_ptr'
		out << '    _ = name_len'
		out << '    _ = value'
	} else {
		out << '    unsafe {'
		out << '        name := name_ptr.vstring_with_len(name_len).clone()'
		out << '        mut obj := &${r.name}(ptr)'
		out << '        arg := vphp.ZVal{ raw: value }'
		for prop in r.properties {
			if prop.is_static || prop.visibility != 'public' || prop.is_property_only
				|| !prop.is_mut {
				continue
			}
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
		}
		out << '    }'
	}
	out << '}'

	// E. 同步器
	out << "@[export: '${r.name}_sync_props']"
	out << 'pub fn ${lower_name}_sync_props(ptr voidptr, zv &C.zval) {'
	if !has_syncable_props {
		out << '    _ = ptr'
		out << '    _ = zv'
	} else {
		out << '    unsafe {'
		out << '        obj := &${r.name}(ptr)'
		out << '        out := vphp.ZVal{ raw: zv }'
		for prop in r.properties {
			if prop.is_static || prop.visibility != 'public' || prop.is_property_only {
				continue
			}
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
		}
		out << '    }'
	}
	out << '}'

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
		out << '    ce := ctx.get_ce()'
		out << '    if ce == voidptr(0) { return }'
		for prop in r.properties {
			if prop.is_static {
				out << '    vphp.set_static_prop(ce, "${prop.name}", ${r.shadow_static_name}.${prop.name})'
			}
		}
		out << '}'

		out << 'pub fn ${r.name}.sync_statics_from_php(ctx vphp.Context) {'
		out << '    ce := ctx.get_ce()'
		out << '    if ce == voidptr(0) { return }'
		out << '    mut s := ${r.name}.statics()'
		for prop in r.properties {
			if prop.is_static {
				out << '    s.${prop.name} = vphp.get_static_prop[${prop.v_type}](ce, "${prop.name}")'
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
		out << "@[export: 'vphp_wrap_${r.name}_${glue_name}']"
		return_type := m.return_spec.effective_v_type()

		return_info := method_runtime_return_info(r.name, m.name, m.is_static, return_type,
			m.borrowed_return)
		is_result := return_info.kind == .result
		is_option := return_info.kind == .option
		// Result/Option 类型在 V glue 侧通过 or{} 处理，C 侧不返回值
		effective_return := if is_result {
			return_type[1..]
		} else if is_option {
			return_type[1..]
		} else {
			return_type
		}
		returns_object := return_info.kind in [.static_factory, .static_object, .instance_object]
		ret_decl := if returns_object { 'voidptr' } else { '' }

		if m.is_static {
			out << 'pub fn vphp_wrap_${lower_name}_${glue_name}(ctx vphp.Context) ${ret_decl} {'
		} else {
			out << 'pub fn vphp_wrap_${lower_name}_${glue_name}(ptr voidptr, ctx vphp.Context) ${ret_decl} {'
			if uses_inherited_receiver {
				out << '    this_obj := unsafe { &C.zend_object(ptr) }'
				out << '    mut recv := ${lower_name}_load_from_php(this_obj)'
			} else {
				out << '    mut recv := unsafe { &${r.name}(ptr) }'
			}
		}
		out << '    vphp_ar_mark := vphp.autorelease_mark()'
		out << '    defer { vphp.autorelease_drain(vphp_ar_mark) }'

		mut arg_names := []string{}
		for i, arg in m.args {
			var_name := 'arg_${i}'
			tm := TypeMap.get_type(arg.v_type)
			if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
				out << '    ${var_name} := ctx'
			} else if arg.v_type == 'vphp.ZVal' || arg.v_type == 'ZVal' {
				out << '    ${var_name} := ctx.arg_raw(${i})'
			} else if arg.v_type == 'Callable' || arg.v_type == 'vphp.Callable' {
				// Callable is a ZVal alias — read as raw ZVal for callable params
				out << '    ${var_name} := ctx.arg_raw(${i})'
			} else if arg.v_type == 'RequestBorrowedZBox'
				|| arg.v_type == 'vphp.RequestBorrowedZBox' {
				out << '    ${var_name} := ctx.arg_borrowed_zbox(${i})'
			} else if arg.v_type == 'RequestOwnedZBox' || arg.v_type == 'vphp.RequestOwnedZBox' {
				out << '    ${var_name} := ctx.arg_owned_request_zbox(${i})'
			} else if arg.v_type == 'PersistentOwnedZBox'
				|| arg.v_type == 'vphp.PersistentOwnedZBox' {
				out << '    ${var_name} := ctx.arg_owned_persistent_zbox(${i})'
			} else if semantic_arg_lines := gen_semantic_arg_lines(var_name, arg.v_type,
				i, returns_object)
			{
				out << semantic_arg_lines
			} else if arg.v_type.starts_with('?') {
				out << '    ${var_name} := ctx.arg_opt[${arg.v_type[1..]}](${i})'
			} else if tm.c_type == 'void*' {
				v_type := if arg.v_type.starts_with('&') { arg.v_type } else { '&' + arg.v_type }
				out << '    ${var_name} := unsafe { ${v_type}(ctx.arg_raw_obj(${i})) }'
			} else {
				// Ownership-aware signatures like `RequestBorrowedZBox` flow through
				// the generic `ctx.arg[T]` path and stay as the preferred generated
				// glue shape. `ZVal`/`Callable` remain the explicit low-level escape
				// hatches above.
				out << '    ${var_name} := ctx.arg[${arg.v_type}](${i})'
			}
			arg_names << var_name
		}

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

		if is_result {
			// Result 类型：通过运行时 helper 桥接 V error → PHP exception
			// 构建闭包捕获列表
			mut captures := arg_names.clone()
			if m.is_static {
				// 静态方法无需捕获 recv
			} else {
				captures << 'recv'
			}
			capture_list := if captures.len > 0 { captures.join(', ') } else { '' }

			if effective_return == '' || effective_return == 'void' {
				// !void: fn () !
				out << '    vphp.call_or_throw(fn [${capture_list}] () ! {'
				out << '        ${call_str}!'
				out << '    })'
			} else {
				// !T: fn () !T
				out << '    vphp.call_or_throw_val[${effective_return}](fn [${capture_list}] () !${effective_return} {'
				out << '        return ${call_str}!'
				out << '    }, ctx)'
			}
			if r.shadow_static_name != '' {
				out << '    ${r.name}.sync_statics_to_php(ctx)'
			}
		} else if is_option {
			// Option 类型：通过运行时 helper 桥接 V none → PHP null
			// 构建闭包捕获列表
			mut captures := arg_names.clone()
			if m.is_static {
				// 静态方法无需捕获 recv
			} else {
				captures << 'recv'
			}
			capture_list := if captures.len > 0 { captures.join(', ') } else { '' }

			if effective_return == '' || effective_return == 'void' {
				// ?void: fn () ? — V option 自动传播，无需 ? 后缀
				out << '    vphp.call_or_null(fn [${capture_list}] () ? {'
				out << '        ${call_str}'
				out << '    }, ctx)'
			} else {
				// ?T: fn () ?T — V option 自动传播，无需 ? 后缀
				out << '    vphp.call_or_null_val[${effective_return}](fn [${capture_list}] () ?${effective_return} {'
				out << '        return ${call_str}'
				out << '    }, ctx)'
			}
			if r.shadow_static_name != '' {
				out << '    ${r.name}.sync_statics_to_php(ctx)'
			}
		} else if return_type == 'void' {
			out << '    ${call_str}'
			if uses_inherited_receiver && !m.is_static {
				out << '    ${lower_name}_sync_to_php(this_obj, recv)'
			}
			if r.shadow_static_name != '' {
				out << '    ${r.name}.sync_statics_to_php(ctx)'
			}
			if returns_object {
				if m.is_static {
					out << '    return voidptr(0)'
				} else if uses_inherited_receiver {
					out << '    return voidptr(this_obj)'
				} else {
					out << '    return ptr'
				}
			}
		} else {
			out << '    res := ${call_str}'
			if uses_inherited_receiver && !m.is_static {
				out << '    ${lower_name}_sync_to_php(this_obj, recv)'
			}
			if r.shadow_static_name != '' {
				out << '    ${r.name}.sync_statics_to_php(ctx)'
			}
			universal_helper := closure_universal_helper_for(effective_return)
			if effective_return.contains('fn') || universal_helper != '' {
				// Handle functions that return V closures. Use the same
				// concrete-helper emission strategy as for top-level functions
				// to avoid emitting generic bracketed forms that can trigger
				// V compiler alias/signature handling bugs.
				out << '    // Returned value is a closure type: wrap using concrete helper'
				mut helper := universal_helper
				if helper == '' {
					em_params := if effective_return.contains('fn (') {
						effective_return.all_after('fn (').all_before(')')
					} else {
						''
					}
					em_ret := if effective_return.contains(') ') {
						effective_return.all_after(') ').trim_space()
					} else {
						''
					}
					mut em_arity := if em_params.trim_space() == '' {
						0
					} else {
						em_params.split(',').len
					}
					if em_arity > 4 {
						em_arity = 4
					}
					helper = 'wrap_closure_universal_0'
					if em_ret == 'void' {
						helper = 'wrap_closure_universal_0_void'
					}
					if em_arity == 1 {
						helper = if em_ret == 'void' {
							'wrap_closure_universal_1_void'
						} else {
							'wrap_closure_universal_1'
						}
					} else if em_arity == 2 {
						helper = if em_ret == 'void' {
							'wrap_closure_universal_2_void'
						} else {
							'wrap_closure_universal_2'
						}
					} else if em_arity == 3 {
						helper = if em_ret == 'void' {
							'wrap_closure_universal_3_void'
						} else {
							'wrap_closure_universal_3'
						}
					} else if em_arity == 4 {
						helper = if em_ret == 'void' {
							'wrap_closure_universal_4_void'
						} else {
							'wrap_closure_universal_4'
						}
					}
				}
				out << '    // Wrap returned V closure using explicit helper: ${helper}'
				out << '    ctx.${helper}(res)'
			} else {
				if !returns_object {
					out << '    ctx.return_val[${return_type}](res)'
				}
			}
			if returns_object {
				out << '    return voidptr(res)'
			}
		}
		out << '}'
	}

	// F. Handlers 导出
	out << "@[export: '${r.name}_handlers']"
	out << 'pub fn ${lower_name}_handlers() voidptr {'
	out << '    return unsafe { &C.vphp_class_handlers{'
	out << '        prop_handler:  voidptr(${lower_name}_get_prop)'
	out << '        write_handler: voidptr(${lower_name}_set_prop)'
	out << '        sync_handler:  voidptr(${lower_name}_sync_props)'
	out << '        new_raw:       voidptr(${lower_name}_new_raw)'
	out << '        cleanup_raw:   voidptr(${lower_name}_cleanup_raw)'
	out << '        free_raw:      voidptr(${lower_name}_free_raw)'
	out << '    } }'
	out << '}'

	return out
}
