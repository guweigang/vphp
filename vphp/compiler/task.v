module compiler

import v.ast

pub struct PhpTaskRepr {
pub mut:
	task_name  string       // 任务的 PHP 注册名称
	v_name     string       // 任务在 V 语言中的 struct 名称
	parameters []PhpTaskArg // 保存提取的字段及其类型
}

pub struct PhpTaskArg {
pub mut:
	name   string
	v_type string
}

pub fn new_task_repr() &PhpTaskRepr {
	return &PhpTaskRepr{}
}

fn (mut r PhpTaskRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.StructDecl {
		if stmt.attrs.any(it.name == 'php_task') {
			r.v_name = stmt.name.all_after('.')
			
			// 提取绑定的任务名，如果没填则默认为 struct 名字
			if attr := stmt.attrs.find_first('php_task') {
				if attr.arg != '' {
					r.task_name = attr.arg
				} else {
					r.task_name = r.v_name
				}
			}

			// 解析 Struct 所有的属性（作为 PHP 传入的参数）
			for field in stmt.fields {
				mut type_name := table.get_type_name(field.typ)
				if type_name.contains('.') { type_name = type_name.all_after('.') }
				r.parameters << PhpTaskArg{
					name: field.name
					v_type: type_name
				}
			}
			return true
		}
	}
	return false
}
