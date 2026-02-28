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
    args          []PhpArg
    has_export    bool
    visibility    string
}

pub struct PhpArg {
pub mut:
    name   string
    v_type string
}

fn new_class_repr() &PhpClassRepr { return &PhpClassRepr{} }

// ============================================
// AST 解析 — 保持不变
// ============================================

fn (mut r PhpClassRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.StructDecl {
		if stmt.attrs.any(it.name == 'php_class') {
			r.name = stmt.name.all_after('.')
			if attr := stmt.attrs.find_first('php_parent') {
				r.parent = attr.arg
			}
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

// ============================================
// C 代码生成 — 模板化重构
// ============================================

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

// 模板变量替换
fn render_tpl(tpl string, vars map[string]string) string {
	mut out := tpl
	for k, v in vars {
		out = out.replace('{{${k}}}', v)
	}
	return out
}

fn (r PhpClassRepr) gen_h() []string {
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

	// 2. 生成方法包装器 — 使用模板
	for m in r.methods {
		php_method_name := if m.name == 'init' { '__construct' } else { m.name }
		
		// 依据是否有 @[export: 'xxx'] 决定目标 C 符号
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
				// Pure factory returns Article, V wrapper puts it in ctx.ret directly?
				// For factory, the original code returns a void*, but a pure V function returns &Article.
				// Wait! If pure, we let the wrapper return the pointer.
				c << render_tpl(tpl_static_factory, vars)
			} else if !m.has_export {
				// 纯业务的非工厂静态方法，统一走 void 返回，内部通过 ctx 返回
				c << render_tpl(tpl_static_scalar, vars)
			} else {
				c << render_tpl(tpl_static_scalar, vars)
			}
		} else {
			if !m.has_export {
				// 纯业务模式下，V 胶水层直接包含所有装箱逻辑，C 侧全视作 void 返回
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

fn (r PhpClassRepr) gen_minit() []string {
	mut m := []string{}
	lower_name := r.name.to_lower()
	ce_ptr := '${lower_name}_ce'

	m << '    {   zend_class_entry ce;'
	m << '        INIT_CLASS_ENTRY(ce, "${r.name}", ${lower_name}_methods);'

	if r.parent != "" {
		m << '        ${lower_name}_ce = zend_register_internal_class_ex(&ce, zend_hash_str_find_ptr(CG(class_table), "${r.parent}", sizeof("${r.parent}")-1));'
	} else {
		m << '        ${lower_name}_ce = zend_register_internal_class(&ce);'
	}

	m << '        $ce_ptr->create_object = vphp_create_object_handler;'

	// 注册常量
	for con in r.constants {
		m << '        zend_declare_class_constant_string(${lower_name}_ce, "${con.name}", sizeof("${con.name}")-1, "${con.value}");'
	}

	// 注册属性
	for prop in r.properties {
			flags := if prop.is_static { 'ZEND_ACC_PUBLIC | ZEND_ACC_STATIC' } else { 'ZEND_ACC_PUBLIC' }
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
					m << '        zend_declare_property_null($ce_ptr, "${prop.name}", sizeof("${prop.name}")-1, $flags);'
				}
			}
	}

	m << '    }'
	return m
}

// ============================================
// 方法添加 — 保持不变
// ============================================

pub fn (mut r PhpClassRepr) add_method(stmt ast.FnDecl, table &ast.Table) {
	if !stmt.attrs.any(it.name == 'php_method') {
		return
	}
	
	mut has_export := false
	for attr in stmt.attrs {
		if attr.name == 'export' && attr.arg != '' {
			has_export = true
		}
	}

	mut args := []PhpArg{}
	start_idx := if stmt.is_method { 1 } else { 0 }
	
	for i := start_idx; i < stmt.params.len; i++ {
	    param := stmt.params[i]
		mut typ_name := table.get_type_name(param.typ)
		if typ_name.contains('.') { typ_name = typ_name.all_after('.') }
		args << PhpArg{
			name: param.name
			v_type: typ_name
		}
	}

	ret_type := table.type_to_str(stmt.return_type)
	r.methods << PhpMethodRepr{
		name: stmt.name
		v_c_func: '${r.name}_${stmt.name}'
		is_static: false
		return_type: ret_type
		visibility: if stmt.is_pub { 'public' } else { 'protected' }
		args: args
		has_export: has_export
	}
}

pub fn (mut r PhpClassRepr) add_static_method(stmt ast.FnDecl, table &ast.Table, method_name string) {
	if !stmt.attrs.any(it.name == 'php_method') {
		return
	}

	mut has_export := false
	for attr in stmt.attrs {
		if attr.name == 'export' && attr.arg != '' {
			has_export = true
		}
	}

	mut args := []PhpArg{}
	for param in stmt.params {
		mut typ_name := table.get_type_name(param.typ)
		if typ_name.contains('.') { typ_name = typ_name.all_after('.') }
		args << PhpArg{
			name: param.name
			v_type: typ_name
		}
	}

	ret_type := table.type_to_str(stmt.return_type)
	r.methods << PhpMethodRepr{
		name: method_name
		v_c_func: '${r.name}_${method_name}'
		is_static: true
		return_type: ret_type
		visibility: 'public'
		args: args
		has_export: has_export
	}
}

// ============================================
// V 侧胶水生成 — 极大简化
// 从 ~55 行 match 逻辑 → 薄转发 + 泛型调用
// ============================================

pub fn (r PhpClassRepr) gen_v_glue() []string {
    mut out := []string{}
    lower_name := r.name.to_lower()

    // A. 堆分配器 — 单行泛型转发
    out << "@[export: '${r.name}_new_raw']"
    out << "pub fn ${lower_name}_new_raw() voidptr {"
    out << "    return vphp.generic_new_raw[${r.name}]()"
    out << "}"

    // B. 属性读取 — 单行泛型转发
    out << "@[export: '${r.name}_get_prop']"
    out << "pub fn ${lower_name}_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {"
    out << "    vphp.generic_get_prop[${r.name}](ptr, name_ptr, name_len, rv)"
    out << "}"

    // C. 属性写入 — 单行泛型转发
    out << "@[export: '${r.name}_set_prop']"
    out << "pub fn ${lower_name}_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {"
    out << "    vphp.generic_set_prop[${r.name}](ptr, name_ptr, name_len, value)"
    out << "}"

    // D. 同步器 — 单行泛型转发
    out << "@[export: '${r.name}_sync_props']"
    out << "pub fn ${lower_name}_sync_props(ptr voidptr, zv &C.zval) {"
    out << "    vphp.generic_sync_props[${r.name}](ptr, zv)"
    out << "}"

    // E. 方法的胶水包装 (纯业务方法)
    for m in r.methods {
        if m.has_export { continue } // 如果带了 export 走原始路线

        out << "@[export: 'vphp_wrap_${r.name}_${m.name}']"
        
        is_factory := m.name == 'init' || (m.is_static && m.return_type.ends_with(r.name))
        ret_decl := if is_factory { "voidptr" } else { "" }
        
        if m.is_static {
            out << "pub fn vphp_wrap_${lower_name}_${m.name}(ctx vphp.Context) ${ret_decl} {"
        } else {
            out << "pub fn vphp_wrap_${lower_name}_${m.name}(ptr voidptr, ctx vphp.Context) ${ret_decl} {"
            out << "    mut recv := unsafe { &${r.name}(ptr) }"
        }

        mut arg_names := []string{}
        for i, arg in m.args {
            var_name := 'arg_${i}'
            if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
                out << "    ${var_name} := ctx"
            } else {
                out << "    ${var_name} := ctx.arg[${arg.v_type}](${i})"
            }
            arg_names << var_name
        }

        call_args := arg_names.join(', ')
        call_str := if m.is_static {
            "${r.name}.${m.name}(${call_args})"
        } else {
            "recv.${m.name}(${call_args})"
        }

        if m.return_type == 'void' {
            out << "    ${call_str}"
        } else {
            out << "    res := ${call_str}"
            if !is_factory {
                out << "    ctx.return_val[${m.return_type}](res)"
            }
        }
        
        if is_factory {
            if m.return_type == 'void' {
                 // Technically init shouldn't be void if it's returning the instance, but let's assume it assigns to a ptr if res exists.
                 out << "    return voidptr(recv)"
            } else {
                 out << "    return voidptr(res)"
            }
        }

        out << "}"
    }

    // F. Handler 聚合器 — 供 C 侧一次性获取所有 handler
    out << "@[export: '${r.name}_handlers']"
    out << "pub fn ${lower_name}_handlers() voidptr {"
    out << "    return unsafe { &C.vphp_class_handlers{"
    out << "        prop_handler:  voidptr(${lower_name}_get_prop)"
    out << "        write_handler: voidptr(${lower_name}_set_prop)"
    out << "        sync_handler:  voidptr(${lower_name}_sync_props)"
    out << "        new_raw:       voidptr(${lower_name}_new_raw)"
    out << "    } }"
    out << "}"

    return out
}
