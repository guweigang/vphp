module zend

pub fn zval_type(v &C.zval) int {
	return C.vphp_get_type(v)
}

pub fn zval_type_ptr(v voidptr) int {
	return zval_type( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) })
}

pub fn zval_is_null(v &C.zval) bool {
	return C.vphp_is_null(v)
}

pub fn zval_is_null_ptr(v voidptr) bool {
	return zval_is_null( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) })
}

pub fn zval_is_callable(v &C.zval) bool {
	return C.vphp_is_callable(v) == 1
}

pub fn zval_is_callable_ptr(v voidptr) bool {
	return zval_is_callable( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) })
}

pub fn zval_get_long(v &C.zval) i64 {
	return unsafe { C.zval_get_long(v) }
}

pub fn zval_get_long_ptr(v voidptr) i64 {
	return zval_get_long( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) })
}

pub fn zval_get_int(v &C.zval) i64 {
	return C.vphp_get_int(v)
}

pub fn zval_get_int_ptr(v voidptr) i64 {
	return zval_get_int( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) })
}

pub fn zval_get_lval(v &C.zval) i64 {
	return C.vphp_get_lval(v)
}

pub fn zval_get_lval_ptr(v voidptr) i64 {
	return zval_get_lval( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) })
}

pub fn zval_get_double(v &C.zval) f64 {
	return C.vphp_get_double(v)
}

pub fn zval_get_double_ptr(v voidptr) f64 {
	return zval_get_double( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) })
}

pub fn zval_string_ptr(v &C.zval) &char {
	return C.VPHP_Z_STRVAL(v)
}

pub fn zval_string_len(v &C.zval) int {
	return C.VPHP_Z_STRLEN(v)
}

pub fn zval_string_value_ptr(v voidptr) string {
	// SAFETY: C interop block with valid pointer arguments
	unsafe {
		raw := &C.zval(v)
		ptr := zval_string_ptr(raw)
		len := zval_string_len(raw)
		if ptr == 0 {
			return ''
		}
		return ptr.vstring_with_len(len).clone()
	}
}

pub fn zval_set_null(v &C.zval) {
	// SAFETY: C bridge call vphp_set_null with valid arguments
	unsafe { C.vphp_set_null(v) }
}

pub fn zval_set_null_ptr(v voidptr) {
	zval_set_null( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) })
}

pub fn zval_set_bool(v &C.zval, b bool) {
	// SAFETY: C bridge call vphp_set_bool with valid arguments
	unsafe { C.vphp_set_bool(v, b) }
}

pub fn zval_set_bool_ptr(v voidptr, b bool) {
	zval_set_bool( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) }, b)
}

pub fn zval_set_lval(v &C.zval, val i64) {
	// SAFETY: C bridge call vphp_set_lval with valid arguments
	unsafe { C.vphp_set_lval(v, val) }
}

pub fn zval_set_lval_ptr(v voidptr, val i64) {
	zval_set_lval( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) }, val)
}

pub fn zval_set_double(v &C.zval, val f64) {
	// SAFETY: C bridge call vphp_set_double with valid arguments
	unsafe { C.vphp_set_double(v, val) }
}

pub fn zval_set_double_ptr(v voidptr, val f64) {
	zval_set_double( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) }, val)
}

pub fn zval_set_string(v &C.zval, s string) {
	// SAFETY: C interop with valid arguments
	unsafe { C.vphp_set_strval(v, &char(s.str), s.len) }
}

pub fn zval_set_string_ptr(v voidptr, s string) {
	zval_set_string( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) }, s)
}

pub fn new_string_zval(s string) &C.zval {
	return C.vphp_new_strl(&char(s.str), s.len)
}

pub fn new_string_zval_ptr(s string) voidptr {
	return new_string_zval(s)
}

pub fn new_null_zval() &C.zval {
	z := new_zval()
	zval_set_null(z)
	return z
}

pub fn new_null_zval_ptr() voidptr {
	return new_null_zval()
}

pub fn new_int_zval(n i64) &C.zval {
	z := new_zval()
	zval_set_lval(z, n)
	return z
}

pub fn new_int_zval_ptr(n i64) voidptr {
	return new_int_zval(n)
}

pub fn new_float_zval(f f64) &C.zval {
	z := new_zval()
	zval_set_double(z, f)
	return z
}

pub fn new_float_zval_ptr(f f64) voidptr {
	return new_float_zval(f)
}

pub fn new_bool_zval(b bool) &C.zval {
	z := new_zval()
	zval_set_bool(z, b)
	return z
}

pub fn new_bool_zval_ptr(b bool) voidptr {
	return new_bool_zval(b)
}

pub fn new_zval() &C.zval {
	return C.vphp_new_zval()
}

pub fn new_zval_ptr() voidptr {
	return new_zval()
}

pub fn new_persistent_zval() &C.zval {
	return C.vphp_new_persistent_zval()
}

pub fn new_persistent_zval_ptr() voidptr {
	return new_persistent_zval()
}

pub fn release_zval(z &C.zval) {
	C.vphp_release_zval(z)
}

pub fn release_zval_ptr(z voidptr) {
	release_zval( // SAFETY: z is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(z) })
}

pub fn release_persistent_zval(z &C.zval) {
	C.vphp_release_persistent_zval(z)
}

pub fn release_persistent_zval_ptr(z voidptr) {
	release_persistent_zval( // SAFETY: z is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(z) })
}

pub fn disown_zval(z &C.zval) {
	C.vphp_disown_zval(z)
}

pub fn disown_zval_ptr(z voidptr) {
	disown_zval( // SAFETY: z is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(z) })
}

pub fn copy_zval(dst &C.zval, src &C.zval) {
	C.ZVAL_COPY(dst, src)
}

pub fn copy_zval_ptr(dst voidptr, src voidptr) {
	copy_zval( // SAFETY: dst is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(dst) }, // SAFETY: src is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(src) })
}

pub fn foreach_zval(v &C.zval, ctx voidptr, wrapper voidptr) {
	C.vphp_zval_foreach(v, ctx, wrapper)
}

pub fn foreach_zval_ptr(v voidptr, ctx voidptr, wrapper voidptr) {
	foreach_zval( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) }, ctx, wrapper)
}

pub fn runtime_counters(autorelease_len &int, owned_len &int, obj_registry_len &u32, rev_registry_len &u32) {
	C.vphp_runtime_counters(autorelease_len, owned_len, obj_registry_len, rev_registry_len)
}

pub fn reference_value(v &C.zval) &C.zval {
	return C.vphp_reference_value(v)
}

pub fn reference_value_ptr(v voidptr) voidptr {
	return reference_value( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) })
}

pub fn reference_set_zval(v &C.zval, value &C.zval) {
	C.vphp_reference_set_zval(v, value)
}

pub fn reference_set_zval_ptr(v voidptr, value voidptr) {
	reference_set_zval( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) }, // SAFETY: value is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(value) })
}

pub fn make_resource(v &C.zval, ptr voidptr, label string) {
	C.vphp_make_res(v, ptr, &char(label.str))
}

pub fn make_resource_ptr(v voidptr, ptr voidptr, label string) {
	make_resource( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) }, ptr, label)
}

pub fn fetch_resource(v &C.zval) voidptr {
	return C.vphp_fetch_res(v)
}

pub fn fetch_resource_ptr(v voidptr) voidptr {
	return fetch_resource( // SAFETY: v is a valid zval pointer from Zend runtime
	 unsafe { &C.zval(v) })
}
