module vphp

// ============================================
// Result 桥接 — V Result (!) → PHP Exception
// ============================================
//
// 运行时 helper，将 V 的 Result 类型自动桥接为 PHP 异常。
// 由编译器生成的 glue 代码调用，用户无需直接使用。
//
// 用法（编译器生成的 glue 代码）:
//
//   // !void
//   vphp.call_or_throw(fn [ptr] () ! {
//       mut recv := unsafe { &Article(ptr) }
//       recv.save()!
//   })
//
//   // !T (如 !bool, !string, !int)
//   vphp.call_or_throw_val[bool](fn [ptr] () !bool {
//       recv := unsafe { &Article(ptr) }
//       return recv.validate()
//   }, ctx)
//

// call_or_throw 处理 !void 方法：
// 成功 → 什么也不做
// 失败 → 抛出 PHP 异常
pub fn call_or_throw(f fn () !) {
	f() or {
		throw_exception(err.msg(), 0)
		return
	}
}

// call_or_throw_val 处理 !T 方法：
// 成功 → 将 unwrap 后的值写入 PHP 返回值
// 失败 → 抛出 PHP 异常
pub fn call_or_throw_val[T](f fn () !T, ctx Context) {
	res := f() or {
		throw_exception(err.msg(), 0)
		return
	}
	ctx.return_val[T](res)
}
