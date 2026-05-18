module vphp

pub struct PhpEnum {
	class PhpClass
}

pub struct PhpEnumCase {
mut:
	object PhpObject
}

pub fn PhpEnum.named(name string) PhpEnum {
	return PhpEnum{
		class: PhpClass.named(name)
	}
}

pub fn PhpEnum.find(name string) ?PhpEnum {
	if !PhpFunction.named('enum_exists').result_bool(PhpString.of(name)) {
		return none
	}
	return PhpEnum.named(name)
}

pub fn (e PhpEnum) name() string {
	return e.class.name()
}

pub fn (e PhpEnum) to_class() PhpClass {
	return e.class
}

pub fn (e PhpEnum) exists() bool {
	return PhpFunction.named('enum_exists').result_bool(PhpString.of(e.name()))
}

pub fn (e PhpEnum) cases() PhpArray {
	mut result := e.class.static_method_request_owned('cases')
	return PhpArray.from_request_owned_zbox(result) or {
		result.release()
		PhpArray.empty()
	}
}

pub fn (e PhpEnum) is_backed() bool {
	return e.class.is_subclass_of('BackedEnum')
}

pub fn PhpEnumCase.from_zval(z ZVal) ?PhpEnumCase {
	if !z.is_object() || !z.is_instance_of('UnitEnum') {
		return none
	}
	return PhpEnumCase{
		object: PhpObject.must_from_zval(z) or { return none }
	}
}

pub fn PhpEnumCase.must_from_zval(z ZVal) !PhpEnumCase {
	case := PhpEnumCase.from_zval(z) or { return error('zval is not enum case') }
	return case
}

pub fn PhpEnumCase.from_persistent_owned_zbox(value PersistentOwnedZBox) ?PhpEnumCase {
	if !value.is_object() || !value.to_zval().is_instance_of('UnitEnum') {
		return none
	}
	object := PhpObject.from_persistent_owned_zbox(value) or { return none }
	return PhpEnumCase{
		object: object
	}
}

pub fn PhpEnumCase.from_persistent_zval(z ZVal) ?PhpEnumCase {
	return PhpEnumCase.from_persistent_owned_zbox(PersistentOwnedZBox.from_persistent_zval(z))
}

pub fn PhpEnumCase.from_request_owned_zbox(value RequestOwnedZBox) ?PhpEnumCase {
	object := PhpObject.from_request_owned_zbox(value) or { return none }
	if !object.to_zval().is_instance_of('UnitEnum') {
		return none
	}
	return PhpEnumCase{
		object: object
	}
}

pub fn (c PhpEnumCase) to_zval() ZVal {
	return c.object.to_zval()
}

pub fn (c PhpEnumCase) to_object() PhpObject {
	return c.object
}

pub fn (c PhpEnumCase) to_borrowed() PhpEnumCase {
	return PhpEnumCase{
		object: c.object.to_borrowed()
	}
}

pub fn (c PhpEnumCase) borrowed() PhpEnumCase {
	return c.to_borrowed()
}

pub fn (c PhpEnumCase) borrow() PhpEnumCase {
	return c.to_borrowed()
}

pub fn (c PhpEnumCase) to_borrowed_zbox() RequestBorrowedZBox {
	return c.object.to_borrowed_zbox()
}

pub fn (c PhpEnumCase) to_request_owned() PhpEnumCase {
	return PhpEnumCase.from_request_owned_zbox(c.object.to_request_owned_zbox()) or {
		c.to_borrowed()
	}
}

pub fn (c PhpEnumCase) owned() PhpEnumCase {
	return c.to_request_owned()
}

pub fn (c PhpEnumCase) to_request_owned_zbox() RequestOwnedZBox {
	return c.object.to_request_owned_zbox()
}

pub fn (c PhpEnumCase) to_persistent_owned() PhpEnumCase {
	return PhpEnumCase.from_persistent_owned_zbox(c.object.to_persistent_owned_zbox()) or {
		c.to_borrowed()
	}
}

pub fn (c PhpEnumCase) retain() PhpEnumCase {
	return c.to_persistent_owned()
}

pub fn (c PhpEnumCase) retained() PhpEnumCase {
	return c.to_persistent_owned()
}

pub fn (c PhpEnumCase) to_persistent_owned_zbox() PersistentOwnedZBox {
	return c.object.to_persistent_owned_zbox()
}

pub fn (c PhpEnumCase) is_borrowed() bool {
	return c.object.is_borrowed()
}

pub fn (c PhpEnumCase) is_owned() bool {
	return c.object.is_owned()
}

pub fn (c PhpEnumCase) is_retained() bool {
	return c.object.is_retained()
}

pub fn (mut c PhpEnumCase) release() {
	c.object.release()
}

pub fn (c PhpEnumCase) enum_name() string {
	return c.object.class_name()
}

pub fn (c PhpEnumCase) name() string {
	return c.object.prop_v[string]('name') or { '' }
}

pub fn (c PhpEnumCase) is_backed() bool {
	return c.object.is_instance_of('BackedEnum')
}

pub fn (c PhpEnumCase) value() ?PhpValue {
	if !c.is_backed() {
		return none
	}
	raw := c.object.prop('value')
	if !raw.is_valid() {
		return none
	}
	return PhpValue.from_zval(raw)
}
