# PHP Interop

`vphp` 的 interop 层负责把 `V -> PHP` 的调用收成一套统一语义：

- 入口函数先拿到一个 `ZVal`
- 后续动作都挂在 `ZVal` 上
- typed helper 只是 `to_v[T]()` / `to_object[T]()` 的语法糖

推荐把这份文档当成使用手册来查。

## 定义权与所有权模型

理解 `vphp` interop 时，最重要的一点是先区分：

1. 谁拥有“定义权”
2. 谁拥有“运行时状态”

可以把系统分成两类。

### 1. PHP-owned symbols

这类定义本来就在 PHP / Zend 一侧：

- PHP 全局函数
- PHP userland class
- PHP internal class
- PHP interface / trait
- PHP userland object

当 V 侧访问它们时，本质上只是：

- 拿到一个 `ZVal`
- 再调用 Zend 原本的能力

例如：

```v
dt := vphp.php_class('DateTimeImmutable').construct([
	vphp.ZVal.new_string('2026-03-04'),
])

stamp := dt.method_v[string]('format', [
	vphp.ZVal.new_string('c'),
])!
```

这里：

- `DateTimeImmutable` 的定义权在 PHP
- 对象状态也在 PHP / Zend
- V 只是调用者

这类场景里，不存在“两次定义”。

### 2. V-owned but PHP-exported symbols

这类定义写在 V 侧，但需要导出到 PHP：

- `@[php_function]`
- `@[php_class]`
- `@[php_interface]`
- `@[php_enum]`

这里要分开看：

#### 函数

函数更接近“单份语义 + 一层 PHP 入口”：

- V 侧有真实函数实现
- PHP 侧注册一个 Zend function entry
- 调用时桥接到 V

所以函数不是“两块状态内存”，而是：

- 一份逻辑实现
- 一份 PHP 导出入口

#### 类 / 对象 / static / const

这类有状态实体，就更接近“两套表示”：

- V 侧有 struct / object 语义
- PHP 侧有 class entry / object / property table / static table

因此这里通常会出现：

- V 侧表示
- PHP 侧表示
- 编译器和运行时负责桥接
- 必要时做同步

这也是为什么 `vphp` 里会有：

- object wrapper
- generated `get_prop / set_prop / sync_props`
- class static shadow
- class const shadow

### 一句话总结

- PHP 原生定义：`V -> Zend`
- V 导出定义：`V 定义 + PHP 导出壳 + 必要的桥接/同步`

### 对对象最实用的理解

如果对象来自 PHP 原生定义，例如：

```v
obj := vphp.php_class('DateTimeImmutable').construct([])
```

那么 V 侧拿到的是“PHP 对象的 `ZVal` 视图”。

如果对象来自 `vphp` 导出的 V 类，例如：

```v
article := vphp.php_class('Article').construct_object[Article]([...]) or { return }
```

那么它同时有两层：

- PHP 侧对象壳子
- V 侧真实对象指针

这也是为什么：

- 普通 PHP 对象不能随便 `to_object[T]()`
- `vphp` 导出的对象才可以恢复成 `&T`

## 1. 函数

全局函数入口：

```v
fn_ref := vphp.php_fn('strlen')
res := fn_ref.call([
	vphp.ZVal.new_string('codex'),
])
```

更短的写法：

```v
length := vphp.php_fn('strlen').call_v[int]([
	vphp.ZVal.new_string('codex'),
])!
```

兼容入口仍然保留：

```v
res := vphp.call_php('phpversion', [])
```

但推荐统一用：

```v
res := vphp.php_fn('phpversion').call([])
```

函数相关的常用 API：

| API | 说明 |
| --- | --- |
| `php_fn(name)` | 获取一个可调用的 PHP 函数引用 |
| `function_exists(name)` | 判断 PHP 全局函数是否存在 |
| `z.call(args)` | 调用 callable / 函数名 |
| `z.call_v[T](args)` | `call(args).to_v[T]()` |
| `z.call_object[T](args)` | `call(args).to_object[T]()` |

## 2. 类

类入口：

```v
cls := vphp.php_class('DateTimeImmutable')
obj := cls.construct([
	vphp.ZVal.new_string('2026-03-04'),
])
```

如果目标是 `vphp` 导出的对象，可以直接恢复成 `&T`：

```v
article := vphp.php_class('Article').construct_object[Article]([
	vphp.ZVal.new_string('Bridge'),
	vphp.ZVal.new_int(7),
]) or { return }
```

类相关的常用 API：

| API | 说明 |
| --- | --- |
| `php_class(name)` | 获取 class-string `ZVal` |
| `class_exists(name)` | 判断类是否存在 |
| `interface_exists(name)` | 判断接口是否存在 |
| `trait_exists(name)` | 判断 trait 是否存在 |
| `z.construct(args)` | 从 class-string 构造对象 |
| `z.construct_object[T](args)` | `construct(args).to_object[T]()` |
| `z.static_method(name, args)` | 调用静态方法 |
| `z.static_method_object[T](name, args)` | 期望结果是 `vphp` 对象时恢复 `&T` |
| `z.static_prop(name)` | 读取静态属性 |
| `z.static_prop_v[T](name)` | 读取静态属性并转成 V 值 |
| `z.@const(name)` | 读取类常量 |
| `z.const_v[T](name)` | 读取类常量并转成 V 值 |
| `z.const_names()` | 获取类常量名列表 |
| `z.const_exists(name)` | 判断类常量是否存在 |

例子：

```v
label := vphp.php_class('PhpTypedBox').const_v[string]('LABEL')!
count := vphp.php_class('PhpCounter').static_prop_v[int]('count')!
```

