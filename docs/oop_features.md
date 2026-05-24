# OOP Features in `vphp`

This document describes the current PHP-facing OOP feature set implemented by `vphp`, including the mapping rules, runtime behavior, and current limitations.

## Supported Features

Current first-class OOP export features:

- `@[php_class]`
- `@[php_trait]`
- `@[php_method]`
- `@[php_const: shadow_const]`
- `@[php_static: shadow_static]`
- `@[php_enum]`
- `@[php_interface]`
- `@[php_abstract]`
- `@[php_extends: 'ParentClass']`
- `@[php_attr: 'AttributeName("arg")']`
- V `implements`

## `@[php_class]`

Use `@[php_class]` on a V `struct` to export it as a PHP class.

```v
@[heap]
@[php_class]
struct Article {
pub mut:
	title string
}
```

Behavior:

- exported as an internal PHP class
- object allocation is handled by the generated Zend wrapper
- instance fields become PHP properties
- visibility is inferred from V field visibility

Current mapping:

- `pub` / `pub mut` fields -> PHP `public`
- non-`pub` fields -> PHP `protected`
- non-`mut` fields -> PHP `readonly` (except static properties, which keep current shadow-static behavior)

Notes:

- field-level PHP attributes are still limited by current V syntax, so some metadata is inferred indirectly
- object property synchronization is field-based and scalar-oriented
- generated property interop handlers only expose `public` fields; protected fields keep Zend visibility checks
- `readonly` is inferred from V mutability, not from a separate PHP-only attribute
- a `pub` but non-`mut` field becomes a public readonly property
- a non-`pub` and non-`mut` field becomes a protected readonly property

Example:

```v
@[heap]
@[php_class]
struct AuditLog {
pub:
	created_at int
pub mut:
	title string
mut:
	internal_note string
}
```

PHP-side effect:

- `created_at` -> `public readonly`
- `title` -> `public`
- `internal_note` -> `protected`

Runtime notes:

- readonly properties can still be assigned from the generated constructor/init path
- PHP userland writes after construction raise the normal Zend readonly error
- `ZVal.set_prop(...)` follows the same runtime rule and will also fail on readonly properties

## `@[php_method]`

Use `@[php_method]` to export methods to PHP.

```v
@[php_method]
pub fn (a &Article) save() bool {
	return true
}
```

Behavior:

- instance methods become PHP instance methods
- static V methods like `fn Article.create()` become PHP static methods
- `construct(...)` is mapped to PHP `__construct`
- `str() string` is mapped to PHP `__toString()`
- method visibility follows V visibility
- method returns support:
  - scalars such as `string`, `int`, `bool`, `f64`
  - container values such as `map[string]string` and `[]string`
  - object returns such as `&Article`

Current mapping:

- `pub fn` -> PHP `public`
- non-`pub fn` -> PHP `protected`

## `@[php_attr: 'AttributeName(...)']`

Use `@[php_attr: '...']` on `@[php_class]` to attach PHP 8 class attributes to
the exported internal class.

Example:

```v
@[heap]
@[php_class]
@[php_attr: 'PhpDispatchable("worker")']
struct DispatchableSample {
pub mut:
	name string
}
```

PHP-side effect:

```php
$ref = new ReflectionClass(DispatchableSample::class);
$attrs = $ref->getAttributes(PhpDispatchable::class);
```

Current scope:

- class-level attributes only
- positional scalar arguments only
- supported argument shapes:
  - strings
  - ints
  - floats
  - bools
  - `null`

Current limitations:

- no method/property/class-constant attribute export yet
- no named arguments yet
- no constant-expression arguments yet

## Class Constants via `@[php_const: shadow_const]`

`vphp` currently exposes class constants through a shadow constant struct.

Example:

```v
struct ArticleConsts {
	max_title_len int
	name          string
	age           int
}

const article_consts = ArticleConsts{
	max_title_len: 1024
	name: 'Samantha Black'
	age: 24
}

@[php_class]
@[php_const: article_consts]
struct Article {}
```

