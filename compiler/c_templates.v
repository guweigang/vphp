module compiler

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
