module vphp

import vphp.zend

// -------- 类元信息 / introspection --------
pub fn (v ZVal) class_name() string {
	if !v.is_valid() {
		return ''
	}
	if v.is_string() {
		return v.to_string()
	}
	if !v.is_object() {
		return ''
	}
	return zend.object_class_name(v.raw_ptr())
}

pub fn (v ZVal) namespace_name() string {
	class_name := v.class_name()
	if !class_name.contains('\\') {
		return ''
	}
	return class_name.all_before_last('\\')
}

pub fn (v ZVal) short_name() string {
	class_name := v.class_name()
	if !class_name.contains('\\') {
		return class_name
	}
	return class_name.all_after_last('\\')
}

pub fn (v ZVal) parent_class_name() string {
	if !v.is_valid() {
		return ''
	}
	return zend.object_parent_class_name(v.raw_ptr())
}

pub fn (v ZVal) is_internal_class() bool {
	if !v.is_valid() {
		return false
	}
	return zend.object_class_is_internal(v.raw_ptr())
}

pub fn (v ZVal) is_user_class() bool {
	return !v.is_internal_class()
}

pub fn (v ZVal) interface_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	return PhpFunction.named('class_implements').with_result[PhpArray, []string](fn (interfaces PhpArray) []string {
		return string_values_from_php_array(interfaces)
	}, PhpString.of(class_name)) or { []string{} }
}

pub fn (v ZVal) is_instance_of(name string) bool {
	if !v.is_valid() {
		return false
	}
	return PhpFunction.named('is_a').result_bool(PhpValue.from_zval(v), PhpString.of(name),
		PhpBool.of(true))
}

pub fn (v ZVal) is_subclass_of(name string) bool {
	if !v.is_valid() {
		return false
	}
	return PhpFunction.named('is_subclass_of').result_bool(PhpValue.from_zval(v),
		PhpString.of(name), PhpBool.of(true))
}

pub fn (v ZVal) implements_interface(name string) bool {
	if name.len == 0 {
		return false
	}
	return name in v.interface_names()
}

pub fn (v ZVal) method_exists(name string) bool {
	if !v.is_valid() {
		return false
	}
	return PhpFunction.named('method_exists').result_bool(PhpValue.from_zval(v), PhpString.of(name))
}

pub fn (v ZVal) property_exists(name string) bool {
	if !v.is_valid() {
		return false
	}
	return PhpFunction.named('property_exists').result_bool(PhpValue.from_zval(v),
		PhpString.of(name))
}

pub fn (v ZVal) method_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	return PhpClass.named('ReflectionClass').with_object(fn (rc PhpObject) []string {
		return rc.with_method_result[PhpArray, []string]('getMethods', fn (methods PhpArray) []string {
			return reflection_member_names(methods)
		}) or { []string{} }
	}, PhpString.of(class_name)) or { []string{} }
}

pub fn (v ZVal) property_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	return PhpClass.named('ReflectionClass').with_object(fn (rc PhpObject) []string {
		return rc.with_method_result[PhpArray, []string]('getProperties', fn (props PhpArray) []string {
			return reflection_member_names(props)
		}) or { []string{} }
	}, PhpString.of(class_name)) or { []string{} }
}

pub fn (v ZVal) const_names() []string {
	class_name := v.class_name()
	if class_name.len == 0 {
		return []string{}
	}
	return PhpClass.named('ReflectionClass').with_object(fn (rc PhpObject) []string {
		return rc.with_method_result[PhpArray, []string]('getConstants', fn (consts PhpArray) []string {
			mut out := consts.fold[[]string]([]string{}, fn (k ZVal, _ ZVal, mut acc []string) {
				acc << k.to_string()
			})
			out.sort()
			return out
		}) or { []string{} }
	}, PhpString.of(class_name)) or { []string{} }
}

pub fn (v ZVal) const_exists(name string) bool {
	class_name := v.class_name()
	if class_name.len == 0 {
		return false
	}
	return PhpClass.named('ReflectionClass').with_object(fn [name] (rc PhpObject) bool {
		return rc.with_method_result[PhpBool, bool]('hasConstant', fn (res PhpBool) bool {
			return res.value()
		}, PhpString.of(name)) or { false }
	}, PhpString.of(class_name)) or { false }
}

fn string_values_from_php_array(values PhpArray) []string {
	mut out := values.fold[[]string]([]string{}, fn (_ ZVal, val ZVal, mut acc []string) {
		acc << val.to_string()
	})
	out.sort()
	return out
}

fn reflection_member_names(items PhpArray) []string {
	mut out := items.fold[[]string]([]string{}, fn (_ ZVal, val ZVal, mut acc []string) {
		obj := PhpObject.must_from_zval(val) or { return }
		name := obj.with_method_result[PhpString, string]('getName', fn (name PhpString) string {
			return name.value()
		}) or { '' }
		if name != '' {
			acc << name
		}
	})
	out.sort()
	return out
}
