#include <php.h>
#include <Zend/zend_exceptions.h>
#include <zend_errors.h>
#include "v_bridge.h"

// 把 PHP 的宏包装成 V 能认出的 C 函数
uint32_t vphp_get_num_args(zend_execute_data* ex) {
    return ZEND_CALL_NUM_ARGS(ex);
}

zval* vphp_get_arg_ptr(zend_execute_data* ex, uint32_t index) {
    return ZEND_CALL_ARG(ex, index);
}

void vphp_throw(char* msg, int code) {
    zend_throw_exception(NULL, msg, (zend_long)code);
}
long vphp_get_lval(zval* z) { return Z_LVAL_P(z); }
void vphp_set_lval(zval* z, long val) {
    ZVAL_LONG(z, val);
}

char* vphp_get_strval(zval* z) { return Z_STRVAL_P(z); }
int vphp_get_strlen(zval* z) { return Z_STRLEN_P(z); }
const char* vphp_get_string_ptr(zval* z, int* len) {
    if (z && Z_TYPE_P(z) == IS_STRING) {
        *len = Z_STRLEN_P(z);
        return Z_STRVAL_P(z);
    }
    *len = 0;
    return "";
}
void vphp_set_strval(zval* z, char* str, int len) {
    ZVAL_STRINGL(z, str, len);
}

void vphp_set_bool(zval* z, bool val) {
    if (val) {
        ZVAL_TRUE(z);
    } else {
        ZVAL_FALSE(z);
    }
}
bool vphp_get_bool(zval* z) {
    if (!z) return false;
    if (Z_TYPE_P(z) == IS_TRUE) return true;
    if (Z_TYPE_P(z) == IS_FALSE) return false;
    return false;
}

// 数组实现
int vphp_array_count(zval* z) {
    if (z == NULL || Z_TYPE_P(z) != IS_ARRAY) return 0;
    return zend_hash_num_elements(Z_ARRVAL_P(z));
}

void vphp_array_init(zval* z) {
    array_init(z);
}

void vphp_return_array_start(zval* return_value) {
    array_init(return_value);
}
// 添加整数
void vphp_array_add_assoc_long(zval* return_value, const char* key, long val) {
    add_assoc_long(return_value, key, val);
}
// 添加布尔值
void vphp_array_add_assoc_bool(zval* return_value, const char* key, int val) {
    add_assoc_bool(return_value, key, val);
}
void vphp_array_add_assoc_double(zval* return_value, const char* key, double val) {
    add_assoc_double(return_value, key, val);
}

void vphp_array_add_assoc_string(zval* z, const char* key, const char* val) {
    add_assoc_string(z, key, val);
}

// 在 v_bridge.c 中添加
void vphp_array_push_string(zval* z, const char* val) {
    add_next_index_string(z, val);
}
void vphp_array_push_double(zval* z, double val) {
    add_next_index_double(z, val);
}
void vphp_array_push_long(zval* z, long val) {
    add_next_index_long(z, val);
}

void vphp_array_each(zval* array, void* ctx, void (*callback)(void*, char*, zval*)) {
    if (Z_TYPE_P(array) != IS_ARRAY) return;

    zend_string *key;
    zval *val;
    // 遍历 HashTable
    ZEND_HASH_FOREACH_STR_KEY_VAL(Z_ARRVAL_P(array), key, val) {
        if (key) {
            callback(ctx, ZSTR_VAL(key), val);
        }
    } ZEND_HASH_FOREACH_END();
}

zval* vphp_array_get_key(zval* array, const char* key, int key_len) {
    if (array == NULL || Z_TYPE_P(array) != IS_ARRAY) {
        return NULL;
    }
    // PHP 内核函数：在哈希表中查找字符串 key
    return zend_hash_str_find(Z_ARRVAL_P(array), key, key_len);
}

int vphp_get_type(zval* z) {
    if (z == NULL) return -1;
    return Z_TYPE_P(z);
}

void vphp_error(int type, const char* msg) {
    // type 可以是 E_ERROR, E_WARNING, E_NOTICE 等
    zend_error(type, "%s", msg);
}

// 检查 zval 是否为 null 或未定义
bool vphp_is_null(zval* z) {
    return z == NULL || Z_TYPE_P(z) == IS_NULL || Z_TYPE_P(z) == IS_UNDEF;
}

