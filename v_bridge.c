#include "v_bridge.h"
#include "bridge/compat.h"

#include <Zend/zend_closures.h>
#include <Zend/zend_exceptions.h>
#include <Zend/zend_inheritance.h>
#include <Zend/zend_interfaces.h>
#include <php.h>
#include <stdbool.h>
#ifdef PHP_WIN32
#include <windows.h>
#else
#include <dlfcn.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zend_errors.h>

#define VPHP_MAGIC 0x56504850

/*
 * v_bridge.c stays as the single compilation unit consumed by existing build
 * scripts, but the implementation is now split into feature-oriented shards so
 * PHP/Zend compatibility work has clearer ownership boundaries.
 */
typedef struct {
  char *class_name;
  int class_name_len;
  char *iface_name;
  int iface_name_len;
} vphp_auto_iface_binding_t;

typedef struct {
  uint32_t binding_index;
} vphp_pending_auto_iface_binding_t;

typedef struct {
  zval **items;
  int len;
  int cap;
} vphp_autorelease_pool_t;

typedef struct {
  zval **items;
  int len;
  int cap;
} vphp_owned_pool_t;

static void vphp_preload_auto_interfaces_for_class(zend_class_entry *class_ce);
static void vphp_prepare_auto_interfaces_for_class(zend_class_entry *class_ce,
                                                   int autoload);
static zend_class_entry *vphp_autoload_class(zend_string *name);
static void vphp_apply_auto_interface_bindings_for_class(zend_class_entry *ce);
static bool vphp_object_matches_unresolved_named_type(zend_class_entry *class_ce,
                                                      zend_string *expected_name);
static zend_string *vphp_normalize_literal_type_name(const char *literal_name);
static bool vphp_value_matches_type(zend_execute_data *execute_data,
                                    zend_type type, zval *value,
                                    bool is_return_type);
static bool vphp_value_matches_mask(uint32_t mask, zval *value, bool strict,
                                    bool is_return_type);
static bool vphp_value_matches_named_type(zend_execute_data *execute_data,
                                          zend_type type, zval *value,
                                          bool is_return_type);
static zend_class_entry *vphp_lookup_class_by_name(const char *class_name,
                                                   int class_name_len);
static zend_class_entry *
vphp_find_loaded_class_no_autoload(const char *class_name, int class_name_len);
static void vphp_apply_registered_auto_interface_bindings(int autoload);
static void vphp_flush_pending_auto_interface_bindings(void);
static int vphp_implement_interface_for_class(zend_class_entry *class_ce,
                                              zend_class_entry *iface_ce);
static void vphp_runtime_prepare_internal_query_bindings(
    zend_execute_data *execute_data);
static void vphp_runtime_maybe_apply_bindings(uint32_t class_count_before,
                                              int should_check);
static int vphp_runtime_bool_arg(zend_execute_data *execute_data, uint32_t index,
                                 int default_value);
static zend_class_entry *vphp_runtime_query_class_from_arg(zval *arg,
                                                           int autoload);
static int vphp_auto_binding_requires_deferral(zend_class_entry *class_ce,
                                               zend_class_entry *iface_ce);
static void vphp_queue_pending_auto_interface_binding(uint32_t binding_index);
static int vphp_try_apply_auto_interface_binding(vphp_auto_iface_binding_t *entry,
                                                 uint32_t binding_index,
                                                 int autoload, int allow_defer);
static void vphp_runtime_binding_execute_ex(zend_execute_data *execute_data);
static void vphp_runtime_binding_execute_internal(zend_execute_data *execute_data,
                                                  zval *return_value);
static zend_class_entry *vphp_get_ce_from_zval(zval *zv);
static void ZEND_FASTCALL vphp_closure_handler(zend_execute_data *execute_data,
                                               zval *return_value);
static void *vphp_lookup_optional_symbol(const char *symbol_name);
void vphp_free_object_handler(zend_object *obj);
zval *vphp_read_property(zend_object *object, zend_string *member, int type,
                         void **cache_slot, zval *rv);
zval *vphp_write_property(zend_object *object, zend_string *member, zval *value,
                          void **cache_slot);
