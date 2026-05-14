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
		'ZExData.new(',
		'.raw_ex()',
		'.raw_zval()',
		'ZVal.from_raw(',
		'ZendObject.from_raw(',
		'ZendClassEntry.from_raw(',
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
		if line.contains('C.vphp_') && !line.starts_with('__global C.') {
			assert false, '${path} should not call ${line.trim_space()}'
		}
	}
}

fn test_generated_bridge_keeps_raw_only_at_known_boundaries() {
	source := read_repo_file('vphptest/bridge.v')
	assert_no_boundary_regressions('vphptest/bridge.v', source)

	closure_sig_count := source.count('ex &C.zend_execute_data, ret &C.zval')
	assert closure_sig_count > 0
	assert closure_sig_count == source.count('vphp.Context.from_ptr(ex, ret)')
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
