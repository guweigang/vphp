module compiler

pub struct CGenerator {
pub:
	ext_name string
}

// 模板变量替换
fn render_tpl(tpl string, vars map[string]string) string {
	mut out := tpl
	for k, v in vars {
		out = out.replace('{{${k}}}', v)
	}
	return out
}

// 将 V 字符串中的 \ 转义为 C 字符串字面量的 \\
fn c_string_escape(s string) string {
	return s.replace('\\', '\\\\')
}

// C 代码模板：构造函数
const tpl_construct = 'PHP_METHOD({{CLASS}}, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* {{CLASS}}_handlers();
    vphp_class_handlers *h = {{CLASS}}_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    void* v_ptr = wrapper->v_ptr;
    {{V_FUNC}}(v_ptr, ctx);
}'

// C 代码模板：静态工厂方法（返回对象指针）
const tpl_static_factory = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* {{V_FUNC}}(vphp_context_internal ctx);
    void* v_instance = {{V_FUNC}}(ctx);
    vphp_return_obj(return_value, v_instance, {{LOWER_CLASS}}_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* {{CLASS}}_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), {{CLASS}}_handlers());
    }
}'

// C 代码模板：静态方法（返回基本类型）
const tpl_static_scalar = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void {{V_FUNC}}(vphp_context_internal ctx);
    {{V_FUNC}}(ctx);
}'

// C 代码模板：静态方法 (void 返回)
const tpl_static_void = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void {{V_FUNC}}(vphp_context_internal ctx);
    {{V_FUNC}}(ctx);
}'

// C 代码模板：实例方法（带返回值）
const tpl_instance_method = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    {{V_FUNC}}(wrapper->v_ptr, ctx);
}'

// C 代码模板：实例方法（void 返回）
const tpl_instance_void = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_NULL();
    {{V_FUNC}}(wrapper->v_ptr, ctx);
}'

// C 代码模板：Result 类型实例方法
const tpl_instance_result = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    {{V_FUNC}}(wrapper->v_ptr, ctx);
}'

// C 代码模板：实例方法（返回对象指针）
const tpl_instance_object = '
PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD {{CLASS}}::{{PHP_METHOD}} called, wrapper->v_ptr=%p\\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = {{V_FUNC}}(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, {{LOWER_RET_CLASS}}_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* {{RET_CLASS}}_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), {{RET_CLASS}}_handlers());
    }
}
'

const tpl_default_construct = '
PHP_METHOD({{CLASS}}, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* {{CLASS}}_handlers();
    vphp_class_handlers *h = {{CLASS}}_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
}
'

pub fn (g CGenerator) gen_h_defs(mut elements []PhpRepr) []string {
	mut res := []string{}
	for mut el in elements {
		if mut el is PhpFuncRepr {
			res << 'PHP_FUNCTION(${el.name});'
		} else if mut el is PhpClassRepr {
			res << 'extern zend_class_entry *${el.c_name().to_lower()}_ce;'
		}
	}
	return res
}

pub fn (g CGenerator) gen_minit_lines(mut elements []PhpRepr) []string {
	mut res := []string{}
	for mut el in elements {
		if mut el is PhpConstRepr {
			// 只有显式标注了 @[php_const] 且不是结构体的才导出为全局常量
			if el.has_php_const && el.const_type != 'struct' {
				res << render_global_constant(el.name, el.const_type, el.value)
			}
		} else if mut el is PhpClassRepr {
			mut builder := new_class_builder(el.php_name, el.c_name())
			builder.set_parent(el.parent)

			for con in el.constants {
				builder.add_constant(con.name, con.const_type, con.value)
			}
			
			for prop in el.properties {
				// 获取可见性修饰符
				mut flags := 'ZEND_ACC_PUBLIC'
				if prop.visibility == 'protected' {
					flags = 'ZEND_ACC_PROTECTED'
				} else if prop.visibility == 'private' {
					flags = 'ZEND_ACC_PRIVATE'
				}

				// 这里的 prop.is_static 必须在 mod.v 链接阶段准确设置
				if prop.is_static { 
					flags += ' | ZEND_ACC_STATIC' 
				}
				builder.add_property(prop.name, prop.v_type, flags)
			}
			
			res << builder.render_minit()
		}
	}
	return res
}

pub fn (g CGenerator) gen_c_code(mut elements []PhpRepr) []string {
    mut res := []string{}
    for mut el in elements {
        if mut el is PhpFuncRepr {
            res << g.gen_func_c(el)
        } else if mut el is PhpClassRepr {
            res << g.gen_class_c(el)
        }
    }
    return res
}

