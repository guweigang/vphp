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
zend_class_entry *vslimrequest_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_construct, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_vslimrequest_str, 0, 0, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_query, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_has_query, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_header, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_has_header, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_cookie, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_has_cookie, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_param, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_has_param, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_attribute, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_has_attribute, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimrequest_query_json_value, 0, 0, 0)
ZEND_END_ARG_INFO()
PHP_METHOD(VSlimRequest, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* VSlimRequest_handlers();
    vphp_class_handlers *h = VSlimRequest_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
    extern void vphp_wrap_VSlimRequest_construct(void* v_ptr, vphp_context_internal ctx);
    void* v_ptr = wrapper->v_ptr;
    vphp_wrap_VSlimRequest_construct(v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, __toString) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_str(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_str(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, query) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_query(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_query(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, has_query) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_query(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_query(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_header(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, has_header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_header(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, cookie) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_cookie(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_cookie(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, has_cookie) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_cookie(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_cookie(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, param) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_param(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_param(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, has_param) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_param(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_param(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, attribute) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_attribute(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_attribute(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, has_attribute) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_attribute(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_attribute(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimRequest, query_json_value) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_query_json_value(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_query_json_value(wrapper->v_ptr, ctx);
}
static const zend_function_entry vslimrequest_methods[] = {
    PHP_ME(VSlimRequest, __construct, arginfo_vslimrequest_construct, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, __toString, arginfo_vslimrequest_str, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, query, arginfo_vslimrequest_query, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, has_query, arginfo_vslimrequest_has_query, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, header, arginfo_vslimrequest_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, has_header, arginfo_vslimrequest_has_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, cookie, arginfo_vslimrequest_cookie, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, has_cookie, arginfo_vslimrequest_has_cookie, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, param, arginfo_vslimrequest_param, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, has_param, arginfo_vslimrequest_has_param, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, attribute, arginfo_vslimrequest_attribute, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, has_attribute, arginfo_vslimrequest_has_attribute, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimRequest, query_json_value, arginfo_vslimrequest_query_json_value, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *vslimresponse_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimresponse_construct, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimresponse_header, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimresponse_has_header, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimresponse_set_header, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimresponse_with_status, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimresponse_text, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimresponse_json, 0, 0, 0)
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
PHP_METHOD(VSlimResponse, header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimResponse_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimResponse_header(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlimResponse, has_header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimResponse_has_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimResponse_has_header(wrapper->v_ptr, ctx);
}

PHP_METHOD(VSlimResponse, set_header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_set_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlimResponse::set_header called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_set_header(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslimresponse_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlimResponse, with_status) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_with_status(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlimResponse::with_status called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_with_status(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslimresponse_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlimResponse, text) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_text(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlimResponse::text called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_text(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslimresponse_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlimResponse, json) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_json(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlimResponse::json called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_json(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslimresponse_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
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
    PHP_ME(VSlimResponse, header, arginfo_vslimresponse_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimResponse, has_header, arginfo_vslimresponse_has_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimResponse, set_header, arginfo_vslimresponse_set_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimResponse, with_status, arginfo_vslimresponse_with_status, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimResponse, text, arginfo_vslimresponse_text, ZEND_ACC_PUBLIC)
    PHP_ME(VSlimResponse, json, arginfo_vslimresponse_json, ZEND_ACC_PUBLIC)
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
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslimapp_dispatch_request, 0, 0, 0)
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


PHP_METHOD(VSlimApp, dispatch_request) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_dispatch_request(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlimApp::dispatch_request called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_dispatch_request(wrapper->v_ptr, ctx);
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
    PHP_ME(VSlimApp, dispatch_request, arginfo_vslimapp_dispatch_request, ZEND_ACC_PUBLIC)
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
        INIT_CLASS_ENTRY(ce, "VSlimRequest", vslimrequest_methods);
        vslimrequest_ce = zend_register_internal_class(&ce);
        vslimrequest_ce->create_object = vphp_create_object_handler;
        zend_declare_property_string(vslimrequest_ce, "method", sizeof("method")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "raw_path", sizeof("raw_path")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "path", sizeof("path")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "body", sizeof("body")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "query_string", sizeof("query_string")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "query_json", sizeof("query_json")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "scheme", sizeof("scheme")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "host", sizeof("host")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "port", sizeof("port")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "protocol_version", sizeof("protocol_version")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "remote_addr", sizeof("remote_addr")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "headers_json", sizeof("headers_json")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "cookies_json", sizeof("cookies_json")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "attributes_json", sizeof("attributes_json")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "server_json", sizeof("server_json")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "uploaded_files_json", sizeof("uploaded_files_json")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimrequest_ce, "params_json", sizeof("params_json")-1, "", ZEND_ACC_PUBLIC);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VSlimResponse", vslimresponse_methods);
        vslimresponse_ce = zend_register_internal_class(&ce);
        vslimresponse_ce->create_object = vphp_create_object_handler;
        zend_declare_property_long(vslimresponse_ce, "status", sizeof("status")-1, 0, ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimresponse_ce, "body", sizeof("body")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimresponse_ce, "content_type", sizeof("content_type")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslimresponse_ce, "headers_json", sizeof("headers_json")-1, "", ZEND_ACC_PUBLIC);
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
