module compiler

pub struct TypeMap {
pub:
	v_type     string // V 原始类型: "int", "string", "!bool"
	c_type     string // C 侧 extern 声明类型: "int", "v_string", "v_res_bool"
	php_return string // PHP 返回宏: "RETURN_LONG", "VPHP_RETURN_STRING"
	is_result  bool   // 是否为 Result 类型 (带 !)，需特殊处理异常
}

// 静态方法：根据 V 的返回类型字符串获取映射表
pub fn TypeMap.get_type(v_type string) TypeMap {
	// 简单清理，防止模块名干扰（如 main.Article -> Article）
	clean_type := if v_type.contains('.') { v_type.all_after('.') } else { v_type }

	return match clean_type {
		'int'    { TypeMap{'int', 'int', 'RETURN_LONG', false} }
		'i64'    { TypeMap{'i64', 'long long', 'RETURN_LONG', false} }
		'bool'   { TypeMap{'bool', 'bool', 'RETURN_BOOL', false} }
		'string' { TypeMap{'string', 'v_string', 'VPHP_RETURN_STRING', false} }

		// 💡 核心：处理带 ! 的 Result 类型
		'!bool'  { TypeMap{'!bool', 'v_res_bool', 'VPHP_RETURN_RESULT_BOOL', true} }
		'!int'   { TypeMap{'!int', 'v_res_int', 'VPHP_RETURN_RESULT_LONG', true} }

		// 默认处理 (void 或未知类型)
		'void',''   { TypeMap{'void', 'void', 'RETURN_NULL', false} }
		else     {
			// 💡 关键：如果是类名（如 Article），在 C 侧统一视为 void*
			TypeMap{v_type, 'void*', 'RETURN_NULL', false}
		}
	}
}
