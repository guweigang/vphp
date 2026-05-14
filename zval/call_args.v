module zval

import vphp.zend

pub fn with_call_args[T](args []Handle, run fn (int, voidptr) T) T {
	mut ptrs := []voidptr{cap: args.len}
	for arg in args {
		ptrs << arg.raw_ptr()
	}
	return zend.with_arg_ptrs[T](ptrs, run)
}
