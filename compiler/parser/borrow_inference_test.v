module parser

// === normalize_delegated_target_type ===

fn test_normalize_strips_optional_marker() {
	assert normalize_delegated_target_type('?MyType') == 'MyType'
}

fn test_normalize_strips_result_marker() {
	assert normalize_delegated_target_type('!MyType') == 'MyType'
}

fn test_normalize_strips_reference_marker() {
	assert normalize_delegated_target_type('&MyType') == 'MyType'
	assert normalize_delegated_target_type('&&MyType') == 'MyType'
}

fn test_normalize_strips_shared_marker() {
	assert normalize_delegated_target_type('shared MyType') == 'MyType'
}

fn test_normalize_strips_atomic_marker() {
	assert normalize_delegated_target_type('atomic MyType') == 'MyType'
}

fn test_normalize_strips_mut_marker() {
	assert normalize_delegated_target_type('mut MyType') == 'MyType'
}

fn test_normalize_strips_combined_markers() {
	assert normalize_delegated_target_type('?&MyType') == 'MyType'
	assert normalize_delegated_target_type('?shared MyType') == 'MyType'
	assert normalize_delegated_target_type('&mut MyType') == 'MyType'
	assert normalize_delegated_target_type('shared mut MyType') == 'MyType'
}

fn test_normalize_extracts_last_segment() {
	assert normalize_delegated_target_type('module.Type') == 'Type'
	assert normalize_delegated_target_type('a.b.c') == 'c'
}

fn test_normalize_preserves_simple_name() {
	assert normalize_delegated_target_type('MyType') == 'MyType'
}

fn test_normalize_handles_spaces() {
	assert normalize_delegated_target_type('  ?MyType  ') == 'MyType'
}

fn test_normalize_empty_string() {
	assert normalize_delegated_target_type('') == ''
}

// === normalize_local_return_like_method_name ===

fn test_normalize_method_construct() {
	assert normalize_local_return_like_method_name('construct') == '__construct'
	assert normalize_local_return_like_method_name('Construct') == '__construct'
}

fn test_normalize_method_init() {
	assert normalize_local_return_like_method_name('init') == '__construct'
}

fn test_normalize_method_str() {
	assert normalize_local_return_like_method_name('str') == '__tostring'
	assert normalize_local_return_like_method_name('Str') == '__tostring'
}

fn test_normalize_method_clone() {
	assert normalize_local_return_like_method_name('clone') == 'clone'
}

fn test_normalize_method_copy() {
	assert normalize_local_return_like_method_name('copy') == 'copy'
}

fn test_normalize_method_strips_module_prefix() {
	// Module prefix is stripped after matching, so 'pkg.clone' → normalize('pkg.clone') → 'clone'
	assert normalize_local_return_like_method_name('module.Type.clone') == 'clone'
	// 'pkg.construct' does NOT become '__construct' because the full string
	// 'pkg.construct' doesn't match 'construct' — matching happens before prefix strip.
	assert normalize_local_return_like_method_name('pkg.construct') == 'construct'
}

fn test_normalize_method_case_insensitive() {
	assert normalize_local_return_like_method_name('CLONE') == 'clone'
	assert normalize_local_return_like_method_name('CONSTRUCT') == '__construct'
}
