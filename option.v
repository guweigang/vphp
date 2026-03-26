module vphp

// ============================================
// Option 桥接 — V Option (?) → PHP null
// ============================================
//
// 运行时 helper，将 V 的 Option 类型自动桥接为 PHP null。
// 由编译器生成的 glue 代码调用，用户无需直接使用。
//
// 用法（编译器生成的 glue 代码）:
//
//   // ?void (实际是执行一个可能返回 none 的操作)
//   vphp.call_or_null(fn [ptr] () ? {
//       mut recv := unsafe { &Article(ptr) }
//       recv.maybe_action()?
//   }, ctx)
//
//   // ?T (如 ?bool, ?string, ?int)
//   vphp.call_or_null_val[bool](fn [ptr] () ?bool {
//       recv := unsafe { &Article(ptr) }
//       return recv.find_flag()
//   }, ctx)
//

// call_or_null 处理 ?void 方法：
// 成功 → 什么也不做（PHP 侧返回 null，等同 void）
// none → 返回 PHP null
pub fn call_or_null(f fn () ?, ctx Context) {
	f() or {
		ctx.return_null()
		return
	}
}

// call_or_null_val 处理 ?T 方法：
// 成功 → 将 unwrap 后的值写入 PHP 返回值
// none → 返回 PHP null
pub fn call_or_null_val[T](f fn () ?T, ctx Context) {
	res := f() or {
		ctx.return_null()
		return
	}
	ctx.return_val[T](res)
}
