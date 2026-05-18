module vphp

pub struct PhpObjectBinding {
pub:
	class_entry ZendClassEntry
	handlers    voidptr
}

pub fn PhpObjectBinding.from_entry(class_entry ZendClassEntry, handlers voidptr) PhpObjectBinding {
	return PhpObjectBinding{
		class_entry: class_entry
		handlers:    handlers
	}
}

pub fn PhpObjectBinding.from_ptr(class_entry voidptr, handlers voidptr) PhpObjectBinding {
	return PhpObjectBinding.from_entry(ZendClassEntry.from_ptr(class_entry), handlers)
}

pub fn PhpObjectBinding.new[T]() PhpObjectBinding {
	return PhpObjectBinding.from_entry(T.php_class_entry(), T.php_object_handlers())
}

pub fn (binding PhpObjectBinding) is_valid() bool {
	return binding.class_entry.is_valid() && binding.handlers != 0
}
