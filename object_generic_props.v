module vphp

// Generic property reader used by generated PHP class handlers.
pub fn generic_get_prop[T](ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
	unsafe {
		name := name_ptr.vstring_with_len(name_len).clone()
		obj := &T(ptr)
		$for field in T.fields {
			if name == field.name {
				val := obj.$(field.name)
				$if field.typ is string {
					return_val_raw(rv, val)
				} $else $if field.typ is int {
					return_val_raw(rv, i64(val))
				} $else $if field.typ is i64 {
					return_val_raw(rv, val)
				} $else $if field.typ is bool {
					return_val_raw(rv, val)
				} $else $if field.typ is f64 {
					return_val_raw(rv, val)
				}
				return
			}
		}
	}
}

// Generic property writer used by generated PHP class handlers.
pub fn generic_set_prop[T](ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
	unsafe {
		name := name_ptr.vstring_with_len(name_len).clone()
		mut obj := &T(ptr)
		arg := ZVal{
			raw: value
		}
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
					obj.$(field.name) = C.vphp_get_double(value)
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
		out := ZVal{
			raw: zv
		}
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
