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
void vphp_error(int level, char *msg) { php_error(level, "%s", msg); }
#define VPHP_MAGIC 0x56504850
#include <stdbool.h>

static HashTable vphp_object_registry;
static bool vphp_registry_initialized = false;
void vphp_init_registry() {
  if (!vphp_registry_initialized) {
    zend_hash_init(&vphp_object_registry, 16, NULL, NULL, 1);
    vphp_registry_initialized = true;
  }
}
void vphp_shutdown_registry() {
  if (vphp_registry_initialized) {
    zend_hash_destroy(&vphp_object_registry);
    vphp_registry_initialized = false;
  }
}
void vphp_register_object(void *v_ptr, zend_object *obj) {
  vphp_init_registry();
  zend_hash_index_update_ptr(&vphp_object_registry, (zend_ulong)v_ptr, obj);
}
vphp_object_wrapper *vphp_obj_from_obj(zend_object *obj) {
  return (
      vphp_object_wrapper *)((char *)(obj)-offsetof(vphp_object_wrapper, std));
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
    GC_ADDREF(existing_obj);
    ZVAL_OBJ(return_value, existing_obj);
    return;
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
void vphp_res_dtor(zend_resource *res) { /* ... */ }
void vphp_init_resource_system(int module_number) {
  le_vphp_res = zend_register_list_destructors_ex(
      vphp_res_dtor, NULL, "VPHP Generic Resource", module_number);
}
void vphp_make_res(zval *return_value, void *ptr, const char *label) {
  if (!ptr) {
    RETVAL_NULL();
    return;
  }
  vphp_res_t *wrapper = malloc(sizeof(vphp_res_t));
  wrapper->ptr = ptr;
  wrapper->label = (char *)label;
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
  if (z && (Z_TYPE_P(z) == IS_ARRAY || Z_TYPE_P(z) == IS_OBJECT)) {
    HashTable *ht = (Z_TYPE_P(z) == IS_ARRAY) ? Z_ARRVAL_P(z) : Z_OBJPROP_P(z);
    zend_string *key;
    zval *val;
    ZEND_HASH_FOREACH_STR_KEY_VAL(ht, key, val) {
      zval key_zv;
      if (key) {
        ZVAL_STR(&key_zv, key);
      } else {
        ZVAL_NULL(&key_zv);
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
zval *vphp_new_zval() { return (zval *)malloc(sizeof(zval)); }
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
int vphp_call_php_func(const char *name, int name_len, zval *retval,
                       int param_count, zval **params_ptrs) {
  zval func_name;
  ZVAL_STRINGL(&func_name, name, name_len);
  zval *params = NULL;
  if (param_count > 0) {
    params = (zval *)safe_emalloc(param_count, sizeof(zval), 0);
    for (int i = 0; i < param_count; i++) {
      if (params_ptrs[i])
        ZVAL_COPY_VALUE(&params[i], params_ptrs[i]);
      else
        ZVAL_NULL(&params[i]);
    }
  }
  int result = call_user_function(EG(function_table), NULL, &func_name, retval,
                                  param_count, params);
  zval_ptr_dtor(&func_name);
  if (params)
    efree(params);
  return result;
}
int vphp_new_instance(const char *class_name, int class_name_len, zval *retval,
                      int param_count, zval **params_ptrs) {
  zend_string *zs = zend_string_init(class_name, class_name_len, 0);
  zend_class_entry *ce = zend_lookup_class(zs);
  zend_string_release(zs);
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
        ZVAL_COPY_VALUE(&params[i], params_ptrs[i]);
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
  if (params)
    efree(params);
  return result;
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
        ZVAL_COPY_VALUE(&params[i], params_ptrs[i]);
      else
        ZVAL_NULL(&params[i]);
    }
  }
  int result = call_user_function(EG(function_table), obj, &method_name, retval,
                                  param_count, params);
  zval_ptr_dtor(&method_name);
  if (params)
    efree(params);
  return result;
}
int vphp_is_callable(zval *callable) {
  return callable ? zend_is_callable(callable, 0, NULL) : 0;
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
        ZVAL_COPY_VALUE(&params[i], params_ptrs[i]);
      else
        ZVAL_NULL(&params[i]);
    }
  }
  int result = call_user_function(EG(function_table), NULL, callable, retval,
                                  param_count, params);
  if (params)
    efree(params);
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
void vphp_free_object_handler(zend_object *obj) { zend_object_std_dtor(obj); }
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
  return zend_get_std_object_handlers()->read_property(
      obj, zend_string_init(name, name_len, 0), BP_VAR_R, NULL, rv);
}
void vphp_write_property_compat(zend_object *obj, const char *name, int name_len,
                                zval *value) {
  zend_get_std_object_handlers()->write_property(
      obj, zend_string_init(name, name_len, 0), value, NULL);
}
int vphp_has_property_compat(zend_object *obj, const char *name, int name_len) {
  return zend_get_std_object_handlers()->has_property(
      obj, zend_string_init(name, name_len, 0), ZEND_PROPERTY_EXISTS, NULL);
}
int vphp_isset_property_compat(zend_object *obj, const char *name, int name_len) {
  return zend_get_std_object_handlers()->has_property(
      obj, zend_string_init(name, name_len, 0), ZEND_PROPERTY_ISSET, NULL);
}
void vphp_unset_property_compat(zend_object *obj, const char *name, int name_len) {
  zend_get_std_object_handlers()->unset_property(
      obj, zend_string_init(name, name_len, 0), NULL);
}
void vphp_write_property(zend_object *object, zend_string *member, zval *value,
                         void **cache_slot) {
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(object);
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
  zend_object_std_init(&obj->std, ce);
  object_properties_init(&obj->std, ce);
  obj->std.handlers = &vphp_obj_handlers;
  return &obj->std;
}
void vphp_bind_handlers(zend_object *obj, vphp_class_handlers *h) {
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(obj);
  if (h->v_ptr) {
    wrapper->v_ptr = h->v_ptr;
  }
  wrapper->prop_handler = h->prop_handler;
  wrapper->write_handler = h->write_handler;
  wrapper->sync_handler = h->sync_handler;
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
