module vphp

// Zend object handler boundary.
// These exported callbacks must keep Zend's raw callback signature, then wrap
// zval pointers immediately before touching normal vphp APIs.

// Generic property reader used by generated PHP class handlers.
pub fn generic_get_prop[T](ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
	unsafe {
		name := PhpObjectPropertyHandler.name_from_ptr(name_ptr, name_len)
		ret := PhpObjectPropertyHandler.return_from_ptr(rv)
		obj := &T(ptr)
		$for field in T.fields {
			if name == field.name {
				val := obj.$(field.name)
				$if field.typ is string {
					ret.v[string](val)
				} $else $if field.typ is int {
					ret.v[i64](i64(val))
				} $else $if field.typ is i64 {
					ret.v[i64](val)
				} $else $if field.typ is bool {
					ret.v[bool](val)
				} $else $if field.typ is f64 {
					ret.v[f64](val)
				}
				return
			}
		}
	}
}

// Generic property writer used by generated PHP class handlers.
pub fn generic_set_prop[T](ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
	unsafe {
		name := PhpObjectPropertyHandler.name_from_ptr(name_ptr, name_len)
		mut obj := &T(ptr)
		arg := PhpObjectPropertyHandler.value_from_ptr(value)
		$for field in T.fields {
			if name == field.name {
				$if field.typ is string {
					obj.$(field.name) = arg.get_string()
				} $else $if field.typ is int {
					obj.$(field.name) = int(arg.get_int())
				} $else $if field.typ is i64 {
					obj.$(field.name) = arg.get_int()
				} $else $if field.typ is bool {
					obj.$(field.name) = arg.get_bool()
				} $else $if field.typ is f64 {
					obj.$(field.name) = arg.to_f64()
				}
				return
			}
		}
	}
}

// Generic property sync used before PHP-side object inspection such as var_dump().
pub fn generic_sync_props[T](ptr voidptr, zv &C.zval) {
	unsafe {
		obj := &T(ptr)
		out := PhpObjectPropertyHandler.value_from_ptr(zv)
		$for field in T.fields {
			name := field.name
			val := obj.$(field.name)
			$if field.typ is string {
				out.add_property_string(name, val)
			} $else $if field.typ is int || field.typ is i64 {
				out.add_property_long(name, i64(val))
			} $else $if field.typ is f64 {
				out.add_property_double(name, val)
			} $else $if field.typ is bool {
				out.add_property_bool(name, val)
			}
		}
	}
}
