# ZVal Conversions

This document describes the symmetric conversion APIs in `zval.v`:

- Zend Value -> V type: `to_v[T]() !T` on `ZVal`
- V type -> Zend Value: `from_v[T](value T) !` on `ZVal`
- Create new value from V type: `new_zval_from[T](value T) !ZVal`
- Preferred static constructor: `ZVal.from[T](value T) !ZVal`

These APIs are strict by default and are designed to be explicit and predictable.

Note:
- `ZVal` is the low-level wrapper over `&C.zval` (in `zval.v`).
- `RequestBorrowedZBox` / `RequestOwnedZBox` / `PersistentOwnedZBox` are the
  preferred ownership-facing wrappers in `lifecycle.v`.
- `DynValue` in `dyn_value.v` is the detached fallback model for unknown/mixed payloads.
- Strongly typed business logic should use ordinary V types directly.

Practical rule:
- use `ZBox` while reading, cloning, storing, and passing PHP-facing values

## 1. Zend Value -> V (`to_v[T]`)

`to_v[T]()` converts a `ZVal` to target V type `T`.

Behavior:
- Performs type checks first.
- Returns `error(...)` if the source type does not match expected type.
- For arrays/maps, validates container kind and converts each element.

### Supported target types

| Target type `T` | Requirement on source `ZVal` |
| --- | --- |
| `bool` | `is_bool()` |
| `int` | `is_numeric()` |
| `i64` | `is_numeric()` |
| `f64` | `is_numeric()` |
| `string` | `is_string()` |
| `[]string` | `is_array()` and each item must be string |
| `[]int` | `is_array()` and each item must be numeric |
| `[]i64` | `is_array()` and each item must be numeric |
| `[]f64` | `is_array()` and each item must be numeric |
| `[]bool` | `is_array()` and each item must be bool |
| `map[string]string` | `is_array()` |
| `map[string]int` | `is_array()` |
| `map[string]f64` | `is_array()` |
| `ZVal` | Always returns itself |

Notes for PHP arrays:
- `map[string]T` is intended for assoc arrays / object-like payloads.
- For PHP lists, prefer `[]T` or inspect with `is_list()` before decoding.
- For mixed-key arrays, keep the value as `ZVal` and inspect keys via `keys()` / `get_key(...)`.

### Example

```v
raw := ctx.arg_raw(2)
cfg := raw.to_v[map[string]string]() or {
    return
}
mode := cfg['mode'] or { 'standard' }
```

## 2. V -> Zend Value (`from_v[T]`)

`from_v[T](value)` writes V value into an existing `ZVal`.

Behavior:
- Overwrites current target value.
- Returns `error(...)` for unsupported source type.
- `from_v[Val]` is intentionally unsupported to avoid ambiguous pointer semantics.

### Supported source types

| Source type `T` | Result |
| --- | --- |
| `bool` | zval bool |
| `int`, `i64` | zval long |
| `f64` | zval double |
| `string` | zval string |
| `[]string` | zval array |
| `[]int`, `[]i64` | zval array |
| `[]f64` | zval array |
| `[]bool` | zval array |
| `map[string]string` | zval assoc array |
| `map[string]int`, `map[string]i64` | zval assoc array |
| `map[string]f64` | zval assoc array |
| `map[string]bool` | zval assoc array |

### Example

```v
mut out := ZVal{ raw: ctx.ret }
out.from_v[map[string]f64]({
    'avg': 91.2
    'max': 120.5
}) or {
    ctx.return_null()
    return
}
```

## 3. Create new `ZVal` from V (`new_zval_from[T]`)

`new_zval_from[T](value)` allocates a new underlying zval, then calls `from_v[T](value)`.
`ZVal.from[T](value)` is the preferred alias with clearer call-site semantics.

### Example

```v
arg0 := new_zval_from[string]('hello') or { return }
arg1 := new_zval_from[int](42) or { return }
res := callable.call([arg0, arg1])
```

```v
arg0 := ZVal.from[string]('hello') or { return }
arg1 := ZVal.from[int](42) or { return }
res := callable.call([arg0, arg1])
```

## 4. Ownership Wrappers

For ordinary typed data, use V types directly:

```v
cfg := ctx.arg_raw(0).to_v[map[string]string]() or {
    return
}
mode := cfg['mode'] or { 'standard' }
ctx.return_any(mode)
```

For PHP-facing values whose ownership still matters, prefer the `ZBox` wrappers:

```v
payload := ctx.arg_borrowed_zbox(0)
if payload.is_null() {
    ctx.return_any('empty')
    return
}
```

When you just need "the argument as a PHP-facing wrapper", use:

```v
arg := ctx.arg_any_zbox(0)
```

For detached dynamic payloads, use `DynValue`:

```v
dyn := decode_dyn_value(ctx.arg_raw(0))!
z := new_zval_from_dyn_value(dyn)!
ctx.return_zval(z)
```

Recommended boundary:
- Typed business logic: native V types
- Dynamic/unknown payload boundary: `DynValue`
- PHP bridge/lifecycle boundary: `RequestBorrowedZBox` / `RequestOwnedZBox` / `PersistentOwnedZBox`

## 5. Low-level APIs and recommended usage

Lower-level getters/setters such as `to_int()`, `set_string()`, `add_assoc_*()` are still valid.

Recommended:
- Use `to_v[T]()` for argument decoding where type safety matters.
- Use `from_v[T]()` for in-place writes and `ZVal.from[T]()` for new values.
- Keep the low-level APIs for bridge internals and specialized interop paths.
- For PHP array key-sensitive logic, prefer `is_list()` / `assoc_keys()` / `get_key(...)` over ad hoc stringified lookups.

## 6. Error handling guidance

For strict decode paths:

```v
user := ctx.arg_raw(0).to_v[string]() or {
    throw_exception('arg0 must be string', 0)
    return
}
```

For tolerant decode paths:

```v
score := ctx.arg_raw(1).to_v[f64]() or { 0.0 }
```
