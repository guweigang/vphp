#include "v_bridge.h"
#include <Zend/zend_closures.h>
#include <Zend/zend_exceptions.h>
#include <php.h>
#include <stdio.h>
#include <stdlib.h>
#include <zend_errors.h>

typedef struct {
  void *str;
  int len;
  int is_lit;
} v_string;

uint32_t vphp_get_num_args(zend_execute_data *ex) {
  return ZEND_CALL_NUM_ARGS(ex);
}
zval *vphp_get_arg_ptr(zend_execute_data *ex, uint32_t index) {
  return ZEND_CALL_ARG(ex, index);
}
void vphp_throw(char *msg, int code) {
  zend_throw_exception(NULL, msg, (zend_long)code);
}
void vphp_throw_class(char *class_name, char *msg, int code) {
  zend_class_entry *ce = NULL;
  zend_string *cls = NULL;
  if (class_name != NULL) {
    cls = zend_string_init(class_name, strlen(class_name), 0);
    ce = zend_lookup_class(cls);
    zend_string_release(cls);
  }
  zend_throw_exception(ce, msg, (zend_long)code);
}
void vphp_error(int level, char *msg) { php_error(level, "%s", msg); }
#define VPHP_MAGIC 0x56504850
#include <stdbool.h>

static HashTable vphp_object_registry;
static HashTable vphp_reverse_registry;
static bool vphp_registry_initialized = false;
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
ZEND_TLS vphp_autorelease_pool_t vphp_autorelease_pool = {NULL, 0, 0};
ZEND_TLS vphp_owned_pool_t vphp_owned_pool = {NULL, 0, 0};

static bool vphp_owned_contains(zval *z) {
  if (z == NULL) {
    return false;
  }
  for (int i = vphp_owned_pool.len - 1; i >= 0; i--) {
    if (vphp_owned_pool.items[i] == z) {
      return true;
    }
  }
  return false;
}

static void vphp_owned_add(zval *z) {
  if (z == NULL || vphp_owned_contains(z)) {
    return;
  }
  if (vphp_owned_pool.len >= vphp_owned_pool.cap) {
    int new_cap = vphp_owned_pool.cap == 0 ? 64 : vphp_owned_pool.cap * 2;
    size_t bytes = (size_t)new_cap * sizeof(zval *);
    if (vphp_owned_pool.items == NULL) {
      vphp_owned_pool.items = (zval **)pemalloc(bytes, 1);
    } else {
      vphp_owned_pool.items =
          (zval **)perealloc(vphp_owned_pool.items, bytes, 1);
    }
    if (vphp_owned_pool.items == NULL) {
      vphp_owned_pool.cap = 0;
      vphp_owned_pool.len = 0;
      return;
    }
    vphp_owned_pool.cap = new_cap;
  }
  vphp_owned_pool.items[vphp_owned_pool.len++] = z;
}

