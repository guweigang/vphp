import os
import v.parser
import v.ast
import v.pref

struct ExtMeta {
mut:
	name    string   = 'vphp_ext'
	version string   = '1.0.0'
	exports []string
	tasks   []string
}

fn main() {
	target_file := if os.args.len > 1 { os.args[1] } else { 'v_logic.v' }
	if !os.exists(target_file) {
		eprintln('❌ 找不到目标文件: $target_file')
		exit(1)
	}

	// 修复 1: table 必须声明为 mut
	mut table := ast.new_table()
	pref_set := pref.new_preferences()

	// 修复 2: 传入 mut table
	file_ast := parser.parse_file(target_file, mut table, .parse_comments, pref_set)

	mut meta := ExtMeta{}

	for stmt in file_ast.stmts {
		if stmt is ast.ConstDecl {
			for field in stmt.fields {
				if field.name.ends_with('ext_config') {
					// 修复 3: 使用智能类型转换处理 StructInit
					expr := field.expr
					if expr is ast.StructInit {
						// 修复 4: 字段名已改为 init_fields
						for f in expr.init_fields {
							if f.name == 'name' {
								val := f.expr
								if val is ast.StringLiteral {
									meta.name = val.val
								}
							}
						}
					}
				}
			}
		}

		if stmt is ast.FnDecl {
      // 检测 ITask 实现
      if stmt.is_method && stmt.name == 'run' {
          // 修复：不要直接 .str()，要从 table 中查真实的类型名称
          raw_name := table.get_type_name(stmt.receiver.typ)
          // 去掉模块前缀（比如 main.FitnessTask -> FitnessTask）
          task_name := raw_name.all_after('.')

          if task_name !in meta.tasks {
              meta.tasks << task_name
          }
      }

			// 检测导出属性
			for attr in stmt.attrs {
				if attr.name == 'export' && attr.arg != '' {
					if !attr.arg.starts_with('vphp_') && !attr.arg.starts_with('zm_') {
						meta.exports << attr.arg
					}
				}
			}
		}
	}

	generate_c_bridge(meta)
	generate_v_glue(meta)

	println('🚀 Codegen 修复成功!')
	println('   - 扩展名: ${meta.name}')
	println('   - 任务列表: ${meta.tasks}')
}

fn generate_c_bridge(meta ExtMeta) {
	mut c := []string{}
	c << '/* ⚠️ 自动生成，请勿修改 */'
	c << '#include <php.h>'
	c << '#include "php_bridge.h"'
	c << ''
	// --- 关键修复点：补上这两个 extern 声明 ---
	c << 'extern void vphp_framework_init(int module_number);'
	c << 'extern void vphp_task_auto_startup();'
	c << ''

	// 收集所有函数
	mut all_funcs := meta.exports.clone()
	all_funcs << 'v_spawn'
	all_funcs << 'v_wait'

	// 1. 生成 ArgInfo
	for func in all_funcs {
		c << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${func}, 0, 0, 0)'
		c << 'ZEND_END_ARG_INFO()'
	}

	// 2. 声明并定义包装函数
	for func in all_funcs {
		c << 'void ${func}(zend_execute_data *execute_data, zval *return_value);'
		c << 'PHP_FUNCTION(${func}) { ${func}(execute_data, return_value); }'
	}

	// 3. 函数表
	c << 'static const zend_function_entry v_ext_functions[] = {'
	for func in all_funcs {
		c << '    PHP_FE(${func}, arginfo_${func})'
	}
	c << '    PHP_FE_END'
	c << '};'

	// 4. MINIT (这里用到了上面 extern 的函数)
	c << 'PHP_MINIT_FUNCTION(${meta.name}) {'
	c << '    vphp_framework_init(module_number);'
	c << '    vphp_task_auto_startup();'
	c << '    return SUCCESS;'
	c << '}'

	c << 'zend_module_entry ${meta.name}_module_entry = {'
	c << '    STANDARD_MODULE_HEADER, "${meta.name}", v_ext_functions,'
	c << '    PHP_MINIT(${meta.name}), NULL, NULL, NULL, NULL, "1.0.0",'
	c << '    STANDARD_MODULE_PROPERTIES'
	c << '};'
	c << 'ZEND_GET_MODULE(${meta.name})'

	os.write_file('php_bridge.c', c.join('\n')) or { panic(err) }
}

fn generate_v_glue(meta ExtMeta) {
    mut v := []string{}
    v << 'module main'
    v << 'import vphp'
    v << ''
    v << '@[export: "vphp_task_auto_startup"]'
    v << 'fn vphp_task_auto_startup() {'
    for task in meta.tasks {
        // 修改这里：改用 ITask.register
        v << "    vphp.ITask.register('$task', fn() vphp.ITask { return $task{} })"
    }
    v << '}'
    os.write_file('_task_glue.v', v.join('\n')) or { panic(err) }
}
