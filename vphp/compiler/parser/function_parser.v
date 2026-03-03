module parser

import v.ast
import compiler.repr

pub fn parse_function_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpFuncRepr {
	mut func := repr.new_func_repr()
	if func.parse(stmt, table) {
		return func
	}
	return none
}