fn (g CGenerator) gen_func_c(f &PhpFuncRepr) []string {
    mut r := []string{}
    r << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${f.name}, 0, 0, 0)'
    r << 'ZEND_END_ARG_INFO()'

    tm := TypeMap.get_type(f.return_type)
    
    target_func := if f.uses_php_function { 'vphp_wrap_${f.name}' } else { f.name }

    if tm.v_type == 'void' {
        r << 'extern void ${target_func}(vphp_context_internal ctx);'
        r << 'PHP_FUNCTION(${f.name}) {'
        r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
        r << '    ${target_func}(ctx);'
        r << '}'
    } else if !f.uses_php_function && tm.v_type == 'string' {
        r << 'extern v_string ${target_func}(vphp_context_internal ctx);'
        r << 'PHP_FUNCTION(${f.name}) {'
        r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
        r << '    v_string res = ${target_func}(ctx);'
        r << '    RETVAL_STRINGL((char*)res.str, res.len);'
        r << '}'
    } else if !f.uses_php_function {
        r << 'extern ${tm.c_type} ${target_func}(vphp_context_internal ctx);'
        r << 'PHP_FUNCTION(${f.name}) {'
        r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
        r << '    ${tm.c_type} res = ${target_func}(ctx);'
        r << '    ${tm.php_return}(res);'
        r << '}'
    } else {
        r << 'extern void ${target_func}(vphp_context_internal ctx);'
        r << 'PHP_FUNCTION(${f.name}) {'
        r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
        r << '    ${target_func}(ctx);'
        r << '}'
    }
    return r
}

fn (g CGenerator) gen_class_c(r &PhpClassRepr) []string {
	mut c := []string{}
	c_class := r.c_name()        // C macro safe: VPhp_Task
	lower_name := c_class.to_lower()

	c << 'zend_class_entry *${lower_name}_ce = NULL;'

	// 1. 生成参数信息
	for m in r.methods {
		c << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${lower_name}_${m.name}, 0, 0, 0)'
		c << 'ZEND_END_ARG_INFO()'
	}

	// 2. 生成方法包装器 — 使用模板
	mut has_init := false
	for m in r.methods {
		if m.name == 'init' { has_init = true }
		php_method_name := if m.name == 'init' { '__construct' } else { m.name }
		
		v_c_func := if m.has_export { '${r.name}_${m.name}' } else { 'vphp_wrap_${r.name}_${m.name}' }
		
		tm := TypeMap.get_type(m.return_type)

		vars := {
			'CLASS':       c_class
			'LOWER_CLASS': lower_name
			'PHP_METHOD':  php_method_name
			'V_FUNC':      v_c_func
			'C_TYPE':      tm.c_type
			'PHP_RETURN':  tm.php_return
		}

		if m.name == 'init' {
			c << render_tpl(tpl_construct, vars)
		} else if m.is_static {
			if m.has_export && tm.c_type == 'void*' {
				c << render_tpl(tpl_static_factory, vars)
			} else if !m.has_export && tm.c_type == 'void*' {
				c << render_tpl(tpl_static_factory, vars)
			} else if tm.v_type == 'void' {
				c << render_tpl(tpl_static_void, vars)
			} else {
				c << render_tpl(tpl_static_scalar, vars)
			}
		} else {
			if tm.c_type == 'void*' {
				ret_class := tm.v_type.replace('&', '').replace('main.', '')
				mut obj_vars := vars.clone()
				obj_vars['RET_CLASS'] = ret_class
				obj_vars['LOWER_RET_CLASS'] = ret_class.to_lower()
				c << render_tpl(tpl_instance_object, obj_vars)
			} else if tm.is_result {
				c << render_tpl(tpl_instance_result, vars)
			} else if tm.v_type == 'void' {
				c << render_tpl(tpl_instance_void, vars)
			} else {
				c << render_tpl(tpl_instance_method, vars)
			}
		}
	}

	if !has_init {
		vars := {
			'CLASS':       c_class
			'LOWER_CLASS': lower_name
		}
		c << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${lower_name}___construct, 0, 0, 0)'
		c << 'ZEND_END_ARG_INFO()'
		c << render_tpl(tpl_default_construct, vars)
	}

	// 3. 生成方法表 (zend_function_entry) 
	mut builder := new_class_builder(r.php_name, c_class)
	if !has_init {
		builder.add_method('__construct', '${lower_name}___construct', 'ZEND_ACC_PUBLIC')
	}
	for m in r.methods {
		php_method_name := if m.name == 'init' { '__construct' } else { m.name }
		
		mut flags := 'ZEND_ACC_PUBLIC'
		if m.visibility == 'protected' {
			flags = 'ZEND_ACC_PROTECTED'
		} else if m.visibility == 'private' {
			flags = 'ZEND_ACC_PRIVATE'
		}

		if m.is_static { 
			flags += ' | ZEND_ACC_STATIC' 
		}
		
		// 传递包含前缀的 C 函数参数信息名称，比如 arginfo_article_save
		c_func := '${lower_name}_${m.name}' 
		builder.add_method(php_method_name, c_func, flags)
	}
	c << builder.render_methods_array()

	return c
}
