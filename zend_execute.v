module vphp

import vphp.execute

pub struct ZendExecuteData {
	handle execute.Handle
}

pub fn ZendExecuteData.from_ptr(raw voidptr) ZendExecuteData {
	return ZendExecuteData{
		handle: execute.Handle.from_ptr(raw)
	}
}

pub fn (ex ZendExecuteData) num_args() int {
	return ex.handle.num_args()
}

pub fn (ex ZendExecuteData) arg(index int) ZVal {
	return ex.arg_raw(index)
}

pub fn (ex ZendExecuteData) arg_raw(index int) ZVal {
	if index < 0 || index >= ex.num_args() {
		return invalid_zval()
	}
	return ZVal.from_handle(ex.handle.arg_handle(index))
}

pub fn (ex ZendExecuteData) arg_or_null(index int) ZVal {
	val := ex.arg(index)
	if !val.is_valid() {
		return ZVal.new_null()
	}
	return val
}

pub fn (ex ZendExecuteData) arg_value(index int) PhpValue {
	return PhpValue.from_zval(ex.arg_or_null(index))
}

pub fn (ex ZendExecuteData) arg_borrowed_zbox(index int) RequestBorrowedZBox {
	return RequestBorrowedZBox.of(ex.arg_or_null(index))
}

pub fn (ex ZendExecuteData) arg_borrowed_zbox_opt(index int) ?RequestBorrowedZBox {
	val := ex.arg(index)
	if !val.is_valid() || val.is_null() || val.is_undef() {
		return none
	}
	return RequestBorrowedZBox.of(val)
}

pub fn (ex ZendExecuteData) php_arg(index int, name string) PhpArg {
	return PhpArg.from_zval(index, name, ex.arg(index))
}

pub fn (ex ZendExecuteData) php_arg_meta(meta PhpArgMeta) PhpArg {
	return PhpArg.from_meta_zval(meta, ex.arg(meta.index))
}

pub fn (ex ZendExecuteData) v_arg[T](index int) T {
	val := ex.arg(index)
	if !val.is_valid() {
		return T{}
	}
	$if T is ZVal {
		return val
	}
	return val.to_v[T]() or { T{} }
}

pub fn (ex ZendExecuteData) v_arg_opt[T](index int) ?T {
	val := ex.arg(index)
	if !val.is_valid() || val.is_null() || val.is_undef() {
		return none
	}
	$if T is ZVal {
		return val
	}
	return val.to_v[T]() or { none }
}

pub fn (ex ZendExecuteData) args() []ZVal {
	num := ex.num_args()
	mut res := []ZVal{cap: num}
	for i in 0 .. num {
		res << ex.arg(i)
	}
	return res
}

pub fn (ex ZendExecuteData) active_class_entry() ZendClassEntry {
	return ZendClassEntry.from_ptr(ex.handle.active_class_ptr())
}

pub fn (ex ZendExecuteData) this_zend_object() ZendObject {
	obj_raw := ex.handle.this_object_ptr()
	if obj_raw == 0 {
		return ZendObject.invalid()
	}
	return ZendObject.from_ptr(obj_raw)
}
