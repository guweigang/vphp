import os
import regex

fn main() {
	println('🚀 正在自动生成 PHP 桥接层代码...')

	mut functions := []string{}
	content := os.read_file('v_logic.v') or {
		println('❌ 无法读取 v_logic.v')
		return
	}

	// 修正正则匹配模式
	mut re := regex.regex_opt(r"@\[export:\s*'(\w+)'\]") or { panic(err) }

	mut start := 0
	for {
		// find_from 返回 (start, end) 两个 int
		s, e := re.find_from(content, start)
		if s == -1 { break }

		// 获取捕获组的范围
		groups := re.get_group_list()
		if groups.len > 0 {
			// group[0] 对应第一个 (\w+)
			g_start := groups[0].start
			g_end := groups[0].end
			func_name := content[g_start..g_end]
			functions << func_name
			println('  found export: $func_name')
		}

		start = e // 从上一个匹配的结尾继续找
	}

	if functions.len == 0 {
		println('⚠️  未在 v_logic.v 中发现导出函数')
	}

	// 生成 C 代码
	mut c_code := '#include <php.h>\n'
	c_code += '#include "../vphp/v_bridge.h"\n\n'
	c_code += 'void vphp_init_resource_system(int module_number);\n\n' // 新增这一行

	for func in functions {
		c_code += 'void ${func}(zend_execute_data *execute_data, zval *return_value);\n'
	}

	for func in functions {
		c_code += '\nZEND_BEGIN_ARG_INFO_EX(arginfo_${func}, 0, 0, -1)\n'
		c_code += '    ZEND_ARG_INFO(0, args)\n'
		c_code += 'ZEND_END_ARG_INFO()\n\n'

		c_code += 'PHP_FUNCTION(${func}) {\n'
		c_code += '    ${func}(execute_data, return_value);\n'
		c_code += '}\n'
	}

	c_code += '\nstatic const zend_function_entry v_ext_functions[] = {\n'
	for func in functions {
		c_code += '    PHP_FE(${func}, arginfo_${func})\n'
	}
	c_code += '    PHP_FE_END\n};\n'

	// 2. 显式定义 PHP_MINIT_FUNCTION
  c_code += '\nPHP_MINIT_FUNCTION(v_php_ext) {\n'
  c_code += '    vphp_init_resource_system(module_number);\n' // 调用 C 桥接层的初始化
  c_code += '    return SUCCESS;\n'
  c_code += '}\n'

  // 3. 修改 zend_module_entry 结构体
  // 将原来的第 4 个参数 NULL 改为 PHP_MINIT(v_php_ext)
  c_code += '\nzend_module_entry v_php_ext_module_entry = {
      STANDARD_MODULE_HEADER,
      "v_php_ext",
      v_ext_functions,
      PHP_MINIT(v_php_ext), // 这里从 NULL 改为初始化入口
      NULL,
      NULL,
      NULL,
      NULL,
      "0.1.0",
      STANDARD_MODULE_PROPERTIES
  };\n'

  c_code += '#ifdef COMPILE_DL_V_PHP_EXT\nZEND_GET_MODULE(v_php_ext)\n#endif\n'

	os.write_file('php_bridge.c', c_code) or { panic(err) }
	println('✅ php_bridge.c 已成功更新 (共 ${functions.len} 个函数)')
}
