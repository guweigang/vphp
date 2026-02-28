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

// 任务不需要生成 C 代码或头文件
fn (r PhpTaskRepr) gen_h() []string     { return []string{} }
fn (r PhpTaskRepr) gen_c() []string     { return []string{} }
fn (r PhpTaskRepr) gen_minit() []string { return []string{} }

// 专门为任务增加一个生成胶水代码的方法
pub fn (r PhpTaskRepr) gen_v_glue() []string {
	return ["    vphp.ITask.register('${r.task_name}', fn(s string) vphp.ITask { return ${r.task_name}{ json_data: s } })"]
}
