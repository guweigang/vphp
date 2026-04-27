# VPHP FFI 与 ABI 跨语言调用避坑指南 (Troubleshooting Guide)

在使用 Vlang 与 PHP (Zend Engine) 进行深度整合（FFI，外部函数接口）时，由于两者的底层内存模型、调用约定（Calling Convention）以及类型系统存在巨大差异，特别是在 Windows x64 等对 ABI 要求极为严苛的操作系统上，极易产生一些非常诡异的“幽灵 Bug”（如局部变量突然变空、无端崩溃等）。

本文档基于真实排查案例，总结了在编写 VPHP 核心代码及上层框架（如 VSlim）时的避坑准则。

## 1. 跨界无状态：永远不要信任“跨界后”的本地栈内存

### 现象与原因
在调用 Zend Engine 的宏大函数（如 `zend_execute_scripts` 来引导整个 PHP 框架）时，Vlang 会将控制权完全移交给 PHP 虚拟机。
Zend Engine 内部会进行极深的栈调用，并大量使用 `setjmp`/`longjmp` 来处理内部的 Bailout（致命错误）。在 Windows x64 下，这种深度的 C 栈操作以及异常展开，极易覆盖或破坏当前 Vlang 函数的栈帧（Stack Frame）。

如果此时 Vlang 栈上分配了一些变量（例如解析出的字符串、数组），在 PHP 脚本执行完毕并返回到 Vlang 时，这些变量的指针或内部状态可能已经变成乱码。

### 避坑准则
* **状态留给堆 (Heap Allocation)**：如果一个状态变量在调用了 `Zend Engine` **之后** 仍然需要被安全读取，**绝对不能将其留在本地函数的栈上**。
* **正确做法**：将其赋值到生命周期更长、明确分配在堆上的对象字段中（例如挂载在 `&App` 或 `mut app` 的属性里），等虚拟机调用结束后，再从堆内存中读回。

```v
// ❌ 错误示范：依赖本地栈内存
mut command_name := "start"
vphp.execute_script("bootstrap.php") // 此时 Zend Engine 可能破坏当前栈帧
println(command_name) // 可能输出乱码或直接段错误

// ✅ 正确示范：使用堆分配的上下文
app.last_command_name = "start"
vphp.execute_script("bootstrap.php")
command_name_safe := app.last_command_name.clone()
println(command_name_safe)
```

## 2. ABI 传参极简原则：拒绝跨界“传值”复杂结构体

### 现象与原因
在 Windows x64 平台下，由于其独特的 `__fastcall` 调用约定、影子空间（Shadow Space）机制以及寄存器分配规则，将体积较大或包含多个指针的结构体（例如 Vlang 的胖指针数组 `[]string`）通过**传值（Pass-by-value）**的方式跨越语言边界传递时，经常会发生参数错位。这会导致函数内部接收到的数组长度莫名其妙变为 0。

### 避坑准则
* **传参用指针**：在任何涉及跨语言 FFI 边界、回调函数，或者需要绕开编译器 ABI “盲区”的地方，**只传递基本类型（int, bool）或裸指针（`&Struct`, `void*`）**。
* **转换方法**：如果必须传递结构体或数组，请将独立函数重构为方法（Method），让结构体作为接收者（Receiver，通过指针传递），或者将其解构为纯 C 风格的指针加长度 (`void* ptr, int len`)。

```v
// ❌ 错误示范：复杂结构体传值，易遭遇 ABI 错位
fn run_command(mut cli CliApp, args []string) { ... }

// ✅ 正确示范：将主体作为 Receiver（按引用传递），稳定 ABI 布局
fn (mut cli CliApp) run_command(args []string) { ... }
```

## 3. 隔离作用域：利用 `defer` 确保资源释放

### 现象与原因
Zval 资源的泄漏通常隐蔽且致命。由于跨语言调用涉及复杂的条件分支，如果在代码中途发生 `panic` 或 `return error`，手动编写的 `release()` 函数经常会被跳过。

