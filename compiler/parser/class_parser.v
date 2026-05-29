module parser

import v.ast
import compiler.repr

pub fn parse_class_decl(stmt ast.Stmt, table &ast.Table, module_name string) ?&repr.PhpClassRepr {
	if stmt !is ast.StructDecl {
		return none
	}
	struct_decl := stmt as ast.StructDecl
	if struct_decl.attrs.any(it.name == 'php_ignore') {
		return none
	}
	mut cls := repr.new_class_repr()
	if !struct_decl.attrs.any(it.name == 'php_class' || it.name == 'php_trait') {
		return none
	}
	cls.is_trait = struct_decl.attrs.any(it.name == 'php_trait')

	cls.name = struct_decl.name.all_after_last('.')
	cls.module_name = module_name
	if attr := struct_decl.attrs.find_first(if cls.is_trait { 'php_trait' } else { 'php_class' }) {
		cls.php_name = if attr.arg != '' { attr.arg } else { cls.name }
	} else {
		cls.php_name = cls.name
	}
	if attr := struct_decl.attrs.find_first('php_extends') {
		cls.parent = normalize_attr_value(attr.arg)
	}
	mut php_prop_map := map[string]string{}
	for attr in struct_decl.attrs {
		if attr.name == 'php_const' {
			cls.shadow_const_name = attr.arg
		} else if attr.name == 'php_static' {
			cls.shadow_static_name = attr.arg
		} else if attr.name == 'php_abstract' {
			cls.is_abstract = true
		} else if attr.name == 'php_implements' {
			cls.implements_attr << parse_attr_list(attr.arg)
		} else if attr.name == 'php_prop' {
			if php_prop := parse_php_prop_attr(attr.arg) {
				cls.properties << php_prop
			}
		} else if attr.name == 'php_attr' {
			if php_attr := parse_php_attr(attr.arg) {
				cls.attributes << php_attr
			}
		} else if attr.name == 'php_prop_map' {
			for v_field_name, php_prop_name in parse_php_prop_map(attr.arg) {
				php_prop_map[v_field_name] = php_prop_name
			}
		}
	}
	if struct_decl.is_implements {
		for iface in struct_decl.implements_types {
			name := strip_module(table.get_type_name(iface.typ))
			if name != '' {
				cls.implements_v << name
			}
		}
	}
	for embed in struct_decl.embeds {
		embed_name := strip_module(table.get_type_name(embed.typ))
		if embed_name != '' {
			cls.embeds_v << embed_name
		}
	}
	for field in struct_decl.fields {
		if field.attrs.any(it.name == 'php_ignore') {
			continue
		}
		type_name := table.get_type_name(field.typ)
		mut is_static := field.attrs.any(it.name == 'php_static')
		mut php_prop_name := php_prop_map[field.name] or { field.name }
		if attr := field.attrs.find_first('php_prop') {
			normalized := normalize_attr_value(attr.arg)
			if normalized != '' {
				php_prop_name = normalized
			}
		}
		if attr := field.attrs.find_first('php_prop_name') {
			normalized := normalize_attr_value(attr.arg)
			if normalized != '' {
				php_prop_name = normalized
			}
		}
		if !is_static {
			for comment in field.comments {
				if comment.text.contains('@[php_static]') {
					is_static = true
					break
				}
			}
		}
		if php_prop_name == field.name {
			for comment in field.comments {
				text := comment.text
				start := text.index('@[php_prop_name:') or { continue }
				rest := text[start + '@[php_prop_name:'.len..]
				end := rest.index(']') or { continue }
				normalized := normalize_attr_value(rest[..end])
				if normalized != '' {
					php_prop_name = normalized
					break
				}
			}
		}

		cls.properties << repr.PhpClassPropRepr{
			name:             php_prop_name
			v_field_name:     field.name
			v_type:           type_name
			visibility:       if field.is_pub { 'public' } else { 'protected' }
			is_static:        is_static
			is_mut:           field.is_mut
			is_property_only: false
		}
	}
	return cls
}

