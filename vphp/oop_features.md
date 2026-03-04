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
