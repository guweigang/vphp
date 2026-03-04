/* ⚠️ VPHP Compiler Generated for vslim */
#include "php_bridge.h"

#include "../vphp/v_bridge.h"


typedef struct { void* ex; void* ret; } vphp_context_internal;
typedef struct { void* str; int len; int is_lit; } v_string;

extern void vphp_framework_init(int module_number);
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim_handle_request, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void vphp_wrap_vslim_handle_request(vphp_context_internal ctx);
PHP_FUNCTION(vslim_handle_request) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    vphp_wrap_vslim_handle_request(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim_demo_dispatch, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void vphp_wrap_vslim_demo_dispatch(vphp_context_internal ctx);
PHP_FUNCTION(vslim_demo_dispatch) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    vphp_wrap_vslim_demo_dispatch(ctx);
}
zend_class_entry *vslimresponse_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimresponse_construct, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_vslimresponse_str, 0, 0, IS_STRING, 0)
ZEND_END_ARG_INFO()
PHP_METHOD(VSlimResponse, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* VSlimResponse_handlers();
    vphp_class_handlers *h = VSlimResponse_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
    extern void vphp_wrap_VSlimResponse_construct(void* v_ptr, vphp_context_internal ctx);
    void* v_ptr = wrapper->v_ptr;
    vphp_wrap_VSlimResponse_construct(v_ptr, ctx);
}
PHP_METHOD(VSlimResponse, __toString) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimResponse_str(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimResponse_str(wrapper->v_ptr, ctx);
}
static const zend_function_entry vslimresponse_methods[] = {
    PHP_ME(VSlimResponse, __construct, arginfo_vslimresponse_construct, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimResponse, __toString, arginfo_vslimresponse_str, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *vslimapp_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimapp___construct, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimapp_demo, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimapp_dispatch, 0, 0, 0)
ZEND_END_ARG_INFO()
PHP_METHOD(VSlimApp, demo) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_demo(vphp_context_internal ctx);
    void* v_instance = vphp_wrap_VSlimApp_demo(ctx);
    vphp_return_obj(return_value, v_instance, vslimapp_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}

PHP_METHOD(VSlimApp, dispatch) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_dispatch(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlimApp::dispatch called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_dispatch(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslimresponse_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlimApp, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* VSlimApp_handlers();
    vphp_class_handlers *h = VSlimApp_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
}

static const zend_function_entry vslimapp_methods[] = {
    PHP_ME(VSlimApp, __construct, arginfo_vslimapp___construct, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimApp, demo, arginfo_vslimapp_demo, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_ME(VSlimApp, dispatch, arginfo_vslimapp_dispatch, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

ZEND_BEGIN_MODULE_GLOBALS(vslim)
    zend_long request_count;
ZEND_END_MODULE_GLOBALS(vslim)

ZEND_DECLARE_MODULE_GLOBALS(vslim)
#define VPHP_G(v) ZEND_MODULE_GLOBALS_ACCESSOR(vslim, v)
static void php_vslim_init_globals(zend_vslim_globals *globals) {
    globals->request_count = 0;
}
static const zend_function_entry vslim_functions[] = {
    PHP_FE(vslim_handle_request, arginfo_vslim_handle_request)
    PHP_FE(vslim_demo_dispatch, arginfo_vslim_demo_dispatch)
    PHP_FE_END
};
PHP_MINIT_FUNCTION(vslim) {
    vphp_framework_init(module_number);
    extern void vphp_ext_startup() __attribute__((weak));
    if (vphp_ext_startup) vphp_ext_startup();
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VSlimResponse", vslimresponse_methods);
        vslimresponse_ce = zend_register_internal_class(&ce);
        vslimresponse_ce->create_object = vphp_create_object_handler;
        zend_declare_property_long(vslimresponse_ce, "status", sizeof("status")-1, 0, ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimresponse_ce, "body", sizeof("body")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimresponse_ce, "content_type", sizeof("content_type")-1, "", ZEND_ACC_PUBLIC);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VSlimApp", vslimapp_methods);
        vslimapp_ce = zend_register_internal_class(&ce);
        vslimapp_ce->create_object = vphp_create_object_handler;
    }
    return SUCCESS;
}
PHP_MINFO_FUNCTION(vslim) {
    php_info_print_table_start();
    php_info_print_table_header(2, "vslim support", "enabled");
    php_info_print_table_row(2, "Version", "0.1.0");
    php_info_print_table_row(2, "Description", "Slim-inspired PHP extension powered by vphp");
    php_info_print_table_end();
}

void* vphp_get_active_globals() {
#ifdef ZTS
    return TSRMG(vslim_globals_id, zend_vslim_globals *, 0);
#else
    return &vslim_globals;
#endif
}
zend_module_entry vslim_module_entry = {
    STANDARD_MODULE_HEADER, "vslim", vslim_functions,
    PHP_MINIT(vslim), NULL, NULL, NULL, PHP_MINFO(vslim), "0.1.0",
    PHP_MODULE_GLOBALS(vslim),
    (void (*)(void*)) php_vslim_init_globals,
    NULL,
    NULL,
    STANDARD_MODULE_PROPERTIES_EX
};

#ifdef COMPILE_DL_VSLIM
ZEND_GET_MODULE(vslim)
#endif
