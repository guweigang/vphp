module compiler

const tpl_construct_context = 'PHP_METHOD({{CLASS}}, __construct) {
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

const tpl_static_context = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
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

const tpl_instance_context = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
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

const tpl_inherited_instance_context = 'PHP_METHOD({{CLASS}}, {{PHP_METHOD}}) {
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