// 初始化一个 zval 为 stdClass 对象
void vphp_object_init(zval* z) {
    object_init(z);
}

// 给对象添加字符串属性
void vphp_update_property_string(zval* obj, const char* name, int name_len, const char* value) {
    // PHP 内核函数：给对象 obj 的属性 name 赋值 value
    add_property_stringl(obj, name, value, strlen(value));
}

// 给对象添加整数属性
void vphp_update_property_long(zval* obj, const char* name, int name_len, long value) {
    add_property_long(obj, name, value);
}

// name: 函数名, params: 参数数组, param_count: 参数个数
int vphp_call_php_func(const char* name, int name_len, zval* retval, int param_count, zval** params_ptrs) {
    zval function_name;
    ZVAL_STRINGL(&function_name, name, name_len);

    // 如果有参数，我们需要构建一个临时的连续 zval 数组
    zval* params = NULL;
    if (param_count > 0) {
        params = (zval*)safe_emalloc(param_count, sizeof(zval), 0);
        for (int i = 0; i < param_count; i++) {
            // 将分散的 zval 内容拷贝到连续内存中
            ZVAL_COPY_VALUE(&params[i], params_ptrs[i]);
        }
    }

    int result = call_user_function(EG(function_table), NULL, &function_name, retval, param_count, params);

    // 清理临时分配的连续空间（注意：这里不清理 zval 里的内容，只清理容器）
    if (params) efree(params);
    zval_ptr_dtor(&function_name);
    return result;
}

long vphp_get_int(zval* z) {
    if (z == NULL) return 0;
    if (Z_TYPE_P(z) == IS_LONG) {
        return Z_LVAL_P(z); // 使用内核宏安全读取
    } else if (Z_TYPE_P(z) == IS_DOUBLE) {
        return (long)Z_DVAL_P(z);
    }
    return 0;
}

// 资源类型 ID
int le_vphp_res;

// 1. 通用包装器结构：记录原始指针和类型标签
typedef struct {
    void *ptr;
    char *label;
} vphp_res_t;

// 2. 通用析构函数：无论什么资源，最终都通过这个函数安全释放
void vphp_res_dtor(zend_resource *res) {
    vphp_res_t *wrapper = (vphp_res_t *)res->ptr;
    if (wrapper) {
        if (wrapper->ptr) {
            // 这里执行真正的内存释放
            free(wrapper->ptr);
            // 如果你有特定的调试需求，可以在这里 printf("Released: %s\n", wrapper->label);
        }
        free(wrapper);
    }
}

// 3. 注册资源（在扩展启动时调用）
void vphp_init_resource_system(int module_number) {
    le_vphp_res = zend_register_list_destructors_ex(
        vphp_res_dtor, NULL, "VPHP Generic Resource", module_number
    );
}

// 4. 包装函数：供 V 调用，将指针转为 PHP 资源
void vphp_make_res(zval* return_value, void* ptr, const char* label) {
    if (!ptr) { RETVAL_NULL(); return; }

    vphp_res_t *wrapper = malloc(sizeof(vphp_res_t));
    wrapper->ptr = ptr;
    wrapper->label = (char*)label; // 这里可以传入 V 的字符串

    RETVAL_RES(zend_register_resource(wrapper, le_vphp_res));
}

// 5. 提取函数：从 PHP 资源中拿回原始指针
void* vphp_fetch_res(zval* z) {
    vphp_res_t *wrapper = (vphp_res_t *)zend_fetch_resource(Z_RES_P(z), "VPHP Generic Resource", le_vphp_res);
    return wrapper ? wrapper->ptr : NULL;
}

// 核心：通用的数组迭代器
// ctx: V 侧传过来的数组指针
// callback: V 侧的转换函数
void vphp_array_foreach(zval* z, void* ctx, void (*callback)(void*, zval*)) {
    if (z == NULL || Z_TYPE_P(z) != IS_ARRAY) return;

    zval *val;
    // 只遍历值 (Value)，暂不处理键 (Key)
    ZEND_HASH_FOREACH_VAL(Z_ARRVAL_P(z), val) {
        callback(ctx, val);
    } ZEND_HASH_FOREACH_END();
}

