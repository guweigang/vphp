module vphp

import vphp.zend as _

// PHP 函数入口。返回一个 callable ZVal，后续可通过 `.call(args)` 调用。
pub fn php_fn(name string) ZVal {
	return ZVal.new_string(name)
}

// PHP 类入口。返回一个 class-string ZVal，后续可通过 `.construct(args)` 实例化。
pub fn php_class(name string) ZVal {
	return ZVal.new_string(name)
}

// 兼容入口：直接调用 PHP 全局函数。
pub fn call_php(name string, args []ZVal) ZVal {
	return php_fn(name).call(args)
}
