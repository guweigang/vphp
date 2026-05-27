module parser

import v.ast

pub fn parse_extension_meta(file_ast &ast.File, table &ast.Table) ?(string, string, string, map[string]string) {
	for stmt in file_ast.stmts {
		if stmt is ast.ConstDecl {
			for field in stmt.fields {
				if field.name.ends_with('ext_config') && field.expr is ast.StructInit {
					expr := field.expr as ast.StructInit
					v_type := table.get_type_name(expr.typ)
					if !v_type.ends_with('ExtensionConfig') {
						continue
					}
					mut name := ''
					mut version := ''
					mut description := ''
					mut ini_entries := map[string]string{}
					for f in expr.init_fields {
						if f.name == 'name' && f.expr is ast.StringLiteral {
							name = (f.expr as ast.StringLiteral).val
						} else if f.name == 'version' && f.expr is ast.StringLiteral {
							version = (f.expr as ast.StringLiteral).val
						} else if f.name == 'description' && f.expr is ast.StringLiteral {
							description = (f.expr as ast.StringLiteral).val
						} else if f.name == 'ini_entries' && f.expr is ast.MapInit {
							m_expr := f.expr as ast.MapInit
							for i, key in m_expr.keys {
								val := m_expr.vals[i]
								if key is ast.StringLiteral && val is ast.StringLiteral {
									k := (key as ast.StringLiteral).val
									v := (val as ast.StringLiteral).val
									ini_entries[k] = v
								}
							}
						}
					}
					if name != '' {
						return name, version, description, ini_entries
					}
				}
			}
		}
	}
	return none
}
