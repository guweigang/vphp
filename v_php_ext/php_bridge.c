/* ⚠️ VPHP Compiler Generated for vphptest */
#include "php_bridge.h"

#include "../vphp/v_bridge.h"

extern void vphp_framework_init(int module_number);
extern void vphp_task_auto_startup();

zend_class_entry *article_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_article_create, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_article_save, 0, 0, 0)
ZEND_END_ARG_INFO()
    PHP_METHOD(Article, create) {
        typedef struct { void* ex; void* ret; } vphp_context_internal;
        vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
        extern void* Article_create(vphp_context_internal ctx);
        void* v_instance = Article_create(ctx);
        if (!v_instance) RETURN_NULL();
        object_init_ex(return_value, article_ce);
        vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(return_value));
        wrapper->v_ptr = v_instance;
        extern void Article_get_prop(void*, const char*, zval*);
        wrapper->prop_handler = Article_get_prop;
            extern void Article_sync_props(void*, zval*);
            wrapper->sync_handler = Article_sync_props;
    }
    PHP_METHOD(Article, save) {
        typedef struct { void* ex; void* ret; } vphp_context_internal;
        vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
        extern bool Article_save(void* v_ptr, vphp_context_internal ctx);
        vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
        if (!wrapper->v_ptr) RETURN_FALSE;
        bool res = Article_save(wrapper->v_ptr, ctx);
        RETURN_BOOL(res);
    }
static const zend_function_entry article_methods[] = {
    PHP_ME(Article, create, arginfo_article_create, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_ME(Article, save, arginfo_article_save, ZEND_ACC_PUBLIC)
    PHP_FE_END
};
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_reverse_string, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_reverse_string(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_reverse_string) {
    v_reverse_string(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_logic_main, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_logic_main(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_logic_main) {
    v_logic_main(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_add, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_add(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_add) {
    v_add(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_greet, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_greet(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_greet) {
    v_greet(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_process_list, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_process_list(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_process_list) {
    v_process_list(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_test_map, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_test_map(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_test_map) {
    v_test_map(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_get_config, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_get_config(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_get_config) {
    v_get_config(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_get_user, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_get_user(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_get_user) {
    v_get_user(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_call_back, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_call_back(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_call_back) {
    v_call_back(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_new_coach, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_new_coach(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_new_coach) {
    v_new_coach(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_new_db, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_new_db(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_new_db) {
    v_new_db(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_check_res, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_check_res(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_check_res) {
    v_check_res(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_analyze_fitness_data, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_analyze_fitness_data(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_analyze_fitness_data) {
    v_analyze_fitness_data(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_get_alerts, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_get_alerts(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_get_alerts) {
    v_get_alerts(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_complex_test, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_complex_test(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_complex_test) {
    v_complex_test(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_analyze_user_object, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_analyze_user_object(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_analyze_user_object) {
    v_analyze_user_object(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_trigger_user_action, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_trigger_user_action(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_trigger_user_action) {
    v_trigger_user_action(execute_data, return_value);
}
ZEND_BEGIN_ARG_INFO_EX(arginfo_v_call_php_closure, 0, 0, 0)
ZEND_END_ARG_INFO()
extern void v_call_php_closure(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_call_php_closure) {
    v_call_php_closure(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_spawn, 0, 0, 0)
ZEND_END_ARG_INFO()
void v_spawn(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_spawn) { v_spawn(execute_data, return_value); }

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_wait, 0, 0, 0)
ZEND_END_ARG_INFO()
void v_wait(zend_execute_data *execute_data, zval *return_value);
PHP_FUNCTION(v_wait) { v_wait(execute_data, return_value); }

static const zend_function_entry vphptest_functions[] = {
    PHP_FE(v_reverse_string, arginfo_v_reverse_string)
    PHP_FE(v_logic_main, arginfo_v_logic_main)
    PHP_FE(v_add, arginfo_v_add)
    PHP_FE(v_greet, arginfo_v_greet)
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
    PHP_FE(v_spawn, arginfo_v_spawn)
    PHP_FE(v_wait, arginfo_v_wait)
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
        article_ce->create_object = vphp_create_object_handler;
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
