module parser

import v.ast
import compiler.repr

pub fn parse_globals_decl(stmt ast.Stmt, table &ast.Table) ?repr.PhpGlobalsRepr {
	mut globals_repr := repr.PhpGlobalsRepr{}
	if globals_repr.parse(stmt, table) {
		return globals_repr
	}
	return none
}