static bool vphp_owned_remove(zval *z) {
  if (z == NULL || vphp_owned_pool.len == 0) {
    return false;
  }
  for (int i = vphp_owned_pool.len - 1; i >= 0; i--) {
    if (vphp_owned_pool.items[i] == z) {
      vphp_owned_pool.items[i] = vphp_owned_pool.items[vphp_owned_pool.len - 1];
      vphp_owned_pool.items[vphp_owned_pool.len - 1] = NULL;
      vphp_owned_pool.len--;
      return true;
    }
  }
  return false;
}
void vphp_init_registry() {
  if (!vphp_registry_initialized) {
    zend_hash_init(&vphp_object_registry, 16, NULL, NULL, 1);
    zend_hash_init(&vphp_reverse_registry, 16, NULL, NULL, 1);
    vphp_registry_initialized = true;
  }
}
void vphp_shutdown_registry() {
  if (vphp_registry_initialized) {
    zend_hash_destroy(&vphp_object_registry);
    zend_hash_destroy(&vphp_reverse_registry);
    vphp_registry_initialized = false;
  }
}
void vphp_register_object(void *v_ptr, zend_object *obj) {
  vphp_init_registry();
  if (v_ptr == NULL || obj == NULL) {
    return;
  }
  zend_hash_index_update_ptr(&vphp_object_registry, (zend_ulong)v_ptr, obj);
  zend_hash_index_update_ptr(&vphp_reverse_registry, (zend_ulong)obj, v_ptr);
}
vphp_object_wrapper *vphp_obj_from_obj(zend_object *obj) {
  vphp_object_wrapper *wrapper =
      (vphp_object_wrapper *)((char *)(obj)-offsetof(vphp_object_wrapper, std));
  if (vphp_registry_initialized && obj != NULL) {
    void *rev_ptr =
        zend_hash_index_find_ptr(&vphp_reverse_registry, (zend_ulong)obj);
    if (rev_ptr != NULL) {
      if (wrapper->v_ptr != rev_ptr) {
        wrapper->v_ptr = rev_ptr;
      }
    } else if (wrapper->v_ptr != NULL) {
      zend_object *mapped =
          zend_hash_index_find_ptr(&vphp_object_registry, (zend_ulong)wrapper->v_ptr);
      if (mapped == obj) {
        zend_hash_index_update_ptr(&vphp_reverse_registry, (zend_ulong)obj,
                                   wrapper->v_ptr);
      }
    }
  }
  return wrapper;
}
void vphp_return_obj(zval *return_value, void *v_ptr, zend_class_entry *ce) {
  if (!v_ptr) {
    ZVAL_NULL(return_value);
    return;
  }
  vphp_init_registry();
  zend_object *existing_obj =
      zend_hash_index_find_ptr(&vphp_object_registry, (zend_ulong)v_ptr);
  if (existing_obj) {
    if (!ce || existing_obj->ce == ce) {
      GC_ADDREF(existing_obj);
      ZVAL_OBJ(return_value, existing_obj);
      return;
    }
    zend_hash_index_del(&vphp_object_registry, (zend_ulong)v_ptr);
  }
  object_init_ex(return_value, ce);
  zend_object *new_obj = Z_OBJ_P(return_value);
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(new_obj);
  wrapper->v_ptr = v_ptr;
  vphp_register_object(v_ptr, new_obj);
}
zend_object *vphp_get_obj_from_zval(zval *zv) { return Z_OBJ_P(zv); }
long vphp_get_lval(zval *z) { return Z_LVAL_P(z); }
void vphp_set_lval(zval *z, long val) { ZVAL_LONG(z, val); }
char *vphp_get_strval(zval *z) { return Z_STRVAL_P(z); }
int vphp_get_strlen(zval *z) { return Z_STRLEN_P(z); }
int vphp_get_type(zval *z) { return Z_TYPE_P(z); }
const char *vphp_get_string_ptr(zval *z, int *len) {
  if (z && Z_TYPE_P(z) == IS_STRING) {
    *len = Z_STRLEN_P(z);
    return Z_STRVAL_P(z);
  }
  *len = 0;
  return "";
}
void vphp_set_strval(zval *z, char *str, int len) { ZVAL_STRINGL(z, str, len); }
void vphp_set_bool(zval *z, bool val) {
  if (val)
    ZVAL_TRUE(z);
  else
    ZVAL_FALSE(z);
}
int vphp_array_count(zval *z) {
  return (z && Z_TYPE_P(z) == IS_ARRAY) ? zend_hash_num_elements(Z_ARRVAL_P(z))
                                        : 0;
}
bool vphp_is_null(zval *z) {
  return z == NULL || Z_TYPE_P(z) == IS_NULL || Z_TYPE_P(z) == IS_UNDEF;
}
void vphp_object_init(zval *z) { object_init(z); }
void vphp_update_property_string(zval *obj, const char *name, int name_len,
                                 const char *value) {
  add_property_stringl(obj, name, value, strlen(value));
}
void vphp_add_property_double(zval *obj, const char *name, double val) {
  add_property_double(obj, name, val);
}
long vphp_get_int(zval *z) {
  if (!z)
    return 0;
  if (Z_TYPE_P(z) == IS_LONG)
    return Z_LVAL_P(z);
  return 0;
}
int le_vphp_res;
void vphp_res_dtor(zend_resource *res) {
  if (res == NULL) {
    return;
  }
  vphp_res_t *wrapper = (vphp_res_t *)res->ptr;
  if (wrapper != NULL) {
    if (wrapper->label != NULL && strcmp(wrapper->label, "v_task") == 0 &&
        wrapper->ptr != NULL) {
      efree(wrapper->ptr);
      wrapper->ptr = NULL;
    }
    if (wrapper->label != NULL) {
      efree(wrapper->label);
      wrapper->label = NULL;
    }
    efree(wrapper);
    res->ptr = NULL;
  }
}
void vphp_init_resource_system(int module_number) {
  le_vphp_res = zend_register_list_destructors_ex(
      vphp_res_dtor, NULL, "VPHP Generic Resource", module_number);
}
void vphp_make_res(zval *return_value, void *ptr, const char *label) {
  if (!ptr) {
    RETVAL_NULL();
    return;
  }
  vphp_res_t *wrapper = emalloc(sizeof(vphp_res_t));
  wrapper->ptr = ptr;
  wrapper->label = estrdup(label != NULL ? label : "");
  RETVAL_RES(zend_register_resource(wrapper, le_vphp_res));
}
void *vphp_fetch_res(zval *z) {
  vphp_res_t *wrapper = (vphp_res_t *)zend_fetch_resource(
      Z_RES_P(z), "VPHP Generic Resource", le_vphp_res);
  return wrapper ? wrapper->ptr : NULL;
}
zval *vphp_array_get_index(zval *z, uint32_t index) {
  return (z && Z_TYPE_P(z) == IS_ARRAY)
             ? zend_hash_index_find(Z_ARRVAL_P(z), index)
             : NULL;
}
zval *vphp_array_get_key(zval *array, const char *key, int key_len) {
  return (array && Z_TYPE_P(array) == IS_ARRAY)
             ? zend_hash_str_find(Z_ARRVAL_P(array), key, key_len)
             : NULL;
}
void vphp_array_add_next_zval(zval *main_array, zval *sub_item) {
  add_next_index_zval(main_array, sub_item);
}
void vphp_return_array_start(zval *return_value) { array_init(return_value); }
void vphp_zval_foreach(zval *z, void *ctx,
                       void (*callback)(void *, zval *, zval *)) {
  if (!z) {
    return;
  }

  if (Z_TYPE_P(z) == IS_ARRAY) {
    HashTable *ht = Z_ARRVAL_P(z);
    zend_string *key;
    zend_ulong index;
    zval *val;
    ZEND_HASH_FOREACH_KEY_VAL(ht, index, key, val) {
      zval key_zv;
      if (key) {
        ZVAL_STR(&key_zv, key);
      } else {
        ZVAL_LONG(&key_zv, index);
      }
      callback(ctx, &key_zv, val);
    }
    ZEND_HASH_FOREACH_END();
    return;
  }

  if (Z_TYPE_P(z) == IS_OBJECT) {
    zend_class_entry *ce = Z_OBJCE_P(z);

    if (ce && ce->get_iterator) {
      zend_object_iterator *iter = ce->get_iterator(ce, z, 0);
      if (iter) {
        if (iter->funcs->rewind) {
          iter->funcs->rewind(iter);
        }
        while (iter->funcs->valid(iter) == SUCCESS) {
          zval key_zv;
          zval *val = iter->funcs->get_current_data(iter);
          if (iter->funcs->get_current_key) {
            iter->funcs->get_current_key(iter, &key_zv);
          } else {
            ZVAL_LONG(&key_zv, iter->index);
          }
          callback(ctx, &key_zv, val);
          zval_ptr_dtor(&key_zv);
          iter->funcs->move_forward(iter);
        }
        zend_iterator_dtor(iter);
        return;
      }
    }

    HashTable *ht = Z_OBJPROP_P(z);
    zend_string *key;
    zend_ulong index;
    zval *val;
    ZEND_HASH_FOREACH_KEY_VAL(ht, index, key, val) {
      zval key_zv;
      if (key) {
        ZVAL_STR(&key_zv, key);
      } else {
        ZVAL_LONG(&key_zv, index);
      }
      callback(ctx, &key_zv, val);
    }
    ZEND_HASH_FOREACH_END();
  }
}
void vphp_array_init(zval *z) { array_init(z); }
void vphp_array_push_string(zval *z, const char *val) {
  add_next_index_string(z, val);
}
void vphp_array_push_double(zval *z, double val) {
  add_next_index_double(z, val);
}
void vphp_array_push_long(zval *z, long val) { add_next_index_long(z, val); }
void vphp_array_add_assoc_long(zval *return_value, const char *key, long val) {
  add_assoc_long(return_value, key, val);
}
void vphp_array_add_assoc_bool(zval *return_value, const char *key, int val) {
  add_assoc_bool(return_value, key, val);
}
void vphp_array_add_assoc_double(zval *return_value, const char *key,
                                 double val) {
  add_assoc_double(return_value, key, val);
}
void vphp_array_add_assoc_string(zval *z, const char *key, const char *val) {
  add_assoc_string(z, key, val);
}
void vphp_array_add_assoc_zval(zval *z, const char *key, zval *val) {
  add_assoc_zval(z, key, val);
}
zval *vphp_new_zval() {
  zval *z = (zval *)emalloc(sizeof(zval));
  if (z == NULL) {
    return NULL;
  }
  ZVAL_UNDEF(z);
  vphp_owned_add(z);
  return z;
}
void vphp_release_zval(zval *z) {
  if (!z) {
    return;
  }
  if (!vphp_owned_remove(z)) {
    return;
  }
  zval_ptr_dtor(z);
  efree(z);
}
int vphp_autorelease_mark(void) { return vphp_autorelease_pool.len; }
void vphp_autorelease_add(zval *z) {
  if (z == NULL) {
    return;
  }
  if (!vphp_owned_contains(z)) {
    return;
  }
  for (int i = vphp_autorelease_pool.len - 1; i >= 0; i--) {
    if (vphp_autorelease_pool.items[i] == z) {
      return;
    }
  }
  if (vphp_autorelease_pool.len >= vphp_autorelease_pool.cap) {
    int new_cap = vphp_autorelease_pool.cap == 0 ? 32 : vphp_autorelease_pool.cap * 2;
    size_t bytes = (size_t)new_cap * sizeof(zval *);
    if (vphp_autorelease_pool.items == NULL) {
      vphp_autorelease_pool.items = (zval **)pemalloc(bytes, 1);
    } else {
      vphp_autorelease_pool.items =
          (zval **)perealloc(vphp_autorelease_pool.items, bytes, 1);
    }
    if (vphp_autorelease_pool.items == NULL) {
      vphp_autorelease_pool.cap = 0;
      vphp_autorelease_pool.len = 0;
      return;
    }
    vphp_autorelease_pool.cap = new_cap;
  }
  vphp_autorelease_pool.items[vphp_autorelease_pool.len++] = z;
}
void vphp_autorelease_forget(zval *z) {
  if (z == NULL || vphp_autorelease_pool.len == 0) {
    return;
  }
  for (int i = vphp_autorelease_pool.len - 1; i >= 0; i--) {
    if (vphp_autorelease_pool.items[i] == z) {
      vphp_autorelease_pool.items[i] = NULL;
    }
  }
}
void vphp_autorelease_drain(int mark) {
  if (mark < 0 || mark > vphp_autorelease_pool.len) {
    return;
  }
  for (int i = vphp_autorelease_pool.len - 1; i >= mark; i--) {
    zval *z = vphp_autorelease_pool.items[i];
    if (z != NULL) {
      vphp_release_zval(z);
    }
  }
  vphp_autorelease_pool.len = mark;
}
void vphp_runtime_counters(int *autorelease_len, int *owned_len,
                           unsigned int *obj_registry_len,
                           unsigned int *rev_registry_len) {
  if (autorelease_len != NULL) {
    *autorelease_len = vphp_autorelease_pool.len;
  }
  if (owned_len != NULL) {
    *owned_len = vphp_owned_pool.len;
  }
  if (obj_registry_len != NULL) {
    *obj_registry_len =
        vphp_registry_initialized ? zend_hash_num_elements(&vphp_object_registry) : 0;
  }
  if (rev_registry_len != NULL) {
    *rev_registry_len =
        vphp_registry_initialized ? zend_hash_num_elements(&vphp_reverse_registry) : 0;
  }
}
void vphp_request_startup(void) {
  // Request scope is lazily managed by per-call marks.
  // Keep this hook for explicit request-lifecycle integration.
}
void vphp_request_shutdown(void) {
  // Drain all request-scoped autorelease values.
  // Persistent owned values are intentionally kept alive.
  vphp_autorelease_drain(0);
}
void vphp_autorelease_shutdown(void) {
  uint32_t obj_reg = 0;
  uint32_t rev_reg = 0;
  if (vphp_registry_initialized) {
    obj_reg = zend_hash_num_elements(&vphp_object_registry);
    rev_reg = zend_hash_num_elements(&vphp_reverse_registry);
  }
  fprintf(stderr,
          "[vphp] autorelease_shutdown autorelease_len=%d autorelease_cap=%d owned_len=%d owned_cap=%d obj_registry=%u rev_registry=%u\n",
          vphp_autorelease_pool.len, vphp_autorelease_pool.cap, vphp_owned_pool.len,
          vphp_owned_pool.cap, obj_reg, rev_reg);
  for (int i = 0; i < vphp_owned_pool.len; i++) {
    zval *z = vphp_owned_pool.items[i];
    if (z == NULL) {
      continue;
    }
    fprintf(stderr, "[vphp] owned[%d]=%p type=%d\n", i, (void *)z, Z_TYPE_P(z));
  }
  /*
   * Module shutdown can happen after exception/abort paths where foreign
   * pointers may still be present in the autorelease list. We only drop the
   * container here and rely on per-call drain for actual zval destruction.
   */
  if (vphp_autorelease_pool.items != NULL) {
    pefree(vphp_autorelease_pool.items, 1);
    vphp_autorelease_pool.items = NULL;
  }
  vphp_autorelease_pool.cap = 0;
  vphp_autorelease_pool.len = 0;
  if (vphp_owned_pool.items != NULL) {
    pefree(vphp_owned_pool.items, 1);
    vphp_owned_pool.items = NULL;
  }
  vphp_owned_pool.cap = 0;
  vphp_owned_pool.len = 0;
}
double vphp_get_double(zval *z) {
  if (!z)
    return 0.0;
  if (Z_TYPE_P(z) == IS_DOUBLE)
    return Z_DVAL_P(z);
  if (Z_TYPE_P(z) == IS_LONG)
    return (double)Z_LVAL_P(z);
  return 0.0;
}
void vphp_set_double(zval *z, double val) { ZVAL_DOUBLE(z, val); }
void vphp_set_null(zval *z) { ZVAL_NULL(z); }
void vphp_convert_to_string(zval *z) {
  if (z && Z_TYPE_P(z) != IS_STRING)
    convert_to_string(z);
}
zval *vphp_new_str(const char *s) {
  zval *z = vphp_new_zval();
  ZVAL_STRING(z, s);
  return z;
}
static zend_class_entry *vphp_lookup_class_by_name(const char *class_name,
                                                   int class_name_len) {
  zend_string *zs = zend_string_init(class_name, class_name_len, 0);
  zend_class_entry *ce = zend_lookup_class(zs);
  zend_string_release(zs);
  return ce;
}
static zend_class_entry *vphp_get_ce_from_zval(zval *zv) {
  if (!zv) {
    return NULL;
  }
  if (Z_TYPE_P(zv) == IS_OBJECT) {
    return Z_OBJCE_P(zv);
  }
  if (Z_TYPE_P(zv) == IS_STRING) {
    return vphp_lookup_class_by_name(Z_STRVAL_P(zv), Z_STRLEN_P(zv));
  }
  return NULL;
}
int vphp_call_php_func(const char *name, int name_len, zval *retval,
                       int param_count, zval **params_ptrs) {
  zval func_name;
  ZVAL_STRINGL(&func_name, name, name_len);
  zval *params = NULL;
  if (param_count > 0) {
    params = (zval *)safe_emalloc(param_count, sizeof(zval), 0);
    for (int i = 0; i < param_count; i++) {
      if (params_ptrs[i])
        ZVAL_COPY(&params[i], params_ptrs[i]);
      else
        ZVAL_NULL(&params[i]);
    }
  }
  int result = call_user_function(EG(function_table), NULL, &func_name, retval,
                                  param_count, params);
  zval_ptr_dtor(&func_name);
  if (params) {
    for (int i = 0; i < param_count; i++) {
      zval_ptr_dtor(&params[i]);
    }
    efree(params);
  }
  return result;
}
int vphp_call_static_method(const char *class_name, int class_name_len,
                            const char *method, int method_len, zval *retval,
                            int param_count, zval **params_ptrs) {
  zend_string *callable =
      zend_strpprintf(0, "%.*s::%.*s", class_name_len, class_name, method_len,
                      method);
  zval callable_zv;
  ZVAL_STR(&callable_zv, callable);
  int result =
      vphp_call_callable(&callable_zv, retval, param_count, params_ptrs);
  zval_ptr_dtor(&callable_zv);
  return result;
}
int vphp_new_instance(const char *class_name, int class_name_len, zval *retval,
                      int param_count, zval **params_ptrs) {
  zend_class_entry *ce = vphp_lookup_class_by_name(class_name, class_name_len);
  if (!ce)
    return -1;

  object_init_ex(retval, ce);
  if (!ce->constructor) {
    return param_count == 0 ? SUCCESS : -1;
  }

  zval ctor_name;
  ZVAL_STRINGL(&ctor_name, "__construct", sizeof("__construct") - 1);
  zval *params = NULL;
  if (param_count > 0) {
    params = (zval *)safe_emalloc(param_count, sizeof(zval), 0);
    for (int i = 0; i < param_count; i++) {
      if (params_ptrs[i])
        ZVAL_COPY(&params[i], params_ptrs[i]);
      else
        ZVAL_NULL(&params[i]);
    }
  }
  zval ctor_retval;
  ZVAL_UNDEF(&ctor_retval);
  int result = call_user_function(EG(function_table), retval, &ctor_name,
                                  &ctor_retval, param_count, params);
  zval_ptr_dtor(&ctor_name);
  zval_ptr_dtor(&ctor_retval);
  if (params) {
    for (int i = 0; i < param_count; i++) {
      zval_ptr_dtor(&params[i]);
    }
    efree(params);
  }
  return result;
}
int vphp_include_file(const char *filename, int filename_len, zval *retval,
                      int once) {
  zend_file_handle file_handle;
  zend_string *filename_str = zend_string_init(filename, filename_len, 0);
  zend_string *resolved_path = zend_resolve_path(filename_str);
  zend_string_release(filename_str);
  if (once && resolved_path &&
      zend_hash_exists(&EG(included_files), resolved_path)) {
    ZVAL_TRUE(retval);
    zend_string_release(resolved_path);
    return SUCCESS;
  }
  zend_stream_init_filename(&file_handle, filename);
  file_handle.primary_script = 0;
  if (resolved_path) {
    file_handle.opened_path = resolved_path;
  }
  ZVAL_UNDEF(retval);
  return zend_execute_scripts(once ? ZEND_INCLUDE_ONCE : ZEND_INCLUDE, retval, 1,
                              &file_handle);
}
bool vphp_has_exception() { return EG(exception) != NULL; }
int vphp_call_method(zval *obj, const char *method, int method_len,
                     zval *retval, int param_count, zval **params_ptrs) {
  if (!obj || Z_TYPE_P(obj) != IS_OBJECT)
    return -1;
  zval method_name;
  ZVAL_STRINGL(&method_name, method, method_len);
  ZVAL_UNDEF(retval);
  zval *params = NULL;
  if (param_count > 0) {
    params = (zval *)safe_emalloc(param_count, sizeof(zval), 0);
    for (int i = 0; i < param_count; i++) {
      if (params_ptrs[i])
        ZVAL_COPY(&params[i], params_ptrs[i]);
      else
        ZVAL_NULL(&params[i]);
    }
  }
  int result = call_user_function(EG(function_table), obj, &method_name, retval,
                                  param_count, params);
  zval_ptr_dtor(&method_name);
  if (params) {
    for (int i = 0; i < param_count; i++) {
      zval_ptr_dtor(&params[i]);
    }
    efree(params);
  }
  return result;
}
int vphp_is_callable(zval *callable) {
  return callable ? zend_is_callable(callable, 0, NULL) : 0;
}
const char *vphp_get_object_class_name(zval *zv, int *len) {
  zend_class_entry *ce = vphp_get_ce_from_zval(zv);
  if (!ce) {
    *len = 0;
    return "";
  }
  *len = ZSTR_LEN(ce->name);
  return ZSTR_VAL(ce->name);
}
const char *vphp_get_parent_class_name(zval *zv, int *len) {
  zend_class_entry *ce = vphp_get_ce_from_zval(zv);
  if (!ce || !ce->parent) {
    *len = 0;
    return "";
  }
  *len = ZSTR_LEN(ce->parent->name);
  return ZSTR_VAL(ce->parent->name);
}
int vphp_class_is_internal(zval *zv) {
  zend_class_entry *ce = vphp_get_ce_from_zval(zv);
  if (!ce) {
    return 0;
  }
  return (ce->type == ZEND_INTERNAL_CLASS) ? 1 : 0;
}
int vphp_call_callable(zval *callable, zval *retval, int param_count,
                       zval **params_ptrs) {
  if (!callable || !zend_is_callable(callable, 0, NULL))
    return -1;
  ZVAL_UNDEF(retval);
  zval *params = NULL;
  if (param_count > 0) {
    params = (zval *)safe_emalloc(param_count, sizeof(zval), 0);
    for (int i = 0; i < param_count; i++) {
      if (params_ptrs[i])
        ZVAL_COPY(&params[i], params_ptrs[i]);
      else
        ZVAL_NULL(&params[i]);
    }
  }
  int result = call_user_function(EG(function_table), NULL, callable, retval,
                                  param_count, params);
  if (params) {
    for (int i = 0; i < param_count; i++) {
      zval_ptr_dtor(&params[i]);
    }
    efree(params);
  }
  return result;
}
void vphp_array_foreach(zval *z, void *ctx, void (*callback)(void *, zval *)) {
  if (z && Z_TYPE_P(z) == IS_ARRAY) {
    zval *val;
    ZEND_HASH_FOREACH_VAL(Z_ARRVAL_P(z), val) { callback(ctx, val); }
    ZEND_HASH_FOREACH_END();
  }
}
zend_object_handlers vphp_obj_handlers;
void vphp_free_object_handler(zend_object *obj) {
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(obj);
  void *owned_v_ptr = NULL;
  void (*free_raw)(void *) = NULL;
  int owns_v_ptr = 0;
  if (wrapper) {
    owned_v_ptr = wrapper->v_ptr;
    free_raw = wrapper->free_raw;
    owns_v_ptr = wrapper->owns_v_ptr;
  }
  if (vphp_registry_initialized && obj) {
    void *mapped_v_ptr =
        zend_hash_index_find_ptr(&vphp_reverse_registry, (zend_ulong)obj);
    if (mapped_v_ptr) {
      zend_object *mapped = zend_hash_index_find_ptr(
          &vphp_object_registry, (zend_ulong)mapped_v_ptr);
      if (mapped == obj) {
        zend_hash_index_del(&vphp_object_registry, (zend_ulong)mapped_v_ptr);
      }
      zend_hash_index_del(&vphp_reverse_registry, (zend_ulong)obj);
    }
  }
  if (vphp_registry_initialized && wrapper && wrapper->v_ptr) {
    zend_object *mapped = zend_hash_index_find_ptr(
        &vphp_object_registry, (zend_ulong)wrapper->v_ptr);
    if (mapped == obj) {
      zend_hash_index_del(&vphp_object_registry, (zend_ulong)wrapper->v_ptr);
    }
  }
  if (owns_v_ptr && owned_v_ptr && free_raw) {
    free_raw(owned_v_ptr);
  }
  if (wrapper) {
    wrapper->v_ptr = NULL;
    wrapper->owns_v_ptr = 0;
    wrapper->cleanup_raw = NULL;
    wrapper->free_raw = NULL;
  }
  zend_object_std_dtor(obj);
}

