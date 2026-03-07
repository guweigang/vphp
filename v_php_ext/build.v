import os
import vphp.compiler 

fn sanitize_ldflags(ldflags string) string {
	mut kept := []string{}
	for token in ldflags.split(' ') {
		t := token.trim_space()
		if t == '' {
			continue
		}
		if t.starts_with('-L') && t.len > 2 {
			path := t[2..]
			if !os.exists(path) {
				continue
			}
		}
		kept << t
	}
	return kept.join(' ')
}

fn main() {
    mut target_files := []string{}
    
    if os.args.len > 1 && os.args[1].ends_with('.v') {
        target_files = os.args[1..].clone()
    } else {
        files := os.ls('.') or { []string{} }
        for f in files {
            if f.ends_with('.v') && f != 'build.v' && f != 'bridge.v' && f != 'mod.v' && !f.ends_with('_test.v') {
                target_files << f
            }
        }
    }
    if target_files.len == 0 {
        eprintln('❌ 未找到任何 V 源文件进行编译！')
        return
    }
    
    println('🛠️  1. 启动 VPHP Compiler 流程...')
    mut vphp_c := compiler.new(target_files)

    ext_name := vphp_c.compile() or {
        eprintln('❌ 编译阶段失败: $err')
        return
    }

    vphp_c.generate_all() or {
        eprintln('❌ 代码生成失败: $err')
        return
    }
    
    disabled_warnings := '-Wno-pointer-to-int-cast -Wno-incompatible-pointer-types -Wno-initializer-overrides'
    brew_path := '/opt/homebrew'
    os.setenv('C_INCLUDE_PATH', '${brew_path}/include/cjson', true)

    transpiled_c := 'vphp_ext_${ext_name}.c'
    println('🛠️  2. 转译 V 逻辑为 C -> ${transpiled_c}')
    
    // 强制清理旧文件
    os.rm('v_php_ext.so') or { }
    
    v_res := os.execute('v -nocache -enable-globals -gc none -path ".:..:@vlib" -shared -o ${transpiled_c} .')
    if v_res.exit_code != 0 {
        println('❌ V 编译失败: ${v_res.output}')
        return
    }

    println('🛠️  3. GCC 最终链接...')
  	php_inc := os.execute('php-config --includes').output.trim_space()
  	php_ldflags := sanitize_ldflags(os.execute('php-config --ldflags').output.trim_space())
  	php_libs := os.execute('php-config --libs').output.replace('-lzip', '').trim_space()

  	gcc_cmd := 'gcc -shared -fPIC ${disabled_warnings} -DCOMPILE_DL_${ext_name.to_upper()}=1 ' +
           '-I${brew_path}/include -L${brew_path}/lib -lcjson ' + 
           '-DcJSON_GetErrorPos=cJSON_GetErrorPtr ' + 
   			   '$php_inc ${transpiled_c} php_bridge.c ../vphp/v_bridge.c -o v_php_ext.so ' +
   				 '-I../vphp ' + 
   			   '$php_ldflags $php_libs -undefined dynamic_lookup -fvisibility=default'

    println('执行命令: $gcc_cmd')
  	if os.system(gcc_cmd) != 0 {
  		eprintln('❌ GCC 编译失败')
  		exit(1)
  	}

    if !os.exists('v_php_ext.so') {
        eprintln('❌ 错误：v_php_ext.so 未生成！')
        exit(1)
    }

  	println('✅ 构建成功！v_php_ext.so 已就绪。')
}