PHP result:

```php
Article::MAX_TITLE_LEN
Article::NAME
Article::AGE
```

Behavior:

- shadow constant fields are exported as PHP class constants
- constant names are uppercased
- values are copied at module init time

Important limitations:

- this is one-way export from V to PHP
- only scalar fields are currently meaningful here
- constants are derived from the shadow struct constant, not from arbitrary V fields

Design note:

- this model is stable and simple
- it is not the same as exporting arbitrary V `const` inside a class body

### PHP 8.3 Typed Class Constants

When targeting PHP 8.3+, `vphp` automatically promotes class constants to **typed class constants**
using `zend_declare_typed_class_constant`. The type is inferred from the V field type in the shadow
constant struct.

**Type mapping table:**

| V field type   | PHP constant type | Zend type code  |
|----------------|-------------------|-----------------|
| `string`       | `string`          | `IS_STRING`     |
| `int`          | `int`             | `IS_LONG`       |
| `f64` / `double` | `float`         | `IS_DOUBLE`     |
| `bool`         | `bool`            | `_IS_BOOL`      |

**V-side definition (extension developer):**

```v
// 1. 定义常量 shadow struct，字段类型即为 PHP 常量类型
struct MyClassConsts {
    max_limit int    = 100
    version   string = '1.0.0'
    is_active bool   = true
    ratio     f64    = 0.85
}

// 2. 声明 shadow const 实例
const my_class_consts = MyClassConsts{}

// 3. 挂载到目标 PHP 类
@[php_class: 'MyNamespace\\MyClass']
@[php_const: my_class_consts]
pub struct MyClass {}
```

**PHP-side result (PHP 8.3+):**

```php
namespace MyNamespace {
    class MyClass {
        public const int MAX_LIMIT = 100;
        public const string VERSION = '1.0.0';
        public const bool IS_ACTIVE = true;
        public const float RATIO = 0.85;
    }
}
```

**Backward compatibility:**

- On PHP < 8.3, the compiler falls back to the classic `zend_declare_class_constant_*` family of
  functions. Constants remain accessible with their correct values but carry no runtime type
  declaration.
- The fallback is generated via a `#if PHP_VERSION_ID >= 80300` / `#else` / `#endif` block in the
  compiled C bridge, so the same V source tree compiles against any supported PHP version.

**IDE stubs:**

The stub generator (`generate_stubs.php`) uses `ReflectionClassConstant::hasType()` and
`ReflectionClassConstant::getType()` (available on PHP 8.3+) to detect the registered type and emit
typed constant signatures in the generated stub file:

```php
// generated stub excerpt
public const string VERSION = '1.0.0';
public const int MAX_LIMIT = 100;
```

On older PHP versions the stub generator omits the type prefix and emits plain constant stubs.

## Class Static Properties via `@[php_static: shadow_static]`

Static properties are currently implemented through a shadow singleton plus generated sync helpers.

Example:

```v
struct ArticleStatics {
pub mut:
	total_count int
}

const article_statics = ArticleStatics{}

@[php_class]
@[php_static: article_statics]
struct Article {
}
```

Runtime model:

1. PHP has a real static property on the class entry
2. V has a shadow singleton object, such as `article_statics`
3. generated wrappers synchronize values:
   - PHP -> V before a wrapped method runs
   - V -> PHP after a wrapped method returns

Generated helpers:

- `Article.statics()`
- `Article.sync_statics_from_php(ctx)`
- `Article.sync_statics_to_php(ctx)`

What this means in practice:

- if PHP writes `Article::$total_count = 100`, the next wrapped V method sees `100`
- if V increments the shadow value inside a wrapped method, PHP sees the updated value afterwards

Important limitations:

