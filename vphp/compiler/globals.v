module compiler

import v.ast

pub struct PhpGlobalsRepr {
pub mut:
	name   string
	fields []PhpGlobalField
}

pub struct PhpGlobalField {
pub:
	name   string
	v_type string
}

fn (mut r PhpGlobalsRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.StructDecl {
		if stmt.attrs.any(it.name == 'php_globals') {
			r.name = stmt.name.all_after('.')
			for field in stmt.fields {
				type_name := table.get_type_name(field.typ)
				r.fields << PhpGlobalField{
					name: field.name
					v_type: type_name
				}
			}
			return true
		}
	}
	return false
}
