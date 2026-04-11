# VPHP Ownership And Lifetime

This document defines the intended ownership boundary for Zend values in VPHP.

## Goal

Keep Zend `zval` lifetime inside the smallest possible bridge boundary.

Application code should primarily work with semantic wrappers.

Preferred public naming:

- `RequestBorrowedZBox`
- `RequestOwnedZBox`
- `PersistentOwnedZBox`

**Core Utility:** `.clone()` (formerly `clone_persistent_owned`) is the primary way to move data from Request scope to Persistent scope.

Implementation model:

- `RequestBorrowedZBox`: borrowed read-only view of an existing Zend value
- `RequestOwnedZBox`: short-lived request-owned value
- `PersistentOwnedZBox`: long-lived detached data or retained handle
- `RetainedObject`: long-lived PHP object handle
- `DynValue`: detached data-oriented representation

For new code, prefer the short constructor-style entry points:

- `RequestBorrowedZBox.of(z)`
- `RequestOwnedZBox.of(z)`
- `PersistentOwnedZBox.of(z)`
- `PersistentOwnedZBox.of_mixed(z)`
- `PersistentOwnedZBox.of_data(value)`
- `PersistentOwnedZBox.try_of_detached(z)`

Equivalent top-level helpers are also available when they read better at the
call site:

- `borrow_zbox(z)`
- `own_request_zbox(z)`
- `own_persistent_zbox(z)`

`PersistentOwnedZBox.of(z)` is the friendly smart-dispatch entry point:

- safe detached data -> `dyn_data`
- PHP object -> retained object routing
- PHP callable -> retained callable routing
- everything else -> fallback compatibility storage

When the input kind is already known, prefer the more explicit constructors:

- `of_data(...)`
- `of_object(...)`
- `of_callable(...)`
- `of_mixed(...)`

`fallback_zval` is an internal compatibility fallback, not a recommended storage
model for new application code.

## Two Independent Axes

These terms answer two different questions:

1. How long may this value live?
2. Who is responsible for releasing it?

Do not mix them together.

### Lifetime: `request` vs `persistent`

`request`

- Valid only for the current PHP request / current bridge call flow
- Typical sources: `ZVal.new_*()`, PHP method return values, temporary arg arrays,
  `include()` results, temporary wrappers created for a callback
- Must not be stored directly in long-lived structs

`persistent`

- Intended to outlive the current request or be stored in long-lived app state
- Typical destinations: app/container fields, registries, cached definitions,
  service graphs, route metadata
- Must use a safe long-lived representation instead of blindly storing raw
  request `zval` state

### Ownership: `borrowed` vs `owned`

`borrowed`

- Read/use only
- You do not release it
- Good for function parameters, inspection helpers, and short-lived views

`owned`

- This scope is now responsible for the wrapper / temporary value
- You must either `release()` it exactly once, or explicitly transfer it into
  another owner

## Mental Model

Think of the four combinations like this:

### `borrowed + request`

- Temporary read-only view into a current request value
- Typical wrapper: `RequestBorrowedZBox`

### `owned + request`

- A temporary value created or returned during the current request
- Typical wrapper: `RequestOwnedZBox`
- The current scope must release it or transfer ownership

### `owned + persistent`

- A long-lived value stored beyond the current request
- Typical wrappers: `PersistentOwnedZBox`, `RetainedObject`

### `borrowed + persistent`

- Usually not stored directly as a standalone type
- More often appears as a temporary borrowed view over a persistent holder,
  such as `with_request_zval(...)`

## Rules

1. `ZVal.new_*()` is request-scoped.

`ZVal.new_null()`, `ZVal.new_string()`, `ZVal.new_bool()`, `ZVal.new_int()`, and
similar constructors produce request-owned temporary Zend values. They must not
be stored directly in long-lived structs.

2. `PersistentOwnedZBox` is not a generic “store any zval forever” box.

Use it for:

- detached scalar data
- detached string data
- detached dynamic payloads
- retained object handles

Do not treat it as a raw persistent copy of arbitrary request-time
`object`/`closure` values.

3. The caller owns PHP call results.

Helpers that inspect return values must not also release them. The call site
that receives a `ZVal` result is responsible for exactly one `release()`.

4. Long-lived object/callable state must use dedicated handles.

- PHP objects: `RetainedObject`
- PHP callables: `retained_callable` routing through
  `PersistentOwnedZBox.from_callable_zval(...)` / `of_callable(...)`

5. **Automatic Root Safety for @[php_class]**

V objects exported to PHP (V-backed objects) are automatically registered as GC roots when they enter the PHP-owned object registry.
- **V-to-PHP**: If you return a V pointer to PHP with `.owned_request` or `.owned_persistent` ownership, the bridge keeps it alive in the V heap.
- **Low Mental Effort**: You do not need to manually manage roots for objects passed to PHP; the bridge handles `GC_add_roots` and `GC_remove_roots` under the hood via a global root registry.

6. Debug/logging must not create ownership side effects.

Do not call APIs like `to_zval()` inside debug interpolation when they allocate
temporary request values.

## When To Use What

Choose in this order:

1. Will the value be stored beyond the current request/call scope?
2. Is this function only reading it, or is it taking responsibility for it?
3. If it is long-lived, is it pure data, an object, or a callable?

### If the value does not escape the current scope

- Prefer `RequestBorrowedZBox` for read-only access
- Use `RequestOwnedZBox` for temporary results you own
- Keep creation, use, and release inside one small scope

