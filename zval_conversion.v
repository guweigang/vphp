module vphp

import vphp.zval

fn C.vphp_find_loaded_class_entry(class_name &char, len int) voidptr
fn C.vphp_zend_enum_get_case(ce voidptr, name &char, len int) voidptr
fn C.vphp_zval_set_object_copy(z voidptr, zo voidptr)

// ======== V -> Zend Value 转换 API ========
//
// Ownership-aware code should prefer `RequestBorrowedZBox`,
// `RequestOwnedZBox`, and `PersistentOwnedZBox`.

pub fn (v ZVal) copy_from(value ZVal) {
	if !value.is_valid() {
		v.set_null()
		return
	}
	zval.copy(v.handle(), value.handle())
}

// 将 V 类型写入 Zend Value
pub fn (v ZVal) from_v[T](value T) ! {
	$if T is $enum {
		mut php_name := ''
		mut has_meta := false
		$for method in T.methods {
			$if method.name == 'php_class_name' {
				php_name = value.php_class_name()
				has_meta = true
			}
		}
		if !has_meta {
			full_name := typeof[T]().name
			php_name = if full_name.contains('.') {
				full_name.all_after_last('.')
			} else {
				full_name
			}
		}
		ce := C.vphp_find_loaded_class_entry(&char(php_name.str), php_name.len)
		if ce == unsafe { nil } {
			return error('failed to find php class entry for enum: ${php_name}')
		}
		case_name := value.str()
		case_zo := C.vphp_zend_enum_get_case(ce, &char(case_name.str), case_name.len)
		if case_zo == unsafe { nil } {
			return error('failed to get php enum case for: ${case_name}')
		}
		C.vphp_zval_set_object_copy(v.raw_ptr(), case_zo)
		return
	}
	$if T is ZVal {
		v.copy_from(value)
		return
	}
	$if T is RequestBorrowedZBox {
		v.copy_from(value.to_zval())
		return
	}
	$if T is RequestOwnedZBox {
		v.copy_from(value.to_zval())
		return
	}
	$if T is PersistentOwnedZBox {
		v.copy_from(value.to_zval())
		return
	}
	$if T is bool {
		v.set_bool(value)
		return
	}
	$if T is int || T is i64 {
		v.set_int(i64(value))
		return
	}
	$if T is f64 {
		v.set_double(value)
		return
	}
	$if T is string {
		v.set_string(value)
		return
	}
	$if T is []string {
		v.array_init()
		for item in value {
			v.push_string(item)
		}
		return
	}
	$if T is []int || T is []i64 {
		v.array_init()
		for item in value {
			v.push_long(i64(item))
		}
		return
	}
	$if T is []f64 {
		v.array_init()
		for item in value {
			v.push_double(item)
		}
		return
	}
	$if T is []bool {
		v.array_init()
		for item in value {
			v.push_bool(item)
		}
		return
	}
	$if T is []ZVal {
		v.array_init()
		for item in value {
			v.add_next_val(item)
		}
		return
	}
	$if T is []map[string]string {
		v.array_init()
		for item in value {
			mut sub := RequestOwnedZBox.new_null().to_zval()
			sub.array_init()
			for key, val in item {
				sub.add_assoc_string(key, val)
			}
			v.add_next_val(sub)
		}
		return
	}
	$if T is map[string][]string {
		v.array_init()
		for key, item in value {
			mut sub := RequestOwnedZBox.new_null().to_zval()
			sub.array_init()
			for entry in item {
				sub.push_string(entry)
			}
			v.add_assoc_zval(key, sub)
		}
		return
	}
	$if T is map[string]string {
		v.array_init()
		for key, item in value {
			v.add_assoc_string(key, item)
		}
		return
	}
	$if T is map[string]int || T is map[string]i64 {
		v.array_init()
		for key, item in value {
			v.add_assoc_long(key, i64(item))
		}
		return
	}
	$if T is map[string]f64 {
		v.array_init()
		for key, item in value {
			v.add_assoc_double(key, item)
		}
		return
	}
	$if T is map[string]bool {
		v.array_init()
		for key, item in value {
			v.add_assoc_bool(key, item)
		}
		return
	}
	$if T is map[string]ZVal {
		v.array_init()
		for key, item in value {
			v.add_assoc_zval(key, item)
		}
		return
	}
	return error('unsupported from_v conversion for source type')
}

fn (v ZVal) push_struct[T](item T) {
	mut temp := RequestOwnedZBox.new_null()
	defer {
		temp.release()
	}
	mut sub := temp.to_zval()
	sub.array_init()
	$for field in T.fields {
		key := field.name
		$if field.typ is string {
			sub.add_assoc_string(key, item.$(field.name))
		} $else $if field.typ is f64 {
			sub.add_assoc_double(key, item.$(field.name))
		} $else $if field.typ is int || field.typ is i64 {
			sub.add_assoc_long(key, i64(item.$(field.name)))
		} $else $if field.typ is bool {
			sub.add_assoc_bool(key, item.$(field.name))
		}
	}
	v.add_next_val(sub)
}

// 便捷工厂：从 V 类型直接创建 Zend Value 包装
pub fn new_zval_from[T](value T) !ZVal {
	mut out := ZVal.new_request()
	RequestScope.autorelease_add_handle(out.handle())
	out.from_v[T](value)!
	return out
}

pub fn ZVal.from[T](value T) !ZVal {
	return new_zval_from[T](value)!
}
