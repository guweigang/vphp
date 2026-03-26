module vphp

import vphp.zend

// 统一映射 zend 常量到 vphp 命名空间
pub const e_error   = zend.e_error
pub const e_warning = zend.e_warning

pub enum InteropErrorClass {
	worker_runtime_error
	app_contract_error
	invalid_argument
	type_mismatch
	conversion_error
	include_error
	symbol_not_found
}

pub fn (c InteropErrorClass) str() string {
	return match c {
		.worker_runtime_error { 'worker_runtime_error' }
		.app_contract_error { 'app_contract_error' }
		.invalid_argument { 'invalid_argument' }
		.type_mismatch { 'type_mismatch' }
		.conversion_error { 'conversion_error' }
		.include_error { 'include_error' }
		.symbol_not_found { 'symbol_not_found' }
	}
}

// 抛出 PHP 异常
pub fn throw_exception(msg string, code int) {
	unsafe { C.vphp_throw(&char(msg.str), code) }
}

pub fn throw_exception_class(class_name string, msg string, code int) {
	unsafe { C.vphp_throw_class(&char(class_name.str), &char(msg.str), code) }
}

// 抛出带稳定错误分类前缀的 PHP 异常
pub fn throw_interop_error(class InteropErrorClass, msg string, code int) {
	throw_exception('[${class.str()}] ${msg}', code)
}

// 将 V error 映射到 PHP exception，保留错误分类
pub fn throw_from_error(class InteropErrorClass, err IError, code int) {
	throw_interop_error(class, err.msg(), code)
}

// 主动向 PHP 报告错误
pub fn report_error(level int, msg string) {
	unsafe {
		C.vphp_error(level, &char(msg.str))
	}
}
