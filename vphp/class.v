module vphp

// ============================================
// Class — PHP 类的 V 侧定义与运行时泛型 Handler
// ============================================

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
		C.vphp_register_internal_class(c.name.str, c.methods.data, c.methods.len)
	}
}

// ============================================
// 运行时泛型 Handler
// 利用 V 的编译期反射 ($for field in T.fields)
// 替代 codegen 生成的 glue 代码
// ============================================

// 泛型属性读取器 — 替代生成的 Article_get_prop 等函数
pub fn generic_get_prop[T](ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
	unsafe {
		name := name_ptr.vstring_with_len(name_len)
		obj := &T(ptr)
		$for field in T.fields {
			if name == field.name {
				val := obj.$(field.name)
				$if field.typ is string {
					return_val_raw(rv, val)
				} $else $if field.typ is int {
					return_val_raw(rv, i64(val))
				} $else $if field.typ is i64 {
					return_val_raw(rv, val)
				} $else $if field.typ is bool {
					return_val_raw(rv, val)
				} $else $if field.typ is f64 {
					return_val_raw(rv, val)
				}
				return
			}
		}
	}
}

// 泛型属性写入器 — 替代生成的 Article_set_prop 等函数
pub fn generic_set_prop[T](ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
	unsafe {
		name := name_ptr.vstring_with_len(name_len)
		mut obj := &T(ptr)
		arg := Val{ raw: value }
		$for field in T.fields {
			if name == field.name {
				$if field.typ is string {
					obj.$(field.name) = arg.get_string()
				} $else $if field.typ is int {
					obj.$(field.name) = int(arg.get_int())
				} $else $if field.typ is i64 {
					obj.$(field.name) = arg.get_int()
				} $else $if field.typ is bool {
					obj.$(field.name) = arg.get_bool()
				} $else $if field.typ is f64 {
					obj.$(field.name) = C.vphp_get_double(value)
				}
				return
			}
		}
	}
}

// 泛型同步器 — 用于 var_dump() 时将 V 内存同步到 PHP 属性表
pub fn generic_sync_props[T](ptr voidptr, zv &C.zval) {
	unsafe {
		mut obj := &T(ptr)
		ctx := Context{ ex: 0, ret: zv }
		ctx.sync_props(obj)
	}
}

// 泛型堆分配器
pub fn generic_new_raw[T]() voidptr {
	return unsafe { &T{} }
}