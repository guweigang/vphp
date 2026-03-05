/* ⚠️ VPHP Compiler Generated，请勿手动修改 */
#ifndef VPHP_EXT_VSLIM_BRIDGE_H
#define VPHP_EXT_VSLIM_BRIDGE_H

#include <php.h>
#include <ext/standard/info.h>

extern zend_module_entry vslim_module_entry;
#define phpext_vslim_ptr &vslim_module_entry

extern void* vphp_get_active_globals();

PHP_FUNCTION(vslim_handle_request);
PHP_FUNCTION(vslim_demo_dispatch);
PHP_FUNCTION(vslim_response_headers);
extern zend_class_entry *vslim__routegroup_ce;
extern zend_class_entry *vslim__request_ce;
extern zend_class_entry *vslim__response_ce;
extern zend_class_entry *vslim__app_ce;
#endif
