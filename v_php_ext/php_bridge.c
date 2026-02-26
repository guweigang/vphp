#include <php.h>
#include "../vphp/v_bridge.h"

void vphp_init_resource_system(int module_number);

void v_reverse_string(zend_execute_data *execute_data, zval *return_value);
void v_logic_main(zend_execute_data *execute_data, zval *return_value);
void v_add(zend_execute_data *execute_data, zval *return_value);
void v_greet(zend_execute_data *execute_data, zval *return_value);
void v_process_list(zend_execute_data *execute_data, zval *return_value);
void v_test_map(zend_execute_data *execute_data, zval *return_value);
void v_get_config(zend_execute_data *execute_data, zval *return_value);
void v_get_user(zend_execute_data *execute_data, zval *return_value);
void v_call_back(zend_execute_data *execute_data, zval *return_value);
void v_new_coach(zend_execute_data *execute_data, zval *return_value);
void v_new_db(zend_execute_data *execute_data, zval *return_value);
void v_check_res(zend_execute_data *execute_data, zval *return_value);
void v_analyze_fitness_data(zend_execute_data *execute_data, zval *return_value);
void v_get_alerts(zend_execute_data *execute_data, zval *return_value);
void v_complex_test(zend_execute_data *execute_data, zval *return_value);
void v_analyze_user_object(zend_execute_data *execute_data, zval *return_value);
void v_trigger_user_action(zend_execute_data *execute_data, zval *return_value);

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_reverse_string, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_reverse_string) {
    v_reverse_string(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_logic_main, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_logic_main) {
    v_logic_main(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_add, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_add) {
    v_add(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_greet, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_greet) {
    v_greet(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_process_list, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_process_list) {
    v_process_list(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_test_map, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_test_map) {
    v_test_map(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_get_config, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_get_config) {
    v_get_config(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_get_user, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_get_user) {
    v_get_user(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_call_back, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_call_back) {
    v_call_back(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_new_coach, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_new_coach) {
    v_new_coach(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_new_db, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_new_db) {
    v_new_db(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_check_res, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_check_res) {
    v_check_res(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_analyze_fitness_data, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_analyze_fitness_data) {
    v_analyze_fitness_data(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_get_alerts, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_get_alerts) {
    v_get_alerts(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_complex_test, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_complex_test) {
    v_complex_test(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_analyze_user_object, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_analyze_user_object) {
    v_analyze_user_object(execute_data, return_value);
}

ZEND_BEGIN_ARG_INFO_EX(arginfo_v_trigger_user_action, 0, 0, -1)
    ZEND_ARG_INFO(0, args)
ZEND_END_ARG_INFO()

PHP_FUNCTION(v_trigger_user_action) {
    v_trigger_user_action(execute_data, return_value);
}

static const zend_function_entry v_ext_functions[] = {
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
    PHP_FE_END
};

PHP_MINIT_FUNCTION(v_php_ext) {
    vphp_init_resource_system(module_number);
    return SUCCESS;
}

zend_module_entry v_php_ext_module_entry = {
      STANDARD_MODULE_HEADER,
      "v_php_ext",
      v_ext_functions,
      PHP_MINIT(v_php_ext), // 这里从 NULL 改为初始化入口
      NULL,
      NULL,
      NULL,
      NULL,
      "0.1.0",
      STANDARD_MODULE_PROPERTIES
  };
#ifdef COMPILE_DL_V_PHP_EXT
ZEND_GET_MODULE(v_php_ext)
#endif
