module parser

import v.ast
import compiler.repr

pub fn parse_task_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpTaskRepr {
	mut task := repr.new_task_repr()
	if task.parse(stmt, table) {
		return task
	}
	return none
}
