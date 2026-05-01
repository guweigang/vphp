# vphp Overview

这页是 `vphp` 面向官网和文档首页的总览页。

如果只想先回答这几个问题：

- `vphp` 是什么？
- 它在整套技术栈里扮演什么角色？
- 它已经能做哪些事情？
- 第一次读该从哪几页开始？

先看这页就够了。

## Product Definition

`vphp` 是一套让 Vlang 和 PHP/Zend 互通的语言桥与导出工具链。

它不只是“再写一个 PHP 扩展”，更像是在回答两个方向的问题：

- `V -> PHP`
  - V 代码怎么导出成 PHP class / function / enum / interface
- `V -> Zend`
  - V 代码怎么安全调用 PHP userland / internal symbols

一句话定义：

- `vphp` = Zend Binding for Vlang

## Stack Position

在整套 `PHP + Vlang` 技术栈里：

- `vphp`
  - 语言桥接层
- `vslim`
  - 应用框架层
- `vhttpd`
  - runtime / transport 层

所以：

- `vphp` 不负责定义应用模型
- `vphp` 也不直接承载 HTTP/WebSocket/runtime
- `vphp` 负责提供“V 驱动 PHP”的基础能力

## Core Capability Map

### 1. PHP Interop

这是 `vphp` 最基础的一层。

核心对象是：

- `ZVal`

围绕 `ZVal`，当前已经能做：

- 调 PHP 全局函数
- 构造 PHP 类实例
- 调实例方法 / 静态方法
- 读写对象属性 / 静态属性
- 读取类常量
- 把结果转成 V 标量
- 把 `vphp` 导出的对象恢复成 typed object pointer

入口文档：

- [value_layers.md](value_layers.md)
- [interop.md](interop.md)

### 2. Ownership / Lifecycle

`vphp` 现在不是裸 `zval*` 风格，而是显式把所有权语义收出来了。

当前关键模型：

- `RequestBorrowedZBox`
- `RequestOwnedZBox`
- `PersistentOwnedZBox`

对应能力：

- request-owned 自动释放
- persistent-owned 显式释放
- request scope / autorelease drain

入口文档：

- [value_layers.md](value_layers.md)
- [lifecycle_model.md](lifecycle_model.md)
- [vphp_vs_ext_php_rs.md](vphp_vs_ext_php_rs.md)

### 3. PHP-facing OOP Export

这层回答的是“V 类型怎么导出成 PHP 类体系”。

当前重点能力包括：

- `@[php_class]`
- `@[php_trait]`
- `@[php_method]`
- `@[php_interface]`
- `@[php_enum]`
- `@[php_abstract]`
- `@[php_extends: 'ParentClass']`
- `@[php_const: shadow_const]`
- `@[php_static: shadow_static]`
- `@[php_attr: 'AttributeName(...)']`

入口文档：

- [oop_features.md](oop_features.md)

### 4. Compiler / Export Pipeline

`vphp` 不只有 runtime bridge，还包含一条导出编译链。

主线可以理解成：

```text
AST -> repr -> linker/builder -> emitted C/V bridge code
```

入口文档：

- [../compiler/README.md](../compiler/README.md)
- [../compiler/docs/architecture.md](../compiler/docs/architecture.md)
- [../compiler/docs/emission_pipeline.md](../compiler/docs/emission_pipeline.md)

## Current Highlights

按现在代码状态，`vphp` 最值得强调的亮点有：

- 基于 `ZVal` 的统一 interop 入口
- 显式所有权模型，而不是全靠调用者猜测释放责任
- V 导出 PHP class / trait / interface / enum
- PHP 8 class attribute 导出
- 对 `vslim` / `vhttpd` 这类常驻 worker/runtime 场景更友好的生命周期控制

## What vphp Is Not

为了避免定位混淆，也可以反过来说：

- `vphp` 不是业务框架
- `vphp` 不是 HTTP runtime
- `vphp` 不是模板引擎 / ORM / MVC 套件
- `vphp` 的核心价值不在“生成代码很多”，而在“桥接语义和生命周期正确”

## Recommended Reading Order

第一次接触 `vphp`：

1. 先看这页
2. 再看 [value_layers.md](value_layers.md)
3. 再看 [interop.md](interop.md)
4. 再看 [oop_features.md](oop_features.md)
5. 再看 [lifecycle_model.md](lifecycle_model.md)
6. 最后看 [../compiler/README.md](../compiler/README.md)

如果你更关心工程实践：

1. [vphp_vs_ext_php_rs.md](vphp_vs_ext_php_rs.md)
2. [val_conversions.md](val_conversions.md)

## Related Docs

- [vphp README](../README.md)
- [compiler README](../compiler/README.md)
- [compiler architecture](../compiler/docs/architecture.md)
