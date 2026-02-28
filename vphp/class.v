module vphp

pub struct Class[T] {
pub mut:
	name    string
	methods []MethodDef
}

pub fn new_class[T](name string) &Class[T] {
	return &Class[T]{ name: name }
}

// 显式添加 Void 方法
pub fn (mut c Class[T]) add_void(name string, method VoidMethod[T]) {
	handler := wrap_void[T](method)
	c.methods << MethodDef{
		name: name.str
		handler: handler
	}
}

// 显式添加 Val 方法
pub fn (mut c Class[T]) add_val(name string, method ValMethod[T]) {
	handler := wrap_val[T](method)
	c.methods << MethodDef{
		name: name.str
		handler: handler
	}
}

// 最终注册
pub fn (mut c Class[T]) register() {
	unsafe {
		// 将方法数组的指针传给 C
		C.vphp_register_internal_class(c.name.str, c.methods.data, c.methods.len)
	}
}