## 3. 对象

对象的实例调用和属性访问都挂在 `ZVal` 上：

```v
obj := vphp.php_class('PhpGreeter').construct([
	vphp.ZVal.new_string('Codex'),
])

msg := obj.method_v[string]('greet', [])!
name := obj.prop_v[string]('name')!
```

对象相关的常用 API：

| API | 说明 |
| --- | --- |
| `z.method(name, args)` | 调用实例方法 |
| `z.method_v[T](name, args)` | `method(name, args).to_v[T]()` |
| `z.method_object[T](name, args)` | `method(name, args).to_object[T]()` |
| `z.prop(name)` | 读取属性 |
| `z.prop_v[T](name)` | `prop(name).to_v[T]()` |
| `z.prop_object[T](name)` | `prop(name).to_object[T]()` |
| `z.set_prop(name, value)` | 写属性 |
| `z.has_prop(name)` | 当前可访问 property 存在判断 |
| `z.isset_prop(name)` | 对齐 PHP `isset($obj->prop)` |
| `z.unset_prop(name)` | 对齐 PHP `unset($obj->prop)` |
| `z.method_exists(name)` | 判断类/对象方法是否存在 |
| `z.property_exists(name)` | 判断类/对象属性是否存在 |

属性写入会遵守 PHP 运行时规则：

- readonly 属性不能写
- protected/private 可见性不会被 interop 放宽

## 4. 文件加载

在 V 侧可以直接加载 PHP 文件：

```v
vphp.include('/path/to/file.php')
vphp.include_once('/path/to/file.php')
```

相关 API：

| API | 说明 |
| --- | --- |
| `php_const(name)` | 读取 PHP 全局常量 |
| `global_const_exists(name)` | 判断 PHP 全局常量是否存在 |
| `include(path)` | 对齐 PHP `include` |
| `include_once(path)` | 对齐 PHP `include_once` |

例子：

```v
ver := vphp.php_const('PHP_VERSION').to_string()
loaded := vphp.include_once('/tmp/bootstrap.php')
```

## 5. 元信息

`ZVal` 还提供了一组偏 introspection 的 helper，主要针对对象和 class-string：

| API | 说明 |
| --- | --- |
| `z.class_name()` | 类全名（对象或 class-string） |
| `z.namespace_name()` | 命名空间部分 |
| `z.short_name()` | 短类名 |
| `z.parent_class_name()` | 父类名 |
| `z.interface_names()` | 已实现接口列表 |
| `z.is_internal_class()` | 是否 PHP 内建类 |
| `z.is_user_class()` | 是否用户类 |
| `z.is_instance_of(name)` | 是否是给定类/父类/接口的实例 |
| `z.is_subclass_of(name)` | 是否是给定父类的子类 |
| `z.implements_interface(name)` | 是否实现指定接口 |
| `z.method_exists(name)` | 方法是否存在 |
| `z.property_exists(name)` | 属性是否存在 |
| `z.method_names()` | 方法名列表 |
| `z.property_names()` | 属性名列表 |
| `z.const_names()` | 类常量列表 |
| `z.const_exists(name)` | 类常量是否存在 |

例子：

```v
obj := vphp.php_class('DateTimeImmutable').construct([
	vphp.ZVal.new_string('2026-03-04'),
])

println(obj.class_name())
println(obj.parent_class_name())
println(obj.interface_names())
println(obj.const_exists('ATOM'))
```

## Typed 与 Raw 的选择

推荐原则：

1. 已知返回类型时，优先 `*_v[T]`
2. 已知返回值是 `vphp` 对象时，优先 `*_object[T]`
3. 需要动态判断类型或做通用运行时时，先拿 raw `ZVal`

例如：

```v
res := vphp.php_fn('strlen').call([vphp.ZVal.new_string('codex')])
length := res.to_v[int]()!
```

或者直接：

```v
length := vphp.php_fn('strlen').call_v[int]([
	vphp.ZVal.new_string('codex'),
])!
```

## `vphp` 对象与普通 PHP 对象的边界

`to_object[T]()` 和所有 `*_object[T]()` helper 只适用于：

- PHP 对象底层真的由 `vphp` wrapper 承载

也就是说，这种可以：

```v
article := vphp.php_class('Article').construct_object[Article]([...]) or { return }
```

这种不可以恢复成 `&Article`：

```v
dt := vphp.php_class('DateTimeImmutable').construct([])
dt.to_object[Article]() or { /* none */ }
```

原因很简单：

- `Article` 带着 V 指针
- `DateTimeImmutable` 没有

## 参数构造建议

手动组装参数时，推荐统一使用：

```v
vphp.ZVal.new_null()
vphp.ZVal.new_int(42)
vphp.ZVal.new_float(3.14)
vphp.ZVal.new_bool(true)
vphp.ZVal.new_string('hello')
```

旧的 `new_val_*` 兼容入口还在，但不再主推。

## 错误处理建议

两种常用风格：

### 严格桥接

当 PHP 调用失败就应该立刻转成 PHP 异常时：

```v
length := vphp.php_fn('strlen').call_v[int]([
	vphp.ZVal.new_string('codex'),
]) or {
	vphp.throw_exception('strlen failed: ${err.msg()}', 0)
	return
}
```

### 宽容桥接

当结果只是增强信息，有清晰 fallback 时：

```v
mode := cfg.prop_v[string]('mode') or { 'default' }
count := vphp.php_class('PhpCounter').static_prop_v[int]('count') or { 0 }
```

经验规则：

- 核心控制流：抛异常
- 可选信息：本地 fallback
