module vphp

pub struct PhpConst {
	name string
}

pub fn PhpConst.named(name string) PhpConst {
	return PhpConst{
		name: name
	}
}

pub fn PhpConst.find(name string) ?PhpConst {
	constant := PhpConst.named(name)
	if !constant.exists() {
		return none
	}
	return constant
}

pub fn (constant PhpConst) name() string {
	return constant.name
}

pub fn (constant PhpConst) exists() bool {
	return PhpFunction.named('defined').result_bool(PhpString.of(constant.name))
}

pub fn (constant PhpConst) value() ZVal {
	mut result := PhpFunction.named('constant').request_owned(PhpString.of(constant.name))
	return result.take_zval()
}

pub fn (constant PhpConst) to_zval() ZVal {
	return constant.value()
}

pub fn (constant PhpConst) value_v[T]() !T {
	return constant.value().to_v[T]()
}

// PHP constant entry. Return the constant value itself.
pub fn php_const(name string) ZVal {
	return PhpConst.named(name).value()
}

pub fn global_const_exists(name string) bool {
	return PhpConst.named(name).exists()
}
