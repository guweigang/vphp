module compiler

import compiler.repr

fn uniq_lines(lines []string) []string {
	mut out := []string{}
	mut seen := map[string]bool{}
	for line in lines {
		normalized := line.trim_space()
		if normalized == '' || normalized in seen {
			continue
		}
		seen[normalized] = true
		out << line
	}
	return out
}

fn closure_universal_helper_for(return_type string) string {
	return match return_type {
		'ClosureUniversal0', 'vphp.ClosureUniversal0' { 'wrap_closure_universal_0' }
		'ClosureUniversal1', 'vphp.ClosureUniversal1' { 'wrap_closure_universal_1' }
		'ClosureUniversal2', 'vphp.ClosureUniversal2' { 'wrap_closure_universal_2' }
		'ClosureUniversal3', 'vphp.ClosureUniversal3' { 'wrap_closure_universal_3' }
		'ClosureUniversal4', 'vphp.ClosureUniversal4' { 'wrap_closure_universal_4' }
		'ClosureUniversal0Void', 'vphp.ClosureUniversal0Void' { 'wrap_closure_universal_0_void' }
		'ClosureUniversal1Void', 'vphp.ClosureUniversal1Void' { 'wrap_closure_universal_1_void' }
		'ClosureUniversal2Void', 'vphp.ClosureUniversal2Void' { 'wrap_closure_universal_2_void' }
		'ClosureUniversal3Void', 'vphp.ClosureUniversal3Void' { 'wrap_closure_universal_3_void' }
		'ClosureUniversal4Void', 'vphp.ClosureUniversal4Void' { 'wrap_closure_universal_4_void' }
		else { '' }
	}
}

fn is_internal_parent_scalar_field(v_type string) bool {
	return v_type in ['string', 'int', 'i64', 'bool', 'f64']
}

fn is_internal_parent_zval_field(v_type string) bool {
	return v_type == 'vphp.ZVal' || v_type == 'ZVal'
}

fn (g VGenerator) gen_class_startup(r &repr.PhpClassRepr) []string {
	mut out := []string{}
	for iface in r.auto_interface_bindings {
		out << "    vphp.register_auto_interface_binding('${r.php_name}', '${iface}')"
	}
	return out
}

// 检查是否为 V 关键字，如果是，则调用时需要加 @ 前缀
fn is_v_keyword(name string) bool {
	keywords := [
		'as',
		'asm',
		'assert',
		'atomic',
		'break',
		'chan',
		'const',
		'continue',
		'defer',
		'else',
		'enum',
		'false',
		'fn',
		'for',
		'go',
		'goto',
		'if',
		'import',
		'in',
		'interface',
		'is',
		'isreftype',
		'lock',
		'match',
		'module',
		'mut',
		'nil',
		'none',
		'or',
		'pub',
		'return',
		'rlock',
		'select',
		'shared',
		'sizeof',
		'struct',
		'true',
		'type',
		'typeof',
		'union',
		'unsafe',
		'volatile',
		'__global',
		'__offsetof',
		'spawn',
	]
	return name in keywords
}

// ---- Task Auto-Registration Glue ----
fn (g VGenerator) gen_task_registration(t &repr.PhpTaskRepr) string {
	mut out := []string{}

	out << "    vphp.ITask.register('${t.task_name}', fn (args []vphp.ZVal) vphp.ITask {"
	out << '        return ${t.v_name}{'

	for i, param in t.parameters {
		out << '            ${param.name}: args[${i}].to_v[${param.v_type}]() or { ${task_zero_value_literal(param.v_type)} }'
	}

	out << '        }'
	out << '    })'
	return out.join('\n')
}

fn task_zero_value_literal(v_type string) string {
	clean := v_type.trim_space()
	return match clean {
		'string' {
			"''"
		}
		'bool' {
			'false'
		}
		'int', 'i8', 'i16', 'i32', 'i64', 'u8', 'u16', 'u32', 'u64', 'usize', 'isize' {
			'0'
		}
		'f32', 'f64' {
			'0.0'
		}
		else {
			if clean.starts_with('[]') {
				'${clean}{}'
			} else if clean.starts_with('map[') {
				'${clean}{}'
			} else {
				'${clean}{}'
			}
		}
	}
}
