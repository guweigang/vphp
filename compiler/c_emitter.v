module compiler

import compiler.builder
import compiler.repr

pub struct CGenerator {
pub:
	ext_name          string
	class_ce_by_type  map[string]string
	class_php_by_type map[string]string
}

fn (g CGenerator) build_func_return_spec(f &repr.PhpFuncRepr) builder.ReturnSpec {
	return_type := f.return_spec.effective_v_type()
	return builder.new_return_spec(return_type, effective_export_php_return_type(return_type,
		f.return_spec.php_type, f.has_export), g.php_name_for_type(return_type))
}

fn (g CGenerator) build_method_return_spec(php_name string, m &repr.PhpMethodRepr) builder.ReturnSpec {
	raw_return_type := m.return_spec.effective_v_type()
	return_type := if php_name == '__construct' { '' } else { raw_return_type }
	return builder.new_return_spec(return_type, effective_export_php_return_type(return_type,
		m.return_spec.php_type, m.has_export), g.php_name_for_type(return_type))
}

fn (g CGenerator) build_func(f &repr.PhpFuncRepr) builder.FuncBuilder {
	// Convert PhpArg to ClassMethodArg for arginfo generation
	mut args := []builder.ClassMethodArg{}
	for arg in f.args {
		if arg.v_type == 'Context' || arg.v_type == 'vphp.Context' {
			continue
		}
		args << builder.ClassMethodArg{
			name:        arg.name
			type_:       arg.v_type
			php_type:    arg.php_type
			is_optional: arg.is_optional
			php_default: arg.php_default
		}
	}
	spec := g.build_func_return_spec(f)
	return *builder.new_func_builder_with_args(f.name, f.name, spec, args, f.uses_context)
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

fn class_uses_inherited_receiver(r &repr.PhpClassRepr) bool {
	return r.direct_internal_parent || r.uses_inherited_object
}

fn class_needs_inherited_object_wrapper(r &repr.PhpClassRepr, has_init bool) bool {
	if !class_uses_inherited_receiver(r) {
		return false
	}
	if has_init || r.has_free_method {
		return true
	}
	for prop in r.properties {
		if prop.is_static || prop.is_property_only {
			continue
		}
		return true
	}
	return false
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
		php_type := if arg.php_type != '' { arg.php_type } else { '' }
		out << builder.ClassMethodArg{
			name:        arg.name
			type_:       arg.v_type
			php_type:    php_type
			is_optional: arg.is_optional
			php_default: arg.php_default
		}
	}
	return out
}

fn interface_method_args_to_builder(_iface &repr.PhpInterfaceRepr, args []repr.PhpArg) []builder.ClassMethodArg {
	mut out := []builder.ClassMethodArg{}
	for i, arg in args {
		// V interface AST can carry an implicit first arg `x` (self-like placeholder).
		// Never expose it to PHP interface signatures.
		if i == 0 && arg.name == 'x' {
			continue
		}
		out << builder.ClassMethodArg{
			name:        arg.name
			type_:       arg.v_type
			php_type:    arg.php_type
			is_optional: arg.is_optional
			php_default: arg.php_default
		}
	}
	return out
}

fn (g CGenerator) build_interface_type(r &repr.PhpInterfaceRepr) &builder.ClassBuilder {
	mut class_builder := builder.new_interface_builder(r.php_name, r.c_name())
	for iface in r.extends {
		class_builder.add_interface(iface)
	}
	for m in r.methods {
		c_func := if m.v_c_func != '' {
			m.v_c_func.to_lower()
		} else {
			'${r.c_name().to_lower()}_${m.v_name}'
		}
		php_name := php_method_name(m.name)
		spec := g.build_method_return_spec(php_name, m)
		class_builder.add_abstract_method_spec(php_name, c_func, spec,
			visibility_to_method_flags(m.visibility) + ' | ZEND_ACC_ABSTRACT', interface_method_args_to_builder(r,
			m.args))
	}
	return class_builder
}

fn (g CGenerator) build_enum_type(r &repr.PhpEnumRepr) &builder.ClassBuilder {
	mut class_builder := builder.new_enum_builder(r.php_name, r.c_name())
	// PHP 8.1 native enum: no ZEND_ACC_FINAL, no __construct, no class constants.
	// Cases are added via zend_enum_add_case_cstr() in MINIT (see builder render_minit).
	// We store cases as constants in the builder so render_minit can iterate them.
	for case_ in r.cases {
		class_builder.add_constant(case_.name, 'int', case_.value)
	}
	return class_builder
}

