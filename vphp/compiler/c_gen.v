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

// C 代码模板：构造函数
const tpl_construct = 'PHP_METHOD({{CLASS}}, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* {{CLASS}}_handlers();
    vphp_class_handlers *h = {{CLASS}}_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    {{V_FUNC}}(wrapper->v_ptr, ctx);
}'

// C 代码模板：静态工厂方法（返回对象指针）
const tpl_static_factory = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* {{V_FUNC}}(vphp_context_internal ctx);
    void* v_instance = {{V_FUNC}}(ctx);
    if (!v_instance) RETURN_NULL();
    object_init_ex(return_value, {{LOWER_CLASS}}_ce);
    extern vphp_class_handlers* {{CLASS}}_handlers();
    vphp_class_handlers *h = {{CLASS}}_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(return_value));
    wrapper->v_ptr = v_instance;
    vphp_bind_handlers(Z_OBJ_P(return_value), h);
}'

// C 代码模板：静态方法（返回基本类型）
const tpl_static_scalar = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern {{C_TYPE}} {{V_FUNC}}(vphp_context_internal ctx);
    {{C_TYPE}} res = {{V_FUNC}}(ctx);
    {{PHP_RETURN}}(res);
}'

// C 代码模板：实例方法（带返回值）
const tpl_instance_method = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern {{C_TYPE}} {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    {{C_TYPE}} res = {{V_FUNC}}(wrapper->v_ptr, ctx);
    {{PHP_RETURN}}(res);
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
    extern {{C_TYPE}} {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    {{C_TYPE}} res = {{V_FUNC}}(wrapper->v_ptr, ctx);
    {{PHP_RETURN}}(res);
}'

pub fn (g CGenerator) gen_h_defs(mut elements []PhpRepr) []string {
	mut res := []string{}
	for mut el in elements {
		if mut el is PhpFuncRepr {
			res << 'PHP_FUNCTION(${el.name});'
		} else if mut el is PhpClassRepr {
			res << 'extern zend_class_entry *${el.name.to_lower()}_ce;'
		}
	}
	return res
}

pub fn (g CGenerator) gen_minit_lines(mut elements []PhpRepr) []string {
	mut res := []string{}
	for mut el in elements {
		if mut el is PhpConstRepr {
			match el.const_type {
				'string' {
					res << '    REGISTER_STRING_CONSTANT("${el.name}", "${el.value}", CONST_CS | CONST_PERSISTENT);'
				}
				'f64' {
					res << '    REGISTER_DOUBLE_CONSTANT("${el.name}", ${el.value}, CONST_CS | CONST_PERSISTENT);'
				}
				'bool' {
					res << '    REGISTER_BOOL_CONSTANT("${el.name}", ${el.value}, CONST_CS | CONST_PERSISTENT);'
				}
				else {
					// int (默认)
					res << '    REGISTER_LONG_CONSTANT("${el.name}", ${el.value}, CONST_CS | CONST_PERSISTENT);'
				}
			}
		} else if mut el is PhpClassRepr {
			lower_name := el.name.to_lower()
			ce_ptr := '${lower_name}_ce'

			res << '    {   zend_class_entry ce;'
			res << '        INIT_CLASS_ENTRY(ce, "${el.name}", ${lower_name}_methods);'

			if el.parent != "" {
				res << '        ${lower_name}_ce = zend_register_internal_class_ex(&ce, zend_hash_str_find_ptr(CG(class_table), "${el.parent}", sizeof("${el.parent}")-1));'
			} else {
				res << '        ${lower_name}_ce = zend_register_internal_class(&ce);'
			}

			res << '        $ce_ptr->create_object = vphp_create_object_handler;'

			// 注册常量
			for con in el.constants {
				res << '        zend_declare_class_constant_string(${lower_name}_ce, "${con.name}", sizeof("${con.name}")-1, "${con.value}");'
			}

			// 注册属性
			for prop in el.properties {
				flags := if prop.is_static { 'ZEND_ACC_PUBLIC | ZEND_ACC_STATIC' } else { 'ZEND_ACC_PUBLIC' }
				match prop.v_type {
					'int', 'i64', 'isize' {
						res << '        zend_declare_property_long($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, 0, $flags);'
					}
					'f64', 'f32' {
						res << '        zend_declare_property_double($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, 0.0, $flags);'
					}
					'bool' {
						res << '        zend_declare_property_bool($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, 0, $flags);'
					}
					'string' {
						res << '        zend_declare_property_string($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, "", $flags);'
					}
					else {
						res << '        zend_declare_property_null($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, $flags);'
					}
				}
			}
			res << '    }'
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
	lower_name := r.name.to_lower()

	c << 'zend_class_entry *${lower_name}_ce = NULL;'

	// 1. 生成参数信息
	for m in r.methods {
		c << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${lower_name}_${m.name}, 0, 0, 0)'
		c << 'ZEND_END_ARG_INFO()'
	}

	// 2. 生成方法包装器 — 使用模板
	for m in r.methods {
		php_method_name := if m.name == 'init' { '__construct' } else { m.name }
		
		v_c_func := if m.has_export { '${r.name}_${m.name}' } else { 'vphp_wrap_${r.name}_${m.name}' }
		
		tm := TypeMap.get_type(m.return_type)

		vars := {
			'CLASS':       r.name
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
			} else if !m.has_export {
				c << render_tpl(tpl_static_scalar, vars)
			} else {
				c << render_tpl(tpl_static_scalar, vars)
			}
		} else {
			if !m.has_export {
				c << render_tpl(tpl_instance_void, vars)
			} else if tm.is_result {
				c << render_tpl(tpl_instance_result, vars)
			} else if tm.v_type == 'void' {
				c << render_tpl(tpl_instance_void, vars)
			} else {
				c << render_tpl(tpl_instance_method, vars)
			}
		}
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
