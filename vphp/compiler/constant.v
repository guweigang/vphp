module compiler

import v.ast

struct PhpConstRepr {
pub mut:
	name  string
	value string
}

fn new_const_repr() &PhpConstRepr { return &PhpConstRepr{} }

fn (mut r PhpConstRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.ConstDecl {
		for field in stmt.fields {
			if field.name.starts_with('PHP_') {
				r.name = field.name.all_after('PHP_')
				r.value = field.expr.str()
				return true
			}
		}
	}
	return false
}


