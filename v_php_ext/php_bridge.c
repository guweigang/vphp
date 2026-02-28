/* ⚠️ VPHP Compiler Generated for vphptest */
#include "php_bridge.h"

#include "../vphp/v_bridge.h"

typedef struct { void* ex; void* ret; } vphp_context_internal;
typedef struct { void* str; int len; int is_lit; } v_string;

extern void vphp_framework_init(int module_number);
extern void vphp_task_auto_startup();

zend_class_entry *post_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_post_set_author, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_post_get_author, 0, 0, 0)
ZEND_END_ARG_INFO()
PHP_METHOD(Post, set_author) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_Post_set_author(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_NULL();
    vphp_wrap_Post_set_author(wrapper->v_ptr, ctx);
}
PHP_METHOD(Post, get_author) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_Post_get_author(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_NULL();
    vphp_wrap_Post_get_author(wrapper->v_ptr, ctx);
}
static const zend_function_entry post_methods[] = {
    PHP_ME(Post, set_author, arginfo_post_set_author, ZEND_ACC_PUBLIC)
    PHP_ME(Post, get_author, arginfo_post_get_author, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *article_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_article_init, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_article_internal_format, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_article_create, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_article_get_formatted_title, 0, 0, 0)
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
PHP_METHOD(Article, internal_format) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_Article_internal_format(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_NULL();
    vphp_wrap_Article_internal_format(wrapper->v_ptr, ctx);
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
PHP_METHOD(Article, get_formatted_title) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_Article_get_formatted_title(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_NULL();
    vphp_wrap_Article_get_formatted_title(wrapper->v_ptr, ctx);
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
    PHP_ME(Article, internal_format, arginfo_article_internal_format, ZEND_ACC_PROTECTED)
    PHP_ME(Article, create, arginfo_article_create, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_ME(Article, get_formatted_title, arginfo_article_get_formatted_title, ZEND_ACC_PUBLIC)
    PHP_ME(Article, save, arginfo_article_save, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *story_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_story_create, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_story_tell, 0, 0, 0)
ZEND_END_ARG_INFO()
PHP_METHOD(Story, create) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void* vphp_wrap_Story_create(vphp_context_internal ctx);
    void* v_instance = vphp_wrap_Story_create(ctx);
    if (!v_instance) RETURN_NULL();
    object_init_ex(return_value, story_ce);
    extern vphp_class_handlers* Story_handlers();
    vphp_class_handlers *h = Story_handlers();
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(return_value));
    wrapper->v_ptr = v_instance;
    vphp_bind_handlers(Z_OBJ_P(return_value), h);
}
PHP_METHOD(Story, tell) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_Story_tell(void* v_ptr, vphp_context_internal ctx);
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(getThis()));
    if (!wrapper->v_ptr) RETURN_NULL();
    vphp_wrap_Story_tell(wrapper->v_ptr, ctx);
}
static const zend_function_entry story_methods[] = {
    PHP_ME(Story, create, arginfo_story_create, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_ME(Story, tell, arginfo_story_tell, ZEND_ACC_PUBLIC)
    PHP_FE_END
};

zend_class_entry *vphp__task_ce = NULL;
ZEND_BEGIN_ARG_INFO_EX(arginfo_vphp__task_spawn, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vphp__task_wait, 0, 0, 0)
ZEND_END_ARG_INFO()
ZEND_BEGIN_ARG_INFO_EX(arginfo_vphp__task_list, 0, 0, 0)
ZEND_END_ARG_INFO()
PHP_METHOD(VPhp__Task, spawn) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VPhpTask_spawn(vphp_context_internal ctx);
    vphp_wrap_VPhpTask_spawn(ctx);
}
PHP_METHOD(VPhp__Task, wait) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VPhpTask_wait(vphp_context_internal ctx);
    vphp_wrap_VPhpTask_wait(ctx);
}
PHP_METHOD(VPhp__Task, list) {
    typedef struct { void* ex; void* ret; } vphp_context_internal;
    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };
    extern void vphp_wrap_VPhpTask_list(vphp_context_internal ctx);
    vphp_wrap_VPhpTask_list(ctx);
}
static const zend_function_entry vphp__task_methods[] = {
    PHP_ME(VPhp__Task, spawn, arginfo_vphp__task_spawn, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_ME(VPhp__Task, wait, arginfo_vphp__task_wait, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_ME(VPhp__Task, list, arginfo_vphp__task_list, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
    PHP_FE_END
};

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
static const zend_function_entry vphptest_functions[] = {
    PHP_FE(v_add, arginfo_v_add)
    PHP_FE(v_greet, arginfo_v_greet)
    PHP_FE(v_pure_map_test, arginfo_v_pure_map_test)
    PHP_FE(v_process_list, arginfo_v_process_list)
    PHP_FE(v_test_map, arginfo_v_test_map)
    PHP_FE(v_get_config, arginfo_v_get_config)
    PHP_FE(v_get_user, arginfo_v_get_user)
    PHP_FE(v_call_back, arginfo_v_call_back)
    PHP_FE(v_complex_test, arginfo_v_complex_test)
    PHP_FE(v_analyze_user_object, arginfo_v_analyze_user_object)
    PHP_FE(v_trigger_user_action, arginfo_v_trigger_user_action)
    PHP_FE(v_call_php_closure, arginfo_v_call_php_closure)
    PHP_FE(v_reverse_string, arginfo_v_reverse_string)
    PHP_FE(v_logic_main, arginfo_v_logic_main)
    PHP_FE(v_new_coach, arginfo_v_new_coach)
    PHP_FE(v_new_db, arginfo_v_new_db)
    PHP_FE(v_check_res, arginfo_v_check_res)
    PHP_FE(v_analyze_fitness_data, arginfo_v_analyze_fitness_data)
    PHP_FE(v_get_alerts, arginfo_v_get_alerts)
    PHP_FE_END
};

PHP_MINIT_FUNCTION(vphptest) {
    vphp_framework_init(module_number);
    extern void vphp_ext_startup() __attribute__((weak));
    if (vphp_ext_startup) vphp_ext_startup();
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "Post", post_methods);
        post_ce = zend_register_internal_class(&ce);
        post_ce->create_object = vphp_create_object_handler;
        zend_declare_property_long(post_ce, "post_id", sizeof("post_id")-1, 0, ZEND_ACC_PUBLIC);
        zend_declare_property_string(post_ce, "author", sizeof("author")-1, "", ZEND_ACC_PUBLIC);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "Article", article_methods);
        article_ce = zend_register_internal_class_ex(&ce, zend_hash_str_find_ptr(CG(class_table), "post", sizeof("post")-1));
        article_ce->create_object = vphp_create_object_handler;
        zend_declare_property_long(article_ce, "id", sizeof("id")-1, 0, ZEND_ACC_PUBLIC);
        zend_declare_property_string(article_ce, "title", sizeof("title")-1, "", ZEND_ACC_PUBLIC);
        zend_declare_property_bool(article_ce, "is_top", sizeof("is_top")-1, 0, ZEND_ACC_PUBLIC);
        zend_declare_property_long(article_ce, "max_title_len", sizeof("max_title_len")-1, 0, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC);
        zend_declare_property_string(article_ce, "content", sizeof("content")-1, "", ZEND_ACC_PROTECTED);
        zend_declare_property_long(article_ce, "total_count", sizeof("total_count")-1, 0, ZEND_ACC_PROTECTED | ZEND_ACC_STATIC);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "Story", story_methods);
        story_ce = zend_register_internal_class_ex(&ce, zend_hash_str_find_ptr(CG(class_table), "post", sizeof("post")-1));
        story_ce->create_object = vphp_create_object_handler;
        zend_declare_property_long(story_ce, "chapter_count", sizeof("chapter_count")-1, 0, ZEND_ACC_PUBLIC);
    }
    {   zend_class_entry ce;
        INIT_CLASS_ENTRY(ce, "VPhp\\Task", vphp__task_methods);
        vphp__task_ce = zend_register_internal_class(&ce);
        vphp__task_ce->create_object = vphp_create_object_handler;
    }
    REGISTER_STRING_CONSTANT("APP_VERSION", "1.0.0", CONST_CS | CONST_PERSISTENT);
    REGISTER_LONG_CONSTANT("MAX_RETRY", 3, CONST_CS | CONST_PERSISTENT);
    REGISTER_DOUBLE_CONSTANT("PI_VALUE", 3.14159, CONST_CS | CONST_PERSISTENT);
    REGISTER_BOOL_CONSTANT("DEBUG_MODE", 0, CONST_CS | CONST_PERSISTENT);
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
