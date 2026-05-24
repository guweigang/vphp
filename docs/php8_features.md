# PHP 8.x 新特性与 vphp 设计启发文档

本文档系统性地梳理了 PHP 自 8.0 以来引入的核心语法与底层新特性，并站在 `vphp` / `vslim` 桥接层与运行时交互的视角，剖析了这些新特性对我们 API 设计、类型映射以及未来演进所带来的技术启发。

---

## 1. PHP 8.0 - 8.5 核心新特性一览

### PHP 8.0
* **Union Types（联合类型）**：如 `int|float`，原生支持参数或返回值可以接受多种指定的类型组合。
* **Constructor Property Promotion（构造函数属性提升）**：支持在构造函数参数中直接声明并初始化属性（如 `public function __construct(public string $name)`），极大减少了声明与赋值的样板代码。
* **Match Expression（Match 表达式）**：强类型安全且有返回值的模式匹配分支，支持严格比对（`===`），克服了传统 `switch` 的缺陷。
* **Named Parameters（命名参数）**：支持在调用时带上形参名（如 `foo(name: 'alice', age: 20)`），传参顺序可随意调换，且可跳过拥有默认值的参数。
* **Nullsafe Operator（空安全操作符）**：`$obj?->method()`，链式调用中如果遇到 `null` 会安全地短路返回 `null`，避免抛出致命错误。
* **`mixed` 类型**：相当于 `array|bool|callable|int|float|null|object|resource|string` 的总和。

### PHP 8.1
* **Enums（枚举）**：提供了对原生枚举的支持（包括不带值的 Pure Enums 和带关联值的 Backed Enums）。
* **Fibers（纤程）**：提供了轻量级的协作式多任务与非阻塞并发原语，是协程框架（如 Amp、Swoole）的底层基石。
* **`never` 返回类型**：指示函数绝对不会正常返回（其内部必须抛出异常或直接调用 `exit()`）。
* **Intersection Types（相交类型）**：如 `Iterator&Countable`，约束一个参数必须同时实现指定的多个接口。
* **`readonly` 属性**：声明初始化后不可被篡改的只读类属性。
* **First-class Callable Syntax（第一等可调用对象语法）**：允许使用 `strlen(...)` 的简洁语法来获取闭包实例。

### PHP 8.2
* **`readonly` 类**：对整个类标记 `readonly`，隐式将旗下所有属性设为 `readonly`，同时阻止动态属性的注入。
* **DNF Types（析取范式类型）**：允许在类型声明中混合并使用联合类型和相交类型，例如 `(A&B)|C`。
* **`null`、`false` 和 `true` 独立类型**：现在它们能够单独充当类型声明的类型，而非仅仅作为联合类型的一部分。

### PHP 8.3
* **Typed Class Constants（类常量类型声明）**：类常量支持声明类型，例如 `const string VERSION = '1.0';`。
* **`json_validate()`**：用于极速校验字符串是否为合法 JSON 格式，性能远好于直接调用 `json_decode()` 进行试错。
* **`#[\Override]` Attribute**：强约束重写行为，编译期确保方法存在于父类中。

### PHP 8.4
* **Property Hooks（属性钩子）**：直接在类属性内部定义 `get` / `set` 拦截器（类似 C# 或 Kotlin），从而消除了手写繁琐 getter/setter 方法的必要：
  ```php
  public string $fullName {
      get => $this->firstName . ' ' . $this->lastName;
  }
  ```
* **Asymmetric Visibility（非对称可见性）**：可以单独限制写权限的可见性级别，例如 `public private(set) string $name;`。
* **`new` 直接链式调用**：支持 `new MyClass()->method()`，省去了外层括号。

### PHP 8.5
* **Pipe Operator Syntax（管道操作符）**：引入管道操作符 `$value |> 'func1' |> 'func2'`，实现更流畅的链式管道函数传递。
* **URI 扩展**：提供全新原生的 URL/URI 解析与管理扩展。

---

## 2. 对 vphp 桥接层与运行时的设计启发

针对 PHP 8.x 的上述演进，`vphp` 在底层桥接和 API 表达上，可以有以下几个重要的技术探索与设计点：

### A. 强类型映射（Union / DNF 与 V 的 Sum Type）
* **现状与瓶颈**：在 V 语言侧，调用 PHP 导出的联合类型参数时，我们需要构建兼容的参数传递。
* **设计启发**：V 语言原生的 Sum Type（联合类型，例如 `string | int`）与 PHP 8.0 的 Union Types (`string|int`) 甚至 PHP 8.2 的 DNF 具备天然的语义一致性。我们可以在 `vphp` 的参数解析及自动 stub 代码生成（Reflection）时，实现 V 语言 Sum Type ➔ PHP Union Types 的自动转译与验证转换，确保边界类型安全的自动适配。

### B. 对 PHP Enums 的原生级支持
* **现状与瓶颈**：PHP 8.1 Enums 是带有方法和可能关联值的对象。
* **设计启发**：目前 `vphp` 中已经可以通过 `is_instance_of('UnitEnum')` 等方式来检测和比对枚举。在后续的演进中，我们可以在 `vphp` 提供一等的 `PhpEnum` 语义包装器，允许 V 语言的 `enum` 在通过代码生成层转译时，自动映射生成为 PHP 底层的 `BackedEnum`，实现两端枚举无缝映射与类型透传。

### C. 属性钩子（Property Hooks）与 stubs 生成
* **现状与瓶颈**：PHP 8.4 的 Property Hooks 使得属性不再仅仅是一个内存数据字段，对其进行读写会隐式触发 get/set 钩子函数。
* **设计启发**：
  1. **底层运行时自然兼容**：由于 V 语言对 `PhpObject` 的属性访问是通过 Zend VM 的 `read_property` / `write_property` 标准 API 走的，所以底层在运行时会自动触发 Hooks，我们无需做任何改动。
  2. **生成器（stubs）的感知**：在从 PHP 侧为 IDE 生成 V 语言的 stubs 声明代码时，我们的代码生成层需要通过 Reflection 识别属性的 Hooks 特性（例如哪些属性只挂载了 `get` 钩子而属于 readonly），在生成的声明中标记为只读，以在静态分析阶段防止 V 语言侧因错误修改该属性而在运行时抛出 PHP 异常。

### D. 非对称可见性（Asymmetric Visibility）的映射
* **设计启发**：PHP 8.4 允许 `public private(set)`。在 V 语言中，我们有非常相似的可见性控制：`pub`（公开只读）与 `mut`（可变）。
  * 在将 V 语言结构体导出为 PHP 类时，V 语言的 `pub` 字段应自动翻译为 PHP 的 `public readonly` 属性（PHP 8.1+）或 `public private(set)`（PHP 8.4+）；
  * V 语言的 `pub mut` 字段则翻译为 PHP 的普通 `public` 属性。
  这能实现两国字段访问控制（Access Control）的完美对称。

---

## 3. 演进路线规划

未来我们在推进 `vphp` 核心库开发时，将逐步按以下优先级接入这些现代 PHP 8.x 特性：
1. **[第一阶段] 完善 IDE Stubs 生成对 PHP 8.4 属性钩子和非对称可见性的解析。**
2. **[第二阶段] 提供便捷的 `UnitEnum` / `BackedEnum` 与 V enum 互相映射转译的高级类型包装。**
3. **[第三阶段] 引入 DNF 联合类型在 V 语言 Sum Type 与 PHP 参数绑定层面的全自动校验。**
