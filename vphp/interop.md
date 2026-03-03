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
```

Compatibility helper:

```v
res := vphp.call_php('phpversion', [])
```

Recommended style:

```v
res := vphp.php_fn('phpversion').call([])
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
| `z.constant(name)` | read class constant |

Example:

```v
obj := vphp.php_class('PhpGreeter').construct([
	vphp.ZVal.new_string('Codex'),
])
msg := obj.method('greet', []).to_string()
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
| `constant_v[T](name)` | `constant(name).to_v[T]()` |

Example:

```v
count := vphp.php_class('PhpCounter').static_prop_v[int]('count')!
label := vphp.php_class('PhpTypedBox').constant_v[string]('LABEL')!
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
