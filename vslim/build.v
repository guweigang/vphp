import os
import vphp.compiler

fn main() {
	source_dir := 'src'
	mut target_files := []string{}

	if os.args.len > 1 && os.args[1].ends_with('.v') {
		target_files = os.args[1..].clone()
	} else {
		files := os.ls(source_dir) or { []string{} }
		for f in files {
			if f.ends_with('.v') && f != 'build.v' && f != 'bridge.v' && f != 'mod.v' && !f.ends_with('_test.v') {
				target_files << os.join_path(source_dir, f)
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
		eprintln('❌ 编译阶段失败: ${err}')
		return
	}

	vphp_c.generate_all() or {
		eprintln('❌ 代码生成失败: ${err}')
		return
	}

	disabled_warnings := '-Wno-pointer-to-int-cast -Wno-incompatible-pointer-types -Wno-initializer-overrides'
	brew_path := '/opt/homebrew'
	os.setenv('C_INCLUDE_PATH', '${brew_path}/include/cjson', true)

	transpiled_c := 'vphp_ext_${ext_name}.c'
	output_so := '${ext_name}.so'
	println('🛠️  2. 转译 V 逻辑为 C -> ${transpiled_c}')
	os.rm(output_so) or {}

	v_res := os.execute('v -nocache -enable-globals -gc none -path ".:..:@vlib" -shared -o ${transpiled_c} ${source_dir}')
	if v_res.exit_code != 0 {
		println('❌ V 编译失败: ${v_res.output}')
		return
	}

	println('🛠️  3. GCC 最终链接...')
	php_inc := os.execute('php-config --includes').output.trim_space()
	php_ldflags := os.execute('php-config --ldflags').output.trim_space()
	php_libs := os.execute('php-config --libs').output.replace('-lzip', '').trim_space()

	gcc_cmd := 'gcc -shared -fPIC ${disabled_warnings} -DCOMPILE_DL_${ext_name.to_upper()}=1 ' +
		'-I${brew_path}/include -L${brew_path}/lib -lcjson ' +
		'-DcJSON_GetErrorPos=cJSON_GetErrorPtr ' +
		'${php_inc} ${transpiled_c} php_bridge.c ../vphp/v_bridge.c -o ${output_so} ' +
		'-I../vphp ' +
		'${php_ldflags} ${php_libs} -undefined dynamic_lookup -fvisibility=default'

	println('执行命令: ${gcc_cmd}')
	if os.system(gcc_cmd) != 0 {
		eprintln('❌ GCC 编译失败')
		exit(1)
	}

	if !os.exists(output_so) {
		eprintln('❌ 错误：${output_so} 未生成！')
		exit(1)
	}

	println('✅ 构建成功！${output_so} 已就绪。')
}
