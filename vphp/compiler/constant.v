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

fn (r PhpConstRepr) gen_h() []string { return []string{} }
fn (r PhpConstRepr) gen_c() []string { return []string{} }
fn (r PhpConstRepr) gen_minit() []string {
	return ['    REGISTER_LONG_CONSTANT("${r.name}", ${r.value}, CONST_CS | CONST_PERSISTENT);']
}

fn (r PhpConstRepr) gen_v_glue() []string {
	return []string{}
}
