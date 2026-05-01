# vphp

`vphp` 是这个技术栈的底层语言桥。

Documentation entry:

- overview: [docs/OVERVIEW.md](docs/OVERVIEW.md)
- docs index: [docs/README.md](docs/README.md)

如果 `vslim` 是框架层，`vhttpd` 是运行时层，那么 `vphp` 负责回答的是：

- V 代码怎么导出成 PHP class / function / enum / interface
- V 代码怎么调用 PHP / Zend 世界里的函数、类、对象、属性、常量
- 两边对象、`ZVal`、所有权、生命周期怎么桥接

一句话定义：

- `vphp` = Zend Binding for Vlang

如果再产品化一点：

- `vphp` 是让 V 成为 PHP 实现语言之一的桥接层

## 它解决什么问题

`vphp` 不是普通 PHP 扩展脚手架。

它的目标更接近：

- 让 V 成为 PHP 的实现语言之一
- 让 V 类型能导出到 PHP
- 让 V 运行时能安全调用 Zend userland / internal symbols
- 让上层框架和运行时可以直接复用这套桥接能力

所以它既有：

- `V -> PHP` interop
- 也有 `V -> Zend export`

## vphp vs PHP-CPP vs ext-php-rs

从官方文档和指南看，三者都在解决“用非 C 语言开发 PHP 扩展”这个问题，但能力边界并不一样。

| 维度 | vphp | PHP-CPP | ext-php-rs |
| --- | --- | --- | --- |
| 主要语言 | V | C++ | Rust |
| 核心定位 | 语言桥接层 + Zend 导出层 + 上层框架基础设施 | C++ 友好的 PHP 扩展开发库 | Rust 的 Zend API binding + 宏/trait 抽象 |
| PHP 函数导出 | 有 | 有 | 有 |
| PHP 类导出 | 有 | 有 | 有 |
| interface / trait / enum 导出 | 有，且是当前设计重点 | 官方文档重点在 class / object / method，trait / enum 不是首页能力 | class / interface 支持明确；trait / enum 在官方入门材料里不是首屏能力 |
| attributes / 元信息导出 | 有，支持 PHP 8 class attributes | 官方文档未把 attributes 作为核心能力强调 | 宏和 doc comments 支持明确，attributes 能力偏 Rust 宏驱动 |
| 统一值桥接抽象 | `ZVal` + `*ZBox` ownership wrappers | `Php::Value` / `Php::Parameters` | `IntoZval` / `FromZval` / `ZBox` / `ZendObject` |
| request / persistent 生命周期模型 | 显式，`Borrowed` / `RequestOwned` / `PersistentOwned` 分层 | 有扩展回调，但对象所有权模型更偏 C++ 开发者自行管理 | 依赖 Rust 类型系统、trait 与 module lifecycle hook |
| request startup / shutdown hook | 有，且可由框架层显式 request_scope 控制 | 有，`onRequest()` / `onIdle()` / `onStartup()` / `onShutdown()` | 有，`ModuleBuilder` 支持 startup / shutdown / request startup / request shutdown |
| 命名空间 / 模块注册 | 有 | 有，`Php::Namespace` / `Php::Extension` | 有，`#[php_module]` + `ModuleBuilder` |
| 设计重心 | 既做 interop，也做“V 导出 PHP 类型系统” | 让 C++ 写扩展更顺手 | 让 Rust 写扩展更安全、更符合 Rust 习惯 |
| 对上层框架的适配 | 强，直接为 `vslim` / `vhttpd` 这类常驻场景服务 | 更偏通用扩展开发 | 更偏通用扩展开发 |
| 最适合的场景 | 想把 V 当作 PHP 实现语言之一，且需要语言桥接、导出、运行时协同时 | 已有 C++ 代码库，要快速暴露给 PHP | 希望利用 Rust 安全性和生态来写 PHP 扩展 |

一个简化判断：

- PHP-CPP 更像 “C++ 友好的扩展 SDK”
- ext-php-rs 更像 “Rust 风格的扩展 binding / macro 框架”
- `vphp` 更像 “把 V 接进 Zend 世界，并支撑上层 V 驱动 PHP 运行时的桥接层”

延伸阅读：

- PHP-CPP 文档：函数、类、常量、命名空间、扩展回调
- ext-php-rs 文档：`#[php_module]`、`ModuleBuilder`、`#[php_class]`、`RegisteredClass`
- 仓库内更细的 ownership 对比：
  - [docs/vphp_vs_ext_php_rs.md](docs/vphp_vs_ext_php_rs.md)

官方参考：

- PHP-CPP 首页与文档目录：
  - https://www.php-cpp.com/
  - https://www.php-cpp.com/documentation/
  - https://www.php-cpp.com/documentation/extension-callbacks
- ext-php-rs 指南与 API：
  - https://ext-php.rs/migration-guides/v0.14.html
  - https://docs.rs/ext-php-rs/latest/ext_php_rs/class/struct.ClassMetadata.html

## What vphp Already Does

当前最值得关注的能力是：

- 统一的 `ZVal` interop 入口
- `RequestBorrowedZBox` / `RequestOwnedZBox` / `PersistentOwnedZBox` 所有权模型
- V 导出 PHP class / trait / interface / enum
- PHP 8 class attribute 导出
- compiler/export pipeline

## Core Areas

### 1. PHP Interop

这是 `vphp` 最基础的一层。

核心对象分两层：

- `ZVal`
- `*ZBox`

其中：

- `ZVal` 负责底层 Zend interop 能力
- `*ZBox` 负责应用层生命周期与 ownership 语义

V 侧通过 `ZVal` 完成：

