module vphp

pub fn (ret PhpReturn) list[T](list []T) {
	out := ret.to_zval()
	out.array_init()
	for item in list {
		$if T is string {
			out.push_string(item)
		} $else $if T is f64 {
			out.push_double(item)
		} $else $if T is int || T is i64 {
			out.push_long(i64(item))
		} $else {
			out.push_struct(item)
		}
	}
}

pub fn (ret PhpReturn) map_value[T](m map[string]T) {
	out := ret.to_zval()
	out.array_init()
	for k, v in m {
		$if T is string {
			out.add_assoc_string(k, v)
		} $else $if T is int || T is i64 {
			out.add_assoc_long(k, i64(v))
		} $else $if T is f64 {
			out.add_assoc_double(k, v)
		} $else $if T is bool {
			out.add_assoc_bool(k, v)
		}
	}
}

pub fn (ret PhpReturn) object_props(props map[string]string) {
	out := ret.to_zval()
	out.object_init()
	for k, v in props {
		out.update_property_string(k, v)
	}
}

pub fn (ret PhpReturn) struct_value[T](s T) {
	out := ret.to_zval()
	out.array_init()
	$for field in T.fields {
		key := field.name
		$if field.typ is string {
			out.add_assoc_string(key, s.$(field.name))
		} $else $if field.typ is f64 {
			out.add_assoc_double(key, s.$(field.name))
		} $else $if field.typ is int || field.typ is i64 {
			out.add_assoc_long(key, i64(s.$(field.name)))
		} $else $if field.typ is bool {
			out.add_assoc_bool(key, s.$(field.name))
		}
	}
}
