## vphp
Bindings for the Zend API to build PHP extensions natively in V lang.

## Example
```v
module main

import vphp
import vphp.zend
import json

const ext_config = vphp.ExtensionConfig{
    name: 'vphptest'
    version: '0.1.0'
    description: 'PHP Bindings for V'
}

@[export: 'v_logic_main']
fn v_logic_main(ex &C.zend_execute_data, retval &C.zval) {
	unsafe {
		// 1. 像 ext-php-rs 一样优雅地获取参数
		args := vphp.get_args(ex)

		if args.len < 1 {
			vphp.throw_exception('至少需要一个参数', 400)
			return
		}

		// 2. 业务逻辑
		main_str := args[0].to_string()

		mut repeat_count := 1
		if args.len >= 2 {
			repeat_count = int(args[1].as_int())
		}

		res := main_str.repeat(repeat_count).reverse()

		// 3. 设置返回值
		out := vphp.Val{ raw: retval }
		out.set_string(res)
	}
}
```
### Build
```bash
vphpext/v_php_ext on main [!?] v run build.v

🛠️  1. 运行 Codegen，目标文件: v_logic.v ...
🛠️  2. 转译 V 逻辑...
🛠️  3. GCC 最终链接...
v_logic.c:4001:26: warning: cast to smaller integer type 'int' from 'const char *' [-Wpointer-to-int-cast]
 4001 |                         const int error_pos = (int)cJSON_GetErrorPos();
      |                                               ^~~~~~~~~~~~~~~~~~~~~~~~
1 warning generated.
ld: warning: ignoring duplicate libraries: '-lcrypto', '-lodbc', '-lpq', '-lsqlite3', '-lssl', '-lxml2', '-lxslt', '-lz'
✅ 构建成功！v_php_ext.so 已就绪。

```
### Test
```bash
vphpext/v_php_ext on main [!?] php -d extension=./v_php_ext.so tests/test_exception.php
VPHP Framework initialized.
dlroW olleH

PHP Fatal error:  Uncaught Exception: 至少需要一个参数 in /Users/guweigang/Source/vphpext/v_php_ext/tests/test_exception.php:4
Stack trace:
#0 /Users/guweigang/Source/vphpext/v_php_ext/tests/test_exception.php(4): v_logic_main()
#1 {main}
  thrown in /Users/guweigang/Source/vphpext/v_php_ext/tests/test_exception.php on line 4

Fatal error: Uncaught Exception: 至少需要一个参数 in /Users/guweigang/Source/vphpext/v_php_ext/tests/test_exception.php:4
Stack trace:
#0 /Users/guweigang/Source/vphpext/v_php_ext/tests/test_exception.php(4): v_logic_main()
#1 {main}
  thrown in /Users/guweigang/Source/vphpext/v_php_ext/tests/test_exception.php on line 4
```
