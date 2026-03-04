# PHP Interop

This document describes the `V -> PHP` interop layer in `vphp`.

Core idea:

- Entry points such as `php_fn(name)` and `php_class(name)` return a `ZVal`
- All follow-up actions happen on `ZVal`
- Typed helpers are thin wrappers over `ZVal.to_v[T]()` or `ZVal.to_object[T]()`

## 1. Entry Points

Use these to obtain a PHP target as `ZVal`:

```v
fn_ref := vphp.php_fn('strlen')
cls_ref := vphp.php_class('DateTime')
app_ver := vphp.php_const('PHP_VERSION')
```

Compatibility helper:

```v
res := vphp.call_php('phpversion', [])
```

Recommended style:

```v
res := vphp.php_fn('phpversion').call([])
```

Additional file-loading helpers:

```v
loaded := vphp.include('/path/to/file.php')
loaded_once := vphp.include_once('/path/to/file.php')
```

## 2. Base `ZVal` Actions

These are the low-level interop actions:

| API | Meaning |
| --- | --- |
| `z.call(args)` | call a callable/function-like target |
| `z.method(name, args)` | call object method |
| `z.construct(args)` | construct object from class-string |
| `z.prop(name)` | read object property |
| `z.set_prop(name, value)` | write object property |
| `z.has_prop(name)` | property exists check |
| `z.isset_prop(name)` | PHP `isset($obj->prop)` |
| `z.unset_prop(name)` | PHP `unset($obj->prop)` |
| `z.static_method(name, args)` | call class static method |
| `z.static_prop(name)` | read static property |
| `z.set_static_prop(name, value)` | write static property |
| `z.@const(name)` | read class constant |
| `z.class_name()` | object class name / class-string name |
| `z.namespace_name()` | namespace part of class name |
| `z.short_name()` | short class name |
| `z.parent_class_name()` | parent class name |
| `z.interface_names()` | implemented interface names |
| `z.is_internal_class()` | whether the class is an internal PHP class |
| `z.is_user_class()` | inverse of `is_internal_class()` |

Example:

```v
obj := vphp.php_class('PhpGreeter').construct([
	vphp.ZVal.new_string('Codex'),
])
msg := obj.method('greet', []).to_string()
```

Property write note:

- `set_prop(...)` respects the PHP runtime rules of the target object
- writing a readonly property raises the normal Zend readonly error
- protected/private properties are not widened by `vphp`; visibility checks still apply
- `class_name()` returns the object FQCN for objects, or the same string for class-string `ZVal`s

Metadata example:

```v
obj := vphp.php_class('DateTimeImmutable').construct([
	vphp.ZVal.new_string('2026-03-04'),
])
println(obj.class_name())
println(obj.parent_class_name())
println(obj.interface_names())
println(obj.is_internal_class())
```

## 3. Typed Value Helpers

If you want a concrete V value, you can always write:

```v
length := vphp.php_fn('strlen').call([
	vphp.ZVal.new_string('codex'),
]).to_v[int]()!
```

Convenience wrappers are available:

| Helper | Equivalent |
| --- | --- |
| `call_v[T](args)` | `call(args).to_v[T]()` |
| `method_v[T](name, args)` | `method(name, args).to_v[T]()` |
| `prop_v[T](name)` | `prop(name).to_v[T]()` |
| `static_prop_v[T](name)` | `static_prop(name).to_v[T]()` |
| `const_v[T](name)` | `@const(name).to_v[T]()` |

Example:

```v
count := vphp.php_class('PhpCounter').static_prop_v[int]('count')!
label := vphp.php_class('PhpTypedBox').const_v[string]('LABEL')!
```

## 4. Typed Object Helpers

For `vphp`-exported objects, you can restore the underlying V pointer as `&T`.

Base restore helper:

```v
article_zv := vphp.php_class('Article').construct([
	vphp.ZVal.new_string('Hello'),
	vphp.ZVal.new_int(1),
])
article := article_zv.to_object[Article]() or { return }
```

Convenience wrappers:

| Helper | Equivalent |
| --- | --- |
| `call_object[T](args)` | `call(args).to_object[T]()` |
| `method_object[T](name, args)` | `method(name, args).to_object[T]()` |
| `prop_object[T](name)` | `prop(name).to_object[T]()` |
| `construct_object[T](args)` | `construct(args).to_object[T]()` |
| `static_method_object[T](name, args)` | `static_method(name, args).to_object[T]()` |

Example:

```v
author := vphp.php_class('Author').static_method_object[Author]('create', [
	vphp.ZVal.new_string('Gu Weigang'),
]) or { return }
```

