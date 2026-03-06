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
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim_response_headers, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void vphp_wrap_vslim_response_headers(vphp_context_internal ctx);
PHP_FUNCTION(vslim_response_headers) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    vphp_wrap_vslim_response_headers(ctx);
}
zend_class_entry *vslim__routegroup_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup___construct, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_group, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, prefix, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_middleware, 0, 0, 1)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_before, 0, 0, 1)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_after, 0, 0, 1)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_get, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_post, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_put, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_patch, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_delete, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_any, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_get_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_post_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_put_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_patch_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_delete_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__routegroup_any_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()

PHP_METHOD(VSlim__RouteGroup, group) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_group(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::group called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_group(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, middleware) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_middleware(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::middleware called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_middleware(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, before) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_before(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::before called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_before(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, after) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_after(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::after called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_after(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, get) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_get(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::get called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_get(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, post) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_post(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::post called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_post(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, put) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_put(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::put called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_put(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, patch) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_patch(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::patch called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_patch(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, delete) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_delete(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::delete called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_delete(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, any) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_any(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::any called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_any(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, get_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_get_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::get_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_get_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, post_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_post_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::post_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_post_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, put_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_put_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::put_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_put_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, patch_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_patch_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::patch_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_patch_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, delete_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_delete_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::delete_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_delete_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, any_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_RouteGroup_any_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__RouteGroup::any_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_RouteGroup_any_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__RouteGroup, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* RouteGroup_handlers();
    vphp_class_handlers *h = RouteGroup_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
}

static const zend_function_entry vslim__routegroup_methods[] = {
    PHP_ME(VSlim__RouteGroup, __construct, arginfo_vslim__routegroup___construct, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, group, arginfo_vslim__routegroup_group, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, middleware, arginfo_vslim__routegroup_middleware, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, before, arginfo_vslim__routegroup_before, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, after, arginfo_vslim__routegroup_after, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, get, arginfo_vslim__routegroup_get, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, post, arginfo_vslim__routegroup_post, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, put, arginfo_vslim__routegroup_put, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, patch, arginfo_vslim__routegroup_patch, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, delete, arginfo_vslim__routegroup_delete, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, any, arginfo_vslim__routegroup_any, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, get_named, arginfo_vslim__routegroup_get_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, post_named, arginfo_vslim__routegroup_post_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, put_named, arginfo_vslim__routegroup_put_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, patch_named, arginfo_vslim__routegroup_patch_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, delete_named, arginfo_vslim__routegroup_delete_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__RouteGroup, any_named, arginfo_vslim__routegroup_any_named, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *vslim__request_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_construct, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, method, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, raw_path, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, body, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_vslim__request_str, 0, 0, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_query, 0, 0, 1)
ZEND_ARG_INFO(0, query)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_method, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, method, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_target, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, raw_path, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_body, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, body, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_scheme, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, scheme, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_host, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, host, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_port, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, port, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_protocol_version, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, protocol_version, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_remote_addr, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, remote_addr, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_headers, 0, 0, 1)
ZEND_ARG_INFO(0, headers)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_cookies, 0, 0, 1)
ZEND_ARG_INFO(0, cookies)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_attributes, 0, 0, 1)
ZEND_ARG_INFO(0, attributes)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_server, 0, 0, 1)
ZEND_ARG_INFO(0, server)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_uploaded_files, 0, 0, 1)
ZEND_ARG_INFO(0, uploaded_files)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_set_params, 0, 0, 1)
ZEND_ARG_INFO(0, params)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_query, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, key, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_query_params, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_has_query, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, key, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_query_all, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_header, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_headers, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_has_header, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_content_type, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_cookie, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_cookies, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_has_cookie, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_param, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_route_params, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_has_param, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_attribute, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_attributes, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_has_attribute, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_server_value, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_server_params, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_has_server, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_uploaded_file_count, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_uploaded_files, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_has_uploaded_files, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_is_secure, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_headers_all, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_cookies_all, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_params_all, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_attributes_all, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_server_all, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__request_uploaded_files_all, 0, 0, 0)
ZEND_END_ARG_INFO()
PHP_METHOD(VSlim__Request, __construct) {
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
PHP_METHOD(VSlim__Request, __toString) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_str(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_str(wrapper->v_ptr, ctx);
}

PHP_METHOD(VSlim__Request, set_query) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_query(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_query called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_query(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_method) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_method(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_method called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_method(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_target) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_target(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_target called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_target(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_body) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_body(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_body called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_body(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_scheme) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_scheme(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_scheme called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_scheme(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_host) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_host(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_host called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_host(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_port) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_port(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_port called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_port(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_protocol_version) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_protocol_version(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_protocol_version called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_protocol_version(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_remote_addr) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_remote_addr(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_remote_addr called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_remote_addr(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_headers) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_headers(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_headers called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_headers(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_cookies) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_cookies(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_cookies called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_cookies(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_attributes) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_attributes(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_attributes called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_attributes(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_server) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_server(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_server called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_server(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_uploaded_files) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_uploaded_files(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_uploaded_files called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_uploaded_files(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}


PHP_METHOD(VSlim__Request, set_params) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimRequest_set_params(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Request::set_params called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimRequest_set_params(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__request_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimRequest_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimRequest_handlers());
    }
}

PHP_METHOD(VSlim__Request, query) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_query(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_query(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, query_params) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_query_params(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_query_params(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, has_query) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_query(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_query(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, query_all) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_query_all(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_query_all(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_header(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, headers) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_headers(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_headers(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, has_header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_header(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, content_type) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_content_type(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_content_type(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, cookie) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_cookie(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_cookie(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, cookies) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_cookies(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_cookies(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, has_cookie) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_cookie(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_cookie(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, param) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_param(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_param(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, route_params) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_route_params(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_route_params(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, has_param) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_param(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_param(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, attribute) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_attribute(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_attribute(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, attributes) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_attributes(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_attributes(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, has_attribute) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_attribute(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_attribute(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, server_value) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_server_value(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_server_value(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, server_params) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_server_params(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_server_params(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, has_server) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_server(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_server(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, uploaded_file_count) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_uploaded_file_count(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_uploaded_file_count(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, uploaded_files) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_uploaded_files(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_uploaded_files(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, has_uploaded_files) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_has_uploaded_files(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_has_uploaded_files(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, is_secure) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_is_secure(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_is_secure(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, headers_all) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_headers_all(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_headers_all(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, cookies_all) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_cookies_all(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_cookies_all(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, params_all) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_params_all(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_params_all(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, attributes_all) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_attributes_all(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_attributes_all(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, server_all) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_server_all(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_server_all(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Request, uploaded_files_all) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimRequest_uploaded_files_all(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimRequest_uploaded_files_all(wrapper->v_ptr, ctx);
}
static const zend_function_entry vslim__request_methods[] = {
    PHP_ME(VSlim__Request, __construct, arginfo_vslim__request_construct, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, __toString, arginfo_vslim__request_str, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_query, arginfo_vslim__request_set_query, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_method, arginfo_vslim__request_set_method, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_target, arginfo_vslim__request_set_target, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_body, arginfo_vslim__request_set_body, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_scheme, arginfo_vslim__request_set_scheme, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_host, arginfo_vslim__request_set_host, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_port, arginfo_vslim__request_set_port, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_protocol_version, arginfo_vslim__request_set_protocol_version, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_remote_addr, arginfo_vslim__request_set_remote_addr, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_headers, arginfo_vslim__request_set_headers, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_cookies, arginfo_vslim__request_set_cookies, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_attributes, arginfo_vslim__request_set_attributes, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_server, arginfo_vslim__request_set_server, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_uploaded_files, arginfo_vslim__request_set_uploaded_files, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, set_params, arginfo_vslim__request_set_params, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, query, arginfo_vslim__request_query, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, query_params, arginfo_vslim__request_query_params, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, has_query, arginfo_vslim__request_has_query, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, query_all, arginfo_vslim__request_query_all, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, header, arginfo_vslim__request_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, headers, arginfo_vslim__request_headers, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, has_header, arginfo_vslim__request_has_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, content_type, arginfo_vslim__request_content_type, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, cookie, arginfo_vslim__request_cookie, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, cookies, arginfo_vslim__request_cookies, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, has_cookie, arginfo_vslim__request_has_cookie, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, param, arginfo_vslim__request_param, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, route_params, arginfo_vslim__request_route_params, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, has_param, arginfo_vslim__request_has_param, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, attribute, arginfo_vslim__request_attribute, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, attributes, arginfo_vslim__request_attributes, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, has_attribute, arginfo_vslim__request_has_attribute, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, server_value, arginfo_vslim__request_server_value, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, server_params, arginfo_vslim__request_server_params, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, has_server, arginfo_vslim__request_has_server, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, uploaded_file_count, arginfo_vslim__request_uploaded_file_count, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, uploaded_files, arginfo_vslim__request_uploaded_files, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, has_uploaded_files, arginfo_vslim__request_has_uploaded_files, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, is_secure, arginfo_vslim__request_is_secure, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, headers_all, arginfo_vslim__request_headers_all, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, cookies_all, arginfo_vslim__request_cookies_all, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, params_all, arginfo_vslim__request_params_all, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, attributes_all, arginfo_vslim__request_attributes_all, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, server_all, arginfo_vslim__request_server_all, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Request, uploaded_files_all, arginfo_vslim__request_uploaded_files_all, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *vslim__response_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_construct, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, status, IS_LONG, 0)
ZEND_ARG_TYPE_INFO(0, body, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, content_type, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_header, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_headers, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_has_header, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_set_header, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, value, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_set_content_type, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, content_type, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_cookie_header, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_set_cookie, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, value, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_set_cookie_opts, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, value, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, path, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_set_cookie_full, 0, 0, 8)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, value, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, path, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, domain, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, max_age, IS_LONG, 0)
ZEND_ARG_TYPE_INFO(0, secure, _IS_BOOL, 0)
ZEND_ARG_TYPE_INFO(0, http_only, _IS_BOOL, 0)
ZEND_ARG_TYPE_INFO(0, same_site, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_delete_cookie, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_set_status, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, status, IS_LONG, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_with_status, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, status, IS_LONG, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_text, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, body, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_json, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, body, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_html, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, body, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_redirect, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, location, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_redirect_with_status, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, location, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, status, IS_LONG, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_headers_all, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_vslim__response_str, 0, 0, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__response_content_length, 0, 0, 0)
ZEND_END_ARG_INFO()
PHP_METHOD(VSlim__Response, __construct) {
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
PHP_METHOD(VSlim__Response, header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimResponse_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimResponse_header(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Response, headers) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimResponse_headers(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimResponse_headers(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Response, has_header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimResponse_has_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimResponse_has_header(wrapper->v_ptr, ctx);
}

PHP_METHOD(VSlim__Response, set_header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_set_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::set_header called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_set_header(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, set_content_type) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_set_content_type(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::set_content_type called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_set_content_type(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}

PHP_METHOD(VSlim__Response, cookie_header) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimResponse_cookie_header(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimResponse_cookie_header(wrapper->v_ptr, ctx);
}

PHP_METHOD(VSlim__Response, set_cookie) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_set_cookie(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::set_cookie called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_set_cookie(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, set_cookie_opts) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_set_cookie_opts(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::set_cookie_opts called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_set_cookie_opts(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, set_cookie_full) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_set_cookie_full(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::set_cookie_full called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_set_cookie_full(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, delete_cookie) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_delete_cookie(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::delete_cookie called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_delete_cookie(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, set_status) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_set_status(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::set_status called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_set_status(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, with_status) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_with_status(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::with_status called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_with_status(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, text) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_text(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::text called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_text(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, json) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_json(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::json called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_json(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, html) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_html(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::html called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_html(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, redirect) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_redirect(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::redirect called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_redirect(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__Response, redirect_with_status) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimResponse_redirect_with_status(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Response::redirect_with_status called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimResponse_redirect_with_status(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}

PHP_METHOD(VSlim__Response, headers_all) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimResponse_headers_all(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimResponse_headers_all(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Response, __toString) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimResponse_str(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimResponse_str(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Response, content_length) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimResponse_content_length(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimResponse_content_length(wrapper->v_ptr, ctx);
}
static const zend_function_entry vslim__response_methods[] = {
    PHP_ME(VSlim__Response, __construct, arginfo_vslim__response_construct, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, header, arginfo_vslim__response_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, headers, arginfo_vslim__response_headers, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, has_header, arginfo_vslim__response_has_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, set_header, arginfo_vslim__response_set_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, set_content_type, arginfo_vslim__response_set_content_type, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, cookie_header, arginfo_vslim__response_cookie_header, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, set_cookie, arginfo_vslim__response_set_cookie, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, set_cookie_opts, arginfo_vslim__response_set_cookie_opts, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, set_cookie_full, arginfo_vslim__response_set_cookie_full, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, delete_cookie, arginfo_vslim__response_delete_cookie, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, set_status, arginfo_vslim__response_set_status, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, with_status, arginfo_vslim__response_with_status, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, text, arginfo_vslim__response_text, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, json, arginfo_vslim__response_json, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, html, arginfo_vslim__response_html, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, redirect, arginfo_vslim__response_redirect, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, redirect_with_status, arginfo_vslim__response_redirect_with_status, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, headers_all, arginfo_vslim__response_headers_all, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, __toString, arginfo_vslim__response_str, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Response, content_length, arginfo_vslim__response_content_length, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *vslim__app_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app___construct, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_demo, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_set_base_path, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, base_path, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_group, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, prefix, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_dispatch, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, method, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, raw_path, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_dispatch_body, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, method, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, raw_path, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, body, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_dispatch_request, 0, 0, 1)
ZEND_ARG_INFO(0, req)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_dispatch_envelope, 0, 0, 1)
ZEND_ARG_INFO(0, envelope)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_get, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_post, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_put, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_patch, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_delete, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_any, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_get_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_post_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_put_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_patch_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_delete_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_any_named, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, pattern, IS_STRING, 0)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_middleware, 0, 0, 1)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_before, 0, 0, 1)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_after, 0, 0, 1)
ZEND_ARG_INFO(0, handler)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_url_for, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_INFO(0, params)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_url_for_query, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_INFO(0, params)
ZEND_ARG_INFO(0, query)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_url_for_abs, 0, 0, 4)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_INFO(0, params)
ZEND_ARG_TYPE_INFO(0, scheme, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, host, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_url_for_query_abs, 0, 0, 5)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_INFO(0, params)
ZEND_ARG_INFO(0, query)
ZEND_ARG_TYPE_INFO(0, scheme, IS_STRING, 0)
ZEND_ARG_TYPE_INFO(0, host, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_redirect_to, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_INFO(0, params)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__app_redirect_to_query, 0, 0, 3)
ZEND_ARG_TYPE_INFO(0, name, IS_STRING, 0)
ZEND_ARG_INFO(0, params)
ZEND_ARG_INFO(0, query)
ZEND_END_ARG_INFO()
PHP_METHOD(VSlim__App, demo) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_demo(vphp_context_internal ctx);
    void* v_instance = vphp_wrap_VSlimApp_demo(ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}

PHP_METHOD(VSlim__App, set_base_path) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_set_base_path(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::set_base_path called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_set_base_path(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, group) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_group(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::group called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_group(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__routegroup_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* RouteGroup_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), RouteGroup_handlers());
    }
}


PHP_METHOD(VSlim__App, dispatch) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_dispatch(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::dispatch called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_dispatch(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__App, dispatch_body) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_dispatch_body(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::dispatch_body called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_dispatch_body(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__App, dispatch_request) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_dispatch_request(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::dispatch_request called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_dispatch_request(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__App, dispatch_envelope) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_dispatch_envelope(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::dispatch_envelope called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_dispatch_envelope(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__App, get) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_get(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::get called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_get(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, post) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_post(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::post called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_post(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, put) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_put(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::put called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_put(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, patch) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_patch(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::patch called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_patch(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, delete) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_delete(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::delete called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_delete(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, any) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_any(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::any called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_any(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, get_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_get_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::get_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_get_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, post_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_post_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::post_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_post_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, put_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_put_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::put_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_put_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, patch_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_patch_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::patch_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_patch_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, delete_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_delete_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::delete_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_delete_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, any_named) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_any_named(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::any_named called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_any_named(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, middleware) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_middleware(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::middleware called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_middleware(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, before) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_before(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::before called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_before(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}


PHP_METHOD(VSlim__App, after) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_after(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::after called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_after(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__app_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimApp_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimApp_handlers());
    }
}

PHP_METHOD(VSlim__App, url_for) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimApp_url_for(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimApp_url_for(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__App, url_for_query) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimApp_url_for_query(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimApp_url_for_query(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__App, url_for_abs) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimApp_url_for_abs(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimApp_url_for_abs(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__App, url_for_query_abs) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimApp_url_for_query_abs(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimApp_url_for_query_abs(wrapper->v_ptr, ctx);
}

PHP_METHOD(VSlim__App, redirect_to) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_redirect_to(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::redirect_to called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_redirect_to(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__App, redirect_to_query) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimApp_redirect_to_query(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__App::redirect_to_query called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimApp_redirect_to_query(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__response_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimResponse_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimResponse_handlers());
    }
}


PHP_METHOD(VSlim__App, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* VSlimApp_handlers();
    vphp_class_handlers *h = VSlimApp_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
}

static const zend_function_entry vslim__app_methods[] = {
    PHP_ME(VSlim__App, __construct, arginfo_vslim__app___construct, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, demo, arginfo_vslim__app_demo, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_ME(VSlim__App, set_base_path, arginfo_vslim__app_set_base_path, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, group, arginfo_vslim__app_group, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, dispatch, arginfo_vslim__app_dispatch, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, dispatch_body, arginfo_vslim__app_dispatch_body, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, dispatch_request, arginfo_vslim__app_dispatch_request, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, dispatch_envelope, arginfo_vslim__app_dispatch_envelope, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, get, arginfo_vslim__app_get, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, post, arginfo_vslim__app_post, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, put, arginfo_vslim__app_put, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, patch, arginfo_vslim__app_patch, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, delete, arginfo_vslim__app_delete, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, any, arginfo_vslim__app_any, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, get_named, arginfo_vslim__app_get_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, post_named, arginfo_vslim__app_post_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, put_named, arginfo_vslim__app_put_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, patch_named, arginfo_vslim__app_patch_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, delete_named, arginfo_vslim__app_delete_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, any_named, arginfo_vslim__app_any_named, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, middleware, arginfo_vslim__app_middleware, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, before, arginfo_vslim__app_before, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, after, arginfo_vslim__app_after, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, url_for, arginfo_vslim__app_url_for, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, url_for_query, arginfo_vslim__app_url_for_query, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, url_for_abs, arginfo_vslim__app_url_for_abs, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, url_for_query_abs, arginfo_vslim__app_url_for_query_abs, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, redirect_to, arginfo_vslim__app_redirect_to, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__App, redirect_to_query, arginfo_vslim__app_redirect_to_query, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *vslim__container__containerexception_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__container__containerexception___construct, 0, 0, 0)
ZEND_END_ARG_INFO()

PHP_METHOD(VSlim__Container__ContainerException, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* VSlimContainerException_handlers();
    vphp_class_handlers *h = VSlimContainerException_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
}

static const zend_function_entry vslim__container__containerexception_methods[] = {
    PHP_ME(VSlim__Container__ContainerException, __construct, arginfo_vslim__container__containerexception___construct, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *vslim__container__notfoundexception_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__container__notfoundexception___construct, 0, 0, 0)
ZEND_END_ARG_INFO()

PHP_METHOD(VSlim__Container__NotFoundException, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* VSlimContainerNotFoundException_handlers();
    vphp_class_handlers *h = VSlimContainerNotFoundException_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
}

static const zend_function_entry vslim__container__notfoundexception_methods[] = {
    PHP_ME(VSlim__Container__NotFoundException, __construct, arginfo_vslim__container__notfoundexception___construct, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *vslim__container_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__container_construct, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__container_set, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, id, IS_STRING, 0)
ZEND_ARG_INFO(0, value)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__container_factory, 0, 0, 2)
ZEND_ARG_TYPE_INFO(0, id, IS_STRING, 0)
ZEND_ARG_INFO(0, callable)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__container_has, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, id, IS_STRING, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vslim__container_get, 0, 0, 1)
ZEND_ARG_TYPE_INFO(0, id, IS_STRING, 0)
ZEND_END_ARG_INFO()
PHP_METHOD(VSlim__Container, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* VSlimContainer_handlers();
    vphp_class_handlers *h = VSlimContainer_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_register_object(wrapper->v_ptr, Z_OBJ_P(getThis()));
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
    extern void vphp_wrap_VSlimContainer_construct(void* v_ptr, vphp_context_internal ctx);
    void* v_ptr = wrapper->v_ptr;
    vphp_wrap_VSlimContainer_construct(v_ptr, ctx);
}

PHP_METHOD(VSlim__Container, set) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimContainer_set(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Container::set called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimContainer_set(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__container_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimContainer_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimContainer_handlers());
    }
}


PHP_METHOD(VSlim__Container, factory) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_VSlimContainer_factory(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    // printf("PHP_METHOD VSlim__Container::factory called, wrapper->v_ptr=%p\n", wrapper->v_ptr);
    if (!wrapper->v_ptr) RETURN_NULL();
    void* v_instance = vphp_wrap_VSlimContainer_factory(wrapper->v_ptr, ctx);
    vphp_return_obj(return_value, v_instance, vslim__container_ce);
    if (Z_TYPE_P(return_value) == IS_OBJECT) {
        extern vphp_class_handlers* VSlimContainer_handlers();
        vphp_bind_handlers(Z_OBJ_P(return_value), VSlimContainer_handlers());
    }
}

PHP_METHOD(VSlim__Container, has) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VSlimContainer_has(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_FALSE;
    vphp_wrap_VSlimContainer_has(wrapper->v_ptr, ctx);
}
PHP_METHOD(VSlim__Container, get) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void VSlimContainer_get(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_NULL();
    VSlimContainer_get(wrapper->v_ptr, ctx);
}
static const zend_function_entry vslim__container_methods[] = {
    PHP_ME(VSlim__Container, __construct, arginfo_vslim__container_construct, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Container, set, arginfo_vslim__container_set, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Container, factory, arginfo_vslim__container_factory, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Container, has, arginfo_vslim__container_has, ZEND_ACC_PUBLIC)
    PHP_ME(VSlim__Container, get, arginfo_vslim__container_get, ZEND_ACC_PUBLIC)
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
    PHP_FE(vslim_response_headers, arginfo_vslim_response_headers)
    PHP_FE_END
};
PHP_MINIT_FUNCTION(vslim) {
    vphp_framework_init(module_number);
    extern void vphp_ext_startup() __attribute__((weak));
    if (vphp_ext_startup) vphp_ext_startup();
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VSlim\\RouteGroup", vslim__routegroup_methods);
        vslim__routegroup_ce = zend_register_internal_class(&ce);
        vslim__routegroup_ce->create_object = vphp_create_object_handler;
        zend_declare_property_null(vslim__routegroup_ce, "app", sizeof("app")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_string(vslim__routegroup_ce, "prefix", sizeof("prefix")-1, "", ZEND_ACC_PROTECTED);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VSlim\\Request", vslim__request_methods);
        vslim__request_ce = zend_register_internal_class(&ce);
        vslim__request_ce->create_object = vphp_create_object_handler;
        zend_declare_property_string(vslim__request_ce, "method", sizeof("method")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__request_ce, "raw_path", sizeof("raw_path")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__request_ce, "path", sizeof("path")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__request_ce, "body", sizeof("body")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__request_ce, "query_string", sizeof("query_string")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__request_ce, "scheme", sizeof("scheme")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__request_ce, "host", sizeof("host")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__request_ce, "port", sizeof("port")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__request_ce, "protocol_version", sizeof("protocol_version")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__request_ce, "remote_addr", sizeof("remote_addr")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_null(vslim__request_ce, "query", sizeof("query")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__request_ce, "headers", sizeof("headers")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__request_ce, "cookies", sizeof("cookies")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__request_ce, "attributes", sizeof("attributes")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__request_ce, "server", sizeof("server")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__request_ce, "uploaded_files", sizeof("uploaded_files")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__request_ce, "params", sizeof("params")-1, ZEND_ACC_PROTECTED);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VSlim\\Response", vslim__response_methods);
        vslim__response_ce = zend_register_internal_class(&ce);
        vslim__response_ce->create_object = vphp_create_object_handler;
        zend_declare_property_long(vslim__response_ce, "status", sizeof("status")-1, 0, ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__response_ce, "body", sizeof("body")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_string(vslim__response_ce, "content_type", sizeof("content_type")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_null(vslim__response_ce, "headers", sizeof("headers")-1, ZEND_ACC_PROTECTED);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VSlim\\App", vslim__app_methods);
        vslim__app_ce = zend_register_internal_class(&ce);
        vslim__app_ce->create_object = vphp_create_object_handler;
        zend_declare_property_null(vslim__app_ce, "routes", sizeof("routes")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__app_ce, "php_before_hooks", sizeof("php_before_hooks")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__app_ce, "php_after_hooks", sizeof("php_after_hooks")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__app_ce, "php_group_before", sizeof("php_group_before")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__app_ce, "php_group_after", sizeof("php_group_after")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_string(vslim__app_ce, "base_path", sizeof("base_path")-1, "", ZEND_ACC_PROTECTED);
        zend_declare_property_bool(vslim__app_ce, "use_demo", sizeof("use_demo")-1, 0, ZEND_ACC_PROTECTED);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VSlim\\Container\\ContainerException", vslim__container__containerexception_methods);
        zend_class_entry *parent_ce = zend_hash_str_find_ptr(CG(class_table), "exception", sizeof("exception")-1);
        if (!parent_ce) {
            vphp_throw("parent class Exception not found for VSlim\\Container\\ContainerException", 0);
            return FAILURE;
        }
        vslim__container__containerexception_ce = zend_register_internal_class_ex(&ce, parent_ce);
        vslim__container__containerexception_ce->create_object = vphp_create_object_handler;
        zend_class_entry *iface_0_ce = zend_hash_str_find_ptr(CG(class_table), "psr\\container\\containerexceptioninterface", sizeof("psr\\container\\containerexceptioninterface")-1);
        if (!iface_0_ce) {
            vphp_throw("interface Psr\\\\Container\\\\ContainerExceptionInterface not found for VSlim\\Container\\ContainerException", 0);
            return FAILURE;
        }
        zend_class_implements(vslim__container__containerexception_ce, 1, iface_0_ce);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VSlim\\Container\\NotFoundException", vslim__container__notfoundexception_methods);
        zend_class_entry *parent_ce = zend_hash_str_find_ptr(CG(class_table), "vslim\\container\\containerexception", sizeof("vslim\\container\\containerexception")-1);
        if (!parent_ce) {
            vphp_throw("parent class VSlim\\\\Container\\\\ContainerException not found for VSlim\\Container\\NotFoundException", 0);
            return FAILURE;
        }
        vslim__container__notfoundexception_ce = zend_register_internal_class_ex(&ce, parent_ce);
        vslim__container__notfoundexception_ce->create_object = vphp_create_object_handler;
        zend_class_entry *iface_0_ce = zend_hash_str_find_ptr(CG(class_table), "psr\\container\\notfoundexceptioninterface", sizeof("psr\\container\\notfoundexceptioninterface")-1);
        if (!iface_0_ce) {
            vphp_throw("interface Psr\\\\Container\\\\NotFoundExceptionInterface not found for VSlim\\Container\\NotFoundException", 0);
            return FAILURE;
        }
        zend_class_implements(vslim__container__notfoundexception_ce, 1, iface_0_ce);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VSlim\\Container", vslim__container_methods);
        vslim__container_ce = zend_register_internal_class(&ce);
        vslim__container_ce->create_object = vphp_create_object_handler;
        zend_class_entry *iface_0_ce = zend_hash_str_find_ptr(CG(class_table), "psr\\container\\containerinterface", sizeof("psr\\container\\containerinterface")-1);
        if (!iface_0_ce) {
            vphp_throw("interface Psr\\\\Container\\\\ContainerInterface not found for VSlim\\Container", 0);
            return FAILURE;
        }
        zend_class_implements(vslim__container_ce, 1, iface_0_ce);
        zend_declare_property_null(vslim__container_ce, "entries", sizeof("entries")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__container_ce, "factories", sizeof("factories")-1, ZEND_ACC_PROTECTED);
        zend_declare_property_null(vslim__container_ce, "resolved", sizeof("resolved")-1, ZEND_ACC_PROTECTED);
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
