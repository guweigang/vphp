#ifndef V_BRIDGE_H
#define V_BRIDGE_H

#include <php.h>
#include <Zend/zend_exceptions.h>

// 显式声明所有代理函数，供 GCC 参考
uint32_t vphp_get_num_args(zend_execute_data* ex);
zval* vphp_get_arg_ptr(zend_execute_data* ex, uint32_t index);

void vphp_throw(char* msg, int code);

long vphp_get_lval(zval* z);
void vphp_set_lval(zval* z, long val);

int vphp_get_strlen(zval* z);
char* vphp_get_strval(zval* z);
// 设置 zval 为字符串
void vphp_set_strval(zval* z, char* str, int len);
const char* vphp_get_string_ptr(zval* z, int* len);

// 设置 zval 为布尔值
void vphp_set_bool(zval* z, bool val);

/* --- 数组操作 (HashTable) --- */

// 获取数组元素个数
int vphp_array_count(zval* z);

// 根据索引获取数组中的 zval (用于索引数组)
zval* vphp_array_get_index(zval* z, uint32_t index);

// 初始化一个 PHP 数组 (array_init)
void vphp_array_init(zval* z);

// 往数组里添加关联字符串 (add_assoc_string)
void vphp_array_add_assoc_string(zval* z, const char* key, const char* val);

// 在 vphp_bridge.h 中添加声明
void vphp_array_push_string(zval* z, const char* val);

void vphp_array_each(zval* array, void* ctx, void (*callback)(void*, char*, zval*));

zval* vphp_array_get_key(zval* array, const char* key, int key_len);

int vphp_get_type(zval* z);

void vphp_error(int type, const char* msg);
bool vphp_is_null(zval* z);

void vphp_object_init(zval* z);
void vphp_update_property_string(zval* obj, const char* name, int name_len, const char* value);
void vphp_update_property_long(zval* obj, const char* name, int name_len, long value);

int vphp_call_php_func(const char* name, int name_len, zval* retval, int param_count, zval** params_ptrs);

long vphp_get_int(zval* z);
double vphp_get_double(zval* z);

void vphp_res_dtor(zend_resource *res);
void vphp_init_resource_system(int module_number);
void vphp_make_res(zval* return_value, void* ptr, const char* label);
void* vphp_fetch_res(zval* z);

void vphp_array_foreach(zval* z, void* ctx, void (*callback)(void*, zval*));
zval* vphp_array_get_index(zval *z, uint32_t index);

void vphp_array_add_assoc_double(zval* return_value, const char* key, double val);
void vphp_return_array_start(zval* return_value);
void vphp_array_add_assoc_long(zval* return_value, const char* key, long val);
void vphp_array_add_assoc_bool(zval* return_value, const char* key, int val);

void vphp_array_add_next_zval(zval* main_array, zval* sub_item);
zval* vphp_new_zval();
bool vphp_is_type(zval* z, int type);
bool vphp_has_exception();
bool vphp_get_bool(zval* z);

zval* vphp_read_property(zval* obj, const char* name, int name_len);
int vphp_call_method(zval* obj, const char* method, int method_len, zval* retval, int param_count, zval** params_ptrs);
int vphp_call_callable(zval* callable, zval* retval, int param_count, zval** params_ptrs);

#endif