- this is not a direct shared-memory static variable model
- synchronization currently happens at generated method boundaries
- if V accesses the shadow singleton outside the normal wrapper path, it is your responsibility to ensure sync is correct
- field names are inferred from the shadow static struct itself
- field-level `@[php_static]` attribute and comment marker remain only as compatibility fallback
- current helper support is scalar-only:
  - `int`
  - `string`
  - `bool`

Review conclusion:

- the model is workable and testable
- the semantics are clear once described as "shadow singleton + sync"
- the current syntax is a bit awkward and should be improved later

## `@[php_enum]`

Use `@[php_enum]` on a V enum to export it to PHP.

```v
@[php_enum]
enum ArticleStatus {
	draft
	review
	published
}
```

Current PHP mapping:

- exported as a `final` internal PHP class
- enum cases are exposed as class constants
- the type is not instantiable

Example:

```php
ArticleStatus::draft
ArticleStatus::review
```

Current limitations:

- this is not yet PHP 8.1 native enum object semantics
- current case values are integer-backed
- complex case expressions are not supported yet

Design note:

- this is intentionally a conservative first version to stabilize compiler and tests first

## `@[php_interface]`

Use `@[php_interface]` on a V interface to export a PHP interface.

```v
@[php_interface]
interface ContentContract {
	save() bool
	get_formatted_title() string
}
```

Then explicitly bind it to a class with V's own `implements` syntax:

```v
@[php_class]
struct Article implements ContentContract {}
```

PHP behavior:

- interface is visible through reflection
- interface methods are abstract
- `instanceof` works
- `class_implements()` works

Current limitation:

- implementation is explicit via V's `implements`
- implicit structural satisfaction is not auto-exported as PHP `implements`
- method signature validation is currently soft; Zend-side relationship is established, but compile-time semantic validation can still be improved

### `@[php_implements: '...']`

Use `@[php_implements: 'InterfaceName']` on `@[php_class]` when you need a PHP-side interface
relationship driven by a string name.

```v
@[php_class]
@[php_implements: 'JsonSerializable']
struct Payload {}
```

Resolution rule:

- if the string matches a V-exported `@[php_interface]` symbol, it is mapped to that interface's PHP name
- otherwise it is treated as a direct PHP interface name (for example `JsonSerializable` or namespaced names)
- V `implements` and `@[php_implements]` can be used together; duplicates are merged

Registration rule:

- interfaces exported by the same vphp extension are treated as internal relationships and emitted through the normal class registration path
- direct PHP interface names that are not exported by the same vphp extension are registered through `vphp.register_auto_interface_binding(...)` in generated `vphp_ext_auto_startup()`
- this allows generated internal classes to satisfy userland/autoloaded interfaces on first touch, while keeping same-extension interfaces on the normal Zend registration path

Practical rule of thumb:

- use V `implements SomeInterface` or `@[php_implements: 'SomeInterface']` for interfaces exported by the same extension
- use `@[php_implements: 'Vendor\\Package\\InterfaceName']` for userland interfaces provided by Composer or another autoload stack

### `@[php_extends: '...']` on `@[php_interface]`

Use `@[php_extends: 'InterfaceName']` on `@[php_interface]` when a generated PHP interface
should extend another PHP interface by name.

```v
@[php_interface: 'Demo\\Contracts\\ChildContract']
@[php_extends: 'Demo\\Contracts\\ParentContract']
interface ChildContract {}
```

Resolution rule:

- if the string matches a V-exported `@[php_interface]` symbol, it is mapped to that interface's PHP name
- otherwise it is treated as a direct PHP interface name

## `@[php_abstract]`

`@[php_abstract]` works on both classes and methods.

Example:

```v
@[php_class]
@[php_abstract]
struct AbstractReport {}

@[php_method]
@[php_abstract]
pub fn (r &AbstractReport) summarize() string {
	return ''
}
```

Behavior:

