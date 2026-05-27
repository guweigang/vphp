module parser

import v.ast

pub fn collect_struct_field_types(stmts []ast.Stmt, table &ast.Table) map[string]string {
	mut field_types := map[string]string{}
	for stmt in stmts {
		if stmt !is ast.StructDecl {
			continue
		}
		struct_decl := stmt as ast.StructDecl
		struct_name := if struct_decl.name.contains('.') {
			struct_decl.name.all_after_last('.')
		} else {
			struct_decl.name
		}
		for field in struct_decl.fields {
			field_type := normalize_delegated_target_type(table.get_type_name(field.typ))
			if field_type != '' {
				field_types['${struct_name}::${field.name}'] = field_type
			}
		}
	}
	return field_types
}

pub fn decl_key(stmt ast.Stmt) string {
	match stmt {
		ast.StructDecl { return 'struct:${stmt.name}' }
		ast.FnDecl { return 'fn:${stmt.name}' }
		ast.InterfaceDecl { return 'interface:${stmt.name}' }
		ast.EnumDecl { return 'enum:${stmt.name}' }
		else { return '' }
	}
}

pub fn decl_short_key(stmt ast.Stmt) string {
	match stmt {
		ast.StructDecl { return 'struct:${stmt.name.all_after_last('.')}' }
		ast.FnDecl { return 'fn:${stmt.name.all_after_last('.')}' }
		ast.InterfaceDecl { return 'interface:${stmt.name.all_after_last('.')}' }
		ast.EnumDecl { return 'enum:${stmt.name.all_after_last('.')}' }
		else { return '' }
	}
}
