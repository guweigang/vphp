module zend

// ============================================
// Zend 引擎 C API — V 侧完整声明
// 按功能分组，覆盖 PHP 扩展开发的全部常用操作
// ============================================

// ===== 1. 执行上下文 & 参数 =====
pub fn C.vphp_get_num_args(ex &C.zend_execute_data) u32
pub fn C.vphp_get_arg_ptr(ex &C.zend_execute_data, index u32) &C.zval
pub fn C.vphp_has_exception() bool

// ===== 2. 异常 & 错误 =====
pub fn C.vphp_throw(msg &char, code int)
pub fn C.vphp_error(int, &char)

// ===== 3. zval 类型检测 =====
pub fn C.vphp_get_type(z &C.zval) int
pub fn C.vphp_is_null(z &C.zval) bool
pub fn C.vphp_is_type(z &C.zval, typ int) bool

// ===== 4. zval 读取 — 标量 =====
// 整型
pub fn C.vphp_get_lval(z &C.zval) i64
pub fn C.vphp_get_int(z &C.zval) i64
pub fn C.zval_get_long(v &C.zval) i64
// 浮点
pub fn C.vphp_get_double(z &C.zval) f64
// 布尔
pub fn C.vphp_get_bool(z &C.zval) bool
// 字符串
pub fn C.vphp_get_strval(z &C.zval) &char
pub fn C.vphp_get_strlen(z &C.zval) int
pub fn C.vphp_get_string_ptr(z &C.zval, len &int) &char
pub fn C.VPHP_Z_STRVAL(v &C.zval) &char
pub fn C.VPHP_Z_STRLEN(v &C.zval) int

// ===== 5. zval 写入 — 标量 =====
// 整型
pub fn C.vphp_set_lval(z &C.zval, val i64)
// 浮点
pub fn C.vphp_set_double(z &C.zval, val f64)
// 布尔
pub fn C.vphp_set_bool(z &C.zval, val bool)
pub fn C.ZVAL_BOOL(z &C.zval, b bool)
// 字符串
pub fn C.vphp_set_strval(z &C.zval, str &char, len int)
// Null
pub fn C.vphp_set_null(z &C.zval)
// 工厂
pub fn C.vphp_new_zval() &C.zval
pub fn C.vphp_new_str(s &char) &C.zval
// 类型转换
pub fn C.vphp_convert_to_string(z &C.zval)

// ===== 6. 数组操作 — 初始化 & 元信息 =====
pub fn C.vphp_array_init(z &C.zval)
pub fn C.vphp_array_count(z &C.zval) int
pub fn C.vphp_return_array_start(res &C.zval)

// ===== 7. 数组操作 — 索引访问 =====
pub fn C.vphp_array_get_index(z &C.zval, index u32) &C.zval
pub fn C.vphp_array_push_string(z &C.zval, val &char)
pub fn C.vphp_array_push_double(z &C.zval, val f64)
pub fn C.vphp_array_push_long(z &C.zval, val i64)
pub fn C.vphp_array_add_next_zval(main_array &C.zval, sub_item &C.zval)

// ===== 8. 数组操作 — 关联访问 =====
pub fn C.vphp_array_get_key(z &C.zval, key &char, len int) &C.zval
pub fn C.vphp_array_add_assoc_string(z &C.zval, key &char, val &char)
pub fn C.vphp_array_add_assoc_double(res &C.zval, key &char, val f64)
pub fn C.vphp_array_add_assoc_long(res &C.zval, key &char, val i64)
pub fn C.vphp_array_add_assoc_bool(res &C.zval, key &char, val int)
pub fn C.vphp_array_add_assoc_zval(z &C.zval, key &char, val &C.zval)

// ===== 9. 数组操作 — 遍历 =====
pub fn C.vphp_array_each(z &C.zval, ctx voidptr, cb voidptr)
pub fn C.vphp_array_foreach(z &C.zval, ctx voidptr, cb voidptr)

// ===== 10. 对象操作 =====
pub fn C.vphp_object_init(z &C.zval)
pub fn C.vphp_get_obj_from_zval(zv &C.zval) &C.zend_object
pub fn C.vphp_read_property_compat(obj &C.zend_object, name &char, name_len int, rv &C.zval) &C.zval
// 属性写入
pub fn C.vphp_update_property_string(obj &C.zval, name &char, name_len int, value &char)
pub fn C.vphp_update_property_long(obj &C.zval, name &char, name_len int, value i64)
pub fn C.add_property_zval(obj &C.zval, name &char, val &C.zval)
pub fn C.add_property_long(arg &C.zval, key &char, n i64)
pub fn C.add_property_bool(arg &C.zval, key &char, b bool)
pub fn C.add_property_stringl(arg &C.zval, key &char, value &char, length usize)
pub fn C.vphp_add_property_double(obj &C.zval, name &char, val f64)

// ===== 11. 函数 & 方法调用 =====
pub fn C.vphp_call_php_func(name &char, len int, retval &C.zval, p_count int, params &&C.zval) int
pub fn C.vphp_call_method(obj &C.zval, method &char, len int, retval &C.zval, p_count int, params &&C.zval) int
pub fn C.vphp_call_callable(callable &C.zval, retval &C.zval, p_count int, params &&C.zval) int

// ===== 12. 资源系统 =====
pub fn C.vphp_init_resource_system(module_number int)
pub fn C.vphp_make_res(ret &C.zval, ptr voidptr, label &char)
pub fn C.vphp_fetch_res(z &C.zval) voidptr

// ===== 13. 类注册 & 对象包装器 =====
pub fn C.vphp_get_this_object(ex &C.zend_execute_data) voidptr
pub fn C.vphp_return_val(ret &C.zval, val &C.zval)
pub fn C.vphp_register_internal_class(name &char, methods voidptr, count int)
pub fn C.vphp_bind_handlers(obj &C.zend_object, handlers voidptr)

// ===== 14. zend_string 内部操作 =====
pub fn C.zend_string_init(str &char, len usize, p int) voidptr
pub fn C.ZVAL_STR(z &C.zval, s voidptr)
