#ifndef VPHP_V_BRIDGE_H
#define VPHP_V_BRIDGE_H

#include <php.h>
#include <stdbool.h>

// 兼容 V 0.5 的字符串结构定义，避免与 V 生成的 v_string 冲突
typedef struct vphp_vstring {
  char *str;
  int len;
  int is_lit;
} vphp_vstring;

// 对象包装器
typedef struct {
  uint32_t magic;
  void *v_ptr;
  void (*prop_handler)(void *, char *, int, zval *);
  void (*write_handler)(void *, char *, int, zval *);
  void (*sync_handler)(void *, zval *);
  void (*bind_handler)(void *, zend_object *);
  zend_object std;
} vphp_object_wrapper;

typedef struct {
  void *v_ptr;
  void *prop_handler;
  void *write_handler;
  void *sync_handler;
  void *(*new_raw)();
} vphp_class_handlers;

typedef struct {
  void *ptr;
  char *label;
} vphp_res_t;

// 核心导出
void vphp_res_dtor(zend_resource *res);
void vphp_create_closure_FULL_AUTO_V2(zval *zv, void *v_thunk,
                                      void *bridge_ptr);
vphp_object_wrapper *vphp_obj_from_obj(zend_object *obj);
void vphp_register_object(void *v_ptr, zend_object *obj);
void vphp_return_obj(zval *return_value, void *v_ptr, zend_class_entry *ce);

// 对象与类管理
zend_object *vphp_create_object_handler(zend_class_entry *ce);
void vphp_init_resource_system(int module_number);
HashTable *vphp_get_properties(zend_object *object);
void vphp_bind_handlers(zend_object *obj, vphp_class_handlers *h);

// 穿梭函数 (Shuttle)
void *vphp_shuttle_v_closure_0(void *v_ptr);
void *vphp_shuttle_v_closure_1(void *v_ptr, void *p0);
void *vphp_shuttle_v_closure_2(void *v_ptr, void *p0, void *p1);

// 参数、值与返回 (由 V 侧代码引用)
uint32_t vphp_get_num_args(zend_execute_data *ex);
zval *vphp_get_arg_ptr(zend_execute_data *ex, uint32_t index);
zval *vphp_new_zval(void);
void vphp_array_add_next_zval(zval *main_array, zval *sub_item);
void vphp_throw(char *msg, int code);
void vphp_error(int level, char *msg);
bool vphp_has_exception(void);
void vphp_init_registry(void);
void vphp_shutdown_registry(void);

// 值设置与操作
void vphp_set_null(zval *z);
bool vphp_is_null(zval *z);
void vphp_set_bool(zval *z, bool val);
void vphp_set_double(zval *z, double val);
long vphp_get_lval(zval *z);
void vphp_set_lval(zval *z, long val);
char *vphp_get_strval(zval *z);
int vphp_get_strlen(zval *z);
int vphp_get_type(zval *z);
void vphp_set_strval(zval *z, char *str, int len);
void vphp_convert_to_string(zval *z);
zval *vphp_new_str(const char *s);
void vphp_make_res(zval *return_value, void *ptr, const char *label);
void *vphp_fetch_res(zval *z);
void vphp_object_init(zval *z);
void vphp_update_property_string(zval *obj, const char *name, int name_len,
                                 const char *value);
void vphp_add_property_double(zval *obj, const char *name, double val);

// 数组助手
int vphp_array_count(zval *z);
zval *vphp_array_get_index(zval *z, uint32_t index);
zval *vphp_array_get_key(zval *array, const char *key, int key_len);
void vphp_array_init(zval *z);
void vphp_array_push_string(zval *z, const char *val);
void vphp_array_push_double(zval *z, double val);
void vphp_array_push_long(zval *z, long val);
void vphp_array_add_assoc_long(zval *return_value, const char *key, long val);
void vphp_array_add_assoc_bool(zval *return_value, const char *key, int val);
void vphp_array_add_assoc_double(zval *return_value, const char *key,
                                 double val);
void vphp_array_add_assoc_string(zval *z, const char *key, const char *val);
void vphp_array_add_assoc_zval(zval *z, const char *key, zval *val);
void vphp_array_foreach(zval *z, void *ctx, void (*callback)(void *, zval *));

// 属性与兼容层
zval *vphp_read_property_compat(zend_object *obj, const char *name,
                                int name_len, zval *rv);

// 状态获取
char *VPHP_Z_STRVAL(zval *z);
int VPHP_Z_STRLEN(zval *z);

// 静态属性与 CE
void vphp_update_static_property_long(zend_class_entry *ce, char *name,
                                      int name_len, long val);
void vphp_update_static_property_string(zend_class_entry *ce, char *name,
                                        int name_len, char *val, int val_len);
void vphp_update_static_property_bool(zend_class_entry *ce, char *name,
                                      int name_len, int val);
long vphp_get_static_property_long(zend_class_entry *ce, char *name,
                                   int name_len);
char *vphp_get_static_property_string(zend_class_entry *ce, char *name,
                                      int name_len);
int vphp_get_static_property_bool(zend_class_entry *ce, char *name,
                                  int name_len);
void *vphp_get_active_ce(zend_execute_data *ex);
const char *vphp_get_string_ptr(zval *z, int *len);
long vphp_get_int(zval *z);
double vphp_get_double(zval *z);
zend_object *vphp_get_obj_from_zval(zval *zv);
void *vphp_get_this_object(zend_execute_data *execute_data);
void *vphp_get_v_ptr_from_zval(zval *zv);

// 方法调用与 Callable
int vphp_call_method(zval *obj, const char *method, int method_len,
                     zval *retval, int param_count, zval **params_ptrs);
int vphp_is_callable(zval *callable);
int vphp_call_callable(zval *callable, zval *retval, int param_count,
                       zval **params_ptrs);
int vphp_call_php_func(const char *name, int name_len, zval *retval,
                       int param_count, zval **params_ptrs);

// 数组与通用
void vphp_return_array_start(zval *return_value);
void vphp_zval_foreach(zval *z, void *ctx,
                       void (*callback)(void *, zval *, zval *));

#endif
