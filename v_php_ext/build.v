import os

fn main() {
    println('🛠️  1. 运行 Codegen...')
    gen_res := os.execute('v run tools/codegen.v')
    if gen_res.exit_code != 0 {
          println('❌ Codegen 失败: ' + gen_res.output)
          return
    }

    println('🛠️  2. 转译 V 逻辑...')
    v_res := os.execute('v -gc none -path "@vlib:.:.." -shared -o v_logic.c .')
    if v_res.exit_code != 0 {
          println('❌ V 编译失败: ' + v_res.output)
          return
    }

    println('🛠️  3. GCC 最终链接...')
  	php_inc := os.execute('php-config --includes').output.trim_space()
  	php_ldflags := os.execute('php-config --ldflags').output.trim_space()
  	php_libs := os.execute('php-config --libs').output.replace('-lzip', '').trim_space()
  	gcc_cmd := 'gcc -shared -fPIC -DCOMPILE_DL_V_PHP_EXT=1 ' +
  			   '$php_inc v_logic.c php_bridge.c ../vphp/v_bridge.c -o v_php_ext.so ' +
  				 '-I../vphp ' +  // 👈 核心：让 GCC 找得到头文件
  			   '$php_ldflags $php_libs -undefined dynamic_lookup -fvisibility=default'

  	if os.system(gcc_cmd) != 0 {
  		eprintln('❌ GCC 编译失败')
  		return
  	}

  	println('✅ 构建成功！v_php_ext.so 已就绪。')
  }
