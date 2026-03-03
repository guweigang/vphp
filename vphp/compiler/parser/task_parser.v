module parser

import v.ast
import compiler.repr

pub fn parse_task_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpTaskRepr {
	if stmt !is ast.StructDecl {
		return none
	}
	struct_decl := stmt as ast.StructDecl
	mut task := repr.new_task_repr()
	if !struct_decl.attrs.any(it.name == 'php_task') {
		return none
	}

	task.v_name = struct_decl.name.all_after('.')
	if attr := struct_decl.attrs.find_first('php_task') {
		task.task_name = if attr.arg != '' { attr.arg } else { task.v_name }
	}

	for field in struct_decl.fields {
		mut type_name := table.get_type_name(field.typ)
		if type_name.contains('.') {
			type_name = type_name.all_after('.')
		}
		task.parameters << repr.PhpTaskArg{
			name: field.name
			v_type: type_name
		}
	}

	return task
}
