/* ⚠️ VPHP Compiler Generated，请勿手动修改 */
#ifndef VPHP_EXT_VPHPTEST_BRIDGE_H
#define VPHP_EXT_VPHPTEST_BRIDGE_H

#include <php.h>
#include <ext/standard/info.h>

extern zend_module_entry vphptest_module_entry;
#define phpext_vphptest_ptr &vphptest_module_entry

extern void* vphp_get_active_globals();

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
PHP_FUNCTION(v_mutate_user_object);
PHP_FUNCTION(v_check_user_object_props);
PHP_FUNCTION(v_construct_php_object);
PHP_FUNCTION(v_call_php_static_method);
PHP_FUNCTION(v_mutate_php_static_prop);
PHP_FUNCTION(v_read_php_class_constant);
PHP_FUNCTION(v_typed_php_interop);
PHP_FUNCTION(v_typed_object_restore);
PHP_FUNCTION(v_read_php_global_const);
PHP_FUNCTION(v_php_symbol_exists);
PHP_FUNCTION(v_include_php_file);
PHP_FUNCTION(v_include_php_file_once);
PHP_FUNCTION(v_php_object_meta);
PHP_FUNCTION(v_php_object_introspection);
PHP_FUNCTION(v_trigger_user_action);
PHP_FUNCTION(v_call_php_closure);
PHP_FUNCTION(v_test_globals);
PHP_FUNCTION(v_get_v_closure);
PHP_FUNCTION(v_get_v_closure_auto);
PHP_FUNCTION(v_reverse_string);
PHP_FUNCTION(v_logic_main);
PHP_FUNCTION(v_slim_demo_dispatch);
PHP_FUNCTION(v_new_coach);
PHP_FUNCTION(v_new_db);
PHP_FUNCTION(v_check_res);
PHP_FUNCTION(v_analyze_fitness_data);
PHP_FUNCTION(v_get_alerts);
extern zend_class_entry *contentcontract_ce;
extern zend_class_entry *abstractreport_ce;
extern zend_class_entry *dailyreport_ce;
extern zend_class_entry *author_ce;
extern zend_class_entry *post_ce;
extern zend_class_entry *article_ce;
extern zend_class_entry *story_ce;
extern zend_class_entry *readonlyrecord_ce;
extern zend_class_entry *traitpost_ce;
extern zend_class_entry *articlestatus_ce;
extern zend_class_entry *vphp__task_ce;
#endif
