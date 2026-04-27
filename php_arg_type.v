module vphp

import vphp.zend as _

pub struct PhpArgMeta {
pub:
	index int
	name  string
}

pub struct PhpArg {
pub:
	index int
	name  string
	value PhpValue
}

pub struct PhpArgs {
pub:
	items []PhpArg
}

pub fn PhpArg.new(index int, name string, value PhpValue) PhpArg {
	return PhpArg{
		index: index
		name:  name
		value: value
	}
}

pub fn PhpArg.from_zval(index int, name string, z ZVal) PhpArg {
	val := if z.is_valid() { z } else { ZVal.new_null() }
	return PhpArg.new(index, name, PhpValue.from_zval(val))
}

pub fn (arg PhpArg) raw() ZVal {
	return arg.value.to_zval()
}

pub fn (arg PhpArg) is_present() bool {
	val := arg.raw()
	return val.is_valid() && !val.is_undef()
}

pub fn (arg PhpArg) zbox() RequestBorrowedZBox {
	return RequestBorrowedZBox.of(arg.raw())
}

pub fn (arg PhpArg) zbox_opt() ?RequestBorrowedZBox {
	val := arg.raw()
	if !val.is_valid() || val.is_null() || val.is_undef() {
		return none
	}
	return RequestBorrowedZBox.of(val)
}

pub fn (arg PhpArg) val() ZVal {
	val := arg.raw()
	if !val.is_valid() {
		return ZVal.new_null()
	}
	return val
}

pub fn (arg PhpArg) null_value() ?PhpNull {
	return PhpNull.from_zval(arg.raw())
}

pub fn (arg PhpArg) bool_value() ?PhpBool {
	return PhpBool.from_zval(arg.raw())
}

pub fn (arg PhpArg) int_value() ?PhpInt {
	return PhpInt.from_zval(arg.raw())
}

pub fn (arg PhpArg) double_value() ?PhpDouble {
	return PhpDouble.from_zval(arg.raw())
}

pub fn (arg PhpArg) string_value() ?PhpString {
	return PhpString.from_zval(arg.raw())
}

pub fn (arg PhpArg) scalar() ?PhpScalar {
	return PhpScalar.from_zval(arg.raw())
}

pub fn (arg PhpArg) array() ?PhpArray {
	return PhpArray.from_zval(arg.raw())
}

pub fn (arg PhpArg) object() ?PhpObject {
	return PhpObject.from_zval(arg.raw())
}

pub fn (arg PhpArg) callable() ?PhpCallable {
	return PhpCallable.from_zval(arg.raw())
}

pub fn (arg PhpArg) resource() ?PhpResource {
	return PhpResource.from_zval(arg.raw())
}

pub fn (arg PhpArg) reference() ?PhpReference {
	return PhpReference.from_zval(arg.raw())
}

pub fn (arg PhpArg) iterable() ?PhpIterable {
	return PhpIterable.from_zval(arg.raw())
}

pub fn (arg PhpArg) throwable() ?PhpThrowable {
	return PhpThrowable.from_zval(arg.raw())
}

pub fn (arg PhpArg) enum_case() ?PhpEnumCase {
	return PhpEnumCase.from_zval(arg.raw())
}

pub fn (arg PhpArg) request_owned_zbox() RequestOwnedZBox {
	return RequestOwnedZBox.of(arg.raw())
}

pub fn (arg PhpArg) persistent_owned_zbox() PersistentOwnedZBox {
	return PersistentOwnedZBox.of(arg.raw())
}

pub fn (arg PhpArg) as_v[T]() T {
	val := arg.raw()
	if !val.is_valid() {
		return T{}
	}
	$if T is ZVal {
		return val
	}
	return val.to_v[T]() or { T{} }
}

pub fn (arg PhpArg) as_v_opt[T]() ?T {
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

pub fn (arg PhpArg) raw_obj() voidptr {
	val := arg.raw()
	if !val.is_valid() || !val.is_object() {
		return unsafe { nil }
	}
	obj := C.vphp_get_obj_from_zval(val.raw)
	wrapper := C.vphp_obj_from_obj(obj)
	return wrapper.v_ptr
}

pub fn PhpArgs.new(items []PhpArg) PhpArgs {
	return PhpArgs{
		items: items
	}
}

pub fn (args PhpArgs) len() int {
	return args.items.len
}

pub fn (args PhpArgs) has(index int) bool {
	return index >= 0 && index < args.items.len && args.items[index].is_present()
}

pub fn (args PhpArgs) at(index int) PhpArg {
	if index >= 0 && index < args.items.len {
		return args.items[index]
	}
	return PhpArg.from_zval(index, '', ZVal.new_null())
}

pub fn (args PhpArgs) named(name string) ?PhpArg {
	for arg in args.items {
		if arg.name == name {
			return arg
		}
	}
	return none
}

pub fn (args PhpArgs) has_named_or_index(index int, name string) bool {
	if name != '' {
		if arg := args.named(name) {
			if arg.is_present() {
				return true
			}
		}
	}
	return args.has(index)
}

pub fn (args PhpArgs) at_named_or_index(index int, name string) PhpArg {
	if name != '' {
		if arg := args.named(name) {
			if arg.is_present() {
				return arg
			}
		}
	}
	return args.at(index)
}
