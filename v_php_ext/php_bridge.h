/* ⚠️ VPHP Compiler Generated，请勿手动修改 */
#ifndef VPHP_BRIDGE_H
#define VPHP_BRIDGE_H

#include <php.h>

extern zend_module_entry vphptest_module_entry;
#define phpext_vphptest_ptr &vphptest_module_entry

extern zend_class_entry *post_ce;
extern zend_class_entry *article_ce;
extern zend_class_entry *vphp__task_ce;
PHP_FUNCTION(v_add);
PHP_FUNCTION(v_greet);
PHP_FUNCTION(v_pure_map_test);
PHP_FUNCTION(v_process_list);
PHP_FUNCTION(v_test_map);
PHP_FUNCTION(v_get_config);
PHP_FUNCTION(v_get_user);
PHP_FUNCTION(v_call_back);
PHP_FUNCTION(v_complex_test);
PHP_FUNCTION(v_analyze_user_object);
PHP_FUNCTION(v_trigger_user_action);
PHP_FUNCTION(v_call_php_closure);
PHP_FUNCTION(v_reverse_string);
PHP_FUNCTION(v_logic_main);
PHP_FUNCTION(v_new_coach);
PHP_FUNCTION(v_new_db);
PHP_FUNCTION(v_check_res);
PHP_FUNCTION(v_analyze_fitness_data);
PHP_FUNCTION(v_get_alerts);
#endif