pub fn add_class_method(mut cls repr.PhpClassRepr, stmt ast.FnDecl, table &ast.Table, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string, params_structs map[string]repr.PhpParamsStruct) {
	if stmt.is_method {
		if stmt.name == 'free' {
			cls.has_free_method = true
		} else if stmt.name == 'cleanup' {
			cls.has_cleanup_method = true
		}
	}
	attrs := parse_callable_attrs(stmt.attrs, 'php_method', stmt.name)
	if !attrs.has_php_callable {
		return
	}
	start_idx := if stmt.is_method { 1 } else { 0 }
	args := build_php_args(stmt.params, table, start_idx, stmt.is_variadic, attrs.php_arg_types, attrs.php_arg_names,
		attrs.php_arg_optional, attrs.php_arg_defaults, attrs.php_param_attrs, params_structs)

	ret_type := strip_module(table.type_to_str(stmt.return_type))
	inferred_borrowed := infer_borrowed_object_return(stmt, table, field_types, borrowed_methods,
		method_return_types)
	if compiler_notes_enabled() && !attrs.borrowed_return && inferred_borrowed
		&& normalize_delegated_target_type(ret_type) == cls.name {
		println('  - [Compiler][note] borrowed self-return inferred: ${cls.name}.${stmt.name} -> consider adding @[php_borrowed_return]')
	}
	mut php_return_type := attrs.php_return_type
	if stmt.is_noreturn && php_return_type == '' {
		php_return_type = 'never'
	}
	cls.methods << repr.PhpMethodRepr{
		name:            attrs.php_name
		v_name:          stmt.name
		v_c_func:        '${cls.name}_${stmt.name}'
		is_static:       false
		return_spec:     repr.new_return_repr(ret_type, php_return_type)
		borrowed_return: attrs.borrowed_return || inferred_borrowed
		visibility:      if stmt.is_pub { 'public' } else { 'protected' }
		args:            args
		has_export:      attrs.has_export
		is_abstract:     attrs.is_abstract
	}
	delegated_type, delegated_method := infer_delegated_method_ref(stmt, table, field_types)
	cls.methods[cls.methods.len - 1].delegated_target_type = delegated_type
	cls.methods[cls.methods.len - 1].delegated_target_method = delegated_method
}

pub fn add_class_static_method(mut cls repr.PhpClassRepr, stmt ast.FnDecl, table &ast.Table, method_name string, params_structs map[string]repr.PhpParamsStruct) {
	attrs := parse_callable_attrs(stmt.attrs, 'php_method', method_name)
	if !attrs.has_php_callable {
		return
	}
	args := build_php_args(stmt.params, table, 0, stmt.is_variadic, attrs.php_arg_types, attrs.php_arg_names,
		attrs.php_arg_optional, attrs.php_arg_defaults, attrs.php_param_attrs, params_structs)

	ret_type := strip_module(table.type_to_str(stmt.return_type))
	mut php_return_type_static := attrs.php_return_type
	if stmt.is_noreturn && php_return_type_static == '' {
		php_return_type_static = 'never'
	}
	cls.methods << repr.PhpMethodRepr{
		name:            attrs.php_name
		v_name:          method_name
		v_c_func:        '${cls.name}_${method_name}'
		is_static:       true
		return_spec:     repr.new_return_repr(ret_type, php_return_type_static)
		borrowed_return: attrs.borrowed_return
		visibility:      if stmt.is_pub { 'public' } else { 'protected' }
		args:            args
		has_export:      attrs.has_export
		is_abstract:     attrs.is_abstract
	}
}

pub fn build_method_borrow_profile(stmt ast.FnDecl, table &ast.Table, field_types map[string]string) ?MethodBorrowProfile {
	if !stmt.is_method || stmt.is_static_type_method {
		return none
	}
	receiver_type := normalize_delegated_target_type(table.get_type_name(stmt.receiver.typ))
	if receiver_type == '' {
		return none
	}
	delegated_type, delegated_method := infer_delegated_method_ref(stmt, table, field_types)
	return MethodBorrowProfile{
		receiver_type:           receiver_type
		method_name:             stmt.name
		return_type:             normalize_delegated_target_type(table.type_to_str(stmt.return_type))
		direct_borrowed:         infer_borrowed_object_return(stmt, table, field_types,
			map[string]bool{}, map[string]string{})
		delegated_target_type:   delegated_type
		delegated_target_method: delegated_method
	}
}

