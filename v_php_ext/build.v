import os

fn main() {
    // 假设你想编译 bullsoft_fitness.v
    target_file := 'v_logic.v'

    println('🛠️  1. 运行 Codegen，目标文件: $target_file ...')
    // 将文件名作为参数传给 codegen.v
    gen_res := os.execute('v run tools/codegen.v $target_file')

    // 检查退出码是否不为 0 (表示执行失败)
    if gen_res.exit_code != 0 {
        // 使用 $ 插值语法打印输出，比字符串相加更稳健
        println('❌ Codegen 失败: ${gen_res.output}')
        return
    }

    // cJson include path
    brew_path := '/opt/homebrew'
    os.setenv('C_INCLUDE_PATH', '${brew_path}/include/cjson', true)

    println('🛠️  2. 转译 V 逻辑...')
    v_res := os.execute('v -enable-globals -gc none -path "@vlib:.:.." -shared -o v_logic.c .')
    if v_res.exit_code != 0 {
          println('❌ V 编译失败: ' + v_res.output)
          return
    }

    println('🛠️  3. GCC 最终链接...')
  	php_inc := os.execute('php-config --includes').output.trim_space()
  	php_ldflags := os.execute('php-config --ldflags').output.trim_space()
  	php_libs := os.execute('php-config --libs').output.replace('-lzip', '').trim_space()

  	gcc_cmd := 'gcc -shared -fPIC -DCOMPILE_DL_V_PHP_EXT=1 ' +
           '-I${brew_path}/include -L${brew_path}/lib -lcjson ' +  // cJson library
           '-DcJSON_GetErrorPos=cJSON_GetErrorPtr ' + // cJson version compatible
  			   '$php_inc v_logic.c php_bridge.c ../vphp/v_bridge.c -o v_php_ext.so ' +
  				 '-I../vphp ' +  // 👈 核心：让 GCC 找得到头文件
  			   '$php_ldflags $php_libs -undefined dynamic_lookup -fvisibility=default'

  	if os.system(gcc_cmd) != 0 {
  		eprintln('❌ GCC 编译失败')
  		return
  	}

  	println('✅ 构建成功！v_php_ext.so 已就绪。')
  }
