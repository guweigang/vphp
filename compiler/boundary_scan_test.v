module compiler

import os

fn repo_root() string {
	return os.real_path(os.join_path(os.dir(@FILE), '..', '..'))
}

fn read_repo_file(path string) string {
	return os.read_file(os.join_path(repo_root(), path)) or {
		panic('failed to read ${path}: ${err}')
	}
}

fn assert_no_boundary_regressions(path string, source string) {
	banned := [
		'Context.from_entry(',
		'Context.from_raw(',
		'ZendExecuteData.new(',
		'PhpReturn.from_ptr(rv)',
		'.raw_ex()',
		'.raw_zval()',
		'ZVal.from_raw(',
		'ZVal.from_ptr(value)',
		'ZVal.from_ptr(zv)',
		'ZendObject.from_raw(',
		'ZendClassEntry.from_raw(',
		'name_ptr.vstring_with_len(name_len)',
		'args_from_zvals(',
		'new_val_null(',
		'new_val_int(',
		'new_val_float(',
		'new_val_bool(',
		'new_val_string(',
		'new_val_from[',
		'arg.as_int()',
		'C.ZVAL_',
		'C.zval{}',
	]
	for pattern in banned {
		assert !source.contains(pattern), '${path} should not contain ${pattern}'
	}
	for line in source.split_into_lines() {
		trimmed := line.trim_space()
		is_generated_class_entry_ref :=
			trimmed.starts_with('return vphp.ZendClassEntry.from_ptr(C.')
			&& trimmed.ends_with('_ce)')
		if line.contains('C.vphp_') && !line.starts_with('__global C.')
			&& !is_generated_class_entry_ref {
			assert false, '${path} should not call ${line.trim_space()}'
		}
	}
}

fn test_generated_bridge_keeps_raw_only_at_known_boundaries() {
	source := read_repo_file('vphptest/vphp_bridge.v')
	assert_no_boundary_regressions('vphptest/vphp_bridge.v', source)

	closure_sig_count := source.count('ex &C.zend_execute_data, ret &C.zval')
	assert closure_sig_count > 0
	assert closure_sig_count == source.count('vphp.Context.from_ptr(ex, ret)')
	assert !source.contains('res := cb(args)')
	assert source.contains('ctx.invoke_struct_closure[')
	assert source.contains('ctx.invoke_variadic_closure[')
}

fn test_compiler_does_not_emit_stale_raw_runtime_entries() {
	files := [
		'vphp/compiler/v_glue.v',
		'vphp/compiler/v_glue_func.v',
		'vphp/compiler/v_glue_class.v',
		'vphp/compiler/class_method_binding.v',
		'vphp/compiler/class_property_binding.v',
		'vphp/compiler/struct_closure_binding.v',
		'vphp/compiler/return_binding.v',
		'vphp/compiler/arg_binding.v',
		'vphp/compiler/params_struct_binding.v',
	]
	for file in files {
		assert_no_boundary_regressions(file, read_repo_file(file))
	}
}

fn test_compiler_keeps_property_callback_abi_signatures_centralized() {
	source := read_repo_file('vphp/compiler/class_property_binding.v')
	allowed := [
		"return 'pub fn \${lower_name}_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {'",
		"return 'pub fn \${lower_name}_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {'",
		"return 'pub fn \${lower_name}_sync_props(ptr voidptr, zv &C.zval) {'",
	]
	for expected in allowed {
		assert source.contains(expected), 'class_property_binding.v lost centralized property ABI helper ${expected}'
	}
	for line in source.split_into_lines() {
		if line.contains('&C.zval') || line.contains('name_ptr &char') {
			assert line.trim_space() in allowed, 'class_property_binding.v introduced raw property ABI outside helpers: ${line.trim_space()}'
		}
	}
}

fn test_compiler_keeps_closure_bridge_abi_signature_centralized() {
	source := read_repo_file('vphp/compiler/struct_closure_binding.v')
	expected := "return 'fn \${binding.bridge}(v_ptr voidptr, ex &C.zend_execute_data, ret &C.zval) {'"
	assert source.contains(expected), 'struct_closure_binding.v lost centralized closure bridge ABI helper'
	for line in source.split_into_lines() {
		if line.contains('&C.zend_execute_data') || line.contains('&C.zval') {
			assert line.trim_space() == expected, 'struct_closure_binding.v introduced raw closure ABI outside helper: ${line.trim_space()}'
		}
	}
}

