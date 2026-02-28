module vphp

import vphp.zend

// 统一映射 zend 常量到 vphp 命名空间
pub const e_error   = zend.e_error
pub const e_warning = zend.e_warning

// 抛出 PHP 异常
pub fn throw_exception(msg string, code int) {
	unsafe { C.vphp_throw(&char(msg.str), code) }
}

// 主动向 PHP 报告错误
pub fn report_error(level int, msg string) {
	unsafe {
		C.vphp_error(level, &char(msg.str))
	}
}
