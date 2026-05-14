module vphp

import vphp.zend
import vphp.zval

fn zend_emalloc(size usize) voidptr {
	return zend.emalloc(size)
}

fn zend_efree(ptr voidptr) {
	zend.efree(ptr)
}

fn zend_throw_exception(msg string, code int) {
	zend.throw_exception(msg, code)
}

fn zend_throw_exception_class(class_name string, msg string, code int) {
	zend.throw_exception_class(class_name, msg, code)
}

fn zend_throw_exception_object(exception zval.Handle) {
	zend.throw_exception_object_ptr(exception.raw_ptr())
}

fn zend_has_exception() bool {
	return zend.has_exception()
}

fn zend_exception_message() string {
	return zend.exception_message()
}

fn zend_clear_exception() {
	zend.clear_exception()
}

fn zend_report_error(level int, msg string) {
	zend.report_error(level, msg)
}

fn zend_output_write(msg string) {
	zend.output_write(msg)
}

fn zend_framework_init(module_number int) {
	zend.framework_init(module_number)
}

fn zend_uninstall_runtime_binding_hooks() {
	zend.uninstall_runtime_binding_hooks()
}

fn zend_autorelease_shutdown() {
	zend.autorelease_shutdown()
}

fn zend_shutdown_registry() {
	zend.shutdown_registry()
}

fn zend_request_startup() {
	zend.request_startup()
}

fn zend_request_shutdown() {
	zend.request_shutdown()
}

fn zend_active_globals_ptr() voidptr {
	return zend.active_globals_ptr()
}

fn zend_autorelease_mark() int {
	return zend.autorelease_mark()
}

fn zend_autorelease_drain(mark int) {
	zend.autorelease_drain(mark)
}
