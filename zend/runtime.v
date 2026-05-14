module zend

pub fn C.emalloc(size usize) voidptr
pub fn C.efree(ptr voidptr)
fn C.builtin___v_free(ptr voidptr)

pub fn emalloc(size usize) voidptr {
	return C.emalloc(size)
}

pub fn efree(ptr voidptr) {
	C.efree(ptr)
}

pub fn v_runtime_free(ptr voidptr) {
	C.builtin___v_free(ptr)
}

pub fn throw_exception(msg string, code int) {
	unsafe { C.vphp_throw(&char(msg.str), code) }
}

pub fn throw_exception_class(class_name string, msg string, code int) {
	unsafe { C.vphp_throw_class(&char(class_name.str), &char(msg.str), code) }
}

pub fn throw_exception_object(exception &C.zval) {
	C.vphp_throw_object(exception)
}

pub fn has_exception() bool {
	return C.vphp_has_exception()
}

pub fn exception_message() string {
	mut buffer := []u8{len: 2048}
	written := unsafe { C.vphp_exception_message(&char(&buffer[0]), buffer.len) }
	if written <= 0 {
		return ''
	}
	return unsafe { (&char(&buffer[0])).vstring_with_len(written).clone() }
}

pub fn clear_exception() {
	C.vphp_clear_exception()
}

pub fn report_error(level int, msg string) {
	unsafe {
		C.vphp_error(level, &char(msg.str))
	}
}

pub fn output_write(msg string) {
	unsafe {
		C.vphp_output_write(&char(msg.str), msg.len)
	}
}

pub fn framework_init(module_number int) {
	unsafe {
		C.vphp_init_registry()
		C.vphp_init_resource_system(module_number)
		C.vphp_install_runtime_binding_hooks()
	}
}

pub fn uninstall_runtime_binding_hooks() {
	C.vphp_uninstall_runtime_binding_hooks()
}

pub fn autorelease_shutdown() {
	C.vphp_autorelease_shutdown()
}

pub fn shutdown_registry() {
	C.vphp_shutdown_registry()
}

pub fn request_startup() {
	C.vphp_request_startup()
}

pub fn request_shutdown() {
	C.vphp_request_shutdown()
}

pub fn active_globals_ptr() voidptr {
	return C.vphp_get_active_globals()
}

pub fn autorelease_mark() int {
	return C.vphp_autorelease_mark()
}

pub fn autorelease_add(z &C.zval) {
	C.vphp_autorelease_add(z)
}

pub fn autorelease_add_ptr(z voidptr) {
	autorelease_add(unsafe { &C.zval(z) })
}

pub fn autorelease_forget(z &C.zval) {
	C.vphp_autorelease_forget(z)
}

pub fn autorelease_forget_ptr(z voidptr) {
	autorelease_forget(unsafe { &C.zval(z) })
}

pub fn autorelease_drain(mark int) {
	C.vphp_autorelease_drain(mark)
}
