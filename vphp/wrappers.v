module vphp

// 辅助：获取对象指针
fn get_object_ptr[T](ex &C.zend_execute_data) &T {
	unsafe {
		// 调用 C 桥接函数获取 this 指针
		ptr := C.vphp_get_this_object(ex)
		return &T(ptr)
	}
}

// 包装器 1: Void 方法
pub fn wrap_void[T](method VoidMethod[T]) ZifHandler {
	return fn [method] (ex &C.zend_execute_data, ret &C.zval) {
		ctx := Context{ex: ex, ret: ret}
		mut obj := *get_object_ptr[T](ex) // 获取 V 结构体引用
		method(obj, ctx)
	}
}

// 包装器 2: Val 方法
pub fn wrap_val[T](method ValMethod[T]) ZifHandler {
	return fn [method] (ex &C.zend_execute_data, ret &C.zval) {
		ctx := Context{ex: ex, ret: ret}
		mut obj := *get_object_ptr[T](ex)
		res := method(obj, ctx)
		unsafe { C.vphp_return_val(ret, res.raw) }
	}
}