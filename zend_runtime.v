module vphp

import vphp.zend as _

fn zend_throw_exception(msg string, code int) {
	unsafe { C.vphp_throw(&char(msg.str), code) }
}

fn zend_throw_exception_class(class_name string, msg string, code int) {
	unsafe { C.vphp_throw_class(&char(class_name.str), &char(msg.str), code) }
}

fn zend_throw_exception_object(exception &C.zval) {
	C.vphp_throw_object(exception)
}

fn zend_has_exception() bool {
	return C.vphp_has_exception()
}

fn zend_exception_message() string {
	mut buffer := []u8{len: 2048}
	written := unsafe { C.vphp_exception_message(&char(&buffer[0]), buffer.len) }
	if written <= 0 {
		return ''
	}
	return unsafe { (&char(&buffer[0])).vstring_with_len(written).clone() }
}

fn zend_clear_exception() {
	C.vphp_clear_exception()
}

fn zend_report_error(level int, msg string) {
	unsafe {
		C.vphp_error(level, &char(msg.str))
	}
}

fn zend_output_write(msg string) {
	unsafe {
		C.vphp_output_write(&char(msg.str), msg.len)
	}
}

fn zend_framework_init(module_number int) {
	unsafe {
		C.vphp_init_registry()
		C.vphp_init_resource_system(module_number)
		C.vphp_install_runtime_binding_hooks()
	}
}

fn zend_uninstall_runtime_binding_hooks() {
	C.vphp_uninstall_runtime_binding_hooks()
}

fn zend_autorelease_shutdown() {
	C.vphp_autorelease_shutdown()
}

fn zend_shutdown_registry() {
	C.vphp_shutdown_registry()
}

fn zend_request_startup() {
	C.vphp_request_startup()
}

fn zend_request_shutdown() {
	C.vphp_request_shutdown()
}
