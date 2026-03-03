module parser

import v.ast
import compiler.repr

pub fn parse_globals_decl(stmt ast.Stmt, table &ast.Table) ?repr.PhpGlobalsRepr {
	if stmt !is ast.StructDecl {
		return none
	}
	struct_decl := stmt as ast.StructDecl
	mut globals_repr := repr.PhpGlobalsRepr{}
	if !struct_decl.attrs.any(it.name == 'php_globals') {
		return none
	}

	globals_repr.name = struct_decl.name.all_after('.')
	for field in struct_decl.fields {
		type_name := table.get_type_name(field.typ)
		globals_repr.fields << repr.PhpGlobalField{
			name: field.name
			v_type: type_name
		}
	}
	return globals_repr
}
