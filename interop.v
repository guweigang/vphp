module vphp

import vphp.zend as _

// PHP 函数入口。返回一个 callable ZVal，后续可通过 `.call(args)` 调用。
pub fn php_fn(name string) ZVal {
	return ZVal.new_string(name)
}

pub fn function_exists(name string) bool {
	res := php_fn('function_exists').call([ZVal.new_string(name)])
	return res.is_valid() && res.to_bool()
}

// PHP 类入口。返回一个 class-string ZVal，后续可通过 `.construct(args)` 实例化。
pub fn php_class(name string) ZVal {
	return ZVal.new_string(name)
}

pub fn class_exists(name string) bool {
	res := php_fn('class_exists').call([ZVal.new_string(name), ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}

pub fn interface_exists(name string) bool {
	res := php_fn('interface_exists').call([ZVal.new_string(name), ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}

pub fn trait_exists(name string) bool {
	res := php_fn('trait_exists').call([ZVal.new_string(name), ZVal.new_bool(true)])
	return res.is_valid() && res.to_bool()
}

// PHP 常量入口。返回常量值本身。
pub fn php_const(name string) ZVal {
	return php_fn('constant').call([ZVal.new_string(name)])
}

pub fn global_const_exists(name string) bool {
	res := php_fn('defined').call([ZVal.new_string(name)])
	return res.is_valid() && res.to_bool()
}

pub fn json_encode(value ZVal) string {
	return json_encode_with_flags(value, 0)
}

pub fn json_encode_with_flags(value ZVal, flags int) string {
	res := php_fn('json_encode').call([value, ZVal.new_int(flags)])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return ''
	}
	return res.to_string()
}

pub fn json_decode_assoc(raw string) ZVal {
	return php_fn('json_decode').call([ZVal.new_string(raw), ZVal.new_bool(true)])
}

pub fn json_last_error_code() int {
	res := php_fn('json_last_error').call([])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return 0
	}
	return int(res.to_i64())
}

pub fn json_last_error_message() string {
	res := php_fn('json_last_error_msg').call([])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return ''
	}
	return res.to_string()
}

pub fn include(path string) ZVal {
	unsafe {
		mut retval := C.vphp_new_zval()
		res := C.vphp_include_file(&char(path.str), path.len, retval, 0)
		if res == -1 {
			C.vphp_release_zval(retval)
			return ZVal{
				raw: 0
			}
		}
		mut out := ZVal{
			raw: retval
			owned: true
		}
		autorelease_add(out.raw)
		return out
	}
}

pub fn include_once(path string) ZVal {
	unsafe {
		mut retval := C.vphp_new_zval()
		res := C.vphp_include_file(&char(path.str), path.len, retval, 1)
		if res == -1 {
			C.vphp_release_zval(retval)
			return ZVal{
				raw: 0
			}
		}
		mut out := ZVal{
			raw: retval
			owned: true
		}
		autorelease_add(out.raw)
		return out
	}
}

// Compatibility entry point for direct PHP function calls.
// Prefer with_php_call_result_zval()/php_call_request_owned_box() in new code so
// request-owned results stay behind an explicit ownership boundary.
pub fn call_php(name string, args []ZVal) ZVal {
	return php_fn(name).call(args)
}