fn (g CGenerator) build_class_type(r &repr.PhpClassRepr, has_init bool) &builder.ClassBuilder {
	mut class_builder := builder.new_class_builder(r.php_name, r.c_name())
	needs_inherited_wrapper := class_needs_inherited_object_wrapper(r, has_init)
	class_builder.set_parent(r.parent)
	class_builder.set_uses_inherited_object(needs_inherited_wrapper)
	if class_uses_inherited_receiver(r) {
		class_builder.set_create_object(false)
	}
	if r.is_abstract {
		class_builder.add_class_flag('ZEND_ACC_EXPLICIT_ABSTRACT_CLASS')
	}
	for iface in r.internal_implements {
		class_builder.add_interface(iface)
	}
	for con in r.constants {
		class_builder.add_constant(con.name, con.const_type, con.value)
	}
	for prop in r.properties {
		class_builder.add_property(prop.name, prop.v_type, visibility_to_property_flags(prop))
	}
	if !has_init && !class_uses_inherited_receiver(r) {
		class_builder.add_method('__construct', '${r.c_name().to_lower()}___construct',
			'', '', 'ZEND_ACC_PUBLIC', []builder.ClassMethodArg{})
	}
	for m in r.methods {
		php_name := php_method_name(m.name)
		mut flags := visibility_to_method_flags(m.visibility)
		if m.is_static {
			flags += ' | ZEND_ACC_STATIC'
		}
		c_func := if m.v_c_func != '' {
			m.v_c_func.to_lower()
		} else {
			'${r.c_name().to_lower()}_${m.v_name}'
		}
		spec := g.build_method_return_spec(php_name, m)
		if m.is_abstract {
			class_builder.add_abstract_method_spec(php_name, c_func, spec, flags +
				' | ZEND_ACC_ABSTRACT', method_args_to_builder(m.args))
		} else {
			class_builder.add_method_spec(php_name, c_func, spec, flags, method_args_to_builder(m.args))
		}
	}
	for attr in r.attributes {
		mut args := []builder.ClassAttributeArg{}
		for arg in attr.args {
			args << builder.ClassAttributeArg{
				kind:  arg.kind
				value: arg.value
			}
		}
		class_builder.add_attribute(attr.name, args)
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
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    vphp_class_handlers *h = {{HANDLER_CLASS}}_handlers();
    vphp_init_owned_instance(Z_OBJ_P(getThis()), h);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    void* v_ptr = wrapper->v_ptr;
    {{V_FUNC}}(v_ptr, ctx);
    if (EG(exception)) {
        return;
    }
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

// C 代码模板：静态工厂方法（返回对象指针）
const tpl_static_factory = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void* {{V_FUNC}}(vphp_context_internal ctx);
    void* v_instance = {{V_FUNC}}(ctx);
    if (EG(exception)) {
        return;
    }
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    vphp_return_owned_object(return_value, v_instance, {{CLASS_CE}}, {{HANDLER_CLASS}}_handlers());
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

const tpl_static_object = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void* {{V_FUNC}}(vphp_context_internal ctx);
    void* v_instance = {{V_FUNC}}(ctx);
    if (EG(exception)) {
        return;
    }
    extern vphp_class_handlers* {{RET_CLASS}}_handlers();
    vphp_return_bound_object(return_value, v_instance, {{RET_CLASS_CE}}, {{RET_CLASS}}_handlers(), {{RET_OWNS_VPTR}});
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

// C 代码模板：静态方法（返回基本类型）
const tpl_static_scalar = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void {{V_FUNC}}(vphp_context_internal ctx);
    {{V_FUNC}}(ctx);
    if (EG(exception)) {
        return;
    }
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

// C 代码模板：静态方法 (void 返回)
const tpl_static_void = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void {{V_FUNC}}(vphp_context_internal ctx);
    {{V_FUNC}}(ctx);
    if (!EG(exception)) {
        vphp_mark_void_return(return_value);
    }
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

const tpl_static_manual_ctx = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void {{V_FUNC}}(vphp_context_internal ctx);
    {{V_FUNC}}(ctx);
    if (EG(exception)) {
        return;
    }
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

// C 代码模板：实例方法（带返回值）
const tpl_instance_method = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    zend_object *vphp_this_obj = Z_OBJ_P(getThis());
    vphp_object_addref(vphp_this_obj);
    vphp_object_wrapper *wrapper = vphp_ensure_owned_instance_binding(vphp_this_obj, {{HANDLER_CLASS}}_handlers());
    if (!wrapper->v_ptr) {
        vphp_object_release(vphp_this_obj);
        RETURN_FALSE;
    }
    {{V_FUNC}}(wrapper->v_ptr, ctx);
    if (EG(exception)) {
        vphp_object_release(vphp_this_obj);
        return;
    }
    vphp_object_release(vphp_this_obj);
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

const tpl_inherited_instance_method = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    zend_object *vphp_this_obj = Z_OBJ_P(getThis());
    vphp_object_addref(vphp_this_obj);
    vphp_object_wrapper *wrapper = vphp_ensure_owned_instance_binding(vphp_this_obj, {{HANDLER_CLASS}}_handlers());
    if (!wrapper->v_ptr) {
        vphp_object_release(vphp_this_obj);
        RETURN_FALSE;
    }
    {{V_FUNC}}(wrapper->v_ptr, ctx);
    if (EG(exception)) {
        vphp_object_release(vphp_this_obj);
        return;
    }
    vphp_object_release(vphp_this_obj);
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

// C 代码模板：实例方法（void 返回）
const tpl_instance_void = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    zend_object *vphp_this_obj = Z_OBJ_P(getThis());
    vphp_object_addref(vphp_this_obj);
    vphp_object_wrapper *wrapper = vphp_ensure_owned_instance_binding(vphp_this_obj, {{HANDLER_CLASS}}_handlers());
    if (!wrapper->v_ptr) {
        vphp_object_release(vphp_this_obj);
        RETURN_NULL();
    }
    {{V_FUNC}}(wrapper->v_ptr, ctx);
    if (!EG(exception)) {
        vphp_mark_void_return(return_value);
    }
    vphp_object_release(vphp_this_obj);
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

const tpl_inherited_instance_void = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    zend_object *vphp_this_obj = Z_OBJ_P(getThis());
    vphp_object_addref(vphp_this_obj);
    vphp_object_wrapper *wrapper = vphp_ensure_owned_instance_binding(vphp_this_obj, {{HANDLER_CLASS}}_handlers());
    if (!wrapper->v_ptr) {
        vphp_object_release(vphp_this_obj);
        RETURN_NULL();
    }
    {{V_FUNC}}(wrapper->v_ptr, ctx);
    if (!EG(exception)) {
        vphp_mark_void_return(return_value);
    }
    vphp_object_release(vphp_this_obj);
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

// C 代码模板：Result 类型实例方法
const tpl_instance_result = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    zend_object *vphp_this_obj = Z_OBJ_P(getThis());
    vphp_object_addref(vphp_this_obj);
    vphp_object_wrapper *wrapper = vphp_ensure_owned_instance_binding(vphp_this_obj, {{HANDLER_CLASS}}_handlers());
    if (!wrapper->v_ptr) {
        vphp_object_release(vphp_this_obj);
        RETURN_FALSE;
    }
    {{V_FUNC}}(wrapper->v_ptr, ctx);
    if (EG(exception)) {
        vphp_object_release(vphp_this_obj);
        return;
    }
    vphp_object_release(vphp_this_obj);
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

const tpl_inherited_instance_result = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    zend_object *vphp_this_obj = Z_OBJ_P(getThis());
    vphp_object_addref(vphp_this_obj);
    vphp_object_wrapper *wrapper = vphp_ensure_owned_instance_binding(vphp_this_obj, {{HANDLER_CLASS}}_handlers());
    if (!wrapper->v_ptr) {
        vphp_object_release(vphp_this_obj);
        RETURN_FALSE;
    }
    {{V_FUNC}}(wrapper->v_ptr, ctx);
    if (EG(exception)) {
        vphp_object_release(vphp_this_obj);
        return;
    }
    vphp_object_release(vphp_this_obj);
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}'

// C 代码模板：实例方法（返回对象指针）
const tpl_instance_object = '
PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void* {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    zend_object *vphp_this_obj = Z_OBJ_P(getThis());
    vphp_object_addref(vphp_this_obj);
    vphp_object_wrapper *wrapper = vphp_ensure_owned_instance_binding(vphp_this_obj, {{HANDLER_CLASS}}_handlers());
    // printf("PHP_METHOD {{CLASS}}::{{PHP_METHOD}} called, wrapper->v_ptr=%p\\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) {
        vphp_object_release(vphp_this_obj);
        RETURN_NULL();
    }
    void* v_instance = {{V_FUNC}}(wrapper->v_ptr, ctx);
    if (EG(exception)) {
        vphp_object_release(vphp_this_obj);
        return;
    }
    extern vphp_class_handlers* {{RET_CLASS}}_handlers();
    vphp_return_bound_object(return_value, v_instance, {{RET_CLASS_CE}}, {{RET_CLASS}}_handlers(), {{RET_OWNS_VPTR}});
    vphp_object_release(vphp_this_obj);
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}
'

