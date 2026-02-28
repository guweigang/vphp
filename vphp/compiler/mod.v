// vphp/compiler/mod.v
module compiler

import v.ast
import v.pref
import v.parser

// 核心 Repr 接口
pub interface PhpRepr {
mut:
    // 匹配并解析：告诉编译器这个 AST 语句是否归你管，如果是，请自行提取数据
	parse(stmt ast.Stmt, table &ast.Table) bool
}

pub struct Compiler {
pub:
	target_files []string
pub mut:
	ext_name     string
	ext_version  string
	ini_entries  map[string]string
	globals_repr PhpGlobalsRepr
	elements     []PhpRepr
mut:
	table       &ast.Table
	pref_set    &pref.Preferences
	// 辅助 Map：通过类名快速找到 elements 里的索引，方便追加方法
	class_index map[string]int
}

pub fn new(target_files []string) Compiler {
	return Compiler{
		target_files: target_files
		ext_name: ''
		table: ast.new_table()
		pref_set: pref.new_preferences()
	}
}

pub fn (mut c Compiler) compile() !string {
    mut all_stmts := []ast.Stmt{}

    for file in c.target_files {
	    file_ast := parser.parse_file(file, mut c.table, .parse_comments, c.pref_set)
	    if file_ast.errors.len > 0 {
		    return error('AST 解析失败: ${file_ast.errors[0].message} in $file')
	    }
        if c.ext_name == '' {
            c.set_extension_meta(file_ast)
        }
        all_stmts << file_ast.stmts
    }

	if c.ext_name == '' {
		return error('无法在输入的文件中找到 ext_config 配置，请确保定义了 ExtensionConfig')
	}
	println('  - [Compiler] 识别到扩展名: ${c.ext_name}')

	// --- 第一阶段：扫描所有 Struct 定义 ---
	for stmt in all_stmts {
		if stmt is ast.StructDecl {
			// A. 探测是否是 Zend Globals 定义
			if c.globals_repr.name == '' {
				if c.globals_repr.parse(stmt, c.table) {
					continue
				}
			}

			// B. 或者是普通类定义
			mut cls := new_class_repr()
			if cls.parse(stmt, c.table) {
				// 记录该类在 elements 数组中的位置
				c.class_index[cls.name] = c.elements.len
				c.elements << cls
			}
		}
	}

	// --- 第二阶段：扫描所有 Fn 定义 ---
	for stmt in all_stmts {
		if stmt is ast.FnDecl {
			// 1. 检查是否是类方法 (Method)
			if stmt.is_method {
				// 获取接收者的类型名 (例如 "User")
				receiver_type := c.table.get_type_name(stmt.receiver.typ).all_after('.')

				if receiver_type in c.class_index {
					idx := c.class_index[receiver_type]
					// 必须通过索引获取 mut 引用
					mut el := c.elements[idx]
					if mut el is PhpClassRepr {
						el.add_method(stmt, c.table)
					}
					continue
				}
			}

			// 2. 核心修正：处理静态方法 (fn Article.create() ...)
			if stmt.name.contains('__static__') {
				parts := stmt.name.split('__static__')
				if parts.len == 2 {
					// 获取类名：如果是 main.Article，取 Article
					raw_class := parts[0]
					class_name := if raw_class.contains('.') { raw_class.all_after('.') } else { raw_class }
					method_name := parts[1]

					if class_name in c.class_index {
						idx := c.class_index[class_name]
						mut el := c.elements[idx]
						if mut el is PhpClassRepr {
							el.add_static_method(stmt, c.table, method_name)
						}
						continue
					}
				}
			}

			// 3. 否则，作为普通全局函数处理
			mut func := new_func_repr()
			if func.parse(stmt, c.table) {
				c.elements << func
				continue
			}
		}

		// 2. 尝试作为常量解析
		mut con := new_const_repr()
		if con.parse(stmt, c.table) {
			c.elements << con
			continue
		}

		// 3. 任务识别逻辑
		mut task := new_task_repr()
		if task.parse(stmt, c.table) {
			c.elements << task
			continue
		}
	}
	return c.ext_name
}

fn (mut c Compiler) set_extension_meta(file_ast &ast.File) {
	for stmt in file_ast.stmts {
		if stmt is ast.ConstDecl {
			for field in stmt.fields {
				if field.name.ends_with('ext_config') && field.expr is ast.StructInit {
					expr := field.expr as ast.StructInit
					for f in expr.init_fields {
						if f.name == 'name' && f.expr is ast.StringLiteral {
							c.ext_name = (f.expr as ast.StringLiteral).val
						} else if f.name == 'version' && f.expr is ast.StringLiteral {
							c.ext_version = (f.expr as ast.StringLiteral).val
						} else if f.name == 'ini_entries' && f.expr is ast.MapInit {
							m_expr := f.expr as ast.MapInit
							for i, key in m_expr.keys {
								val := m_expr.vals[i]
								if key is ast.StringLiteral && val is ast.StringLiteral {
									k := (key as ast.StringLiteral).val
									v := (val as ast.StringLiteral).val
									c.ini_entries[k] = v
								}
							}
						}
					}
					if c.ext_name != '' { return }
				}
			}
		}
	}
}
