module parser

import v.ast
import compiler.repr

// parse_structural_elements 扫描并提取所有结构要素（Interface, Enum, globals Struct, 普通 Struct）
pub fn parse_structural_elements(all_stmts []ast.Stmt,
	table &ast.Table,
	decl_modules map[string]string) !([]repr.PhpRepr, repr.PhpGlobalsRepr) {
	mut elements := []repr.PhpRepr{}
	mut globals_repr := repr.PhpGlobalsRepr{}

	for stmt in all_stmts {
		if stmt is ast.InterfaceDecl {
			if iface := parse_interface_decl(stmt, table) {
				elements << iface
				continue
			}
		}

		if stmt is ast.EnumDecl {
			if mut enum_repr := parse_enum_decl(stmt, table) {
				if enum_repr.parse_err != '' {
					return error(enum_repr.parse_err)
				}
				enum_repr.module_name = decl_modules['enum:${stmt.name}']
				elements << enum_repr
				continue
			}
		}

		if stmt is ast.StructDecl {
			if g_repr := parse_globals_decl(stmt, table) {
				if globals_repr.name != '' {
					return error('multiple @[php_globals] declarations are not supported: ${globals_repr.name} and ${g_repr.name}')
				}
				globals_repr = g_repr
				continue
			}

			if cls := parse_class_decl(stmt, table, module_for_stmt(stmt, decl_modules)) {
				elements << cls
			}
		}
	}
	return elements, globals_repr
}

// parse_behavioral_elements 扫描并挂载行为要素（普通函数, 类方法, 静态方法, 常量, 并发任务）
pub fn parse_behavioral_elements(all_stmts []ast.Stmt,
	table &ast.Table,
	decl_modules map[string]string,
	mut elements []repr.PhpRepr,
	field_types map[string]string,
	params_structs map[string]repr.PhpParamsStruct,
	resolved_borrowed map[string]bool,
	method_return_types map[string]string) ! {
	mut class_index := map[string]int{}
	for idx, el in elements {
		if el is repr.PhpClassRepr {
			class_index[el.name] = idx
		}
	}

	for stmt in all_stmts {
		if stmt is ast.FnDecl {
			if stmt.is_method {
				receiver_type := table.get_type_name(stmt.receiver.typ).all_after_last('.')
				if receiver_type in class_index {
					idx := class_index[receiver_type]
					mut el := elements[idx]
					if mut el is repr.PhpClassRepr {
						add_class_method(mut el, stmt, table, field_types, resolved_borrowed,
							method_return_types, params_structs)
						elements[idx] = el
					}
					continue
				}
			}

			if stmt.name.contains('__static__') {
				parts := stmt.name.split('__static__')
				if parts.len == 2 {
					raw_class := parts[0]
					class_name := if raw_class.contains('.') {
						raw_class.all_after_last('.')
					} else {
						raw_class
					}
					method_name := parts[1]

					if class_name in class_index {
						idx := class_index[class_name]
						mut el := elements[idx]
						if mut el is repr.PhpClassRepr {
							add_class_static_method(mut el, stmt, table, method_name,
								params_structs)
							elements[idx] = el
						}
						continue
					}
				}
			}

			if func := parse_function_decl(stmt, table, module_for_stmt(stmt, decl_modules),
				params_structs)
			{
				elements << func
				continue
			}
		}

		if con := parse_constant_decl(stmt, table) {
			elements << con
			continue
		}

		if task := parse_task_decl(stmt, table) {
			elements << task
			continue
		}
	}
}

fn module_for_stmt(stmt ast.Stmt, decl_modules map[string]string) string {
	key := decl_key(stmt)
	if module_name := decl_modules[key] {
		return module_name
	}
	short_key := decl_short_key(stmt)
	return decl_modules[short_key] or { 'main' }
}