const tpl_inherited_instance_object = '
PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);
    extern void* {{V_FUNC}}(void* v_ptr, vphp_context_internal ctx);
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    zend_object *vphp_this_obj = Z_OBJ_P(getThis());
    vphp_object_addref(vphp_this_obj);
    vphp_object_wrapper *wrapper = vphp_ensure_owned_instance_binding(vphp_this_obj, {{HANDLER_CLASS}}_handlers());
    if (!wrapper->v_ptr) {
        vphp_object_release(vphp_this_obj);
        RETURN_NULL();
    }
    void* v_instance = {{V_FUNC}}(wrapper->v_ptr, ctx);
    if (EG(exception)) {
        vphp_object_release(vphp_this_obj);
        return;
    }
    extern vphp_class_handlers* {{RET_CLASS}}_handlers();
    vphp_return_bound_object(return_value, v_instance, {{RET_CLASS_CE}}, {{RET_CLASS}}_handlers(), {{RET_OWNS_VPTR}});
    vphp_object_release(vphp_this_obj);
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
}
'

const tpl_default_construct = '
PHP_METHOD({{CLASS}}, __construct) {
    if (!vphp_validate_internal_call(execute_data)) {
        return;
    }
    extern vphp_class_handlers* {{HANDLER_CLASS}}_handlers();
    vphp_class_handlers *h = {{HANDLER_CLASS}}_handlers();
    vphp_init_owned_instance(Z_OBJ_P(getThis()), h);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!vphp_validate_internal_return(execute_data, return_value)) {
        return;
    }
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
	class_builder := g.build_enum_type(r)

	// PHP 8.1 native enum: only need ce declaration + empty methods array.
	// No PHP_METHOD implementations needed — native enums provide their own
	// methods (cases, from, tryFrom) via zend_register_internal_enum().
	c << class_builder.render_impl_prelude()
	c << class_builder.render_impl_postlude()

	return c
}