- 调 PHP 函数
- 构造 PHP 对象
- 调实例方法 / 静态方法
- 读写属性 / 静态属性
- 取类常量
- 把结果转回 V 标量或 V 导出对象

更细文档：

- [docs/interop.md](docs/interop.md)

### 2. PHP-facing OOP Export

这层回答“V 代码怎么导出成 PHP 类体系”。

当前重点能力包括：

- `@[php_class]`
- `@[php_trait]`
- `@[php_method]`
- `@[php_interface]`
- `@[php_enum]`
- `@[php_abstract]`
- `@[php_implements: 'InterfaceName']`
- `@[php_extends: 'ParentClass']`
- `@[php_const: shadow_const]`
- `@[php_static: shadow_static]`
- `@[php_attr: 'AttributeName(...)']`

当前约束：

- `@[php_implements: '...']` 支持同扩展导出的接口，也支持 userland/autoload 接口；后者会自动在生成的 `vphp_ext_auto_startup()` 里注册 runtime binding
- `@[php_extends: '...']` 只支持同扩展导出的类或 PHP internal class；不支持 userland 父类，违规会在编译期直接报错

Lifecycle hooks:

- module init: `vphp_ext_auto_startup()` then `vphp_ext_startup()`
- module shutdown: `vphp_ext_shutdown()` then `vphp_ext_auto_shutdown()`
- request init: `vphp_ext_request_auto_startup()` then `vphp_ext_request_startup()`
- request shutdown: `vphp_ext_request_shutdown()` then `vphp_ext_request_auto_shutdown()`

其中：

- `auto_*` 由编译器/运行时保留给自动生成逻辑
- 不带 `auto_` 的 hook 留给扩展作者自定义逻辑

最小示例：

```v
module main

__global (
    ext_request_boots int
)

@[export: 'vphp_ext_startup']
fn vphp_ext_startup() {
    println('[ext] module startup')
}

@[export: 'vphp_ext_request_startup']
fn vphp_ext_request_startup() {
    unsafe {
        ext_request_boots++
    }
}

@[php_function]
fn v_request_boot_count() int {
    unsafe {
        return ext_request_boots
    }
}
```

这个例子里：

- `vphp_ext_startup()` 在 module init 时执行一次
- `vphp_ext_request_startup()` 在每次 request init 时执行一次
- 自动生成逻辑仍然会走 `vphp_ext_auto_*`，不会占用开发者自定义 hook 名字

更细文档：

- [docs/oop_features.md](docs/oop_features.md)

### 3. Compiler / Export Pipeline

`vphp` 不只是运行时 API，也包含一套导出编译链：

- parser
- repr
- builder
- emitter
- export

入口说明：

- [compiler/README.md](compiler/README.md)

## Documentation Map

如果你更希望按主题读，而不是按仓库目录读，可以直接走这张图：

- 产品总览：
  - [docs/OVERVIEW.md](docs/OVERVIEW.md)
- interop：
  - [docs/interop.md](docs/interop.md)
- 生命周期：
  - [docs/lifecycle_model.md](docs/lifecycle_model.md)
- OOP 导出：
  - [docs/oop_features.md](docs/oop_features.md)
- 值转换：
  - [docs/val_conversions.md](docs/val_conversions.md)
- 设计对比：
  - [docs/vphp_vs_ext_php_rs.md](docs/vphp_vs_ext_php_rs.md)
- 编译链：
  - [compiler/README.md](compiler/README.md)

## Current Product Role

在整个 `PHP + Vlang` 技术栈里，`vphp` 现在扮演的是：

- 语言桥接层
- Zend 导出层
- 上层 `vslim` / `vhttpd` 的基础设施层

也就是说：

- `vphp` 不直接定义应用模型
- `vphp` 也不直接定义 runtime
- 它负责让上层框架和运行时具备“V 驱动 PHP”的能力

## Current Highlights

从当前代码状态看，比较关键的能力有：

- 基于 `ZVal` 的统一 interop 入口
- request-owned / persistent-owned / borrowed 所有权模型
- V 导出 PHP class / trait / interface / enum
- PHP 8 class attribute 导出
- V 导出对象恢复成 typed object pointer

### Returning V closures to PHP

vphp returns V closures to PHP through compiler-generated bridge code. Prefer declaring the closure type directly on the exported function and let the compiler choose the bridge.

Examples:

1) Struct params:

```v
@[params]
pub struct SearchParams {
    q string
    limit int
}

fn search_cb(p SearchParams) string {
    return '${p.q}:${p.limit}'
}

@[php_function]
pub fn get_search_cb() fn (SearchParams) string {
    return search_cb
}
```

2) Variadic values:

```v
fn join_cb(args ...vphp.VScalarValue) string {
    return args.map(it.str()).join(',')
}

@[php_function]
pub fn get_join_cb() fn (...vphp.VScalarValue) string {
    return join_cb
}
```

Notes:
- Supported variadic argument carriers are `vphp.PhpValue`, `vphp.ZVal`, `vphp.RequestBorrowedZBox`, and `vphp.VScalarValue`.
- Supported closure returns follow the normal vphp return binding rules, including `void`, V scalars, `vphp.PhpValue`, and `vphp.VScalarValue`.

## Recommended Reading Order

如果你第一次看 `vphp`，推荐顺序：

1. 先看这页
2. 再看 [docs/OVERVIEW.md](docs/OVERVIEW.md)
3. 再看 [docs/interop.md](docs/interop.md)
4. 再看 [docs/oop_features.md](docs/oop_features.md)
5. 最后看 [compiler/README.md](compiler/README.md)
