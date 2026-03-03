module repr

import v.ast

pub interface PhpRepr {
mut:
	parse(stmt ast.Stmt, table &ast.Table) bool
}

fn strip_module(mut_typ_name string) string {
	return mut_typ_name.replace('main.', '')
}
