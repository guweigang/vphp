// vphp/compiler/entry.v
module compiler

import v.ast
import v.pref
import compiler.linker
import compiler.parser as cparser
import v.parser
import compiler.repr

pub struct Compiler {
pub:
	target_files []string
pub mut:
	ext_name        string
	ext_version     string
	ext_description string
	ini_entries     map[string]string
	globals_repr    repr.PhpGlobalsRepr
	elements        []repr.PhpRepr
	params_structs  map[string]repr.PhpParamsStruct
mut:
	table        &ast.Table
	pref_set     &pref.Preferences
	decl_modules map[string]string
	// 辅助 Map：通过类名快速找到 elements 里的索引，方便追加方法
	class_index map[string]int
}

pub fn new(target_files []string) Compiler {
	return Compiler{
		target_files: target_files
		ext_name:     ''
		table:        ast.new_table()
		pref_set:     pref.new_preferences()
	}
}

pub fn (mut c Compiler) compile() !string {
	mut all_stmts := []ast.Stmt{}

	for file in c.target_files {
		file_ast := parser.parse_file(file, mut c.table, .parse_comments, c.pref_set)
		if file_ast.errors.len > 0 {
			return error('AST 解析失败: ${file_ast.errors[0].message} in ${file}')
		}
		if c.ext_name == '' {
			if meta := cparser.parse_extension_meta(file_ast, c.table) {
				c.ext_name = meta.name
				c.ext_version = meta.version
				c.ext_description = meta.description
				c.ini_entries = meta.ini_entries.clone()
			}
		}
		c.remember_decl_modules(file_ast.stmts, file_ast.mod.name)
		all_stmts << file_ast.stmts
	}

	if c.ext_name == '' {
		return error('无法在输入的文件中找到 ext_config 配置，请确保定义了 ExtensionConfig')
	}
	println('  - [Compiler] 识别到扩展名: ${c.ext_name}')
	field_types := cparser.collect_struct_field_types(all_stmts, c.table)
	params_structs := cparser.collect_params_structs(all_stmts, c.table, c.decl_modules)
	c.params_structs = params_structs.clone()
	resolved_borrowed := linker.resolve_borrowed_methods(all_stmts, c.table, field_types)
	method_return_types := linker.collect_method_return_types(all_stmts, c.table, field_types)

	// --- 第一阶段：扫描所有 Struct 定义 ---
	for stmt in all_stmts {
		if stmt is ast.InterfaceDecl {
			if iface := cparser.parse_interface_decl(stmt, c.table) {
				c.elements << iface
				continue
			}
		}

		if stmt is ast.EnumDecl {
			if mut enum_repr := cparser.parse_enum_decl(stmt, c.table) {
				if enum_repr.parse_err != '' {
					return error(enum_repr.parse_err)
				}
				enum_repr.module_name = c.decl_modules['enum:${stmt.name}']
				c.elements << enum_repr
				continue
			}
		}

		if stmt is ast.StructDecl {
			if globals_repr := cparser.parse_globals_decl(stmt, c.table) {
				if c.globals_repr.name != '' {
					return error('multiple @[php_globals] declarations are not supported: ${c.globals_repr.name} and ${globals_repr.name}')
				}
				c.globals_repr = globals_repr
				continue
			}

			if cls := cparser.parse_class_decl(stmt, c.table, c.module_for_stmt(stmt)) {
				c.class_index[cls.name] = c.elements.len
				c.elements << cls
			}
		}
	}

	// --- 第二阶段：扫描所有 Fn 定义 ---
	for stmt in all_stmts {
		if stmt is ast.FnDecl {
			if stmt.is_method {
				receiver_type := c.table.get_type_name(stmt.receiver.typ).all_after_last('.')
				if receiver_type in c.class_index {
					idx := c.class_index[receiver_type]
					mut el := c.elements[idx]
					if mut el is repr.PhpClassRepr {
						cparser.add_class_method(mut el, stmt, c.table, field_types,
							resolved_borrowed, method_return_types, params_structs)
						c.elements[idx] = el // 重要：写回修改后的对象！
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

					if class_name in c.class_index {
						idx := c.class_index[class_name]
						mut el := c.elements[idx]
						if mut el is repr.PhpClassRepr {
							cparser.add_class_static_method(mut el, stmt, c.table, method_name,
								params_structs)
						}
						continue
					}
				}
			}

			if func := cparser.parse_function_decl(stmt, c.table, c.module_for_stmt(stmt),
				params_structs)
			{
				c.elements << func
				continue
			}
		}

		if con := cparser.parse_constant_decl(stmt, c.table) {
			c.elements << con
			continue
		}

		if task := cparser.parse_task_decl(stmt, c.table) {
			c.elements << task
			continue
		}
	}

	linker.link_class_shadows(mut c.elements, c.table)
	linker.resolve_and_apply_borrow_returns(mut c.elements, all_stmts, c.table, field_types)
	linker.link_class_traits(mut c.elements)!
	linker.link_class_embeds(mut c.elements)!
	linker.link_class_parents(mut c.elements)!
	linker.validate_inherited_object_classes(c.elements)!
	linker.link_interface_parents(mut c.elements)!
	linker.link_class_interfaces(mut c.elements)!

	return c.ext_name
}

fn (c &Compiler) module_for_stmt(stmt ast.Stmt) string {
	key := cparser.decl_key(stmt)
	if module_name := c.decl_modules[key] {
		return module_name
	}
	short_key := cparser.decl_short_key(stmt)
	return c.decl_modules[short_key] or { 'main' }
}

fn (mut c Compiler) remember_decl_modules(stmts []ast.Stmt, module_name string) {
	for stmt in stmts {
		key := cparser.decl_key(stmt)
		if key != '' {
			c.decl_modules[key] = module_name
		}
		short_key := cparser.decl_short_key(stmt)
		if short_key != '' {
			c.decl_modules[short_key] = module_name
		}
	}
}