HashTable *vphp_get_properties(zend_object *object);
static zend_object_handlers *vphp_clone_inherited_handlers(
    const zend_object_handlers *original_handlers);
static const zend_object_handlers *vphp_original_handlers_for(zend_object *obj);
static const zend_object_handlers *vphp_unwrap_inherited_handlers(
    const zend_object_handlers *handlers);
static const zend_object_handlers *vphp_fallback_handlers(
    const zend_object_handlers *handlers);
static zend_object *vphp_resolve_inherited_parent_object(
    zend_class_entry *ce,
    zend_object *(*self_create_object)(zend_class_entry *));
static void vphp_init_sidecar_registry(void);
static int vphp_object_uses_inline_wrapper(zend_object *obj);
static void vphp_init_inherited_handler_registry(void);
static vphp_object_wrapper *vphp_lookup_sidecar(zend_object *obj);
static vphp_object_wrapper *vphp_binding_for_obj(zend_object *obj, int create);
static int vphp_binding_uses_registry(zend_object *obj);

static HashTable vphp_object_registry;
static HashTable vphp_reverse_registry;
static HashTable vphp_sidecar_registry;
static HashTable vphp_inherited_handler_registry;
static bool vphp_registry_initialized = false;
static bool vphp_sidecar_registry_initialized = false;
static bool vphp_inherited_handler_registry_initialized = false;
static vphp_object_wrapper vphp_null_wrapper;
static void (*vphp_prev_execute_ex)(zend_execute_data *execute_data) = NULL;
static void (*vphp_prev_execute_internal)(zend_execute_data *execute_data,
                                          zval *return_value) = NULL;
static uint32_t vphp_runtime_binding_hook_refs = 0;
zend_object_handlers vphp_obj_handlers;

static vphp_auto_iface_binding_t *vphp_auto_iface_bindings = NULL;
static uint32_t vphp_auto_iface_bindings_len = 0;
static uint32_t vphp_auto_iface_bindings_cap = 0;
ZEND_TLS vphp_autorelease_pool_t vphp_autorelease_pool = {NULL, 0, 0};
ZEND_TLS vphp_owned_pool_t vphp_owned_pool = {NULL, 0, 0};
ZEND_TLS uint32_t vphp_last_class_table_count = 0;
ZEND_TLS int vphp_runtime_binding_applying = 0;
ZEND_TLS uint32_t vphp_runtime_internal_call_depth = 0;
ZEND_TLS vphp_pending_auto_iface_binding_t *vphp_pending_auto_iface_bindings =
    NULL;
ZEND_TLS uint32_t vphp_pending_auto_iface_bindings_len = 0;
ZEND_TLS uint32_t vphp_pending_auto_iface_bindings_cap = 0;
ZEND_TLS int vphp_runtime_autoloading = 0;

#include "bridge/runtime.inc.c"
#include "bridge/call.inc.c"
#include "bridge/values.inc.c"
#include "bridge/object.inc.c"

vphp_context_internal vphp_context_from_execute(zend_execute_data *execute_data,
                                                zval *return_value) {
  vphp_context_internal ctx;
  ctx.ex = (void *)execute_data;
  ctx.ret = (void *)return_value;
  return ctx;
}

static void *vphp_lookup_optional_symbol(const char *symbol_name) {
  if (symbol_name == NULL || symbol_name[0] == '\0') {
    return NULL;
  }
#ifdef PHP_WIN32
  HMODULE module = NULL;
  if (!GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                              GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                          (LPCSTR)(const void *)&vphp_lookup_optional_symbol,
                          &module) ||
      module == NULL) {
    return NULL;
  }
  return (void *)GetProcAddress(module, symbol_name);
#else
  return dlsym(RTLD_DEFAULT, symbol_name);
#endif
}

void vphp_call_optional_void_symbol(const char *symbol_name) {
  typedef void (*vphp_void_symbol_fn)(void);

  void *symbol = vphp_lookup_optional_symbol(symbol_name);
  if (symbol == NULL) {
    return;
  }
  ((vphp_void_symbol_fn)symbol)();
}
