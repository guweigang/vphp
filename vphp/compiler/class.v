module compiler

import v.ast

pub struct PhpClassRepr {
pub mut:
	name       string
	parent     string      // 继承关系
	is_final   bool
	constants  []PhpClassConst
	properties []PhpClassProp
	methods    []PhpMethodRepr
}

pub struct PhpClassConst {
	name  string
	value string
}

pub struct PhpClassProp {
pub:
	name       string
	v_type     string // V 端的原始类型，如 'int', 'string', 'bool'
	visibility string // 'public', 'protected', 'private'
	is_static  bool
}

struct PhpMethodRepr {
mut:
    name          string   // 方法名，如 "create"
    v_c_func      string   // V 导出的 C 符号名，如 "Article_create"
    is_static     bool     // 是否为静态方法
    return_type   string   // 返回类型，如 "bool" 或 "&Article"
    args          []PhpArg // 👈 关键：这里存了参数的 V 类型和名称
    visibility    string
}

struct PhpArg {
    name   string // 参数名，如 "title"
    v_type string // V 类型，如 "string" 或 "int"
}

fn new_class_repr() &PhpClassRepr { return &PhpClassRepr{} }

// vphp/compiler/class.v 续
fn (mut r PhpClassRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.StructDecl {
		// 检查是否有 @[php_class] 属性
		if stmt.attrs.any(it.name == 'php_class') {
			r.name = stmt.name.all_after('.')
			// 处理继承：检查是否有 @[php_parent: 'BaseClass']
			if attr := stmt.attrs.find_first('php_parent') {
				r.parent = attr.arg
			}
			// 自动收集字段作为 Property
			for field in stmt.fields {
			  type_name := table.get_type_name(field.typ)
				r.properties << PhpClassProp{
					name: field.name
					v_type: type_name
					visibility: if field.is_pub { 'public' } else { 'protected' }
					is_static: field.attrs.any(it.name == 'static')
				}
			}
			return true
		}
	}
	return false
}

fn (r PhpClassRepr) gen_h() []string {
    // 为每个 PHP 类导出其 zend_class_entry 指针，供 V 侧或其他 C 代码引用
    return [
        'extern zend_class_entry *${r.name.to_lower()}_ce;'
    ]
}

fn (r PhpClassRepr) gen_c() []string {
    mut c := []string{}
    lower_name := r.name.to_lower()

    c << 'zend_class_entry *${lower_name}_ce = NULL;'

    // 1. 生成每个方法的 ArgInfo (PHP 要求每个方法都要有参数描述)
    for m in r.methods {
        c << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${lower_name}_${m.name}, 0, 0, 0)'
        c << 'ZEND_END_ARG_INFO()'
    }

    // 2. 生成方法包装器 (调用 V 导出的 C 函数)
    for m in r.methods {
        v_c_func := '${r.name}_${m.name}'
        lower_class := r.name.to_lower()

        c << '    PHP_METHOD(${r.name}, ${m.name}) {'
        // 定义一个与 V 侧 vphp.Context 内存布局一致的 C 结构体
        // 注意：顺序必须与 vphp/context.v 中的 ex, ret 一致
        c << '        typedef struct { void* ex; void* ret; } vphp_context_internal;'
        c << '        vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'

        if m.is_static {
            // 静态方法：V 侧定义为 fn Article.create(ctx vphp.Context) &Article
            c << '        extern void* ${v_c_func}(vphp_context_internal ctx);'
            c << '        void* v_instance = ${v_c_func}(ctx);'
            c << '        if (!v_instance) RETURN_NULL();'

            c << '        object_init_ex(return_value, ${lower_class}_ce);'
            c << '        vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(return_value));'
            c << '        wrapper->v_ptr = v_instance;'

            // 💡 关键：在这里由编译器自动插入 Handler 绑定，开发者完全无感
            c << '        extern void ${r.name}_get_prop(void*, const char*, zval*);'
            c << '        wrapper->prop_handler = ${r.name}_get_prop;'

            // 💡 绑定同步句柄
            c << '            extern void ${r.name}_sync_props(void*, zval*);'
            c << '            wrapper->sync_handler = ${r.name}_sync_props;'

        } else {
            // 实例方法：V 侧定义为 fn (a &Article) save(ctx vphp.Context) bool
            c << '        extern bool ${v_c_func}(void* v_ptr, vphp_context_internal ctx);'
            c << '        vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));'
            c << '        if (!wrapper->v_ptr) RETURN_FALSE;'

            c << '        bool res = ${v_c_func}(wrapper->v_ptr, ctx);'
            c << '        RETURN_BOOL(res);'
        }
        c << '    }'
    }

    // 3. 生成核心方法表
    c << 'static const zend_function_entry ${lower_name}_methods[] = {'
    for m in r.methods {
        // 关键：静态方法使用 ZEND_ACC_STATIC，动态方法默认 0 (Public)
        flags := if m.is_static { 'ZEND_ACC_PUBLIC | ZEND_ACC_STATIC' } else { 'ZEND_ACC_PUBLIC' }
        c << '    PHP_ME(${r.name}, ${m.name}, arginfo_${lower_name}_${m.name}, $flags)'
    }
    c << '    PHP_FE_END'
    c << '};'

    return c
}

