module parser

import v.ast
import compiler.repr

pub fn parse_enum_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpEnumRepr {
	mut enum_repr := repr.new_enum_repr()
	if enum_repr.parse(stmt, table) {
		return enum_repr
	}
	return none
}
