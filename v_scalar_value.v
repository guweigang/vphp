module vphp

pub type VScalarValue = bool | f64 | i64 | string

pub fn VScalarValue.from_zval(z ZVal) !VScalarValue {
	if !z.is_valid() || z.is_undef() || z.is_null() {
		return error('expected V scalar, got ${z.type_name()}')
	}
	if z.is_bool() {
		return VScalarValue(z.to_bool())
	}
	if z.is_long() {
		return VScalarValue(z.to_i64())
	}
	if z.is_double() {
		return VScalarValue(z.to_f64())
	}
	if z.is_string() {
		return VScalarValue(z.to_string())
	}
	return error('expected V scalar, got ${z.type_name()}')
}

pub fn (v VScalarValue) to_zval() ZVal {
	return match v {
		bool { ZVal.new_bool(v) }
		f64 { ZVal.new_float(v) }
		i64 { ZVal.new_int(v) }
		string { ZVal.new_string(v) }
	}
}

pub fn (v VScalarValue) to_bool() bool {
	return match v {
		bool { v }
		f64 { v != 0 }
		i64 { v != 0 }
		string { v != '' && v != '0' }
	}
}

pub fn (v VScalarValue) to_i64() i64 {
	return match v {
		bool {
			if v {
				i64(1)
			} else {
				i64(0)
			}
		}
		f64 {
			i64(v)
		}
		i64 {
			v
		}
		string {
			v.i64()
		}
	}
}

pub fn (v VScalarValue) to_f64() f64 {
	return match v {
		bool {
			if v {
				f64(1)
			} else {
				f64(0)
			}
		}
		f64 {
			v
		}
		i64 {
			f64(v)
		}
		string {
			v.f64()
		}
	}
}

pub fn (v VScalarValue) str() string {
	return v.to_string()
}

pub fn (v VScalarValue) to_string() string {
	return match v {
		bool { v.str() }
		f64 { v.str() }
		i64 { v.str() }
		string { v }
	}
}
