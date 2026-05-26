module vphp

import vphp.zend as _

pub struct PhpArgMeta {
pub:
	index      int
	name       string
	attributes []PhpAttribute
}

pub struct PhpArg {
pub:
	value PhpValue
	meta  ?PhpArgMeta
}

pub struct PhpArgs {
pub:
	items []PhpArg
}

pub fn PhpArg.new(index int, name string, value PhpValue) PhpArg {
	return PhpArg.from_meta(PhpArgMeta{
		index: index
		name:  name
	}, value)
}

pub fn PhpArg.from_meta(meta PhpArgMeta, value PhpValue) PhpArg {
	return PhpArg{
		value: value
		meta:  meta
	}
}

pub fn PhpArg.from_value(value PhpValue) PhpArg {
	return PhpArg{
		value: value
	}
}

pub fn PhpArg.from_zval(index int, name string, z ZVal) PhpArg {
	val := if z.is_valid() { z } else { ZVal.new_null() }
	return PhpArg.new(index, name, PhpValue.from_zval(val))
}

pub fn PhpArg.from_meta_zval(meta PhpArgMeta, z ZVal) PhpArg {
	val := if z.is_valid() { z } else { ZVal.new_null() }
	return PhpArg.from_meta(meta, PhpValue.from_zval(val))
}

pub fn (meta PhpArgMeta) with_attribute_target(target PhpAttributeTarget) PhpArgMeta {
	mut attrs := []PhpAttribute{cap: meta.attributes.len}
	for attr in meta.attributes {
		if attr.target == .unknown {
			attrs << attr.for_target(target)
		} else {
			attrs << attr
		}
	}
	return PhpArgMeta{
		index:      meta.index
		name:       meta.name
		attributes: attrs
	}
}

pub fn (arg PhpArg) index() int {
	if meta := arg.meta {
		return meta.index
	}
	return -1
}

pub fn (arg PhpArg) name() string {
	if meta := arg.meta {
		return meta.name
	}
	return ''
}

pub fn (arg PhpArg) attributes() []PhpAttribute {
	if meta := arg.meta {
		return meta.attributes
	}
	return []
}

pub fn (arg PhpArg) attr(name string) ?PhpAttribute {
	for attr in arg.attributes() {
		if attr.name == name {
			return attr
		}
	}
	return none
}

pub fn (arg PhpArg) has_attr(name string) bool {
	return arg.attr(name) != none
}

pub fn (arg PhpArg) zval() ZVal {
	return arg.value.to_zval()
}

pub fn (arg PhpArg) to_zval() ZVal {
	return arg.zval()
}

pub fn (arg PhpArg) is_present() bool {
	val := arg.zval()
	return val.is_valid() && !val.is_undef()
}

pub fn (arg PhpArg) zbox() RequestBorrowedZBox {
	return RequestBorrowedZBox.of(arg.zval())
}

pub fn (arg PhpArg) zbox_opt() ?RequestBorrowedZBox {
	val := arg.zval()
	if !val.is_valid() || val.is_null() || val.is_undef() {
		return none
	}
	return RequestBorrowedZBox.of(val)
}

pub fn (arg PhpArg) zval_or_null() ZVal {
	val := arg.zval()
	if !val.is_valid() {
		return ZVal.new_null()
	}
	return val
}

pub fn (arg PhpArg) null_value() ?PhpNull {
	return PhpNull.from_zval(arg.zval())
}

pub fn (arg PhpArg) bool_value() ?PhpBool {
	return PhpBool.from_zval(arg.zval())
}

pub fn (arg PhpArg) int_value() ?PhpInt {
	return PhpInt.from_zval(arg.zval())
}

pub fn (arg PhpArg) double_value() ?PhpDouble {
	return PhpDouble.from_zval(arg.zval())
}

pub fn (arg PhpArg) string_value() ?PhpString {
	return PhpString.from_zval(arg.zval())
}

pub fn (arg PhpArg) scalar() ?PhpScalar {
	return PhpScalar.from_zval(arg.zval())
}

pub fn (arg PhpArg) array() ?PhpArray {
	return PhpArray.from_zval(arg.zval())
}

pub fn (arg PhpArg) object() ?PhpObject {
	return PhpObject.from_zval(arg.zval())
}

pub fn (arg PhpArg) callable() ?PhpCallable {
	return PhpCallable.from_zval(arg.zval())
}

pub fn (arg PhpArg) resource() ?PhpResource {
	return PhpResource.from_zval(arg.zval())
}

pub fn (arg PhpArg) reference() ?PhpReference {
	return PhpReference.from_zval(arg.zval())
}

pub fn (arg PhpArg) iterable() ?PhpIterable {
	return PhpIterable.from_zval(arg.zval())
}

pub fn (arg PhpArg) iterator() ?PhpIterator {
	return PhpIterator.from_zval(arg.zval())
}

pub fn (arg PhpArg) throwable() ?PhpThrowable {
	return PhpThrowable.from_zval(arg.zval())
}

pub fn (arg PhpArg) enum_case() ?PhpEnumCase {
	return PhpEnumCase.from_zval(arg.zval())
}

pub fn (arg PhpArg) request_owned_zbox() RequestOwnedZBox {
	return RequestOwnedZBox.of(arg.zval())
}

pub fn (arg PhpArg) persistent_owned_zbox() PersistentOwnedZBox {
	return PersistentOwnedZBox.of(arg.zval())
}

pub fn (arg PhpArg) as_v[T]() T {
	val := arg.zval()
	if !val.is_valid() {
		return T{}
	}
	$if T is ZVal {
		return val
	}
	return val.to_v[T]() or { T{} }
}

pub fn (arg PhpArg) as_v_opt[T]() ?T {
	val := arg.zval()
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
	val := arg.zval()
	return ZendObject.from_zval(val).bound_v_ptr()
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
		if arg.name() == name {
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

pub fn (args PhpArgs) as_variadic_v[T](start_index int) []T {
	if start_index < 0 || start_index >= args.items.len {
		return []T{}
	}
	mut res := []T{cap: args.items.len - start_index}
	for i := start_index; i < args.items.len; i++ {
		res << args.items[i].as_v[T]()
	}
	return res
}
