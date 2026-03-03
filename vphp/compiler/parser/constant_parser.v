module parser

import v.ast
import compiler.repr

pub fn parse_constant_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpConstRepr {
	mut con := repr.new_const_repr()
	if con.parse(stmt, table) {
		return con
	}
	return none
}
