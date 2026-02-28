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

	// 1. 生成参数信息
	for m in r.methods {
		c << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${lower_name}_${m.name}, 0, 0, 0)'
		c << 'ZEND_END_ARG_INFO()'
	}

	// 2. 生成方法包装器
	for m in r.methods {
	  // 💡 关键 1: 映射方法名。V 侧叫 init，PHP 侧叫 __construct
    php_method_name := if m.name == 'init' { '__construct' } else { m.name }
		v_c_func := '${r.name}_${m.name}'
		tm := TypeMap.get_type(m.return_type)

		c << '    PHP_METHOD(${r.name}, ${php_method_name}) {'
		c << '        typedef struct { void* ex; void* ret; } vphp_context_internal;'
		c << '        vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
		if m.name == 'init' {
		  c << '        extern void ${v_c_func}(void* v_ptr, vphp_context_internal ctx);'
      // --- 构造函数逻辑 ---
      c << '        vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));'

      // 1. 在 V 侧分配一个新的结构体实例
      c << '        extern void* ${r.name}_new_raw();'
      c << '        wrapper->v_ptr = ${r.name}_new_raw();'

      // 2. 绑定所有的 Handler (和 static create 逻辑一致)
      c << '        extern void ${r.name}_get_prop(void*, const char*, int, zval*);'
      c << '        extern void ${r.name}_set_prop(void*, const char*, int, zval*);'
      c << '        extern void ${r.name}_sync_props(void*, zval*);'
      c << '        wrapper->prop_handler = ${r.name}_get_prop;'
      c << '        wrapper->write_handler = ${r.name}_set_prop;'
      c << '        wrapper->sync_handler = ${r.name}_sync_props;'

      // 3. 调用 V 的 init 方法进行参数初始化
      // 这里需要解析 PHP 传来的参数并传给 V
      c << '        ${v_c_func}(wrapper->v_ptr, ctx);'
		} else if m.is_static {
      c << '        extern ${tm.c_type} ${v_c_func}(vphp_context_internal ctx);'
      // 1. 调用 V 函数创建实例
      // 💡 如果返回的是对象指针 (void*)
      if tm.c_type == 'void*' {
          c << '        ${tm.c_type} v_instance = ${v_c_func}(ctx);'
          c << '        if (!v_instance) RETURN_NULL();'

          // 2. 初始化 PHP 对象
          c << '        object_init_ex(return_value, ${lower_name}_ce);'

          // 3. 拿到 wrapper 指针
          c << '        vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(return_value));'

          // 4. 接通“三条线”：内存、读取器、写入器、同步器
          c << '        wrapper->v_ptr = v_instance;'  // 线 A：V 内存地址

          c << '        extern void ${r.name}_get_prop(void*, const char*, int, zval*);'
          c << '        wrapper->prop_handler = ${r.name}_get_prop;' // 线 B：读取劫持

          c << '        extern void ${r.name}_set_prop(void*, const char*, int, zval*);'
          c << '        wrapper->write_handler = ${r.name}_set_prop;' // 线 C：写入劫持

          c << '        extern void ${r.name}_sync_props(void*, zval*);'
          c << '        wrapper->sync_handler = ${r.name}_sync_props;' // 线 D：var_dump 同步
      } else {
          // 如果返回的是基本类型，直接返回值
          c << '        ${tm.c_type} v_instance = ${v_c_func}(ctx);'
          c << '        if (!v_instance) RETURN_NULL();'
          c << '        ${tm.php_return}(v_instance);'
      }
  } else {
      // 💡 动态生成 extern，不再死守 bool
      c << '        extern ${tm.c_type} ${v_c_func}(void* v_ptr, vphp_context_internal ctx);'
      c << '        vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));'
      c << '        if (!wrapper->v_ptr) RETURN_FALSE;'

      // 💡 动态处理调用逻辑
      if tm.is_result {
          // 如果是 !bool 这种带错误的
          c << '        ${tm.c_type} res = ${v_c_func}(wrapper->v_ptr, ctx);'
          c << '        ${tm.php_return}(res); // 在 v_bridge.h 里实现这个宏，处理异常抛出'
      } else if tm.v_type == 'void' {
          c << '        ${v_c_func}(wrapper->v_ptr, ctx);'
      } else {
          // 普通类型返回
          c << '        ${tm.c_type} res = ${v_c_func}(wrapper->v_ptr, ctx);'
          c << '        ${tm.php_return}(res); // 比如 RETURN_LONG(res) 或 RETURN_BOOL(res)'
      }
		}
		c << '    }'
	}

	// 3. 生成方法表
	c << 'static const zend_function_entry ${lower_name}_methods[] = {'
	for m in r.methods {
	  php_method_name := if m.name == 'init' { '__construct' } else { m.name }
		flags := if m.is_static { 'ZEND_ACC_PUBLIC | ZEND_ACC_STATIC' } else { 'ZEND_ACC_PUBLIC' }
		c << '    PHP_ME(${r.name}, ${php_method_name}, arginfo_${lower_name}_${m.name}, $flags)'
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

	// 💡 关键：从 AST 中提取返回类型
	ret_type := table.type_to_str(stmt.return_type)

	r.methods << PhpMethodRepr{
		name: stmt.name
		v_c_func: '${r.name}_${stmt.name}'
		is_static: false
		return_type: ret_type // 👈 存入解析出的 "!bool" 等
		visibility: if stmt.is_pub { 'public' } else { 'protected' }
		// 如果需要处理参数，可以在这里遍历 stmt.params 填充 args
	}
}

