module compiler

pub struct TypeMap {
pub:
	v_type     string // V 原始类型: "int", "string", "!bool", "?int"
	c_type     string // C 侧 extern 声明类型: "int", "v_string", "v_res_bool"
	php_return string // PHP 返回宏: "RETURN_LONG", "VPHP_RETURN_STRING"
	is_result  bool   // 是否为 Result 类型 (带 !)，需特殊处理异常
	is_option  bool   // 是否为 Option 类型 (带 ?)，成功返回值，none 返回 null
}

pub fn normalize_export_type_key(v_type string) string {
	mut clean_type := v_type.trim_space().replace('vphp.ZVal', 'ZVal')
	if clean_type.starts_with('&') || clean_type.starts_with('!') || clean_type.starts_with('?') {
		clean_type = clean_type[1..]
	}
	if !clean_type.starts_with('[]') && !clean_type.starts_with('map[') && clean_type.contains('.') {
		clean_type = clean_type.all_after('.')
	}
	return clean_type
}

// 静态方法：根据 V 的返回类型字符串获取映射表
pub fn TypeMap.get_type(v_type string) TypeMap {
	clean_type := normalize_export_type_key(v_type)

	return match clean_type {
		'int'    { TypeMap{'int', 'int', 'RETURN_LONG', false, false} }
		'i64'    { TypeMap{'i64', 'long long', 'RETURN_LONG', false, false} }
		'f32'    { TypeMap{'f32', 'double', 'RETURN_DOUBLE', false, false} }
		'f64'    { TypeMap{'f64', 'double', 'RETURN_DOUBLE', false, false} }
		'bool'   { TypeMap{'bool', 'bool', 'RETURN_BOOL', false, false} }
		'string' { TypeMap{'string', 'v_string', 'VPHP_RETURN_STRING', false, false} }
		'Value', 'BorrowedValue', 'PersistentValue', 'ZVal' {
			TypeMap{clean_type, 'zval', 'RETURN_NULL', false, false}
		}
		'[]string', '[]int', '[]i64', '[]bool', '[]f64', '[]f32', '[]', '[]ZVal' {
			TypeMap{clean_type, 'zval', 'RETURN_NULL', false, false}
		}
		'map[string]string', 'map[string]int', 'map[string]i64', 'map[string]bool', 'map[string]f64', 'map[string][]string', 'map[string]ZVal' {
			TypeMap{clean_type, 'zval', 'RETURN_NULL', false, false}
		}

		// 💡 核心：处理带 ! 的 Result 类型
		'!bool'   { TypeMap{'!bool', 'void', 'RETURN_NULL', true, false} }
		'!int'    { TypeMap{'!int', 'void', 'RETURN_NULL', true, false} }
		'!i64'    { TypeMap{'!i64', 'void', 'RETURN_NULL', true, false} }
		'!f32'    { TypeMap{'!f32', 'void', 'RETURN_NULL', true, false} }
		'!f64'    { TypeMap{'!f64', 'void', 'RETURN_NULL', true, false} }
		'!string' { TypeMap{'!string', 'void', 'RETURN_NULL', true, false} }

		// 💡 核心：处理带 ? 的 Option 类型
		'?bool'   { TypeMap{'?bool', 'void', 'RETURN_NULL', false, true} }
		'?int'    { TypeMap{'?int', 'void', 'RETURN_NULL', false, true} }
		'?i64'    { TypeMap{'?i64', 'void', 'RETURN_NULL', false, true} }
		'?f32'    { TypeMap{'?f32', 'void', 'RETURN_NULL', false, true} }
		'?f64'    { TypeMap{'?f64', 'void', 'RETURN_NULL', false, true} }
		'?string' { TypeMap{'?string', 'void', 'RETURN_NULL', false, true} }

		// 默认处理 (void 或未知类型)
		'void',''   { TypeMap{'void', 'void', 'RETURN_NULL', false, false} }
		else     {
			if clean_type.starts_with('!') {
				// Result 类型：!void 或 !SomeClass — V glue 侧处理 or{}，C 侧统一 void
				TypeMap{v_type, 'void', 'RETURN_NULL', true, false}
			} else if clean_type.starts_with('?') {
				// Option 类型：?void 或 ?SomeClass — V glue 侧处理 or{}，C 侧统一 void
				TypeMap{v_type, 'void', 'RETURN_NULL', false, true}
			} else {
				// 💡 关键：如果是类名（如 Article），在 C 侧统一视为 void*
				TypeMap{v_type, 'void*', 'RETURN_NULL', false, false}
			}
		}
	}
}