zval *vphp_read_property(zend_object *object, zend_string *member, int type,
                         void **cache_slot, zval *rv) {
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(object);
  if (wrapper->v_ptr && wrapper->prop_handler) {
    ZVAL_UNDEF(rv);
    wrapper->prop_handler(wrapper->v_ptr, ZSTR_VAL(member),
                          (int)ZSTR_LEN(member), rv);
    if (Z_TYPE_P(rv) != IS_UNDEF)
      return rv;
  }
  return zend_get_std_object_handlers()->read_property(object, member, type,
                                                       cache_slot, rv);
}
zval *vphp_read_property_compat(zend_object *obj, const char *name,
                                int name_len, zval *rv) {
  zend_string *member = zend_string_init(name, name_len, 0);
  zval *out = zend_get_std_object_handlers()->read_property(obj, member, BP_VAR_R,
                                                            NULL, rv);
  zend_string_release(member);
  return out;
}
void vphp_write_property_compat(zend_object *obj, const char *name, int name_len,
                                zval *value) {
  zend_string *member = zend_string_init(name, name_len, 0);
  zend_get_std_object_handlers()->write_property(obj, member, value, NULL);
  zend_string_release(member);
}
zval *vphp_read_static_property_compat(const char *class_name, int class_name_len,
                                       const char *name, int name_len, zval *rv) {
  zend_class_entry *ce = vphp_lookup_class_by_name(class_name, class_name_len);
  if (!ce) {
    ZVAL_NULL(rv);
    return rv;
  }
  zval *prop = zend_read_static_property(ce, name, name_len, 1);
  if (!prop) {
    ZVAL_NULL(rv);
    return rv;
  }
  ZVAL_COPY(rv, prop);
  return rv;
}
int vphp_write_static_property_compat(const char *class_name, int class_name_len,
                                      const char *name, int name_len, zval *value) {
  zend_class_entry *ce = vphp_lookup_class_by_name(class_name, class_name_len);
  if (!ce)
    return -1;
  zend_update_static_property(ce, name, name_len, value);
  return 0;
}
zval *vphp_read_class_constant_compat(const char *class_name, int class_name_len,
                                      const char *name, int name_len, zval *rv) {
  zend_string *class_name_str = zend_string_init(class_name, class_name_len, 0);
  zend_string *const_name_str = zend_string_init(name, name_len, 0);
  zval *constant =
      zend_get_class_constant_ex(class_name_str, const_name_str, NULL, 0);
  zend_string_release(class_name_str);
  zend_string_release(const_name_str);
  if (!constant) {
    ZVAL_NULL(rv);
    return rv;
  }
  ZVAL_COPY(rv, constant);
  return rv;
}
int vphp_has_property_compat(zend_object *obj, const char *name, int name_len) {
  zend_string *member = zend_string_init(name, name_len, 0);
  int out = zend_get_std_object_handlers()->has_property(
      obj, member, ZEND_PROPERTY_EXISTS, NULL);
  zend_string_release(member);
  return out;
}
int vphp_isset_property_compat(zend_object *obj, const char *name, int name_len) {
  zend_string *member = zend_string_init(name, name_len, 0);
  int out = zend_get_std_object_handlers()->has_property(
      obj, member, ZEND_PROPERTY_ISSET, NULL);
  zend_string_release(member);
  return out;
}
void vphp_unset_property_compat(zend_object *obj, const char *name, int name_len) {
  zend_string *member = zend_string_init(name, name_len, 0);
  zend_get_std_object_handlers()->unset_property(obj, member, NULL);
  zend_string_release(member);
}
void vphp_write_property(zend_object *object, zend_string *member, zval *value,
                         void **cache_slot) {
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(object);
  zend_property_info *prop_info =
      zend_get_property_info(object->ce, member, /* silent */ true);
  if (prop_info && prop_info != ZEND_WRONG_PROPERTY_INFO &&
      (prop_info->flags & ZEND_ACC_READONLY)) {
    zend_readonly_property_modification_error_ex(
        ZSTR_VAL(object->ce->name), ZSTR_VAL(member));
    return;
  }
  if (wrapper->v_ptr && wrapper->write_handler)
    wrapper->write_handler(wrapper->v_ptr, ZSTR_VAL(member),
                           (int)ZSTR_LEN(member), value);
  zend_get_std_object_handlers()->write_property(object, member, value,
                                                 cache_slot);
}
HashTable *vphp_get_properties(zend_object *object) {
  HashTable *props = zend_std_get_properties(object);
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(object);
  if (wrapper->v_ptr && wrapper->sync_handler) {
    zval obj_zv;
    ZVAL_OBJ(&obj_zv, object);
    wrapper->sync_handler(wrapper->v_ptr, &obj_zv);
  }
  return props;
}
void vphp_init_handlers() {
  memcpy(&vphp_obj_handlers, zend_get_std_object_handlers(),
         sizeof(zend_object_handlers));
  vphp_obj_handlers.offset = offsetof(vphp_object_wrapper, std);
  vphp_obj_handlers.free_obj = vphp_free_object_handler;
  vphp_obj_handlers.read_property = vphp_read_property;
  vphp_obj_handlers.get_properties = vphp_get_properties;
  vphp_obj_handlers.write_property = vphp_write_property;
}
zend_object *vphp_create_object_handler(zend_class_entry *ce) {
  if (vphp_obj_handlers.read_property == NULL)
    vphp_init_handlers();
  vphp_object_wrapper *obj = zend_object_alloc(sizeof(vphp_object_wrapper), ce);
  obj->magic = VPHP_MAGIC;
  obj->v_ptr = NULL;
  obj->owns_v_ptr = 0;
  obj->cleanup_raw = NULL;
  obj->free_raw = NULL;
  zend_object_std_init(&obj->std, ce);
  object_properties_init(&obj->std, ce);
  obj->std.handlers = &vphp_obj_handlers;
  return &obj->std;
}
void vphp_bind_handlers_with_ownership(zend_object *obj, vphp_class_handlers *h,
                                       int owns_v_ptr) {
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(obj);
  wrapper->owns_v_ptr = owns_v_ptr ? 1 : 0;
  wrapper->cleanup_raw = h->cleanup_raw;
  wrapper->free_raw = h->free_raw;
  if (h->v_ptr) {
    wrapper->v_ptr = h->v_ptr;
    vphp_register_object(h->v_ptr, obj);
  }
  wrapper->prop_handler = h->prop_handler;
  wrapper->write_handler = h->write_handler;
  wrapper->sync_handler = h->sync_handler;
}
void vphp_bind_handlers(zend_object *obj, vphp_class_handlers *h) {
  vphp_bind_handlers_with_ownership(obj, h, 1);
}
void *vphp_get_this_object(zend_execute_data *execute_data) {
  zval *this_obj = getThis();
  return this_obj ? (void *)Z_OBJ_P(this_obj) : NULL;
}
void *vphp_get_v_ptr_from_zval(zval *zv) {
  if (!zv || Z_TYPE_P(zv) != IS_OBJECT)
    return NULL;
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(zv));
  return wrapper ? wrapper->v_ptr : NULL;
}
void *vphp_get_active_ce(zend_execute_data *ex) {
  if (ex && ex->func && ex->func->common.scope)
    return (void *)ex->func->common.scope;
  return NULL;
}
void vphp_update_static_property_long(zend_class_entry *ce, char *name,
                                      int name_len, long val) {
  zend_update_static_property_long(ce, name, name_len, val);
}
void vphp_update_static_property_string(zend_class_entry *ce, char *name,
                                        int name_len, char *val, int val_len) {
  zend_update_static_property_stringl(ce, name, name_len, val, val_len);
}
void vphp_update_static_property_bool(zend_class_entry *ce, char *name,
                                      int name_len, int val) {
  zend_update_static_property_bool(ce, name, name_len, val);
}
long vphp_get_static_property_long(zend_class_entry *ce, char *name,
                                   int name_len) {
  zval *rv = zend_read_static_property(ce, name, name_len, 1);
  return rv ? zval_get_long(rv) : 0;
}
char *vphp_get_static_property_string(zend_class_entry *ce, char *name,
                                      int name_len) {
  zval *rv = zend_read_static_property(ce, name, name_len, 1);
  if (rv) {
    zend_string *s = zval_get_string(rv);
    return ZSTR_VAL(s);
  }
  return "";
}
int vphp_get_static_property_bool(zend_class_entry *ce, char *name,
                                  int name_len) {
  zval *rv = zend_read_static_property(ce, name, name_len, 1);
  return rv ? zval_is_true(rv) : 0;
}
char *VPHP_Z_STRVAL(zval *z) { return Z_STRVAL_P(z); }
int VPHP_Z_STRLEN(zval *z) { return Z_STRLEN_P(z); }