### 避坑准则
* **谁创建，谁释放**：在 V 代码中，只要创建了需要进入 PHP 引擎的 owned wrapper（如 `RequestOwnedZBox` / `PersistentOwnedZBox`），立刻在下一行写下 `defer { box.release() }`，除非它被明确转移给上层所有者。
* **PHP call 结果不要裸奔**：新代码优先用 `PhpFunction.with_result_zval(...)` 在 callback 内消费返回值，或者用 `PhpFunction.request_owned_box(...)` 接收 request-owned 结果。需要按名字直接调用 PHP 函数时，用 `call_php_fn(...)`。
* 不要让资源的生命周期跨越不必要的逻辑块。

```v
mut path := vphp.RequestOwnedZBox.new_string('/tmp/demo.txt')
defer { path.release() }

ok := vphp.PhpFunction.named('file_exists').with_result_zval([path.to_zval()], fn (res vphp.ZVal) bool {
	return res.to_bool()
})
```

## 4. 尊重目标语言的哲学：鸭子类型优先于严格继承

### 现象与原因
Vlang 是一门强类型、静态编译的语言，而 PHP 是一门极度灵活的动态语言。当尝试在 C/V 端判断一个 PHP 对象是否为“合法处理器”时，强静态语言思维会倾向于使用 `is_instance_of('MyCommand')`。
但这会破坏 PHP 开发者广泛使用的匿名类、闭包映射以及**鸭子类型（Duck-Typing）**。当 PHP 侧传入一个只要拥有 `handle()` 方法的对象时，强类型检查会将其拒绝，导致意外的逻辑截断和无任何反馈的静默失败。

### 避坑准则
* **判断靠特征**：在编写底层桥接代码时，务必适应上层语言（PHP）的开发范式。
* 优先使用 `method_exists('handle')` 或 `is_callable()` 来判断对象能力，而不是强迫 C 扩展层面进行硬编码的类名继承检查。

```v
// ❌ 错误示范：静态语言的死板约束
is_valid := obj.is_instance_of('VSlim\\Cli\\Command')

// ✅ 正确示范：动态语言的鸭子类型
is_valid := obj.is_object() && obj.method_exists('handle')
```

## 5. Windows/MSVC ABI 规则要产品化，而不是靠记忆

### 现象与原因
Linux/macOS 下能工作的 V 到 C 到 Zend 链路，不代表 Windows/MSVC 下也稳定。Windows PHP 扩展最终由 PHP 官方 devel pack 和 MSVC 编译；V 侧更适合生成桥接 C，而不是直接替代 Zend ABI 的最终编译链。

### 避坑准则
* **桥接层签名只传轻量值**：跨 V/C/Zend 的 exported wrapper 避免按值传递 V 数组、map、字符串切片、泛型容器或复杂结构体。传 `Context`、裸指针、整数、布尔值，复杂数据留在对象字段或通过 `ZVal`/box API 读取。
* **Zend ABI 由 C emitter 收口**：PHP arginfo、return type、object handler、module entry 等 Zend 细节只在 compiler C emitter / runtime C helper 一侧生成，V glue 不直接散落 Zend 宏。
* **Windows binary 走 MSVC**：Windows 发布包坚持 PHP 8.5 NTS x64 devel pack + MSVC/NMake；V 侧使用 emit-only 生成桥接源码。
* **GC 模式固定可复现**：基础 CI 和 release job 使用 `VPHP_V_GC=none` 做最小依赖验证；需要 Boehm 时作为额外矩阵加入，不能替代 none 模式。
* **ABI 变更必须有 smoke**：新增 wrapper 模板、Context 参数规则、返回值模板或 module ABI 字段时，至少跑 `make -C vphptest test`，并优先覆盖 `Context`、`?T/!T`、object return、persistent fallback 这几类高风险路径。

### PR 检查清单
1. exported wrapper 是否只传轻量值或指针？
2. V glue 是否没有新增 Zend 宏/ABI 细节？
3. `Context` 参数是否从 PHP arginfo 和参数解析中隐藏？
4. owned wrapper 是否有明确 release 或所有权转移？
5. `VPHP_V_GC=none make -C vphptest test` 是否通过？

## 总结
VPHP 作为一个桥接层，本身就站在两个世界的断层线上。未来的开发中请时刻铭记：
**状态留给堆，传参用指针，返回值有所有权，判断靠特征，永远敬畏虚拟机的黑盒边界。**