fn (g CGenerator) gen_func_c(f &repr.PhpFuncRepr) []string {
	mut r := []string{}
	func_builder := g.build_func(f)
	return_type := f.return_spec.effective_v_type()
	r << func_builder.render_arginfo()
	target_func := 'vphp_wrap_${f.name}'
	// The V glue exposes a single wrapper symbol `vphp_wrap_${f.name}` that
	// performs any necessary argument marshaling and return handling. The C
	// emitter simply forwards the PHP entry point to that V glue. We avoid
	// generating additional N-suffixed helper wrappers here — the V glue and
	// runtime will handle closure wrapping (ctx.wrap_closure /
	// ctx.wrap_closure_universal) to keep the generated C stable.
	r << 'extern void ${target_func}(vphp_context_internal ctx);'
	r << 'PHP_FUNCTION(${f.name}) {'
	if !f.uses_context {
		r << '    if (!vphp_validate_internal_call(execute_data)) {'
		r << '        return;'
		r << '    }'
	}
	r << '    vphp_context_internal ctx = vphp_context_from_execute(execute_data, return_value);'
	r << '    ${target_func}(ctx);'
	if f.uses_context {
		r << '}'
		return r
	}
	if return_type == 'void' {
		r << '    if (!EG(exception)) {'
		r << '        vphp_mark_void_return(return_value);'
		r << '    }'
	}
	r << '    if (!vphp_validate_internal_return(execute_data, return_value)) {'
	r << '        return;'
	r << '    }'
	r << '}'
	return r
}

