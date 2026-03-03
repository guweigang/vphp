module parser

import v.ast
import compiler.repr

pub fn parse_class_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpClassRepr {
	mut cls := repr.new_class_repr()
	if cls.parse(stmt, table) {
		return cls
	}
	return none
}
