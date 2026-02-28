module compiler

import os
import strings

// ==========================================
// 1. 总入口：由外部 build.v 调用
// ==========================================
pub fn (mut c Compiler) generate_all() ! {
    c.generate_h()!
    c.generate_c()!
    c.generate_v_glue()!
}

// ==========================================
// 2. 生成 C 源文件 (php_bridge.c)
// ==========================================
fn (mut c Compiler) generate_c() ! {
	mut res := strings.new_builder(2048)
	res.write_string('/* ⚠️ VPHP Compiler Generated for ${c.ext_name} */\n')
	res.write_string('#include "php_bridge.h"\n\n')
	res.write_string('#include "../vphp/v_bridge.h"\n\n')

	// 1. 显式声明，解决 -Wimplicit-function-declaration
	res.write_string('extern void vphp_framework_init(int module_number);\n')
	res.write_string('extern void vphp_task_auto_startup();\n\n')

	// 2. 写入每个元素的实现 (Wrapper / ArgInfo)
	for mut el in c.elements {
		res.write_string(el.gen_c().join('\n') + '\n')
	}

	// 3. 写入框架内置函数的 Wrapper
	internal_funcs := ['v_spawn', 'v_wait']
	for f in internal_funcs {
		res.write_string('ZEND_BEGIN_ARG_INFO_EX(arginfo_${f}, 0, 0, 0)\nZEND_END_ARG_INFO()\n')
		res.write_string('void ${f}(zend_execute_data *execute_data, zval *return_value);\n')
		res.write_string('PHP_FUNCTION(${f}) { ${f}(execute_data, return_value); }\n\n')
	}

	// 4. 函数表 (使用 ${c.ext_name}_functions)
	res.write_string('static const zend_function_entry ${c.ext_name}_functions[] = {\n')
	for mut el in c.elements {
		if mut el is PhpFuncRepr {
			f := el
			res.write_string('    PHP_FE(${f.name}, arginfo_${f.name})\n')
		}
	}
	for f in internal_funcs {
		res.write_string('    PHP_FE(${f}, arginfo_${f})\n')
	}
	res.write_string('    PHP_FE_END\n};\n\n')

	// 5. MINIT
	res.write_string('PHP_MINIT_FUNCTION(${c.ext_name}) {\n')
	res.write_string('    vphp_framework_init(module_number);\n')
	for mut el in c.elements {
		res.write_string(el.gen_minit().join('\n') + '\n')
	}
	res.write_string('    vphp_task_auto_startup();\n')
	res.write_string('    return SUCCESS;\n}\n\n')

	// 6. 模块入口
	res.write_string('zend_module_entry ${c.ext_name}_module_entry = {\n')
	res.write_string('    STANDARD_MODULE_HEADER, "${c.ext_name}", ${c.ext_name}_functions,\n')
	res.write_string('    PHP_MINIT(${c.ext_name}), NULL, NULL, NULL, NULL, "1.0.0",\n')
	res.write_string('    STANDARD_MODULE_PROPERTIES\n};\n\n')

  // 7. 核心：写入 ZEND_GET_MODULE 宏 👈
  // 这行代码会让 PHP 引擎识别并加载这个扩展
  res.write_string('#ifndef COMPILE_DL_${c.ext_name.to_upper()}\n')
	res.write_string('#define COMPILE_DL_${c.ext_name.to_upper()}\n\n')
  res.write_string('ZEND_GET_MODULE(${c.ext_name})\n')
  res.write_string('#endif\n')

  os.write_file('php_bridge.c', res.str())!
}

// ==========================================
// 3. 生成 V 胶水代码 (_task_glue.v)
// ==========================================
fn (mut c Compiler) generate_v_glue() ! {
    mut v := []string{}
    v << 'module main\nimport vphp\n'
    v << '@[export: "vphp_task_auto_startup"]\nfn vphp_task_auto_startup() {'
    for mut el in c.elements {
        if mut el is PhpTaskRepr { // 只有任务 Repr 贡献 ITask.register
          task := el
          v << task.gen_v_glue()
        }
    }
    v << '}'

    for mut el in c.elements {
      if mut el is PhpClassRepr {
          // 为每个标记了 @[php_class] 的结构体生成映射器
          cls := el
          v << cls.gen_v_glue();
      }
    }
    os.write_file('bridge.v', v.join('\n'))!
}

// ==========================================
// 4. 生成头文件 (php_bridge.h)
// ==========================================
fn (mut c Compiler) generate_h() ! {
	mut res := strings.new_builder(1024)

	// 1. 写入文件头和头文件保护 (Header Guard)
	res.write_string('/* ⚠️ VPHP Compiler Generated，请勿手动修改 */\n')
	res.write_string('#ifndef VPHP_BRIDGE_H\n')
	res.write_string('#define VPHP_BRIDGE_H\n\n')

	// 2. 引入必要的 PHP 内核头文件
	res.write_string('#include <php.h>\n\n')

	// 3. 写入扩展模块入口声明
	// 这样 C 侧和 V 侧都能引用 &vphp_ext_module_entry
	res.write_string('extern zend_module_entry ${c.ext_name}_module_entry;\n')
	res.write_string('#define phpext_${c.ext_name}_ptr &${c.ext_name}_module_entry\n\n')

	// 4. 核心：遍历所有 Repr 元素，收集它们的头文件声明
	for mut el in c.elements {
		// 调用接口定义的 gen_h() 方法
		lines := el.gen_h()
		if lines.len > 0 {
			res.write_string(lines.join('\n') + '\n')
		}
	}

	// 5. 补充框架内置函数的声明 (这些不走 Repr 扫描)
	res.write_string('\n/* Framework Internal Functions */\n')
	res.write_string('PHP_FUNCTION(v_spawn);\n')
	res.write_string('PHP_FUNCTION(v_wait);\n\n')

	// 6. 写入头文件保护结束
	res.write_string('#endif\n')

	// 7. 物理写入文件
	os.write_file('php_bridge.h', res.str()) or {
		return error('无法写入 php_bridge.h: $err')
	}

	println('  - [Generator] 已生成 php_bridge.h')
}