- abstract classes are marked with PHP abstract class flags
- abstract methods are emitted into the method table without a concrete handler
- abstract classes cannot be instantiated from PHP

Current expectation:

- concrete subclasses should provide the implementation as normal exported methods

## Inheritance and Embed Semantics

`vphp` now treats V-side embeds as a semantic input that must be resolved by linker rules, instead of blindly assuming "first embed == parent class".

There are three target cases.

### Case 1: embedded `@[php_class]`

If an embedded struct is also exported as `@[php_class]`, `vphp` may map it to PHP inheritance.

Explicit form:

```v
@[php_class]
@[php_extends: 'Post']
struct Article {
	Post
}
```

String form also supports V symbol mapping, including renamed PHP class names:

```v
@[php_class: 'Demo\\Contracts\\AliasBase']
struct AliasBase {}

@[php_class]
@[php_extends: 'AliasBase']
struct AliasWorker {
	AliasBase
}
```

Implicit form:

```v
@[php_class]
struct Story {
	Post
}
```

Current linker rule:

- if `@[php_extends: ...]` is present, that wins
- otherwise, if exactly one embedded struct is a `@[php_class]`, it becomes the PHP parent
- if multiple embedded structs are `@[php_class]`, compilation should fail and require explicit `@[php_extends: ...]`

Current parent support:

- supported: a parent class exported by the same vphp extension
- supported: a PHP internal class such as `Exception`
- not supported: a userland PHP class loaded through Composer/autoload

Compile-time guard:

- if `@[php_extends: '...']` resolves to neither a same-extension exported class nor a PHP internal class, compilation fails early
- the compiler error is explicit: `@[php_extends: ...]` only supports internal PHP classes or classes exported by the same vphp extension

### Case 2: embedded `@[php_trait]`

Embedded `@[php_trait]` structs are treated as PHP trait-style mixins at compile time.

Current behavior:

- their properties and methods are flattened into the consuming class
- if the outer struct already defines the same property or method, the outer struct wins
- if multiple embedded traits contribute the same property or method, later conflicts are skipped
- trait member visibility is preserved when flattened into the outer class
- traits are currently compile-time mixins in `vphp`; they are not emitted as standalone PHP `trait` declarations

### Case 3: embedded plain V struct

If an embedded struct is neither `@[php_class]` nor `@[php_trait]`, the recommended semantics are:

- keep it as V-side composition only
- do not auto-map it to PHP `extends`
- do not auto-flatten it into PHP-visible properties or methods

Why this default is preferred:

- not every V embed is intended as a PHP type relationship
- auto-flattening would leak implementation details into the PHP surface
- treating every embed as inheritance was too aggressive and incorrect

Recommendation:

- use `@[php_class]` for PHP inheritance
- use `@[php_trait]` for trait-style composition when you want embedded methods and properties flattened into the outer PHP class
- leave plain embeds as internal implementation detail unless you explicitly want PHP projection

### Embed Mapping Summary

| V embed form | PHP projection | Current rule |
|---|---|---|
| embedded `@[php_class]` | `extends` | exactly one embedded exported class may become the parent unless `@[php_extends: ...]` is declared explicitly |
| embedded `@[php_trait]` | compile-time flatten | trait properties and methods are flattened into the outer class; outer class members win on conflicts |
| embedded plain struct | no projection | kept as V-only composition detail; not exposed as PHP inheritance, properties, or methods |

## Current Design Assessment

These parts are in good shape:

- class export
- method export
- inheritance
- interface registration
- abstract registration
- enum first version

These parts are functional but still a little awkward:

- class constants through shadow structs
- static properties through shadow singleton synchronization
- field-level `@[php_static]` marker via comments

## Recommended Next Improvements

1. replace comment-based static field marking with a cleaner syntax
2. add signature validation for explicit V `implements`
3. decide whether `@[php_enum]` should evolve into native PHP enum support
4. document sum type / Result / Option mapping before implementation
