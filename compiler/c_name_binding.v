module compiler

import compiler.php_types

fn (g CGenerator) ce_var_for_type(v_type string) string {
	key := php_types.normalize_export_type_key(v_type)
	if key in g.class_ce_by_type {
		return g.class_ce_by_type[key]
	}
	if key.contains('\\') {
		return '${key.replace('\\', '_').to_lower()}_ce'
	}
	return '${key.to_lower()}_ce'
}

fn (g CGenerator) php_name_for_type(v_type string) string {
	key := php_types.normalize_export_type_key(v_type)
	if key in g.class_php_by_type {
		return g.class_php_by_type[key]
	}
	return ''
}
