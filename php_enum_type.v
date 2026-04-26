module vphp

pub struct PhpEnum {
	class PhpClass
}

pub struct PhpEnumCase {
	object PhpObject
}

pub fn PhpEnum.named(name string) PhpEnum {
	return PhpEnum{
		class: PhpClass.named(name)
	}
}

pub fn PhpEnum.find(name string) ?PhpEnum {
	if !php_fn('enum_exists').call([ZVal.new_string(name)]).to_bool() {
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
	return php_fn('enum_exists').call([ZVal.new_string(e.name())]).to_bool()
}

pub fn (e PhpEnum) cases() PhpArray {
	raw := e.class.static_method('cases', [])
	return PhpArray.must_from_zval(raw) or {
		mut empty := ZVal.new_null()
		empty.array_init()
		PhpArray.must_from_zval(empty) or { panic(err) }
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

pub fn (c PhpEnumCase) to_zval() ZVal {
	return c.object.to_zval()
}

pub fn (c PhpEnumCase) to_object() PhpObject {
	return c.object
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
