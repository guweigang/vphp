/* ⚠️ VPHP Compiler Generated for vphptest */
#include "php_bridge.h"

#include "../vphp/v_bridge.h"

typedef struct { void* ex; void* ret; } vphp_context_internal;
typedef struct { void* str; int len; int is_lit; } v_string;

extern void vphp_framework_init(int module_number);
extern void vphp_task_auto_startup();

zend_class_entry *article_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_article_init, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_article_create, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_article_is_top, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_article_save, 0, 0, 0)
ZEND_END_ARG_INFO()
PHP_METHOD(Article, __construct) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern vphp_class_handlers* Article_handlers();
    vphp_class_handlers *h = Article_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    wrapper->v_ptr = h->new_raw();
    vphp_bind_handlers(Z_OBJ_P(getThis()), h);
    extern void vphp_wrap_Article_init(void* v_ptr, vphp_context_internal ctx);
    vphp_wrap_Article_init(wrapper->v_ptr, ctx);
}
PHP_METHOD(Article, create) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_Article_create(vphp_context_internal ctx);
    void* v_instance = vphp_wrap_Article_create(ctx);
    if (!v_instance) RETURN_NULL();
    object_init_ex(return_value, article_ce);
    extern vphp_class_handlers* Article_handlers();
    vphp_class_handlers *h = Article_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(return_value));
    wrapper->v_ptr = v_instance;
    vphp_bind_handlers(Z_OBJ_P(return_value), h);
}
PHP_METHOD(Article, is_top) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_Article_is_top(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_NULL();
    vphp_wrap_Article_is_top(wrapper->v_ptr, ctx);
}
PHP_METHOD(Article, save) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_Article_save(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_NULL();
    vphp_wrap_Article_save(wrapper->v_ptr, ctx);
}
static const zend_function_entry article_methods[] = {
    PHP_ME(Article, __construct, arginfo_article_init, ZEND_ACC_PUBLIC)
    PHP_ME(Article, create, arginfo_article_create, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_ME(Article, is_top, arginfo_article_is_top, ZEND_ACC_PUBLIC)
    PHP_ME(Article, save, arginfo_article_save, ZEND_ACC_PUBLIC)
    PHP_FE_END
};
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_reverse_string, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_reverse_string(vphp_context_internal ctx);
PHP_FUNCTION(v_reverse_string) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_reverse_string(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_logic_main, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_logic_main(vphp_context_internal ctx);
PHP_FUNCTION(v_logic_main) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_logic_main(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_add, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void vphp_wrap_v_add(vphp_context_internal ctx);
PHP_FUNCTION(v_add) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    vphp_wrap_v_add(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_greet, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void vphp_wrap_v_greet(vphp_context_internal ctx);
PHP_FUNCTION(v_greet) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    vphp_wrap_v_greet(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_pure_map_test, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void vphp_wrap_v_pure_map_test(vphp_context_internal ctx);
PHP_FUNCTION(v_pure_map_test) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    vphp_wrap_v_pure_map_test(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_process_list, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_process_list(vphp_context_internal ctx);
PHP_FUNCTION(v_process_list) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_process_list(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_test_map, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_test_map(vphp_context_internal ctx);
PHP_FUNCTION(v_test_map) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_test_map(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_get_config, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_get_config(vphp_context_internal ctx);
PHP_FUNCTION(v_get_config) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_get_config(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_get_user, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_get_user(vphp_context_internal ctx);
PHP_FUNCTION(v_get_user) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_get_user(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_call_back, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_call_back(vphp_context_internal ctx);
PHP_FUNCTION(v_call_back) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_call_back(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_new_coach, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_new_coach(vphp_context_internal ctx);
PHP_FUNCTION(v_new_coach) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_new_coach(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_new_db, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_new_db(vphp_context_internal ctx);
PHP_FUNCTION(v_new_db) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_new_db(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_check_res, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_check_res(vphp_context_internal ctx);
PHP_FUNCTION(v_check_res) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_check_res(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_analyze_fitness_data, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_analyze_fitness_data(vphp_context_internal ctx);
PHP_FUNCTION(v_analyze_fitness_data) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_analyze_fitness_data(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_get_alerts, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_get_alerts(vphp_context_internal ctx);
PHP_FUNCTION(v_get_alerts) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_get_alerts(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_complex_test, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_complex_test(vphp_context_internal ctx);
PHP_FUNCTION(v_complex_test) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_complex_test(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_analyze_user_object, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_analyze_user_object(vphp_context_internal ctx);
PHP_FUNCTION(v_analyze_user_object) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_analyze_user_object(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_trigger_user_action, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_trigger_user_action(vphp_context_internal ctx);
PHP_FUNCTION(v_trigger_user_action) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_trigger_user_action(ctx);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_call_php_closure, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_call_php_closure(vphp_context_internal ctx);
PHP_FUNCTION(v_call_php_closure) {
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    v_call_php_closure(ctx);
}
/* === VPhp\\Task built-in class === */
extern void vphp_task_spawn(zend_execute_data *execute_data, zval *return_value);
extern void vphp_task_wait(zend_execute_data *execute_data, zval *return_value);

ZEND_BEGIN_ARG_INFO_EX(arginfo_vphp_task_spawn, 0, 0, 2)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vphp_task_wait, 0, 0, 1)
ZEND_END_ARG_INFO()

PHP_METHOD(VPhp_Task, spawn) { vphp_task_spawn(execute_data, return_value); }
PHP_METHOD(VPhp_Task, wait)  { vphp_task_wait(execute_data, return_value); }

static const zend_function_entry vphp_task_methods[] = {
    PHP_ME(VPhp_Task, spawn, arginfo_vphp_task_spawn, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_ME(VPhp_Task, wait,  arginfo_vphp_task_wait,  ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_FE_END
};

static const zend_function_entry vphptest_functions[] = {
    PHP_FE(v_reverse_string, arginfo_v_reverse_string)
    PHP_FE(v_logic_main, arginfo_v_logic_main)
    PHP_FE(v_add, arginfo_v_add)
    PHP_FE(v_greet, arginfo_v_greet)
    PHP_FE(v_pure_map_test, arginfo_v_pure_map_test)
    PHP_FE(v_process_list, arginfo_v_process_list)
    PHP_FE(v_test_map, arginfo_v_test_map)
    PHP_FE(v_get_config, arginfo_v_get_config)
    PHP_FE(v_get_user, arginfo_v_get_user)
    PHP_FE(v_call_back, arginfo_v_call_back)
    PHP_FE(v_new_coach, arginfo_v_new_coach)
    PHP_FE(v_new_db, arginfo_v_new_db)
    PHP_FE(v_check_res, arginfo_v_check_res)
    PHP_FE(v_analyze_fitness_data, arginfo_v_analyze_fitness_data)
    PHP_FE(v_get_alerts, arginfo_v_get_alerts)
    PHP_FE(v_complex_test, arginfo_v_complex_test)
    PHP_FE(v_analyze_user_object, arginfo_v_analyze_user_object)
    PHP_FE(v_trigger_user_action, arginfo_v_trigger_user_action)
    PHP_FE(v_call_php_closure, arginfo_v_call_php_closure)
    PHP_FE_END
};

PHP_MINIT_FUNCTION(vphptest) {
    vphp_framework_init(module_number);
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "Article", article_methods);
        article_ce = zend_register_internal_class(&ce);
        article_ce->create_object = vphp_create_object_handler;
        zend_declare_property_long(article_ce, "id", sizeof("id")-1, 0, ZEND_ACC_PUBLIC);
        zend_declare_property_string(article_ce, "title", sizeof("title")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_bool(article_ce, "is_top", sizeof("is_top")-1, 0, ZEND_ACC_PUBLIC);
    }
    REGISTER_STRING_CONSTANT("APP_VERSION", "1.0.0", CONST_CS | CONST_PERSISTENT);
    REGISTER_LONG_CONSTANT("MAX_RETRY", 3, CONST_CS | CONST_PERSISTENT);
    REGISTER_DOUBLE_CONSTANT("PI_VALUE", 3.14159, CONST_CS | CONST_PERSISTENT);
    REGISTER_BOOL_CONSTANT("DEBUG_MODE", 0, CONST_CS | CONST_PERSISTENT);
    {
        zend_class_entry ce_task;
        INIT_CLASS_ENTRY(ce_task, "VPhp\\Task", vphp_task_methods);
        zend_register_internal_class(&ce_task);
    }
    vphp_task_auto_startup();
    return SUCCESS;
}

zend_module_entry vphptest_module_entry = {
    STANDARD_MODULE_HEADER, "vphptest", vphptest_functions,
    PHP_MINIT(vphptest), NULL, NULL, NULL, NULL, "1.0.0",
    STANDARD_MODULE_PROPERTIES
};

#ifndef COMPILE_DL_VPHPTEST
#define COMPILE_DL_VPHPTEST

ZEND_GET_MODULE(vphptest)
#endif
