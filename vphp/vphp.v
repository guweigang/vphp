module vphp

import vphp.zend as _

// ============================================
// vphp 核心：入口函数、全局工具、Map 回调
// ============================================

// 调用 PHP 全局函数
pub fn call_php(name string, args []ZVal) ZVal {
	unsafe {
		mut retval := C.zval{}
		mut p_args := &&C.zval(nil)
		if args.len > 0 {
			p_args = &args[0].raw
		}
		C.vphp_call_php_func(&char(name.str), name.len, &retval, args.len, p_args)
		return ZVal{
			raw: &retval
		}
	}
}
