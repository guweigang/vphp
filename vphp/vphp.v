module vphp
import vphp.zend

// 主动向 PHP 报告错误
pub fn report_error(level int, msg string) {
  unsafe {
    C.vphp_error(level, &char(msg.str))
  }
}

pub fn get_args(ex &C.zend_execute_data) []Val {
    num := int(C.vphp_get_num_args(ex))
    mut res := []Val{}
    for i in 1 .. (num + 1) { // PHP 参数从 1 开始
        res << Val{ raw: C.vphp_get_arg_ptr(ex, u32(i)) }
    }
    return res
}

pub fn new_context(ex &C.zend_execute_data, ret &C.zval) Context {
	return unsafe {
		Context{
			ex: ex
			ret: ret
		}
	}
}

struct MapContext {
mut:
	m map[string]string
}

// 2. 修改 map_callback 的定义，让它的第一个参数是 voidptr
fn map_callback(p_ctx voidptr, key &char, val &C.zval) {
    // 手动转回 MapContext 指针
    mut ctx := unsafe { &MapContext(p_ctx) }

    v_key := unsafe { key.vstring() }
    v_val := unsafe { Val{ raw: val }.to_string() }

    // 直接操作
    ctx.m[v_key] = v_val
}

pub fn call_php(name string, args []Val) Val {
	unsafe {
		mut retval := C.zval{}
		// 修正：V 不允许 &&C.zval(0)，我们改用这种方式
		mut p_args := &&C.zval( nil )
		if args.len > 0 {
			p_args = &args[0].raw
		}

		C.vphp_call_php_func(&char(name.str), name.len, &retval, args.len, p_args)
		return Val{ raw: &retval }
	}
}


// 因为 C 不懂泛型，我们通过 voidptr 传递 V 数组的地址
fn array_push_handler[T](mut res []T, val &C.zval) {
    $if T is f64 {
        res << C.vphp_get_double(val)
    } $else $if T is int || T is i64 {
        res << i64(C.vphp_get_int(val))
    } $else $if T is string {
        res << C.vphp_get_string(val).v_str() // 假设你已有 zval 转 string 的封装
    }
}
