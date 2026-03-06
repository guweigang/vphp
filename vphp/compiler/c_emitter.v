module compiler

import compiler.builder
import compiler.repr

pub struct CGenerator {
pub:
	ext_name         string
	class_ce_by_type map[string]string
}

fn is_constructor_method(name string) bool {
	return name == 'construct' || name == 'init'
}

fn php_method_name(name string) string {
	return match name {
		'construct', 'init' { '__construct' }
		'str' { '__toString' }
		else { name }
	}
}

fn method_returns_object(r &repr.PhpClassRepr, m &repr.PhpMethodRepr) bool {
	is_factory := is_constructor_method(m.name) || (m.is_static && m.return_type.ends_with(r.name))
	return is_factory || m.return_type.starts_with('&')
}

fn (g CGenerator) build_func(f &repr.PhpFuncRepr) builder.FuncBuilder {
	return *builder.new_func_builder(f.name, f.name)
}

fn (g CGenerator) build_func_export(f &repr.PhpFuncRepr) builder.ExportFragments {
	mut fragments := g.build_func(f).export_fragments()
	fragments.implementations = g.gen_func_c(f)
	return fragments
}

fn (g CGenerator) build_global_constant(c &repr.PhpConstRepr) builder.ConstantBuilder {
	return builder.new_constant_builder(c.name, c.const_type, c.value)
}

fn (g CGenerator) build_interface_export(r &repr.PhpInterfaceRepr) builder.ExportFragments {
	mut fragments := g.build_interface_type(r).export_fragments()
	fragments.implementations = g.gen_interface_c(r)
	return fragments
}

fn (g CGenerator) build_enum_export(r &repr.PhpEnumRepr) builder.ExportFragments {
	mut fragments := g.build_enum_type(r).export_fragments()
	fragments.implementations = g.gen_enum_c(r)
	return fragments
}

fn (g CGenerator) build_class_export(r &repr.PhpClassRepr) builder.ExportFragments {
	has_init := r.methods.any(is_constructor_method(it.name))
	mut fragments := g.build_class_type(r, has_init).export_fragments()
	fragments.implementations = g.gen_class_c(r)
	return fragments
}

fn visibility_to_method_flags(visibility string) string {
	return match visibility {
		'protected' { 'ZEND_ACC_PROTECTED' }
		'private' { 'ZEND_ACC_PRIVATE' }
		else { 'ZEND_ACC_PUBLIC' }
	}
}

fn visibility_to_property_flags(prop repr.PhpClassProp) string {
	mut flags := visibility_to_method_flags(prop.visibility)
	if prop.is_static {
		flags += ' | ZEND_ACC_STATIC'
	}
	if !prop.is_static && !prop.is_mut {
		flags += ' | ZEND_ACC_READONLY'
	}
	return flags
}

fn method_args_to_builder(args []repr.PhpArg) []builder.ClassMethodArg {
	mut out := []builder.ClassMethodArg{}
	for arg in args {
		out << builder.ClassMethodArg{
			name: arg.name
			type_: arg.v_type
		}
	}
	return out
}

fn (g CGenerator) build_interface_type(r &repr.PhpInterfaceRepr) &builder.ClassBuilder {
	mut class_builder := builder.new_interface_builder(r.php_name, r.c_name())
	for m in r.methods {
		class_builder.add_abstract_method(php_method_name(m.name), '${r.c_name().to_lower()}_${m.name}', visibility_to_method_flags(m.visibility) + ' | ZEND_ACC_ABSTRACT', method_args_to_builder(m.args))
	}
	return class_builder
}

fn (g CGenerator) build_enum_type(r &repr.PhpEnumRepr) &builder.ClassBuilder {
	mut class_builder := builder.new_enum_builder(r.php_name, r.c_name())
	class_builder.add_class_flag('ZEND_ACC_FINAL')
	class_builder.add_method('__construct', '${r.c_name().to_lower()}___construct', 'ZEND_ACC_PRIVATE', []builder.ClassMethodArg{})
	for case_ in r.cases {
		class_builder.add_constant(case_.name, 'int', case_.value)
	}
	return class_builder
}

