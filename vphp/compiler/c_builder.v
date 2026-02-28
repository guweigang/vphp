module compiler

// 定义类属性信息
pub struct ClassProperty {
pub:
	name  string
	type_ string // string, long, double, bool, null
	flags string // ZEND_ACC_PUBLIC | ZEND_ACC_PROTECTED ...
}

// 定义类常量信息
pub struct ClassConstant {
pub:
	name  string
	type_ string // string, long, double, bool
	value string // C 代码字面量表达 (如 "1.0" 或 "true")
}

// 定义类方法信息
pub struct ClassMethod {
pub:
	php_name string
	c_func   string // 包装在 C 的函数名称
	flags    string // ZEND_ACC_PUBLIC | ZEND_ACC_STATIC ...
}

// 核心构建器
pub struct ClassBuilder {
pub mut:
	php_name   string // PHP命名空间类名, 例如 "VPhp\\Task"
	c_name     string // 转换为 C 的名字, 例如 "VPhp_Task"
	parent     string // 父类名称, 默认为空
	properties []ClassProperty
	constants  []ClassConstant
	methods    []ClassMethod
}

pub fn new_class_builder(php_name string, c_name string) &ClassBuilder {
	return &ClassBuilder{
		php_name: php_name
		c_name: c_name
	}
}

pub fn (mut b ClassBuilder) set_parent(parent_name string) &ClassBuilder {
	b.parent = parent_name
	return b
}

pub fn (mut b ClassBuilder) add_property(name string, type_ string, flags string) &ClassBuilder {
	b.properties << ClassProperty{name, type_, flags}
	return b
}

pub fn (mut b ClassBuilder) add_constant(name string, type_ string, value string) &ClassBuilder {
	b.constants << ClassConstant{name, type_, value}
	return b
}

pub fn (mut b ClassBuilder) add_method(php_name string, c_func string, flags string) &ClassBuilder {
	b.methods << ClassMethod{php_name, c_func, flags}
	return b
}

// ---------------------------------------------------------------------
// 渲染层代码
// ---------------------------------------------------------------------

// 渲染方法的 C 数组定义 (zend_function_entry)
pub fn (b &ClassBuilder) render_methods_array() string {
	mut res := []string{}
	lower_name := b.c_name.to_lower()
	res << 'static const zend_function_entry ${lower_name}_methods[] = {'
	
	for m in b.methods {
		// 生成 PHP_ME 宏
		res << '    PHP_ME(${b.c_name}, ${m.php_name}, arginfo_${m.c_func}, ${m.flags})'
	}
	
	res << '    PHP_FE_END\n};\n'
	return res.join('\n')
}

// 渲染 PHP_MINIT 中的类注册过程
pub fn (b &ClassBuilder) render_minit() string {
	mut res := []string{}
	lower_name := b.c_name.to_lower()
	ce_ptr := '${lower_name}_ce'

	res << '    {   zend_class_entry ce;'
	res << '        INIT_CLASS_ENTRY(ce, "${b.php_name}", ${lower_name}_methods);'

	// 1. 继承或普通注册
	if b.parent != '' {
		lower_parent := b.parent.to_lower()
		// 如果在同一扩展内作为前置声明出现的大写类，也能在 CG(class_table) 查到，因为 PHP 的类表 key 全是小写
		res << '        ${ce_ptr} = zend_register_internal_class_ex(&ce, zend_hash_str_find_ptr(CG(class_table), "${lower_parent}", sizeof("${lower_parent}")-1));'
	} else {
		res << '        ${ce_ptr} = zend_register_internal_class(&ce);'
	}

	res << '        ${ce_ptr}->create_object = vphp_create_object_handler;'

	// 2. 渲染常量
	for con in b.constants {
		match con.type_ {
			'string' {
				res << '        zend_declare_class_constant_string(${ce_ptr}, "${con.name}", sizeof("${con.name}")-1, "${con.value}");'
			}
			'double' {
				res << '        zend_declare_class_constant_double(${ce_ptr}, "${con.name}", sizeof("${con.name}")-1, ${con.value});'
			}
			'long', 'int' {
				res << '        zend_declare_class_constant_long(${ce_ptr}, "${con.name}", sizeof("${con.name}")-1, ${con.value});'
			}
			'bool' {
				res << '        zend_declare_class_constant_bool(${ce_ptr}, "${con.name}", sizeof("${con.name}")-1, ${con.value});'
			}
			else {}
		}
	}

	// 3. 渲染属性
	for prop in b.properties {
		match prop.type_ {
			'long', 'int' {
				res << '        zend_declare_property_long(${ce_ptr}, "${prop.name}", sizeof("${prop.name}")-1, 0, ${prop.flags});'
			}
			'double', 'f64' {
				res << '        zend_declare_property_double(${ce_ptr}, "${prop.name}", sizeof("${prop.name}")-1, 0.0, ${prop.flags});'
			}
			'bool' {
				res << '        zend_declare_property_bool(${ce_ptr}, "${prop.name}", sizeof("${prop.name}")-1, 0, ${prop.flags});'
			}
			'string' {
				res << '        zend_declare_property_string(${ce_ptr}, "${prop.name}", sizeof("${prop.name}")-1, "", ${prop.flags});'
			}
			else {
				res << '        zend_declare_property_null(${ce_ptr}, "${prop.name}", sizeof("${prop.name}")-1, ${prop.flags});'
			}
		}
	}

	res << '    }'
	return res.join('\n')
}

// ---------------------------------------------------------------------
// 函数 (Global Functions) 构建器
// ---------------------------------------------------------------------

pub struct FuncBuilder {
pub mut:
	php_name string
	c_func   string
}

pub fn new_func_builder(php_name string, c_func string) &FuncBuilder {
	return &FuncBuilder{
		php_name: php_name
		c_func: c_func
	}
}

// 生成 PHP_FE 宏
pub fn (b &FuncBuilder) render_fe() string {
	return '    PHP_FE(${b.php_name}, arginfo_${b.c_func})'
}

// ---------------------------------------------------------------------
// 常量 (Global Constants) 渲染器
// ---------------------------------------------------------------------

pub fn render_global_constant(name string, type_ string, value string) string {
	match type_ {
		'string' {
			return '    REGISTER_STRING_CONSTANT("${name}", "${value}", CONST_CS | CONST_PERSISTENT);'
		}
		'double', 'f64' {
			return '    REGISTER_DOUBLE_CONSTANT("${name}", ${value}, CONST_CS | CONST_PERSISTENT);'
		}
		'bool' {
			return '    REGISTER_BOOL_CONSTANT("${name}", ${value}, CONST_CS | CONST_PERSISTENT);'
		}
		else {
			// int/long
			return '    REGISTER_LONG_CONSTANT("${name}", ${value}, CONST_CS | CONST_PERSISTENT);'
		}
	}
}
