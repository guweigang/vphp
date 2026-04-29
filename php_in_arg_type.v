module vphp

import vphp.zend as _

pub struct PhpInArgMeta {
pub:
	index int
	name  string
}

pub struct PhpInArg {
pub:
	value PhpValue
	meta  ?PhpInArgMeta
}

pub struct PhpInArgs {
pub:
	items []PhpInArg
}

pub fn PhpInArg.new(index int, name string, value PhpValue) PhpInArg {
	return PhpInArg{
		value: value
		meta:  PhpInArgMeta{
			index: index
			name:  name
		}
	}
}

pub fn PhpInArg.from_value(value PhpValue) PhpInArg {
	return PhpInArg{
		value: value
	}
}

pub fn PhpInArg.from_zval(index int, name string, z ZVal) PhpInArg {
	val := if z.is_valid() { z } else { ZVal.new_null() }
	return PhpInArg.new(index, name, PhpValue.from_zval(val))
}

pub fn (arg PhpInArg) index() int {
	if meta := arg.meta {
		return meta.index
	}
	return -1
}

pub fn (arg PhpInArg) name() string {
	if meta := arg.meta {
		return meta.name
	}
	return ''
}

pub fn (arg PhpInArg) raw() ZVal {
	return arg.value.to_zval()
}

pub fn (arg PhpInArg) to_zval() ZVal {
	return arg.raw()
}

pub fn (arg PhpInArg) is_present() bool {
	val := arg.raw()
	return val.is_valid() && !val.is_undef()
}

pub fn (arg PhpInArg) zbox() RequestBorrowedZBox {
	return RequestBorrowedZBox.of(arg.raw())
}

pub fn (arg PhpInArg) zbox_opt() ?RequestBorrowedZBox {
	val := arg.raw()
	if !val.is_valid() || val.is_null() || val.is_undef() {
		return none
	}
	return RequestBorrowedZBox.of(val)
}

pub fn (arg PhpInArg) val() ZVal {
	val := arg.raw()
	if !val.is_valid() {
		return ZVal.new_null()
	}
	return val
}

pub fn (arg PhpInArg) null_value() ?PhpNull {
	return PhpNull.from_zval(arg.raw())
}

pub fn (arg PhpInArg) bool_value() ?PhpBool {
	return PhpBool.from_zval(arg.raw())
}

pub fn (arg PhpInArg) int_value() ?PhpInt {
	return PhpInt.from_zval(arg.raw())
}

pub fn (arg PhpInArg) double_value() ?PhpDouble {
	return PhpDouble.from_zval(arg.raw())
}

pub fn (arg PhpInArg) string_value() ?PhpString {
	return PhpString.from_zval(arg.raw())
}

pub fn (arg PhpInArg) scalar() ?PhpScalar {
	return PhpScalar.from_zval(arg.raw())
}

pub fn (arg PhpInArg) array() ?PhpArray {
	return PhpArray.from_zval(arg.raw())
}

pub fn (arg PhpInArg) object() ?PhpObject {
	return PhpObject.from_zval(arg.raw())
}

pub fn (arg PhpInArg) callable() ?PhpCallable {
	return PhpCallable.from_zval(arg.raw())
}

pub fn (arg PhpInArg) resource() ?PhpResource {
	return PhpResource.from_zval(arg.raw())
}

pub fn (arg PhpInArg) reference() ?PhpReference {
	return PhpReference.from_zval(arg.raw())
}

pub fn (arg PhpInArg) iterable() ?PhpIterable {
	return PhpIterable.from_zval(arg.raw())
}

pub fn (arg PhpInArg) throwable() ?PhpThrowable {
	return PhpThrowable.from_zval(arg.raw())
}

pub fn (arg PhpInArg) enum_case() ?PhpEnumCase {
	return PhpEnumCase.from_zval(arg.raw())
}

pub fn (arg PhpInArg) request_owned_zbox() RequestOwnedZBox {
	return RequestOwnedZBox.of(arg.raw())
}

pub fn (arg PhpInArg) persistent_owned_zbox() PersistentOwnedZBox {
	return PersistentOwnedZBox.of(arg.raw())
}

pub fn (arg PhpInArg) as_v[T]() T {
	val := arg.raw()
	if !val.is_valid() {
		return T{}
	}
	$if T is ZVal {
		return val
	}
	return val.to_v[T]() or { T{} }
}

pub fn (arg PhpInArg) as_v_opt[T]() ?T {
	val := arg.raw()
	if !val.is_valid() || val.is_null() || val.is_undef() {
		return none
	}
	$if T is ZVal {
		return val
	}
	if converted := val.to_v[T]() {
		return converted
	}
	return none
}

pub fn (arg PhpInArg) raw_obj() voidptr {
	val := arg.raw()
	if !val.is_valid() || !val.is_object() {
		return unsafe { nil }
	}
	obj := C.vphp_get_obj_from_zval(val.raw)
	wrapper := C.vphp_obj_from_obj(obj)
	return wrapper.v_ptr
}

pub fn PhpInArgs.new(items []PhpInArg) PhpInArgs {
	return PhpInArgs{
		items: items
	}
}

pub fn (args PhpInArgs) len() int {
	return args.items.len
}

pub fn (args PhpInArgs) has(index int) bool {
	return index >= 0 && index < args.items.len && args.items[index].is_present()
}

pub fn (args PhpInArgs) at(index int) PhpInArg {
	if index >= 0 && index < args.items.len {
		return args.items[index]
	}
	return PhpInArg.from_zval(index, '', ZVal.new_null())
}

pub fn (args PhpInArgs) named(name string) ?PhpInArg {
	for arg in args.items {
		if arg.name() == name {
			return arg
		}
	}
	return none
}

pub fn (args PhpInArgs) has_named_or_index(index int, name string) bool {
	if name != '' {
		if arg := args.named(name) {
			if arg.is_present() {
				return true
			}
		}
	}
	return args.has(index)
}

pub fn (args PhpInArgs) at_named_or_index(index int, name string) PhpInArg {
	if name != '' {
		if arg := args.named(name) {
			if arg.is_present() {
				return arg
			}
		}
	}
	return args.at(index)
}