```v
article := vphp.php_class('Article').construct_object[Article]([
	vphp.ZVal.new_string('Bridge'),
	vphp.ZVal.new_int(7),
]) or { return }
```

## 5. Important Boundary: Userland PHP Objects vs `vphp` Objects

`to_object[T]()` and all `*_object[T]()` helpers only work when the PHP object
is actually backed by a `vphp` object wrapper.

This works:

```v
article := vphp.php_class('Article').construct_object[Article]([...]) or { return }
```

This does **not** restore to a V pointer:

```v
user_obj := vphp.php_class('DateTime').construct([])
user_obj.to_object[Article]() or { /* none */ }
```

Reason:

- `Article` is exported by `vphp`, so the PHP object carries a V pointer
- `DateTime` is a normal PHP/userland/internal object, so there is no V pointer to recover

## 6. Preferred Value Construction

When building arguments manually, prefer the static factory style on `ZVal`:

```v
vphp.ZVal.new_null()
vphp.ZVal.new_int(42)
vphp.ZVal.new_float(3.14)
vphp.ZVal.new_bool(true)
vphp.ZVal.new_string('hello')
```

Legacy compatibility helpers such as `new_val_string(...)` still exist, but the
preferred style is `ZVal.new_*()`.

## 7. Recommended Usage Style

Use low-level methods when you want full control:

```v
res := vphp.php_fn('strlen').call([vphp.ZVal.new_string('codex')])
length := res.to_v[int]()!
```

Use typed helpers when you want concise code:

```v
length := vphp.php_fn('strlen').call_v[int]([
	vphp.ZVal.new_string('codex'),
])!
```

Use object helpers only when you know the result is a `vphp`-exported object:

```v
author := vphp.php_class('Author').static_method_object[Author]('create', [
	vphp.ZVal.new_string('Typed Author'),
]) or { return }
```

## 8. Error Handling Guidance

There are two common styles in `vphp` interop code.

### Style A: strict bridge, fail fast

Use this when the PHP call is part of your core contract and failure should
become a PHP exception immediately.

```v
fn v_do_work(ctx vphp.Context) {
	length := vphp.php_fn('strlen').call_v[int]([
		vphp.ZVal.new_string('codex'),
	]) or {
		vphp.throw_exception('strlen failed: ${err.msg()}', 0)
		return
	}
	ctx.return_int(length)
}
```

Use this style for:

- required callbacks
- required configuration/constants
- object restoration that must succeed
- framework/runtime control flow

### Style B: tolerant bridge, fallback locally

Use this when PHP interop is optional and you have a clear local default.

```v
mode := cfg.prop_v[string]('mode') or { 'default' }
count := vphp.php_class('PhpCounter').static_prop_v[int]('count') or { 0 }
```

Use this style for:

- optional metadata
- diagnostics
- best-effort enrichment

### Suggested rule of thumb

- if the result is required to continue safely: `throw_exception(...)`
- if the result is optional and you know the fallback: `or { ... }`

## 9. Mixing Value and Object Helpers

In real code, interop usually mixes both styles.

Example:

```v
author := vphp.php_class('Author').static_method_object[Author]('create', [
	vphp.ZVal.new_string('Gu Weigang'),
]) or {
	vphp.throw_exception('create author failed', 0)
	return
}

article := vphp.php_class('Article').construct_object[Article]([
	vphp.ZVal.new_string('Bridge'),
	vphp.ZVal.new_int(7),
]) or {
	vphp.throw_exception('construct article failed', 0)
	return
}

label := vphp.php_class('Article').const_v[string]('NAME') or {
	'unknown'
}

println('${author.name} -> ${article.title} (${label})')
```

This pattern is usually the most readable:

1. restore objects with `*_object[T]()`
2. read scalars with `*_v[T]()`
3. only drop down to raw `ZVal` when you need custom conversion or low-level control

## 10. Choosing Between Raw and Typed APIs

Prefer raw `ZVal` actions when:

- you need to inspect PHP type at runtime
- the target type is not known yet
- you are building generic runtime helpers

Prefer typed helpers when:

- the result type is already known
- you want shorter business logic
- you want conversion failures to be explicit

Example of raw-first flow:

```v
res := vphp.php_fn('phpversion').call([])
if !res.is_string() {
	vphp.throw_exception('phpversion must return string', 0)
	return
}
version := res.to_string()
```

Example of typed-first flow:

```v
version := vphp.php_fn('phpversion').call_v[string]([]) or {
	vphp.throw_exception('phpversion failed: ${err.msg()}', 0)
	return
}
```