fn (g CGenerator) gen_class_c(r &repr.PhpClassRepr) []string {
	mut c := []string{}
	c_class := r.c_name() // C macro safe: VPhp_Task
	has_init := r.methods.any(is_constructor_method(it.name))
	class_builder := g.build_class_type(r, has_init)

	c << class_builder.render_impl_prelude()

	// 2. 生成方法包装器 — 使用模板
	for m in r.methods {
		if m.is_abstract {
			continue
		}
		php_name := php_method_name(m.name)
		glue_name := if m.v_name != '' { m.v_name } else { m.name }

		v_c_func := if m.has_export { m.v_c_func } else { 'vphp_wrap_${r.name}_${glue_name}' }

		method_return_type := m.return_spec.effective_v_type()
		return_info := method_runtime_return_info(r.name, m.name, m.is_static, method_return_type,
			m.borrowed_return)
		uses_inherited_receiver := class_uses_inherited_receiver(r)

		vars := {
			'CLASS':         c_class
			'CLASS_CE':      g.ce_var_for_type(r.name)
			'HANDLER_CLASS': r.name
			'PHP_METHOD':    php_name
			'V_FUNC':        v_c_func
			'C_TYPE':        return_info.tm.c_type
			'PHP_RETURN':    return_info.tm.php_return
		}

		if m.has_export {
			if m.is_static {
				c << render_tpl(tpl_static_manual_ctx, vars)
			} else if uses_inherited_receiver {
				c << render_tpl(tpl_inherited_instance_method, vars)
			} else {
				c << render_tpl(tpl_instance_method, vars)
			}
			continue
		}

		if is_constructor_method(m.name) {
			if class_uses_inherited_receiver(r) {
				continue
			}
			c << render_tpl(tpl_construct, vars)
		} else if m.is_static {
			if return_info.kind == .static_factory {
				c << render_tpl(tpl_static_factory, vars)
			} else if return_info.kind == .static_object {
				mut obj_vars := vars.clone()
				obj_vars['RET_CLASS'] = return_info.class_key
				obj_vars['RET_CLASS_CE'] = g.ce_var_for_type(return_info.class_key)
				obj_vars['RET_OWNS_VPTR'] = return_info.owns_vptr
				c << render_tpl(tpl_static_object, obj_vars)
			} else if return_info.kind in [.result, .option, .void_] {
				// Result/Option 类型在 V glue 侧处理 or{}，C 侧等同 void 调用
				c << render_tpl(tpl_static_void, vars)
			} else {
				c << render_tpl(tpl_static_scalar, vars)
			}
		} else {
			if return_info.kind == .instance_object {
				mut obj_vars := vars.clone()
				obj_vars['RET_CLASS'] = return_info.class_key
				obj_vars['RET_CLASS_CE'] = g.ce_var_for_type(return_info.class_key)
				obj_vars['RET_OWNS_VPTR'] = return_info.owns_vptr
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_object, obj_vars)
				} else {
					c << render_tpl(tpl_instance_object, obj_vars)
				}
			} else if return_info.kind == .result {
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_result, vars)
				} else {
					c << render_tpl(tpl_instance_result, vars)
				}
			} else if return_info.kind == .option {
				// Option 类型在 V glue 侧处理 or{}，C 侧等同 result 调用模式
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_result, vars)
				} else {
					c << render_tpl(tpl_instance_result, vars)
				}
			} else if return_info.kind == .void_ {
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_void, vars)
				} else {
					c << render_tpl(tpl_instance_void, vars)
				}
			} else {
				if uses_inherited_receiver {
					c << render_tpl(tpl_inherited_instance_method, vars)
				} else {
					c << render_tpl(tpl_instance_method, vars)
				}
			}
		}
	}

	if !has_init && !class_uses_inherited_receiver(r) {
		vars := {
			'CLASS':         c_class
			'HANDLER_CLASS': r.name
		}
		c << render_tpl(tpl_default_construct, vars)
	}

	// 3. 生成方法表 (zend_function_entry)
	c << class_builder.render_impl_postlude()

	return c
}

fn (g CGenerator) ce_var_for_type(v_type string) string {
	key := normalize_export_type_key(v_type)
	if key in g.class_ce_by_type {
		return g.class_ce_by_type[key]
	}
	if key.contains('\\') {
		return '${key.replace('\\', '_').to_lower()}_ce'
	}
	return '${key.to_lower()}_ce'
}

fn (g CGenerator) php_name_for_type(v_type string) string {
	key := normalize_export_type_key(v_type)
	if key in g.class_php_by_type {
		return g.class_php_by_type[key]
	}
	return ''
}
