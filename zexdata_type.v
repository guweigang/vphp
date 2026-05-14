module vphp

import vphp.execute

pub struct ZExData {
	handle execute.Handle
}

pub fn ZExData.new(raw &C.zend_execute_data) ZExData {
	return ZExData{
		handle: execute.Handle.from_ptr(raw)
	}
}

pub fn ZExData.from_voidptr(raw voidptr) ZExData {
	return ZExData{
		handle: execute.Handle.from_ptr(raw)
	}
}

pub fn (ex ZExData) raw_ex() &C.zend_execute_data {
	return unsafe { &C.zend_execute_data(ex.handle.raw_ptr()) }
}

fn zend_execute_num_args(ex ZExData) int {
	return ex.handle.num_args()
}

fn zend_execute_arg(ex ZExData, index int) &C.zval {
	return unsafe { &C.zval(ex.handle.arg_ptr(index)) }
}

fn zend_execute_active_class(ex ZExData) ZendClassEntry {
	return ZendClassEntry.from_raw(ex.handle.active_class_ptr())
}

fn zend_execute_this_object(ex ZExData) ZendObject {
	obj_raw := ex.handle.this_object_ptr()
	if obj_raw == 0 {
		return ZendObject.invalid()
	}
	return ZendObject.from_ptr(obj_raw)
}

pub fn (ex ZExData) num_args() int {
	return zend_execute_num_args(ex)
}

pub fn (ex ZExData) arg(index int) ZVal {
	return ex.arg_raw(index)
}

pub fn (ex ZExData) arg_raw(index int) ZVal {
	if index < 0 || index >= ex.num_args() {
		return invalid_zval()
	}
	raw := zend_execute_arg(ex, index)
	if raw == 0 {
		return invalid_zval()
	}
	return ZVal{
		raw: raw
	}
}

pub fn (ex ZExData) arg_or_null(index int) ZVal {
	val := ex.arg(index)
	if !val.is_valid() {
		return ZVal.new_null()
	}
	return val
}

pub fn (ex ZExData) arg_value(index int) PhpValue {
	return PhpValue.from_zval(ex.arg_or_null(index))
}

pub fn (ex ZExData) arg_borrowed_zbox(index int) RequestBorrowedZBox {
	return RequestBorrowedZBox.of(ex.arg_or_null(index))
}

pub fn (ex ZExData) arg_borrowed_zbox_opt(index int) ?RequestBorrowedZBox {
	val := ex.arg(index)
	if !val.is_valid() || val.is_null() || val.is_undef() {
		return none
	}
	return RequestBorrowedZBox.of(val)
}

pub fn (ex ZExData) php_arg(index int, name string) PhpArg {
	return PhpArg.from_zval(index, name, ex.arg(index))
}

pub fn (ex ZExData) php_arg_meta(meta PhpArgMeta) PhpArg {
	return PhpArg.from_meta_zval(meta, ex.arg(meta.index))
}

pub fn (ex ZExData) v_arg[T](index int) T {
	val := ex.arg(index)
	if !val.is_valid() {
		return T{}
	}
	$if T is ZVal {
		return val
	}
	return val.to_v[T]() or { T{} }
}

pub fn (ex ZExData) v_arg_opt[T](index int) ?T {
	val := ex.arg(index)
	if !val.is_valid() || val.is_null() || val.is_undef() {
		return none
	}
	$if T is ZVal {
		return val
	}
	return val.to_v[T]() or { none }
}

pub fn (ex ZExData) args() []ZVal {
	num := ex.num_args()
	mut res := []ZVal{cap: num}
	for i in 0 .. num {
		res << ex.arg(i)
	}
	return res
}

pub fn (ex ZExData) active_class_entry() ZendClassEntry {
	return zend_execute_active_class(ex)
}

pub fn (ex ZExData) active_ce() voidptr {
	return ex.active_class_entry().raw_ptr()
}

pub fn (ex ZExData) this_zend_object() ZendObject {
	return zend_execute_this_object(ex)
}

pub fn (ex ZExData) this_object() voidptr {
	return ex.this_zend_object().raw_ptr()
}
