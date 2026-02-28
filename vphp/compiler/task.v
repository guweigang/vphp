module compiler

import v.ast

pub struct PhpTaskRepr {
pub mut:
	task_name string
}

pub fn new_task_repr() &PhpTaskRepr {
	return &PhpTaskRepr{}
}

fn (mut r PhpTaskRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.FnDecl {
		// 识别实现了 run() []f64 的方法
		if stmt.is_method && stmt.name == 'run' {
			raw_name := table.get_type_name(stmt.receiver.typ)
			r.task_name = raw_name.all_after('.')
			return true
		}
	}
	return false
}


