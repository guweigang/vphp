module vphp

// ======== 空值检查 ========

pub fn (v ZVal) is_valid() bool {
	return v.raw != 0
}

// ======== 类型判断 ========

pub fn (v ZVal) type_raw() int {
	if v.raw == 0 {
		return int(PHPType.undef)
	}
	return C.vphp_get_type(v.raw)
}

pub fn (v ZVal) type_id() PHPType {
	return PHPType.from_id(v.type_raw())
}

pub fn (v ZVal) is_undef() bool {
	return v.type_id() == .undef
}

pub fn (v ZVal) is_null() bool {
	return v.type_id() == .null
}

pub fn (v ZVal) is_bool() bool {
	return v.type_id().is_bool()
}

pub fn (v ZVal) is_long() bool {
	return v.type_id() == .long
}

pub fn (v ZVal) is_double() bool {
	return v.type_id() == .double
}

pub fn (v ZVal) is_numeric() bool {
	return v.type_id().is_numeric()
}

pub fn (v ZVal) is_string() bool {
	return v.type_id() == .string
}

pub fn (v ZVal) is_array() bool {
	return v.type_id() == .array
}

pub fn (v ZVal) is_list() bool {
	if !v.is_array() {
		return false
	}
	if !function_exists('array_is_list') {
		state := v.fold[ListCheckState](ListCheckState{}, fn (key ZVal, _ ZVal, mut acc ListCheckState) {
			if !acc.ok {
				return
			}
			if !key.is_long() || key.to_i64() != acc.expected {
				acc.ok = false
				return
			}
			acc.expected++
		})
		return state.ok
	}
	res := php_fn('array_is_list').call([v])
	return res.is_valid() && res.to_bool()
}

struct ListCheckState {
mut:
	expected i64
	ok       bool = true
}

pub fn (v ZVal) is_object() bool {
	return v.type_id() == .object
}

pub fn (v ZVal) is_resource() bool {
	return v.type_id() == .resource
}

pub fn (v ZVal) is_callable() bool {
	return C.vphp_is_callable(v.raw) == 1
}

pub fn (v ZVal) to_callable() ?Callable {
	if !v.is_callable() {
		return none
	}
	return Callable(v)
}

pub fn (v ZVal) must_callable() !Callable {
	callable := v.to_callable() or { return error('zval is not callable') }
	return callable
}

pub fn (v ZVal) type_name() string {
	return v.type_id().name()
}
