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
    // 生成 H：返回需要写入 php_bridge.h 的代码行
	gen_h() []string
    // 生成 C：返回需要写入 php_bridge.c（全局作用域）的代码行
	gen_c() []string
    // 生成 MINIT：返回需要写入 PHP_MINIT_FUNCTION 内部的代码行
	gen_minit() []string
    // 生成 V 胶水：返回需要写入 bridge.v 的 V 包装代码
	gen_v_glue() []string
}

pub struct Compiler {
pub:
	target_file string
pub mut:
	ext_name    string
	elements    []PhpRepr
mut:
	table       &ast.Table
	pref_set    &pref.Preferences
	// 辅助 Map：通过类名快速找到 elements 里的索引，方便追加方法
	class_index map[string]int
}

pub fn new(target_file string) Compiler {
	return Compiler{
		target_file: target_file
		ext_name: ''
		table: ast.new_table()
		pref_set: pref.new_preferences()
	}
}

pub fn (mut c Compiler) compile() ! {
	file_ast := parser.parse_file(c.target_file, mut c.table, .parse_comments, c.pref_set)

	if file_ast.errors.len > 0 {
		return error('AST 解析失败: ${file_ast.errors[0].message}')
	}
	// 2. 第一步：填充 ext_name (从 const ext_config 提取)
	c.set_ext_name(file_ast)
	if c.ext_name == '' {
		return error('无法在 ${c.target_file} 中找到 ext_config 配置，请确保定义了 ExtensionConfig')
	}
	println('  - [Compiler] 识别到扩展名: ${c.ext_name}')

	// --- 第一阶段：扫描所有 Struct 定义 ---
		for stmt in file_ast.stmts {
			if stmt is ast.StructDecl {
				mut cls := new_class_repr()
				if cls.parse(stmt, c.table) {
					// 记录该类在 elements 数组中的位置
					c.class_index[cls.name] = c.elements.len
					c.elements << cls
				}
			}
		}

	// --- 第二阶段：扫描所有 Fn 定义 ---
  for stmt in file_ast.stmts {
		if stmt is ast.FnDecl {
		  // println('Scanning function: ${stmt.name} | is_method: ${stmt.is_method}')
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

		// 1. 尝试作为类解析
		// mut cls := new_class_repr()
		// if cls.parse(stmt, c.table) {
		// 	c.elements << cls
		// 	continue
		// }

		// 2. 尝试作为常量解析
		mut con := new_const_repr()
		if con.parse(stmt, c.table) {
			c.elements << con
			continue
		}

		// 3. 尝试作为全局函数解析
		// mut func := new_func_repr()
		// if func.parse(stmt, c.table) {
		// 	c.elements << func
		// 	continue
		// }

    // 4. 任务识别逻辑
    mut task := new_task_repr()
    if task.parse(stmt, c.table) {
			c.elements << task
			continue
		}
	}
}

fn (mut c Compiler) set_ext_name(file_ast &ast.File) {
	for stmt in file_ast.stmts {
		if stmt is ast.ConstDecl {
			for field in stmt.fields {
				if field.name.ends_with('ext_config') && field.expr is ast.StructInit {
					expr := field.expr as ast.StructInit
					for f in expr.init_fields {
						if f.name == 'name' && f.expr is ast.StringLiteral {
							c.ext_name = (f.expr as ast.StringLiteral).val
							return
						}
					}
				}
			}
		}
	}
}
