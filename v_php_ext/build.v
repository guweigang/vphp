import os
import vphp.compiler // 现在这行可以被识别了

fn main() {
    mut target_files := []string{}
    
    // 如果命令行带了参数，优先用命令行指定的，否则扫描当前目录
    if os.args.len > 1 && os.args[1].ends_with('.v') {
        target_files = os.args[1..].clone()
    } else {
        files := os.ls('.') or { []string{} } // os 也是可以直接 ls
        for f in files {
            // bridge.v 是接下来生成给 V 编译器内联的生成物，build.v 是自身，排除掉。
            // 同样排除通常作为包声明的 mod.v 以及所有的单元测试文件
            if f.ends_with('.v') && f != 'build.v' && f != 'bridge.v' && f != 'mod.v' && !f.ends_with('_test.v') {
                target_files << f
            }
        }
    }

    if target_files.len == 0 {
        eprintln('❌ 未找到任何 V 源文件进行编译！')
        return
    }
    
    println('🛠️  1. 启动 VPHP Compiler 流程... \n 解析文件: $target_files')

    // 实例化并运行编译器
    mut vphp_c := compiler.new(target_files)

    ext_name := vphp_c.compile() or {
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

    transpiled_c := 'vphp_ext_${ext_name}.c'
    println('🛠️  2. 转译 V 逻辑为 C -> ${transpiled_c}')
    // 确保这里也带上路径，以便找到生成的 _task_glue.v 和 vphp 依赖
    v_res := os.execute('v -enable-globals -gc none -path "@vlib:.:.." -shared -o ${transpiled_c} .')
    if v_res.exit_code != 0 {
        println('❌ V 编译失败: ${v_res.output}')
        return
    }

    println('🛠️  3. GCC 最终链接...')
  	php_inc := os.execute('php-config --includes').output.trim_space()
  	php_ldflags := os.execute('php-config --ldflags').output.trim_space()
  	php_libs := os.execute('php-config --libs').output.replace('-lzip', '').trim_space()

  	gcc_cmd := 'gcc -shared -fPIC ${disabled_warnings} -DCOMPILE_DL_${ext_name.to_upper()}=1 ' +
           '-I${brew_path}/include -L${brew_path}/lib -lcjson ' +  // cJson library
           '-DcJSON_GetErrorPos=cJSON_GetErrorPtr ' + // cJson version compatible
  			   '$php_inc ${transpiled_c} php_bridge.c ../vphp/v_bridge.c -o v_php_ext.so ' +
  				 '-I../vphp ' +  // 👈 核心：让 GCC 找得到头文件
  			   '$php_ldflags $php_libs -undefined dynamic_lookup -fvisibility=default'

  	if os.system(gcc_cmd) != 0 {
  		eprintln('❌ GCC 编译失败')
  		return
  	}

  	println('✅ 构建成功！v_php_ext.so 已就绪。')
}