fn (g CGenerator) build_class_type(r &repr.PhpClassRepr, has_init bool) &builder.ClassBuilder {
	mut class_builder := builder.new_class_builder(r.php_name, r.c_name())
	class_builder.set_parent(r.parent)
	if r.is_abstract {
		class_builder.add_class_flag('ZEND_ACC_EXPLICIT_ABSTRACT_CLASS')
	}
	for iface in r.implements {
		class_builder.add_interface(iface)
	}
	for con in r.constants {
		class_builder.add_constant(con.name, con.const_type, con.value)
	}
	for prop in r.properties {
		class_builder.add_property(prop.name, prop.v_type, visibility_to_property_flags(prop))
	}
	if !has_init {
		class_builder.add_method('__construct', '${r.c_name().to_lower()}___construct', 'ZEND_ACC_PUBLIC', []builder.ClassMethodArg{})
	}
	for m in r.methods {
		php_name := php_method_name(m.name)
		mut flags := visibility_to_method_flags(m.visibility)
		if m.is_static {
			flags += ' | ZEND_ACC_STATIC'
		}
		c_func := '${r.c_name().to_lower()}_${m.name}'
		if m.is_abstract {
			class_builder.add_abstract_method(php_name, c_func, flags + ' | ZEND_ACC_ABSTRACT', method_args_to_builder(m.args))
		} else {
			class_builder.add_method(php_name, c_func, flags, method_args_to_builder(m.args))
		}
	}
	return class_builder
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
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    vphp_class_handlers *h = {{HANDLER_CLASS}}_handlers();
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
    vphp_return_obj(return_value, v_instance, {{CLASS_CE}});
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), {{HANDLER_CLASS}}_handlers());
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
    vphp_return_obj(return_value, v_instance, {{RET_CLASS_CE}});
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
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    vphp_class_handlers *h = {{HANDLER_CLASS}}_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
}
'

fn (g CGenerator) gen_interface_c(r &repr.PhpInterfaceRepr) []string {
	mut c := []string{}
	class_builder := g.build_interface_type(r)
	c << class_builder.render_impl_prelude()
	c << class_builder.render_impl_postlude()
	return c
}

fn (g CGenerator) gen_enum_c(r &repr.PhpEnumRepr) []string {
	mut c := []string{}
	c_class := r.c_name()
	class_builder := g.build_enum_type(r)

	c << class_builder.render_impl_prelude()
	c << 'PHP_METHOD(${c_class}, __construct) {'
	c << '    vphp_throw("${r.php_name} is an enum-style type and cannot be instantiated", 0);'
	c << '}'
	c << class_builder.render_impl_postlude()

	return c
}

fn (g CGenerator) gen_func_c(f &repr.PhpFuncRepr) []string {
    mut r := []string{}
    func_builder := g.build_func(f)
    r << func_builder.render_arginfo()
	target_func := 'vphp_wrap_${f.name}'
	r << 'extern void ${target_func}(vphp_context_internal ctx);'
	r << 'PHP_FUNCTION(${f.name}) {'
	r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
	r << '    ${target_func}(ctx);'
	r << '}'
    return r
}

fn (g CGenerator) gen_class_c(r &repr.PhpClassRepr) []string {
	mut c := []string{}
	c_class := r.c_name()        // C macro safe: VPhp_Task
	has_init := r.methods.any(is_constructor_method(it.name))
	class_builder := g.build_class_type(r, has_init)

	c << class_builder.render_impl_prelude()

	// 2. 生成方法包装器 — 使用模板
	for m in r.methods {
		if m.is_abstract {
			continue
		}
		php_name := php_method_name(m.name)
		
		v_c_func := if m.has_export { '${r.name}_${m.name}' } else { 'vphp_wrap_${r.name}_${m.name}' }
		
		tm := TypeMap.get_type(m.return_type)
		returns_object := method_returns_object(r, m)

		vars := {
			'CLASS':      c_class
			'CLASS_CE':   g.ce_var_for_type(r.name)
			'HANDLER_CLASS': r.name
			'PHP_METHOD': php_name
			'V_FUNC':     v_c_func
			'C_TYPE':     tm.c_type
			'PHP_RETURN': tm.php_return
		}

		if is_constructor_method(m.name) {
			c << render_tpl(tpl_construct, vars)
		} else if m.is_static {
			if returns_object {
				c << render_tpl(tpl_static_factory, vars)
			} else if tm.v_type == 'void' {
				c << render_tpl(tpl_static_void, vars)
			} else {
				c << render_tpl(tpl_static_scalar, vars)
			}
		} else {
			if returns_object {
				ret_class := tm.v_type.replace('&', '').replace('main.', '')
				mut obj_vars := vars.clone()
				obj_vars['RET_CLASS'] = ret_class
				obj_vars['RET_CLASS_CE'] = g.ce_var_for_type(ret_class)
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
			'CLASS': c_class
			'HANDLER_CLASS': r.name
		}
		c << render_tpl(tpl_default_construct, vars)
	}

	// 3. 生成方法表 (zend_function_entry) 
	c << class_builder.render_impl_postlude()

	return c
}

fn (g CGenerator) ce_var_for_type(v_type string) string {
	mut key := v_type.trim_space()
	if key.starts_with('&') {
		key = key[1..]
	}
	if key.starts_with('!') {
		key = key[1..]
	}
	if key.contains('.') {
		key = key.all_after('.')
	}
	if key in g.class_ce_by_type {
		return g.class_ce_by_type[key]
	}
	if key.contains('\\') {
		return '${key.replace('\\', '_').to_lower()}_ce'
	}
	return '${key.to_lower()}_ce'
}