// 根据数字索引获取元素 (专门用于处理非关联数组)
zval* vphp_array_get_index(zval *z, uint32_t index) {
    if (z && Z_TYPE_P(z) == IS_ARRAY) {
        return zend_hash_index_find(Z_ARRVAL_P(z), index);
    }
    return NULL;
}

// 向索引数组（List）中添加另一个 zval (通常是子数组/对象)
void vphp_array_add_next_zval(zval* main_array, zval* sub_item) {
    add_next_index_zval(main_array, sub_item);
}

// 专门用于在反射循环中创建一个临时的 zval 容器
zval* vphp_new_zval() {
    zval* zv = (zval*)malloc(sizeof(zval));
    return zv;
}

double vphp_get_double(zval* z) {
    if (!z) return 0.0;
    if (Z_TYPE_P(z) == IS_DOUBLE) return Z_DVAL_P(z);
    if (Z_TYPE_P(z) == IS_LONG) return (double)Z_LVAL_P(z);
    return 0.0;
}

// 检查是否为指定类型
bool vphp_is_type(zval* z, int type) {
    if (!z) return false;
    return Z_TYPE_P(z) == type;
}

bool vphp_has_exception() {
    if (EG(exception)) {
        return true;
    }
    return false;
}

// 对象方法调用：obj 对象, method 方法名, param_count 参数数量, params 参数数组指针
int vphp_call_method(zval* obj, const char* method, int method_len, zval* retval, int param_count, zval** params_ptrs) {
    if (obj == NULL || Z_TYPE_P(obj) != IS_OBJECT) return -1;

    zval method_name;
    // 使用 ZVAL_STRINGL 确保方法名安全
    ZVAL_STRINGL(&method_name, method, method_len);

    // 关键修复：retval 必须初始化为 UNDEF，否则内核可能会尝试释放其中的旧值
    ZVAL_UNDEF(retval);

    // 参数转换：call_user_function 需要连续内存空间的 zval 数组
    zval* params = NULL;
    if (param_count > 0) {
        params = (zval*)safe_emalloc(param_count, sizeof(zval), 0);
        for (int i = 0; i < param_count; i++) {
            if (params_ptrs[i] != NULL) {
                ZVAL_COPY_VALUE(&params[i], params_ptrs[i]);
            } else {
                ZVAL_NULL(&params[i]);
            }
        }
    }

    // 执行 PHP 对象方法调用
    // EG(function_table) 用于查找函数
    int result = call_user_function(EG(function_table), obj, &method_name, retval, param_count, params);

    // 清理：释放方法名字符串和临时参数数组
    zval_ptr_dtor(&method_name);
    if (params) efree(params);

    return result;
}

// 通用调用：支持闭包、匿名函数或任何 Callable 对象
int vphp_call_callable(zval* callable, zval* retval, int param_count, zval** params_ptrs) {
    // 修复点：将 IS_CALLABLE_CHECK_SYNTAXONLY 替换为 0
    // 在 PHP 8 中，0 表示标准检查
    if (callable == NULL || !zend_is_callable(callable, 0, NULL)) {
        return -1;
    }

    ZVAL_UNDEF(retval);

    zval* params = NULL;
    if (param_count > 0) {
        params = (zval*)safe_emalloc(param_count, sizeof(zval), 0);
        for (int i = 0; i < param_count; i++) {
            if (params_ptrs[i]) {
                ZVAL_COPY_VALUE(&params[i], params_ptrs[i]);
            } else {
                ZVAL_NULL(&params[i]);
            }
        }
    }

    // 执行调用
    int result = call_user_function(EG(function_table), NULL, callable, retval, param_count, params);

    if (params) efree(params);
    return result;
}

// 定义全局句柄表
zend_object_handlers vphp_obj_handlers;

void vphp_free_object_handler(zend_object *obj) {
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(obj);
    if (wrapper->v_ptr) {
        // 这里可以调用 V 侧导出的释放函数，或者简单地根据 GC 策略处理
        // free(wrapper->v_ptr);
    }
    zend_object_std_dtor(obj);
}

