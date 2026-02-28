import os
import vphp.compiler // 现在这行可以被识别了

fn main() {
    target_file := 'v_logic.v'

    println('🛠️  1. 启动 VPHP Compiler 流程...')

    // 实例化并运行编译器
    // 注意：new 内部会自动从 v_logic.v 的 ext_config 中解析 ext_name
    mut vphp_c := compiler.new(target_file)

    vphp_c.compile() or {
        eprintln('❌ 编译阶段失败: $err')
        return
    }

    vphp_c.generate_all() or {
        eprintln('❌ 代码生成失败: $err')
        return
    }
    // 1. 定义要屏蔽的警告
    // -Wno-pointer-to-int-cast: 解决 cJSON 警告
    // -Wno-incompatible-pointer-types: 解决 mach_task 警告
    disabled_warnings := '-Wno-pointer-to-int-cast -Wno-incompatible-pointer-types'

    // 2. 整理库路径，cJson include path
    brew_path := '/opt/homebrew'
    os.setenv('C_INCLUDE_PATH', '${brew_path}/include/cjson', true)

    println('🛠️  2. 转译 V 逻辑为 C...')
    // 确保这里也带上路径，以便找到生成的 _task_glue.v 和 vphp 依赖
    v_res := os.execute('v -enable-globals -gc none -path "@vlib:.:.." -shared -o v_logic.c .')
    if v_res.exit_code != 0 {
        println('❌ V 编译失败: ${v_res.output}')
        return
    }

    println('🛠️  3. GCC 最终链接...')
  	php_inc := os.execute('php-config --includes').output.trim_space()
  	php_ldflags := os.execute('php-config --ldflags').output.trim_space()
  	php_libs := os.execute('php-config --libs').output.replace('-lzip', '').trim_space()

  	gcc_cmd := 'gcc -shared -fPIC ${disabled_warnings} -DCOMPILE_DL_V_PHP_EXT=1 ' +
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
