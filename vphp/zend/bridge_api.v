module zend

// ============================================
// VPHP bridge API declarations
// These are wrappers/helpers implemented by v_bridge.c/.h.
// ============================================

// ===== 1. 执行上下文 & 参数 =====
pub fn C.vphp_get_num_args(ex &C.zend_execute_data) u32
pub fn C.vphp_get_arg_ptr(ex &C.zend_execute_data, index u32) &C.zval
pub fn C.vphp_has_exception() bool
pub fn C.vphp_get_active_ce(ex &C.zend_execute_data) voidptr
pub fn C.vphp_get_this_object(ex &C.zend_execute_data) voidptr
pub fn C.vphp_get_active_globals() voidptr

// ===== 2. 框架与异常 =====
pub fn C.vphp_init_registry()
pub fn C.vphp_throw(msg &char, code int)
pub fn C.vphp_error(int, &char)

// ===== 3. zval 类型检测 =====
pub fn C.vphp_get_type(z &C.zval) int
pub fn C.vphp_is_null(z &C.zval) bool
pub fn C.vphp_is_type(z &C.zval, typ int) bool

// ===== 4. zval 读取 — 标量 =====
pub fn C.vphp_get_lval(z &C.zval) i64
pub fn C.vphp_get_int(z &C.zval) i64
pub fn C.vphp_get_double(z &C.zval) f64
pub fn C.vphp_get_bool(z &C.zval) bool
pub fn C.vphp_get_strval(z &C.zval) &char
pub fn C.vphp_get_strlen(z &C.zval) int
pub fn C.vphp_get_string_ptr(z &C.zval, len &int) &char
pub fn C.VPHP_Z_STRVAL(v &C.zval) &char
pub fn C.VPHP_Z_STRLEN(v &C.zval) int

// ===== 5. zval 写入 — 标量 =====
pub fn C.vphp_set_lval(z &C.zval, val i64)
pub fn C.vphp_set_double(z &C.zval, val f64)
pub fn C.vphp_set_bool(z &C.zval, val bool)
pub fn C.vphp_set_strval(z &C.zval, str &char, len int)
pub fn C.vphp_set_null(z &C.zval)
pub fn C.vphp_new_zval() &C.zval
pub fn C.vphp_new_str(s &char) &C.zval
pub fn C.vphp_convert_to_string(z &C.zval)

// ===== 6. 数组操作 =====
pub fn C.vphp_array_init(z &C.zval)
pub fn C.vphp_array_count(z &C.zval) int
pub fn C.vphp_return_array_start(res &C.zval)
pub fn C.vphp_array_get_index(z &C.zval, index u32) &C.zval
pub fn C.vphp_array_get_key(z &C.zval, key &char, len int) &C.zval
pub fn C.vphp_array_push_string(z &C.zval, val &char)
pub fn C.vphp_array_push_double(z &C.zval, val f64)
pub fn C.vphp_array_push_long(z &C.zval, val i64)
pub fn C.vphp_array_add_next_zval(main_array &C.zval, sub_item &C.zval)
pub fn C.vphp_array_add_assoc_string(z &C.zval, key &char, val &char)
pub fn C.vphp_array_add_assoc_double(res &C.zval, key &char, val f64)
pub fn C.vphp_array_add_assoc_long(res &C.zval, key &char, val i64)
pub fn C.vphp_array_add_assoc_bool(res &C.zval, key &char, val int)
pub fn C.vphp_array_add_assoc_zval(z &C.zval, key &char, val &C.zval)
pub fn C.vphp_array_each(z &C.zval, ctx voidptr, cb voidptr)
pub fn C.vphp_array_foreach(z &C.zval, ctx voidptr, cb voidptr)

// ===== 7. 对象操作 =====
pub fn C.vphp_object_init(z &C.zval)
pub fn C.vphp_get_obj_from_zval(zv &C.zval) &C.zend_object
pub fn C.vphp_get_v_ptr_from_zval(zv &C.zval) voidptr
pub fn C.vphp_zval_foreach(zv &C.zval, cb voidptr, ctx voidptr)
pub fn C.vphp_read_property_compat(obj &C.zend_object, name &char, name_len int, rv &C.zval) &C.zval
pub fn C.vphp_write_property_compat(obj &C.zend_object, name &char, name_len int, value &C.zval)
pub fn C.vphp_has_property_compat(obj &C.zend_object, name &char, name_len int) int
pub fn C.vphp_isset_property_compat(obj &C.zend_object, name &char, name_len int) int
pub fn C.vphp_unset_property_compat(obj &C.zend_object, name &char, name_len int)
pub fn C.vphp_update_property_string(obj &C.zval, name &char, name_len int, value &char)
pub fn C.vphp_update_property_long(obj &C.zval, name &char, name_len int, value i64)
pub fn C.vphp_add_property_double(obj &C.zval, name &char, val f64)

@[typedef]
pub struct C.vphp_object_wrapper {
pub:
	v_ptr          voidptr
	prop_handler   voidptr
	sync_handler   voidptr
	write_handler  voidptr
	std            C.zend_object
}

pub fn C.vphp_obj_from_obj(obj &C.zend_object) &C.vphp_object_wrapper
pub fn C.vphp_register_object(v_ptr voidptr, obj &C.zend_object)
pub fn C.vphp_return_obj(return_value &C.zval, v_ptr voidptr, ce &C.zend_class_entry)
pub fn C.vphp_bind_handlers(obj &C.zend_object, handlers voidptr)

// ===== 8. 闭包 & 调用 =====
pub fn C.vphp_call_php_func(name &char, len int, retval &C.zval, p_count int, params &&C.zval) int
pub fn C.vphp_call_static_method(class_name &char, class_name_len int, method &char, method_len int, retval &C.zval, p_count int, params &&C.zval) int
pub fn C.vphp_call_method(obj &C.zval, method &char, len int, retval &C.zval, p_count int, params &&C.zval) int
pub fn C.vphp_is_callable(callable &C.zval) int
pub fn C.vphp_call_callable(callable &C.zval, retval &C.zval, p_count int, params &&C.zval) int
pub fn C.vphp_new_instance(class_name &char, len int, retval &C.zval, p_count int, params &&C.zval) int
pub fn C.vphp_create_closure_FULL_AUTO_V2(z &C.zval, thunk voidptr, bridge voidptr)

// ===== 9. 资源系统 =====
pub fn C.vphp_init_resource_system(module_number int)
pub fn C.vphp_make_res(ret &C.zval, ptr voidptr, label &char)
pub fn C.vphp_fetch_res(z &C.zval) voidptr

// ===== 10. 静态属性 =====
pub fn C.vphp_update_static_property_long(ce voidptr, name &char, name_len int, val i64)
pub fn C.vphp_update_static_property_string(ce voidptr, name &char, name_len int, val &char, val_len int)
pub fn C.vphp_update_static_property_bool(ce voidptr, name &char, name_len int, val int)
pub fn C.vphp_get_static_property_long(ce voidptr, name &char, name_len int) i64
pub fn C.vphp_get_static_property_string(ce voidptr, name &char, name_len int) &char
pub fn C.vphp_get_static_property_bool(ce voidptr, name &char, name_len int) int
pub fn C.vphp_read_static_property_compat(class_name &char, class_name_len int, name &char, name_len int, rv &C.zval) &C.zval
pub fn C.vphp_write_static_property_compat(class_name &char, class_name_len int, name &char, name_len int, value &C.zval) int

// ===== 11. 类注册与辅助 =====
pub fn C.vphp_register_internal_class(name &char, methods voidptr, count int)