// 拦截读取操作
// 3. 实现标准的 5 参数版本
zval *vphp_read_property(zend_object *object, zend_string *member, int type, void **cache_slot, zval *rv) {
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(object);
    if (wrapper->v_ptr && wrapper->prop_handler) {
        // 重点：在这里打印一下 rv 的地址，确认它不是 NULL
        // printf("Reading prop: %s, rv addr: %p\n", ZSTR_VAL(member), rv);

        ZVAL_UNDEF(rv); // 必须先初始化为 UNDEF
        wrapper->prop_handler(
            wrapper->v_ptr,
            ZSTR_VAL(member),
            (int)ZSTR_LEN(member),
            rv
        );

        if (Z_TYPE_P(rv) != IS_UNDEF) {
            return rv;
        }
    }
    return zend_get_std_object_handlers()->read_property(object, member, type, cache_slot, rv);
}

// 拦截写入操作
void vphp_write_property(zend_object *object, zend_string *member, zval *value, void **cache_slot) {
    vphp_object_wrapper *wrapper = vphp_obj_from_obj(object);

    if (wrapper->v_ptr && wrapper->write_handler) {
        // 调用 V 侧生成的 Setter 逻辑
        wrapper->write_handler(wrapper->v_ptr, ZSTR_VAL(member), (int)ZSTR_LEN(member), value);
    }

    // 依然调用标准写入，保持 PHP 侧属性表同步（可选，建议保留以支持 var_dump）
    zend_get_std_object_handlers()->write_property(object, member, value, cache_slot);
}

// 在初始化时克隆标准句柄并覆盖
void vphp_init_handlers() {
    memcpy(&vphp_obj_handlers, zend_get_std_object_handlers(), sizeof(zend_object_handlers));
    vphp_obj_handlers.offset = offsetof(vphp_object_wrapper, std); // 这里用 std
    vphp_obj_handlers.free_obj = vphp_free_object_handler;
    vphp_obj_handlers.read_property = vphp_read_property;
    vphp_obj_handlers.get_properties = vphp_get_properties; // 👈 挂载劫持
    vphp_obj_handlers.write_property = vphp_write_property;
}

zend_object* vphp_create_object_handler(zend_class_entry *ce) {
    if (vphp_obj_handlers.read_property == NULL) {
        memcpy(&vphp_obj_handlers, zend_get_std_object_handlers(), sizeof(zend_object_handlers));
        vphp_obj_handlers.offset = offsetof(vphp_object_wrapper, std); // 这里用 std
        vphp_obj_handlers.free_obj = vphp_free_object_handler;
        vphp_obj_handlers.read_property = vphp_read_property;
        vphp_obj_handlers.get_properties = vphp_get_properties; // 👈 挂载劫持
        vphp_obj_handlers.write_property = vphp_write_property;
    }

    vphp_object_wrapper *obj = zend_object_alloc(sizeof(vphp_object_wrapper), ce);
    zend_object_std_init(&obj->std, ce);
    object_properties_init(&obj->std, ce);
    obj->std.handlers = &vphp_obj_handlers;

    return &obj->std;
}

// 专门给 V 调用的 3 参数版本，内部转发给标准的 5 参数 Handler
zval* vphp_read_property_compat(zend_object *obj, const char *name, int name_len, zval *rv) {
    // 构造 zend_string
    zend_string *member = zend_string_init(name, name_len, 0);

    // 调用我们之前定义的 5 参数劫持函数
    // type 传 BP_VAR_R (只读)，cache_slot 传 NULL
    zval *res = vphp_read_property(obj, member, BP_VAR_R, NULL, rv);

    // 释放临时字符串
    zend_string_release(member);
    return res;
}


HashTable* vphp_get_properties(zend_object *object) {
    // 1. 获取默认属性表（PHP 的标准行为）
    HashTable *props = zend_std_get_properties(object);

    vphp_object_wrapper *wrapper = vphp_obj_from_obj(object);

    if (wrapper->v_ptr && wrapper->sync_handler) {
        // 2. 构造一个临时的 zval 指向当前对象
        zval obj_zv;
        ZVAL_OBJ(&obj_zv, object);

        // 3. 调用 V 侧生成的同步函数，把 V 内存刷进这个 props 表
        wrapper->sync_handler(wrapper->v_ptr, &obj_zv);
    }

    return props;
}
