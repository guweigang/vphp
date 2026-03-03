module parser

import v.ast
import compiler.repr

pub fn parse_class_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpClassRepr {
	if stmt !is ast.StructDecl {
		return none
	}
	struct_decl := stmt as ast.StructDecl
	mut cls := repr.new_class_repr()
	if !struct_decl.attrs.any(it.name == 'php_class') {
		return none
	}

	cls.name = struct_decl.name.all_after('.')
	if attr := struct_decl.attrs.find_first('php_class') {
		cls.php_name = if attr.arg != '' { attr.arg } else { cls.name }
	} else {
		cls.php_name = cls.name
	}
	if attr := struct_decl.attrs.find_first('php_extends') {
		cls.parent = attr.arg
	}
	for attr in struct_decl.attrs {
		if attr.name == 'php_const' {
			cls.shadow_const_name = attr.arg
		} else if attr.name == 'php_static' {
			cls.shadow_static_name = attr.arg
		} else if attr.name == 'php_abstract' {
			cls.is_abstract = true
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
	if struct_decl.embeds.len > 0 && cls.parent == '' {
		parent_type_name := table.get_type_name(struct_decl.embeds[0].typ)
		cls.parent = if parent_type_name.contains('.') {
			parent_type_name.all_after('.')
		} else {
			parent_type_name
		}
	}
	for field in struct_decl.fields {
		type_name := table.get_type_name(field.typ)
		mut is_static := field.attrs.any(it.name == 'php_static')
		if !is_static {
			for comment in field.comments {
				if comment.text.contains('@[php_static]') {
					is_static = true
					break
				}
			}
		}

		cls.properties << repr.PhpClassProp{
			name: field.name
			v_type: type_name
			visibility: if field.is_pub { 'public' } else { 'protected' }
			is_static: is_static
		}
	}
	return cls
}

pub fn add_class_method(mut cls repr.PhpClassRepr, stmt ast.FnDecl, table &ast.Table) {
	if !stmt.attrs.any(it.name == 'php_method') {
		return
	}

	mut has_export := false
	mut php_name := stmt.name
	for attr in stmt.attrs {
		if attr.name == 'export' && attr.arg != '' {
			has_export = true
		}
		if attr.name == 'php_method' && attr.arg != '' {
			php_name = attr.arg
		}
	}

	is_abstract := stmt.attrs.any(it.name == 'php_abstract')
	mut args := []repr.PhpArg{}
	start_idx := if stmt.is_method { 1 } else { 0 }

	for i := start_idx; i < stmt.params.len; i++ {
		param := stmt.params[i]
		args << repr.PhpArg{
			name: param.name
			v_type: strip_module(table.get_type_name(param.typ))
		}
	}

	ret_type := strip_module(table.type_to_str(stmt.return_type))
	cls.methods << repr.PhpMethodRepr{
		name: php_name
		v_name: stmt.name
		v_c_func: '${cls.name}_${stmt.name}'
		is_static: false
		return_type: ret_type
		visibility: if stmt.is_pub { 'public' } else { 'protected' }
		args: args
		has_export: has_export
		is_abstract: is_abstract
	}
}

pub fn add_class_static_method(mut cls repr.PhpClassRepr, stmt ast.FnDecl, table &ast.Table, method_name string) {
	if !stmt.attrs.any(it.name == 'php_method') {
		return
	}

	mut has_export := false
	mut php_name := method_name
	for attr in stmt.attrs {
		if attr.name == 'export' && attr.arg != '' {
			has_export = true
		}
		if attr.name == 'php_method' && attr.arg != '' {
			php_name = attr.arg
		}
	}

	is_abstract := stmt.attrs.any(it.name == 'php_abstract')
	mut args := []repr.PhpArg{}
	for param in stmt.params {
		args << repr.PhpArg{
			name: param.name
			v_type: strip_module(table.get_type_name(param.typ))
		}
	}

	ret_type := strip_module(table.type_to_str(stmt.return_type))
	cls.methods << repr.PhpMethodRepr{
		name: php_name
		v_name: method_name
		v_c_func: '${cls.name}_${method_name}'
		is_static: true
		return_type: ret_type
		visibility: if stmt.is_pub { 'public' } else { 'protected' }
		args: args
		has_export: has_export
		is_abstract: is_abstract
	}
}