### If the value must be stored

- General long-lived input when the type is not known yet:
  `PersistentOwnedZBox.of(...)`
- Pure data: `PersistentOwnedZBox.new_*()`, `of_data(...)`,
  `try_of_detached(...)`, `of_mixed(...)`
- PHP object: `RetainedObject`, or object-routing through
  `PersistentOwnedZBox.from_object_zval(...)` / `of_object(...)`
- PHP callable: `PersistentOwnedZBox.from_callable_zval(...)` /
  `PersistentOwnedZBox.of_callable(...)`

## Quick Decision Table

| Situation | Preferred wrapper |
| --- | --- |
| Read an argument without keeping it | `RequestBorrowedZBox.of(...)` |
| Call PHP and inspect the result in-place | `with_call_result_zval(...)` / `with_method_result_zval(...)` |
| Call PHP and return/hand off the temporary result | `RequestOwnedZBox.adopt_zval(...)`, `take_zval()` |
| Store a long-lived value when the type is not known in advance | `PersistentOwnedZBox.of(...)` |
| Store long-lived scalar / string / list / map data | `PersistentOwnedZBox.new_*()`, `of_data(...)`, `try_of_detached(...)`, `of_mixed(...)` |
| Store a long-lived PHP object | `RetainedObject` or `PersistentOwnedZBox.from_object_zval(...)` / `of_object(...)` |
| Store a long-lived PHP callable | `PersistentOwnedZBox.from_callable_zval(...)` / `of_callable(...)` |

In practice:

- prefer `RequestBorrowedZBox` / `RequestOwnedZBox` / `PersistentOwnedZBox`
  while computing or storing values

## Practical Rules Of Thumb

- Function parameters should default to borrowed wrappers.
- PHP call results should default to request-owned wrappers.
- Long-lived struct fields should default to persistent wrappers or retained handles.
- The scope that creates an owned request value should also release it, unless
  it explicitly transfers ownership onward.

## Developer's Low Mental Effort Checklist

1. **Reading Data?** Use `RequestBorrowedZBox`. Don't bother with release.
2. **Moving Data to Storage?** Use `.clone()`.
   - Source: `RequestOwnedZBox` or `RequestBorrowedZBox`
   - Target: `PersistentOwnedZBox`
3. **Clearing Storage?** Use `.release()` or `release_persistent_boxes(mut list)`.
   - This is the only place where you MUST be careful. Anything in a persistent struct needs an explicit release in the struct's cleanup stage.
4. **Using V objects in PHP?** Just use them.
   - No more "Middleware is not valid" errors. The bridge-level root registry makes V objects safely pinnable from the PHP side.
## Preferred Construction Patterns

### Request-scoped values

Use:

- `RequestOwnedZBox.new_null()`
- `RequestOwnedZBox.new_bool(...)`
- `RequestOwnedZBox.new_int(...)`
- `RequestOwnedZBox.new_float(...)`
- `RequestOwnedZBox.new_string(...)`
- `RequestOwnedZBox.of(z)` when starting from an existing Zend value

### Persistent scalar data

Use:

- `PersistentOwnedZBox.new_null()`
- `PersistentOwnedZBox.new_bool(...)`
- `PersistentOwnedZBox.new_int(...)`
- `PersistentOwnedZBox.new_float(...)`
- `PersistentOwnedZBox.new_string(...)`
- `PersistentOwnedZBox.of_data(...)`
- `PersistentOwnedZBox.try_of_detached(...)` for scalar/array/map payloads that
  do not contain object/resource references
- `PersistentOwnedZBox.of_mixed(...)` when detached data is preferred but mixed
  values still need a compatibility fallback

These constructors should remain detached from raw `ZVal.new_*()` allocation.

### Persistent objects

Use:

- `RetainedObject.from_zval(...)`
- `PersistentOwnedZBox.of(...)` only when object routing is explicitly
  intended to become a retained-object variant

### Persistent callables

Use:

- `PersistentOwnedZBox.from_callable_zval(...)`
- `PersistentOwnedZBox.of_callable(...)`

These route long-lived callable forms into the retained-callable model:

- function-name strings
- `['ClassName', 'method']`
- `[$object, 'method']`
- invokable objects / `Closure`

## Constructor Semantics

`PersistentOwnedZBox.of(z)`

- Friendly general entry point
- Accepts any `ZVal`
- Routes objects into retained handles
- Routes safe pure data into detached storage when possible
- Still allows narrow compatibility fallback for mixed legacy values

`PersistentOwnedZBox.of_data(value)`

- Use when the caller already has detached `DynValue`
- No Zend lifecycle dependency

`PersistentOwnedZBox.try_of_detached(z)`

- Use when the input is expected to be pure detachable data
- Returns `none` if the payload contains object/resource references

`PersistentOwnedZBox.of_mixed(z)`

- Use when the value should prefer detached storage, but mixed inputs still
  need a compatibility fallback

## Summary

`request` vs `persistent` describes lifetime.

`borrowed` vs `owned` describes responsibility.

These are independent axes. A correct API should make both obvious.

## Design Direction

The long-term direction is:

- keep raw `ZVal` manipulation inside bridge-level helpers
- let upper layers consume `*ZBox` wrappers, detached data, or retained handles
- make the safe ownership path the easiest default API
- keep ownership reasoning centered on `*ZBox`, detached data, and retained handles

If a new API returns `ZVal`, its ownership contract must be obvious from the
name or documentation.
