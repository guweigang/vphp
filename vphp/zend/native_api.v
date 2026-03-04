module zend

// ============================================
// Native Zend / PHP API declarations
// These are direct engine/runtime APIs, not VPHP bridge helpers.
// ============================================

pub fn C.zval_get_long(v &C.zval) i64
pub fn C.ZVAL_BOOL(z &C.zval, b bool)

pub fn C.add_property_zval(obj &C.zval, name &char, val &C.zval)
pub fn C.add_property_long(arg &C.zval, key &char, n i64)
pub fn C.add_property_bool(arg &C.zval, key &char, b bool)
pub fn C.add_property_stringl(arg &C.zval, key &char, value &char, length usize)

pub fn C.zend_string_init(str &char, len usize, p int) voidptr
pub fn C.ZVAL_STR(z &C.zval, s voidptr)
pub fn C.ZVAL_COPY(dst &C.zval, src &C.zval)
