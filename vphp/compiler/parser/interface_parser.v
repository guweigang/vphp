module parser

import v.ast
import compiler.repr

pub fn parse_interface_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpInterfaceRepr {
	mut iface := repr.new_interface_repr()
	if iface.parse(stmt, table) {
		return iface
	}
	return none
}
