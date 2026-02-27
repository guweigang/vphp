module zend

// 声明我们在 v_bridge.c 里写的代理函数
pub fn C.vphp_get_num_args(ex &C.zend_execute_data) u32
pub fn C.vphp_get_arg_ptr(ex &C.zend_execute_data, index u32) &C.zval
pub fn C.vphp_throw(msg &char, code int)
pub fn C.vphp_get_strval(z &C.zval) &char
pub fn C.vphp_get_strlen(z &C.zval) int
pub fn C.vphp_set_strval(z &C.zval, str &char, len int)
pub fn C.vphp_get_lval(z &C.zval) i64
pub fn C.zend_string_init(str &char, len usize, p int) voidptr
pub fn C.ZVAL_STR(z &C.zval, s voidptr)

pub fn C.vphp_error(int, &char)
pub fn C.vphp_is_null(z &C.zval) bool
pub fn C.vphp_object_init(z &C.zval)
pub fn C.vphp_update_property_string(obj &C.zval, name &char, name_len int, value &char)
pub fn C.vphp_update_property_long(obj &C.zval, name &char, name_len int, value i64)
pub fn C.vphp_call_php_func(name &char, len int, retval &C.zval, p_count int, params &&C.zval) int
pub fn C.vphp_get_type(z &C.zval) int
pub fn C.vphp_get_int(z &C.zval) i64  // 映射到 C 侧的 long
pub fn C.vphp_get_double(z &C.zval) f64
pub fn C.vphp_get_string_ptr(z &C.zval, len &int) &char

// Resource
pub fn C.vphp_make_res(ret &C.zval, ptr voidptr, label &char)
pub fn C.vphp_fetch_res(z &C.zval) voidptr
pub fn C.vphp_init_resource_system(module_number int)

// Array
pub fn C.vphp_array_count(z &C.zval) int
pub fn C.vphp_array_get_index(z &C.zval, index u32) &C.zval
pub fn C.vphp_array_init(z &C.zval)
pub fn C.vphp_array_add_assoc_string(z &C.zval, key &char, val &char)
pub fn C.vphp_array_push_string(z &C.zval, val &char)
pub fn C.vphp_array_push_double(z &C.zval, val f64)
pub fn C.vphp_array_push_long(z &C.zval, val long)
pub fn C.vphp_array_each(z &C.zval, ctx voidptr, cb voidptr)
pub fn C.vphp_array_get_key(z &C.zval, key &char, len int) &C.zval
pub fn C.vphp_array_foreach(z &C.zval, ctx voidptr, cb voidptr)
pub fn C.vphp_array_get_index(z &C.zval, index u32) &C.zval
pub fn C.vphp_return_array_start(res &C.zval)
pub fn C.vphp_array_add_assoc_double(res &C.zval, key &char, val f64)
pub fn C.vphp_array_add_assoc_long(res &C.zval, key &char, val i64)
pub fn C.vphp_array_add_assoc_bool(res &C.zval, key &char, val int)
pub fn C.vphp_array_add_next_zval(main_array &C.zval, sub_item &C.zval)
pub fn C.vphp_has_exception() bool
pub fn C.vphp_get_bool(z &C.zval) bool
pub fn C.vphp_call_method(obj &C.zval, method &char, len int, retval &C.zval, p_count int, params &&C.zval) int
pub fn C.vphp_new_zval() &C.zval
pub fn C.vphp_call_callable(callable &C.zval, retval &C.zval, p_count int, params &&C.zval) int
pub fn C.vphp_set_lval(z &C.zval, val i64)


// 声明 C 包装函数
fn C.vphp_get_obj_from_zval(zv &C.zval) &C.zend_object
fn C.vphp_read_property_compat(obj &C.zend_object, name &char, name_len int, rv &C.zval) &C.zval

fn C.add_property_zval(obj &C.zval, name &char, val &C.zval)
fn C.add_property_long(arg &C.zval, key &char, n i64)
fn C.add_property_bool(arg &C.zval, key &char, b bool)
fn C.add_property_stringl(arg &C.zval, key &char, value &char, length usize)
fn C.zval_get_long(v &C.zval) i64

fn C.VPHP_Z_STRVAL(v &C.zval) &char
fn C.VPHP_Z_STRLEN(v &C.zval) int
