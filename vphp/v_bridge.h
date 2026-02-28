#ifndef V_BRIDGE_H
#define V_BRIDGE_H

#include <php.h>
#include <Zend/zend_exceptions.h>
#include <zend_objects.h>
#include <zend_API.h>
#include <stddef.h> // 必须包含，为了 offsetof

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

int vphp_call_method(zval* obj, const char* method, int method_len, zval* retval, int param_count, zval** params_ptrs);
int vphp_call_callable(zval* callable, zval* retval, int param_count, zval** params_ptrs);
void vphp_array_push_double(zval* z, double val);
void vphp_array_push_long(zval* z, long val);


typedef void (*vphp_prop_handler_t)(void* v_ptr, const char* name, int name_len, zval *rv);
// 增加同步函数的签名定义
typedef void (*vphp_sync_handler_t)(void* v_ptr, zval* object_zv);
// 增加写入处理函数的签名定义
typedef void (*vphp_write_handler_t)(void* v_ptr, const char* name, int name_len, zval *value);

// 1. 定义包装器：把 V 指针和 PHP 对象捆绑在一起
typedef struct {
    void *v_ptr;         // 指向 V 侧分配的结构体内存
    vphp_prop_handler_t prop_handler; // 核心指针
    vphp_sync_handler_t sync_handler; // 👈 专门用于全量同步
    vphp_write_handler_t write_handler; // 👈 增加写入回调
    zend_object std;     // PHP 标准对象（必须放在最后，以便偏移量计算）
} vphp_object_wrapper;

// 句柄声明
HashTable* vphp_get_properties(zend_object *object);

// 3. 声明通用的对象创建处理器
void vphp_init_object_handlers();
zend_object* vphp_create_object_handler(zend_class_entry *ce);
void vphp_free_object_handler(zend_object *obj);


// 声明自定义句柄
zval *vphp_read_property(zend_object *object, zend_string *member, int type, void **cache_slot, zval *rv);
void vphp_write_property(zend_object *object, zend_string *member, zval *value, void **cache_slot);

// 声明全局句柄表（用于保存默认行为并覆盖）
extern zend_object_handlers vphp_obj_handlers;

// 修正 offsetof
static inline vphp_object_wrapper* vphp_obj_from_obj(zend_object* obj) {
    return (vphp_object_wrapper*)((char*)(obj) - offsetof(vphp_object_wrapper, std));
}

// 包装 PHP 的 Z_OBJ_P 宏
static inline zend_object* vphp_get_obj_from_zval(zval *zv) {
    return Z_OBJ_P(zv);
}

// 声明刚才提到的兼容层函数
zval* vphp_read_property_compat(zend_object *obj, const char *name, int name_len, zval *rv);


// 获取 zval 字符串指针
static inline char* VPHP_Z_STRVAL(zval *z) {
    if (Z_TYPE_P(z) != IS_STRING) {
        // 如果不是字符串，尝试强制转换（可选，但更稳健）
        // convert_to_string(z);
    }
    return Z_STRVAL_P(z);
}

// 获取 zval 字符串长度
static inline int VPHP_Z_STRLEN(zval *z) {
    return (int)Z_STRLEN_P(z);
}

// 处理普通字符串
#define VPHP_RETURN_STRING(v_str) do { \
    RETVAL_STRINGL(v_str.str, v_str.len); \
    return; \
} while(0)

// 处理带错误的 Result 类型
#define VPHP_RETURN_RESULT_BOOL(res) do { \
    if (res._error.code != 0) { \
        zend_throw_exception(NULL, (char*)res._error.msg.str, 0); \
        return; \
    } \
    RETURN_BOOL(res.data); \
} while(0)

#endif
