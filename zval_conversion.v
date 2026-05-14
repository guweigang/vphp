module vphp

// ======== V -> Zend Value 转换 API ========
//
// Ownership-aware code should prefer `RequestBorrowedZBox`,
// `RequestOwnedZBox`, and `PersistentOwnedZBox`.

pub fn (v ZVal) copy_from(value ZVal) {
	if !value.is_valid() {
		v.set_null()
		return
	}
	zend_copy_zval(v.raw, value.raw)
}

// 将 V 类型写入 Zend Value
pub fn (v ZVal) from_v[T](value T) ! {
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
	mut out := ZVal{
		raw:   zend_new_zval()
		owned: true
	}
	RequestScope.autorelease_add_handle(out.handle())
	out.from_v[T](value)!
	return out
}

pub fn ZVal.from[T](value T) !ZVal {
	return new_zval_from[T](value)!
}

// 兼容旧命名：建议改用 new_zval_from[T]
pub fn new_val_from[T](value T) !ZVal {
	return new_zval_from[T](value)
}
