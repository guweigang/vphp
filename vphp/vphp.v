module vphp
import vphp.zend as _

// ============================================
// vphp 核心：入口函数、全局工具、Map 回调
// ============================================



// 获取当前 PHP 函数调用的所有参数
pub fn get_args(ex &C.zend_execute_data) []Val {
	num := int(C.vphp_get_num_args(ex))
	mut res := []Val{}
	for i in 1 .. (num + 1) { // PHP 参数从 1 开始
		res << Val{ raw: C.vphp_get_arg_ptr(ex, u32(i)) }
	}
	return res
}

// 创建 Context 实例
pub fn new_context(ex &C.zend_execute_data, ret &C.zval) Context {
	return unsafe {
		Context{
			ex: ex
			ret: ret
		}
	}
}



// 调用 PHP 全局函数
pub fn call_php(name string, args []Val) Val {
	unsafe {
		mut retval := C.zval{}
		mut p_args := &&C.zval(nil)
		if args.len > 0 {
			p_args = &args[0].raw
		}
		C.vphp_call_php_func(&char(name.str), name.len, &retval, args.len, p_args)
		return Val{ raw: &retval }
	}
}


