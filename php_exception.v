module vphp

import vphp.zend

// 统一映射 zend 常量到 vphp 命名空间
pub const e_error = zend.e_error
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

pub struct PhpException {}

pub fn PhpException.raise(msg string, code int) {
	unsafe { C.vphp_throw(&char(msg.str), code) }
}

pub fn PhpException.raise_class(class_name string, msg string, code int) {
	unsafe { C.vphp_throw_class(&char(class_name.str), &char(msg.str), code) }
}

pub fn PhpException.raise_object(mut exception ZVal) {
	if !exception.is_valid() || !exception.is_object() {
		PhpException.raise('exception object must be a valid object', 0)
		return
	}
	unsafe {
		C.vphp_disown_zval(exception.raw)
		C.vphp_throw_object(exception.raw)
	}
	exception.raw = unsafe { nil }
	exception.owned = false
}

pub fn PhpException.has_current() bool {
	return C.vphp_has_exception()
}

pub fn PhpException.current_message() string {
	mut buffer := []u8{len: 2048}
	written := unsafe { C.vphp_exception_message(&char(&buffer[0]), buffer.len) }
	if written <= 0 {
		return ''
	}
	return unsafe { (&char(&buffer[0])).vstring_with_len(written).clone() }
}

pub fn PhpException.clear() {
	C.vphp_clear_exception()
}

pub fn PhpException.raise_interop(class InteropErrorClass, msg string, code int) {
	PhpException.raise('[${class.str()}] ${msg}', code)
}

pub fn PhpException.raise_from_error(class InteropErrorClass, err IError, code int) {
	PhpException.raise_interop(class, err.msg(), code)
}

pub fn PhpException.report(level int, msg string) {
	unsafe {
		C.vphp_error(level, &char(msg.str))
	}
}

// 抛出 PHP 异常
pub fn throw_exception(msg string, code int) {
	PhpException.raise(msg, code)
}

pub fn throw_exception_class(class_name string, msg string, code int) {
	PhpException.raise_class(class_name, msg, code)
}

pub fn throw_exception_object(mut exception ZVal) {
	PhpException.raise_object(mut exception)
}

pub fn has_exception() bool {
	return PhpException.has_current()
}

pub fn current_exception_message() string {
	return PhpException.current_message()
}

pub fn clear_exception() {
	PhpException.clear()
}

// 抛出带稳定错误分类前缀的 PHP 异常
pub fn throw_interop_error(class InteropErrorClass, msg string, code int) {
	PhpException.raise_interop(class, msg, code)
}

// 将 V error 映射到 PHP exception，保留错误分类
pub fn throw_from_error(class InteropErrorClass, err IError, code int) {
	PhpException.raise_from_error(class, err, code)
}

// 主动向 PHP 报告错误
pub fn report_error(level int, msg string) {
	PhpException.report(level, msg)
}
