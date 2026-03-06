module repr

pub struct PhpClassRepr {
pub mut:
	name       string      // V struct 名 (如 VPhpTask)
	php_name   string      // PHP 侧类名 (如 VPhp\Task)，可含命名空间
	parent     string      // 继承关系
	is_trait   bool
	is_final   bool
	is_abstract bool
	embeds_v   []string
	implements_v []string
	implements_attr []string
	implements []string
	shadow_const_name string  // 绑定的影子常量名，如 "article_consts"
	shadow_static_name string // 新增：绑定的影子静态属性名，如 "article_statics"
	shadow_const_type string  // 绑定的影子常量的 V 侧类型
	shadow_static_type string // 新增：绑定的影子静态属性的 V 侧类型
	constants  []PhpClassConst
	properties []PhpClassProp
	methods    []PhpMethodRepr
}

// C 宏安全名称：将 \ 替换为 _
pub fn (r PhpClassRepr) c_name() string {
	return r.php_name.replace('\\', '_')
}

pub struct PhpClassConst {
pub:
	name         string // PHP 侧大写名，如 "MAX_TITLE_LEN"
	v_field_name string // V 侧原始名，如 "max_title_len"
	value        string
	const_type   string
}

pub struct PhpClassProp {
pub:
	name       string
	v_type     string // V 端的原始类型，如 'int', 'string', 'bool'
	visibility string // 'public', 'protected', 'private'
	is_static  bool
	is_mut     bool
}

pub struct PhpMethodRepr {
pub mut:
    name          string   // PHP 侧方法名，如 "create"
    v_name        string   // V 侧原始方法名，如 "spawn"
    v_c_func      string   // V 导出的 C 符号名，如 "Article_create"
    is_static     bool     // 是否为静态方法
    return_type   string   // 返回类型，如 "bool" 或 "&Article"
    args          []PhpArg
    has_export    bool
    visibility    string
    is_abstract   bool
}

pub struct PhpArg {
pub mut:
    name   string
    v_type string
}

pub fn new_class_repr() &PhpClassRepr { return &PhpClassRepr{} }