fn (r PhpClassRepr) gen_minit() []string {
	mut m := []string{}
	lower_name := r.name.to_lower()
	ce_ptr := '${lower_name}_ce'

	m << '    {   zend_class_entry ce;'
	m << '        INIT_CLASS_ENTRY(ce, "${r.name}", ${lower_name}_methods);'

	// 处理继承
	if r.parent != "" {
		m << '        ${lower_name}_ce = zend_register_internal_class_ex(&ce, zend_hash_str_find_ptr(CG(class_table), "${r.parent}", sizeof("${r.parent}")-1));'
	} else {
		m << '        ${lower_name}_ce = zend_register_internal_class(&ce);'
	}
	// 关键点：绑定内存分配处理器
  m << '        $ce_ptr->create_object = vphp_create_object_handler;'

	// 注册常量
	for con in r.constants {
		m << '        zend_declare_class_constant_string(${lower_name}_ce, "${con.name}", sizeof("${con.name}")-1, "${con.value}");'
	}

	// 注册属性 (默认值暂设为 NULL)
	for prop in r.properties {
			flags := if prop.is_static { 'ZEND_ACC_PUBLIC | ZEND_ACC_STATIC' } else { 'ZEND_ACC_PUBLIC' }

			// 根据 V 类型进行自动映射
			match prop.v_type {
				'int', 'i64', 'isize' {
					m << '        zend_declare_property_long($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, 0, $flags);'
				}
				'f64', 'f32' {
					m << '        zend_declare_property_double($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, 0.0, $flags);'
				}
				'bool' {
					m << '        zend_declare_property_bool($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, 0, $flags);'
				}
				'string' {
					m << '        zend_declare_property_string($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, "", $flags);'
				}
				else {
					// 复杂类型（如嵌套的 Struct）默认设为 null，后续由构造函数初始化
					m << '        zend_declare_property_null($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, $flags);'
				}
			}
	}
	// 💡 关键：不再只是设置 create_object，而是确保该类使用劫持后的句柄
  m << '        ${ce_ptr}->create_object = vphp_create_object_handler;'
  // 我们需要在 vphp_create_object_handler 里将 handlers 指向 vphp_obj_handlers

	m << '    }'
	return m
}

// 为类增加普通方法
pub fn (mut r PhpClassRepr) add_method(stmt ast.FnDecl, table &ast.Table) {
	// 只有标记了 @[php_method] 的才导出
	if !stmt.attrs.any(it.name == 'php_method') {
		return
	}

	r.methods << PhpMethodRepr{
		name: stmt.name
		is_static: false
		visibility: if stmt.is_pub { 'public' } else { 'protected' }
	}
}

// 为类增加静态方法
pub fn (mut r PhpClassRepr) add_static_method(stmt ast.FnDecl, table &ast.Table, method_name string) {
    // 别忘了检查属性标签
    if !stmt.attrs.any(it.name == 'php_method') {
        return
    }

    r.methods << PhpMethodRepr{
        name: method_name
        is_static: true
        visibility: 'public'
    }
}

// vphp/compiler/class.v

pub fn (r PhpClassRepr) gen_v_property_mapper() string {
    mut out := []string{}
    lower_name := r.name.to_lower()

    out << "@[export: '${r.name}_get_prop']"
    out << "pub fn ${lower_name}_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {"
    out << "    unsafe {"
    out << "        // 1. 安全构造 V 字符串，解决 C 传参导致的内存错位"
    out << "        name := name_ptr.vstring_with_len(name_len)"
    out << "        mut a := &${r.name}(ptr)"
    out << "        "
    out << "        match name {"

    for prop in r.properties {
        out << "            '${prop.name}' { "
        match prop.v_type {
            'string' {
                out << "                vphp.return_val_raw(rv, a.${prop.name})"
            }
            'int', 'i64', 'isize' {
                out << "                vphp.return_val_raw(rv, i64(a.${prop.name}))"
            }
            'bool' {
                out << "                vphp.return_val_raw(rv, a.${prop.name})"
            }
            else {
                out << "                // 暂不支持自动映射 ${prop.v_type}"
            }
        }
        out << "            }"
    }

    out << "            else { /* 保持 rv 为 IS_UNDEF，触发 C 侧回退到 PHP 默认属性槽 */ }"
    out << "        }"
    out << "    }"
    out << "}"

    return out.join('\n')
}


pub fn (r PhpClassRepr) gen_v_sync_mapper() string {
    mut out := []string{}
    lower_name := r.name.to_lower()

    out << "@[export: '${r.name}_sync_props']"
    out << "pub fn ${lower_name}_sync_props(ptr voidptr, zv &C.zval) {"
    out << "    unsafe {"
    out << "        mut a := &${r.name}(ptr)"
    out << "        // 包装一个临时的 context，利用现有的反射同步逻辑"
    out << "        ctx := vphp.Context{ ex: 0, ret: zv }"
    out << "        ctx.sync_props(a)"
    out << "    }"
    out << "}"

    return out.join('\n')
}