// 为类增加静态方法
pub fn (mut r PhpClassRepr) add_static_method(stmt ast.FnDecl, table &ast.Table, method_name string) {
	if !stmt.attrs.any(it.name == 'php_method') {
		return
	}

	ret_type := table.type_to_str(stmt.return_type)

	r.methods << PhpMethodRepr{
		name: method_name
		v_c_func: '${r.name}_${method_name}'
		is_static: true
		return_type: ret_type // 👈 存入解析出的返回类型
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


pub fn (r PhpClassRepr) gen_v_write_mapper() string {
    mut out := []string{}
    lower_name := r.name.to_lower()

    out << "@[export: '${r.name}_set_prop']"
    out << "pub fn ${lower_name}_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {"
    out << "    unsafe {"
    out << "        name := name_ptr.vstring_with_len(name_len)"
    out << "        mut a := &${r.name}(ptr)"
    out << "        // 包装 zval 方便读取"
    out << "        arg := vphp.Val{ raw: value }"
    out << "        "
    out << "        match name {"

    for prop in r.properties {
        out << "            '${prop.name}' { "
        match prop.v_type {
            'string' { out << "                a.${prop.name} = arg.get_string()" }
            'int' {
                  // 💡 重点：这里显式写死转 int，因为 arg.get_int() 返回 i64
                  out << "                a.${prop.name} = int(arg.get_int())"
            }
            'i64' {
                // i64 不需要强转
                out << "                a.${prop.name} = arg.get_int()"
            }
            'bool' { out << "                a.${prop.name} = arg.get_bool()" }
            else { }
        }
        out << "            }"
    }
    out << "            else { }"
    out << "        }"
    out << "    }"
    out << "}"
    return out.join('\n')
}

pub fn (r PhpClassRepr) gen_v_glue() string {
    mut out := []string{}
    lower_name := r.name.to_lower()

    // --- A. 生成基础分配器 (针对 __construct) ---
    // 这个函数供 C 侧的 PHP_METHOD(__construct) 调用
    out << "// 自动分配堆内存的分配器"
    out << "@[export: '${r.name}_new_raw']"
    out << "pub fn ${lower_name}_new_raw() voidptr {"
    out << "    return unsafe { &${r.name}{} }"
    out << "}"

    // --- B. 生成原本的属性映射器 (read/write/sync) ---
    out << r.gen_v_property_mapper()
    out << r.gen_v_write_mapper()
    out << r.gen_v_sync_mapper()

    // --- C. 生成方法导出 (对应 Article_save 等) ---
    // ... 原有的方法导出逻辑 ...

    return out.join('\n')
}
