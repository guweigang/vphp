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

fn test_root_zend_helpers_stay_on_known_runtime_boundaries() {
	allowed := {
		'vphp/zval.v': [
			'fn zend_new_zval() &C.zval {',
			'fn zend_new_persistent_zval() &C.zval {',
			'fn zend_release_zval(z &C.zval) {',
			'fn zend_release_persistent_zval(z &C.zval) {',
			'fn zend_disown_zval(z &C.zval) {',
			'fn zend_copy_zval(dst &C.zval, src &C.zval) {',
		]
		'vphp/zend_object_lifecycle.v': [
			'fn zend_allocate_contiguous_object(ce voidptr, v_size usize) voidptr {',
			'fn zend_object_add_ref(obj ZendObject) {',
			'fn zend_object_release(obj ZendObject) {',
			'fn zend_object_bind_handlers(obj ZendObject, handlers voidptr, ownership OwnershipKind) {',
			'fn zend_object_ensure_binding(obj ZendObject, handlers voidptr, ownership OwnershipKind) &C.vphp_object_wrapper {',
			'fn zend_object_init_owned_instance(obj ZendObject, handlers voidptr) {',
			'fn zend_object_wrapper(obj ZendObject) &C.vphp_object_wrapper {',
			'fn zend_wrap_existing_object(out zval.Handle, obj ZendObject) {',
		]
		'vphp/zend_runtime.v': [
			'fn zend_emalloc(size usize) voidptr {',
			'fn zend_efree(ptr voidptr) {',
			'fn zend_throw_exception(msg string, code int) {',
			'fn zend_throw_exception_class(class_name string, msg string, code int) {',
			'fn zend_throw_exception_object(exception zval.Handle) {',
			'fn zend_has_exception() bool {',
			'fn zend_exception_message() string {',
			'fn zend_clear_exception() {',
			'fn zend_report_error(level int, msg string) {',
			'fn zend_output_write(msg string) {',
			'fn zend_framework_init(module_number int) {',
			'fn zend_uninstall_runtime_binding_hooks() {',
			'fn zend_autorelease_shutdown() {',
			'fn zend_shutdown_registry() {',
			'fn zend_request_startup() {',
			'fn zend_request_shutdown() {',
			'fn zend_active_globals_ptr() voidptr {',
			'fn zend_autorelease_mark() int {',
			'fn zend_autorelease_drain(mark int) {',
		]
		'vphp/zval/superglobals.v': [
			'fn zend_superglobal(kind Superglobal) zend.Superglobal {',
		]
	}

	for path, expected_lines in allowed {
		source := read_repo_file(path)
		for expected in expected_lines {
			assert source.contains(expected), '${path} lost expected boundary helper ${expected}'
		}
	}

	vphp_root := os.join_path(repo_root(), 'vphp')
	for file in os.walk_ext(vphp_root, '.v') {
		path := file.all_after(repo_root() + os.path_separator)
		if path.starts_with('vphp/zend/') {
			continue
		}
		source := read_repo_file(path)
		expected_lines := allowed[path] or { []string{} }
		for line in source.split_into_lines() {
			if line.starts_with('fn zend_') {
				assert line in expected_lines, '${path} introduced unclassified root Zend helper ${line}'
			}
		}
	}
}