fn test_context_keeps_execute_and_return_wrappers() {
	source := read_repo_file('vphp/context.v')
	assert source.contains('ex  ZendExecuteData'), 'Context.ex should stay wrapped as ZendExecuteData'
	assert source.contains('ret PhpReturn'), 'Context.ret should stay wrapped as PhpReturn'
	for line in source.split_into_lines() {
		assert !line.contains('&C.zend_execute_data'), 'Context should not store raw execute data: ${line.trim_space()}'
		assert !line.contains('&C.zval'), 'Context should not store raw return zval: ${line.trim_space()}'
	}
}

fn test_root_files_do_not_reintroduce_zend_prefixed_helpers() {
	vphp_root := os.join_path(repo_root(), 'vphp')
	for file in os.walk_ext(vphp_root, '.v') {
		path := file.all_after(repo_root() + os.path_separator)
		if path.starts_with('vphp/zend/') {
			continue
		}
		source := read_repo_file(path)
		for line in source.split_into_lines() {
			if line.starts_with('fn zend_') {
				assert false, '${path} introduced root Zend-prefixed helper ${line}'
			}
		}
	}
}

fn test_root_files_do_not_reintroduce_raw_zval_lifecycle_helpers() {
	vphp_root := os.join_path(repo_root(), 'vphp')
	banned := [
		'request_raw_zval',
		'persistent_raw_zval',
		'release_request_raw_zval',
		'release_persistent_raw_zval',
		'disown_raw_zval',
		'copy_raw_zval',
	]
	for file in os.walk_ext(vphp_root, '.v') {
		path := file.all_after(repo_root() + os.path_separator)
		if path == 'vphp/compiler/boundary_scan_test.v' {
			continue
		}
		source := read_repo_file(path)
		for pattern in banned {
			assert !source.contains(pattern), '${path} should use ZVal/zval.Handle lifecycle helpers instead of ${pattern}'
		}
	}
}

fn test_compiler_emits_compat_wrapped_raw_fentry() {
	vphp_compiler := os.join_path(repo_root(), 'vphp', 'compiler')
	for file in os.walk_ext(vphp_compiler, '.v') {
		path := file.all_after(repo_root() + os.path_separator)
		if path == 'vphp/compiler/boundary_scan_test.v' {
			continue
		}
		source := read_repo_file(path)
		for line in source.split_into_lines() {
			trimmed := line.trim_space()
			if trimmed.contains('ZEND_RAW_FENTRY(') && !trimmed.contains('VPHP_ZEND_RAW_FENTRY(') {
				assert false, '${path} should emit VPHP_ZEND_RAW_FENTRY through compat.h: ${trimmed}'
			}
		}
	}

	compat := read_repo_file('vphp/bridge/compat.h')
	assert compat.contains('VPHP_ZEND_RAW_FENTRY'), 'compat.h should keep the PHP-version-aware raw fentry wrapper'
}

fn test_semantic_php_wrappers_do_not_touch_c_boundary_directly() {
	vphp_root := os.join_path(repo_root(), 'vphp')
	for file in os.walk_ext(vphp_root, '.v') {
		path := file.all_after(repo_root() + os.path_separator)
		base := os.base(path)
		if !base.starts_with('php_') {
			continue
		}
		if base in ['php_wrapper_interface.v'] {
			continue
		}
		source := read_repo_file(path)
		for line in source.split_into_lines() {
			trimmed := line.trim_space()
			assert !trimmed.contains('C.'), '${path} semantic wrapper should not use C boundary directly: ${trimmed}'
			assert !trimmed.contains('&C.'), '${path} semantic wrapper should not expose C pointers: ${trimmed}'
			assert !trimmed.contains('ZEND_'), '${path} semantic wrapper should not use Zend macros directly: ${trimmed}'
			assert !trimmed.contains('zend_'), '${path} semantic wrapper should not call Zend APIs directly: ${trimmed}'
		}
	}
}

fn test_no_c_low_level_wrapper_dirs_do_not_touch_c_boundary_directly() {
	for dir in ['vphp/zval', 'vphp/object', 'vphp/execute', 'vphp/scope'] {
		for file in os.walk_ext(os.join_path(repo_root(), dir), '.v') {
			path := file.all_after(repo_root() + os.path_separator)
			source := read_repo_file(path)
			for line in source.split_into_lines() {
				trimmed := line.trim_space()
				assert !trimmed.contains('C.'), '${path} no-C wrapper should delegate C boundary work to vphp/zend: ${trimmed}'
				assert !trimmed.contains('&C.'), '${path} no-C wrapper should not expose raw C pointers: ${trimmed}'
				assert !trimmed.contains('ZEND_'), '${path} no-C wrapper should not use Zend macros directly: ${trimmed}'
			}
		}
	}
}