static void vphp_closure_handler(zend_execute_data *execute_data,
                                 zval *return_value) {
  zend_internal_function *zf = (zend_internal_function *)execute_data->func;
  // 使用 PHP 预留字段传递上下文，避免复制时截断
  void *v_thunk = zf->reserved[0];
  void *bridge_ptr = zf->reserved[1];

  if (bridge_ptr) {
    void (*bridge)(void *, zend_execute_data *, zval *) =
        (void (*)(void *, zend_execute_data *, zval *))bridge_ptr;
    bridge(v_thunk, execute_data, return_value);
  }
}

void vphp_create_closure_FULL_AUTO_V2(zval *zv, void *v_thunk,
                                      void *bridge_ptr) {
  zend_internal_function *zf =
      (zend_internal_function *)pecalloc(1, sizeof(zend_internal_function), 1);
  zf->type = ZEND_INTERNAL_FUNCTION;
  zf->handler = vphp_closure_handler;
  zf->fn_flags = ZEND_ACC_CLOSURE | ZEND_ACC_PUBLIC;
  zf->function_name = zend_string_init("VPHPClosure", 11, 1);
  zf->num_args = 0;
  zf->required_num_args = 0;
  zf->arg_info = NULL;

  // 关键：存入预留槽位
  zf->reserved[0] = v_thunk;
  zf->reserved[1] = bridge_ptr;

  zend_create_closure(zv, (zend_function *)zf, NULL, NULL, NULL);

  // 注意：zend_create_closure 会拷贝 zf，但在持久化环境中，原本的 zf
  // 往往需要手动管理， 这里暂时保持 pecalloc，实际可能需要注册到 cleanup
}
