module vphp

import vphp.object

pub struct PhpObjectBinding {
pub:
	class_entry ZendClassEntry
	handlers    object.ObjectHandlers
}

pub fn PhpObjectBinding.from_entry(class_entry ZendClassEntry, handlers object.ObjectHandlers) PhpObjectBinding {
	return PhpObjectBinding{
		class_entry: class_entry
		handlers:    handlers
	}
}

pub fn PhpObjectBinding.from_ptr(class_entry voidptr, handlers object.ObjectHandlers) PhpObjectBinding {
	return PhpObjectBinding.from_entry(ZendClassEntry.from_ptr(class_entry), handlers)
}

pub fn PhpObjectBinding.new[T]() PhpObjectBinding {
	return PhpObjectBinding.from_entry(T.php_class_entry(), T.php_object_handlers())
}

pub fn (binding PhpObjectBinding) is_valid() bool {
	return binding.class_entry.is_valid() && binding.handlers.is_valid()
}

pub fn bind_object_zval[T](v_ptr voidptr, ownership OwnershipKind) ZVal {
	mut value := PhpValue.null()
	binding := PhpObjectBinding.new[T]()
	if v_ptr == 0 || !binding.is_valid() {
		return value.take_zval()
	}
	PhpReturn.from_zval(value.to_zval()).bound_object(v_ptr, binding.class_entry, binding.handlers,
		ownership)
	return value.take_zval()
}

pub fn bind_object_value[T](v_ptr voidptr, ownership OwnershipKind) PhpValue {
	return PhpValue.adopt_zval(bind_object_zval[T](v_ptr, ownership))
}

pub fn bind_borrowed_object_zval[T](obj &T) ZVal {
	return bind_object_zval[T](obj, .borrowed)
}

pub fn bind_borrowed_object_value[T](obj &T) PhpValue {
	return bind_object_value[T](obj, .borrowed)
}

pub fn bind_owned_object_zval[T](obj &T) ZVal {
	return bind_object_zval[T](obj, .owned_request)
}

pub fn bind_owned_object_value[T](obj &T) PhpValue {
	return bind_object_value[T](obj, .owned_request)
}
