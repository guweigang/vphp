module repr

pub struct PhpConstRepr {
pub mut:
	name          string // 导出到 PHP 的常量名（自动大写）
	value         string // 常量值的字符串形式
	const_type    string // 'int', 'f64', 'string', 'bool', 'struct'
	v_type        string // 该常量在 V 侧的类型名，如 "ArticleConsts"
	has_php_const bool   // 是否显式导出为 PHP 全局常量
	fields        map[string]PhpConstRepr // 如果是结构体，存储其子字段
}

pub fn new_const_repr() &PhpConstRepr { return &PhpConstRepr{} }
