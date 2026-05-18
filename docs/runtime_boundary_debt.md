# Runtime Boundary Debt

Status: **checkpoint / do not blindly migrate**.

This document records the remaining runtime boundary debt after the first
`zend_wrapper_layer` cleanup pass. It is intentionally conservative: the goal is
to keep future work focused, not to force every `ZVal` or `ZBox` occurrence into
a semantic wrapper.

## Current Guardrails

The old raw runtime API surface is now guarded by tests:

- `vphp/compiler/boundary_scan_test.v`
  - checks generated `vphptest/bridge.v`
  - checks compiler files that emit V glue
  - checks that `Context` stores `ZExData` and `PhpReturn`, not raw Zend
    pointers
  - blocks stale entries such as `Context.from_raw(...)`, `raw_zval()`,
    `ZVal.from_raw(...)`, direct generated `C.vphp_*`, and manual `C.zval{}`
- `vslim/tests/boundary_scan_test.v`
  - checks handwritten `vslim/src/*.v`, excluding generated `bridge.v`
  - blocks stale entries such as `Context.from_raw(...)`,
    `call_owned_request_zval(...)`, `method_owned_request(...)`, direct
    `C.vphp_*`, and manual `C.zval{}`

These tests do not ban `ZVal`, `RequestBorrowedZBox`, `RequestOwnedZBox`, or
`PersistentOwnedZBox`. Those types still express real ownership and bridge
boundaries.

## Snapshot

The current rough scan shape is:

- `vphp`: many files still mention `ZVal`; this is expected because `ZVal` is
  the Layer 3 facade over Zend values.
- `vphp`: direct `C.xxx` appears mainly in:
  - `vphp/zend/**`
  - generated-code emitters / boundary scan tests
  - generic Zend callback boundaries such as `object_generic_props.v` and
    `zval_factory_iter.v`
  - root-level runtime/lifecycle adapters that still intentionally bridge
    `ZVal`, `ZendObject`, `OwnershipKind`, superglobal enum conversion, and
    Zend request/runtime hooks
- `vslim/src`: handwritten sources still use:
  - `ZVal` in data decoding, PSR bridge, routing, view/template, stream,
    task/job, and bootstrap internals
  - `RequestBorrowedZBox` for PHP-facing borrowed parameters
  - `RequestOwnedZBox` for request-scope computed values
  - `PersistentOwnedZBox` for app-level handlers, services, routes, cached
    PSR state, and cross-request storage
- `vslim/src`: direct `C.xxx` is limited to:
  - generated class-entry globals such as `C.vslim__app_ce`
  - object wrapping through `ZendClassEntry.from_ptr(...)`
  - explicit external C dependencies such as MySQL thread helpers and allocator
    helpers

## Allowed Boundaries

### Zend C Boundary

Allowed:

- `vphp/zend/**`
- C declarations and direct `C.xxx` wrappers
- `&C.zval`, `&&C.zval`, `&C.zend_object`, `&C.zend_execute_data`
- Zend callback ABI signatures

Rule:

`vphp/zend/**` is where Zend details belong. Do not pull semantic `Php*` types
down into this layer.

### No-C Runtime Boundary

Allowed:

- `vphp/zval/**`
- `vphp/object/**`
- `vphp/execute/**`
- `ZVal`, `ZExData`, `ZendObject`, `ZendClassEntry`
- `RequestScope`, `FrameScope`
- `RequestBorrowedZBox`, `RequestOwnedZBox`, `PersistentOwnedZBox`
- `OwnershipKind`

Rule:

This layer may expose low-level V wrappers, but should avoid normal public APIs
that expose raw C pointers. Pointer exits should stay narrow, such as
`raw_ptr()` on handle wrappers.

### Generated ABI Glue

Allowed:

```v
fn generated_bridge(ex &C.zend_execute_data, ret &C.zval) {
    ctx := vphp.Context.from_ptr(ex, ret)
    ...
}

fn generated_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    ret := vphp.PhpObjectPropertyHandler.return_from_ptr(rv)
    name := vphp.PhpObjectPropertyHandler.name_from_ptr(name_ptr, name_len)
    ...
}
```

Rule:

Raw C pointer shapes are allowed at exported Zend callback signatures. The
generated body should immediately wrap them into `Context`,
`PhpObjectPropertyHandler`, `PhpReturn`, `ZVal`, `ZendObject`, or
`ZendClassEntry`.

### VSlim Handwritten Runtime

Allowed:

- `RequestBorrowedZBox` as PHP-facing borrowed input
- `RequestOwnedZBox` as request-scope return or intermediate storage
- `PersistentOwnedZBox` for app-level retained state
- `ZVal` for low-level PHP data decoding, PSR bridge normalization, iterable
  folding, and special object restoration
- `C.vslim__*_ce` class-entry globals when wrapping V structs as PHP objects

Rule:

Prefer semantic wrappers for PHP function/object interaction:

```v
vphp.PhpFunction.named('array_values').invoke(value)
vphp.PhpObject.borrowed(obj).call_method('getBody')
vphp.PhpCallable.borrowed(callable).invoke(args...)
```

Avoid handwritten VSlim code that falls back to:

```v
call_owned_request_zval(...)
method_owned_request(...)
[]vphp.ZVal{} // only to express "no args"
```

The `vslim/tests/boundary_scan_test.v` guard currently enforces that.

## Do Not Migrate Blindly

These areas are lifecycle-sensitive and should only move with focused tests:

- `PhpValueZBox` conversions between borrowed, request-owned, and
  persistent-owned storage
- `DynValue` persistent/request conversion
- `RetainedObject` and `RetainedCallable`
- PSR-7 server request attributes, uploaded files, parsed body, and stream body
  storage
- VSlim route/middleware dispatch payloads
- app-level registries that store callable/object state across requests
- closure binding and saved closure storage
- `ZVal.raw` and `zval_lifecycle_interop.v`

In these areas, a semantic-looking wrapper can still be wrong if it changes
who owns the underlying Zend value.

## Good Next Targets

These are relatively good next steps:

1. Add focused semantic helpers where callers repeatedly convert `ZVal` into
   `PhpValue` only to call one obvious operation.
2. Continue reducing `[]ZVal{}` as "no args" inside vphp runtime APIs by
   preferring variadic `PhpArgInput` entrypoints. The semantic call wrappers
   now route through their owned result entrypoints first.
3. Continue migrating direct PHP function/object interactions in VSlim to
   `PhpFunction`, `PhpObject`, `PhpCallable`, `PhpClass`, and semantic
   `Php*` wrappers.
4. Add tests before moving any persistent/request conversion code. The
   `vphptest` suite now includes a `PhpValueZBox` conversion counter probe.
5. Keep generated `bridge.v` style aligned with
   `vphp/compiler/boundary_scan_test.v`.

## Old API Surface Inventory

Status: **classified / not all are bugs**.

This section separates old-looking APIs into three buckets. The goal is to keep
the low-level layer available while making day-to-day extension code prefer
semantic wrappers.

### Keep As Low-Level Boundary APIs

These APIs are still legitimate because they sit at Layer 3 or below, or expose
ownership explicitly:

| API shape | Owner layer | Why it stays |
| --- | --- | --- |
| `ZVal` receiver methods in `zval_*.v` and `vphp/zval/**` | Layer 3 no-C value wrapper | This is the low-level facade over Zend values. |
| `RequestBorrowedZBox`, `RequestOwnedZBox`, `PersistentOwnedZBox` | lifecycle layer | They express ownership and request/persistent boundaries. |
| `with_request_zval`, `with_borrowed_zval`, `with_owned_zval` on `PhpValueZBox` | lifecycle bridge | These are scoped exits from semantic values back to request-safe zvals. |
| `Context.arg_raw`, `Context.get_args`, `Context.arg_*_zbox` | generated/runtime argument boundary | Needed when a function explicitly opts into context/manual decoding. |
| `php_arg_inputs_to_zvals` | semantic call adapter | Converts variadic semantic call inputs once before entering Layer 3. |
| `PhpReturn.request_owned/request_borrowed/persistent_owned` | return boundary | Return writes must preserve exact ownership semantics. |

### Migration Candidates

These are public or semi-public APIs that still expose `ZVal` in semantic files.
They are not wrong, but new user-facing examples should prefer the semantic
entrypoints in the right column.

| Current API | Prefer | Notes |
| --- | --- | --- |
| `PhpFunction.call_zval(args []ZVal)` | `PhpFunction.invoke(args ...PhpArgInput)` or `with_result*` | Keep `call_zval` for low-level callers; do not use it in normal examples. |
| `PhpCallable.call_zval(args []ZVal)` | `PhpCallable.invoke(args ...PhpArgInput)` | Callable results should surface as `PhpValue`. |
| `PhpClosure.call_zval(args []ZVal)` | `PhpClosure.invoke(args ...PhpArgInput)` | Same policy as `PhpCallable`. |
| `PhpObject.method_zval(method, args []ZVal)` | `PhpObject.call_method(method, args ...PhpArgInput)` | Keep direct zval method calls for special interop and probes. |
| `PhpClass.construct_zval(args []ZVal)` | `PhpClass.construct(args ...PhpArgInput)` | No-arg calls should use the variadic overload, not `[]ZVal{}`. |
| `PhpClass.static_method_zval(...)` | `PhpClass.call_static(...)` | Static method results should surface as `PhpValue`. |
| `PhpClass.static_prop_*` / `const_*` returning `ZVal` | typed semantic accessors where available | Property/constant reads are still a likely next API polish target. |
| `PhpArray.items() []ZVal` | future `items_value()` / iterator wrapper | Useful today, but it leaks raw item representation into semantic array code. |
| `PhpObject.prop*` returning `ZVal` | future `prop_value()` / typed prop helpers | High-value cleanup target because object properties are common in app code. |

### Deep-Water APIs

Do not migrate these without a focused test/probe. They are old-looking because
they sit on difficult ownership boundaries:

| Area | Risk |
| --- | --- |
| `PhpValueZBox.take_zval()` and request/persistent conversion | Can silently change ownership or release timing. |
| `PersistentOwnedZBox.from_*`, `of_*`, `from_detached_zval`, `from_mixed_zval` | Controls cross-request storage semantics. |
| `DynValue.persistent_owned_zbox(...)` and retained object/callable conversion | Bridges V-owned detached data and PHP runtime refs. |
| `RetainedObject` / `RetainedCallable` | Zend refcount and request teardown sensitive. |
| Closure binding/invocation helpers | ABI, captured V closure lifetime, and zval argument lifetime meet here. |
| PSR-7 request/response state in VSlim | Mixes persistent app state with request-owned Zend values. |

### Guardrail Status

`vphp/compiler/boundary_scan_test.v` now additionally checks:

- compiler sources must not emit raw `ZEND_RAW_FENTRY(...)`; generated C should
  go through `VPHP_ZEND_RAW_FENTRY(...)` in `compat.h`
- semantic `php_*` wrapper files must not directly use `C.`, `&C.*`,
  `ZEND_*`, or `zend_*`; they should cross into `vphp.zend`, `vphp.zval`, or
  lifecycle wrappers instead

These guardrails intentionally do **not** ban `ZVal` or `*ZBox` in semantic
files, because conversion methods and low-level escape hatches are part of the
public runtime contract.

## Execution Plan

Status: **incremental / small batches only**.

The next work should be split into five small phases. Each phase should be
individually reviewable and verifiable before moving on.

### Phase 1: Boundary Inventory

Goal:

- classify the remaining `C.xxx`, `&C.zval`, `php_fn`, `php_class`, and
  `[]ZVal` usages
- separate true ABI/lower-layer boundaries from places that should be
  semantic wrappers

Scope:

- docs
- boundary scan rules

Risk: low.

### Phase 2: Low-Risk Semantic Call Sites

Goal:

- keep migrating day-to-day VSlim and vphptest call sites to semantic wrappers
- prefer `PhpFunction`, `PhpClass`, `PhpObject`, `PhpCallable`, `PhpReturn`,
  and `PhpArgInput` where the call site does not need raw low-level arrays

Scope:

- handwritten `vslim/src/*.v`
- selected `vphptest/*.v`

Risk: low to medium.

Do not force low-level test fixtures or internal interop probes into this phase.

### Phase 3: Layer 3 Helper Cleanup

Goal:

- keep `zval_stream.v`, `zval_scalar.v`, and similar Layer 3 helpers tidy
- make internal helper names and call paths more object-like without changing
  ownership semantics
- avoid adding root-level `zend_*` forwarding helpers when the call can go
  straight to `vphp.zval`, `vphp.object`, `vphp.execute`, or `vphp.zend`

Scope:

- `vphp/zval/**`
- small private helper refactors

Risk: medium.

Progress:

- removed stale forwarding helpers from scalar, array, type, reference,
  resource, factory, execute-data, class-entry, interface-binding,
  superglobal, and object-zval paths
- renamed root-level private `ZVal` allocation/release/copy helpers away from
  `zend_*` so they read as raw `ZVal` lifecycle internals instead of Zend
  boundary wrappers
- removed root-level private `zend_object_*` forwarding helpers; `ZendObject`
  receiver methods now call the object handle layer directly
- removed the root-level `zend_runtime.v` forwarding layer; semantic facades
  such as `PhpException`, `PhpOutput`, extension lifecycle hooks, task storage,
  and closure storage now call the `vphp.zend` boundary module directly
- added VSlim boundary scan checks to block common semantic-to-zval roundtrip
  regressions in handwritten VSlim code
- root-level `fn zend_*` helpers are now blocked; direct Zend calls should live
  in `vphp/zend/**` or be made explicitly from a semantic facade when crossing
  that boundary is the point

### Phase 4: Compiler Glue Refinement

Goal:

- reduce repeated low-level patterns in generated glue
- keep ABI signatures raw, but move generated bodies toward `Context`,
  `PhpReturn`, `ZendObject`, and `php_types`

Scope:

- compiler emitters
- generated `bridge.v` shape

Risk: medium to high.

Progress:

- generated object property glue now wraps handler callback inputs through
  `PhpObjectPropertyHandler` instead of spelling `PhpReturn.from_ptr(rv)`,
  `ZVal.from_ptr(value)`, or `name_ptr.vstring_with_len(name_len)` directly
- compiler property callback raw ABI signatures are centralized in
  `class_property_binding.v` helper functions and guarded by
  `boundary_scan_test.v`
- compiler closure bridge raw ABI signatures are centralized in
  `struct_closure_binding.v` and guarded by `boundary_scan_test.v`
- generated struct-param closure bridges now delegate callback invocation and
  return writing through `Context.invoke_struct_closure*`
- `ReturnBinding` owns value-return write emission for function and class method
  glue
- `arg_binding` and `params_struct_binding` share argument presence/read
  expression helpers while preserving their separate default-value semantics
- boundary scan guards now block the old property-handler wrapping shape and
  struct closure bridges that hand-write `res := cb(args)`
- VSlim PSR-17 `ResponseFactory::createResponse` is now tracked as the first
  end-to-end Phase 4 scenario: `@[params]` struct fields become generated
  `bridge.v` argument reads, C arginfo exposes the semantic PHP signature, and
  generated stubs/tests assert `int $status = 200, string $reasonPhrase = ''`
  instead of stale low-level `mixed/default*` names
- VSlim PSR-17 `StreamFactory::createStream` now uses a real params struct and
  native V `string` input instead of `RequestBorrowedZBox` plus manual
  `php_arg_*` attributes; generated PHP reflection/stubs expose
  `string $content = ''`
- VSlim PSR-17 `UploadedFileFactory::createUploadedFile` now covers a more
  complex Phase 4 shape: required semantic `PhpObject` stream argument plus a
  trailing `@[params]` struct for nullable/defaulted `size`, `error`,
  `clientFilename`, and `clientMediaType`
- VSlim PSR-17 `RequestFactory::createRequest`,
  `ServerRequestFactory::createServerRequest`,
  `StreamFactory::createStreamFromFile`, and `UriFactory::createUri` now keep
  public signatures on V scalars, `PhpValue`, `PhpArray`, and params structs
  while leaving zval conversion at the PSR object construction boundary
- VSlim migration rule: VSlim should consume vphp runtime abstractions, not
  reimplement them. When handwritten VSlim helpers manipulate PHP values,
  arguments, returns, object/function calls, attributes, or lifecycle in a way
  that would be useful to extensions generally, add the capability to vphp
  first, then simplify VSlim.
- VSlim logger APIs now use semantic public signatures for context/message
  handling: native logger context parameters are `PhpArray`, PSR-3 logger
  context is a params struct-backed `array $context = []`, and PSR messages use
  `PhpValue` instead of borrowed zboxes. The old low-level `ZVal -> string`
  helper remains available for PSR HTTP internals.
- `PhpArray` now exposes `to_string_map()`, `to_scalar_string_map()`, and
  `to_string_list()` so VSlim request setters can consume semantic arrays
  directly. `VSlim\\VHttpd\\Request` array-shaped setters now expose `array`
  signatures instead of `mixed`/borrowed zbox internals.

### Phase 5: Ownership Deep Water

Goal:

- touch lifecycle-sensitive code only with probes and focused tests
- treat `PhpValueZBox`, `DynValue`, `PersistentOwnedZBox`, `RetainedObject`,
  `RetainedCallable`, closure binding, and PSR state storage as separate
  mini-projects

Scope:

- one concern at a time
- one probe/test batch at a time

Risk: high.

### Priority Order

1. Phase 1 inventory and guardrails
2. Phase 2 semantic call-site cleanup
3. Phase 3 Layer 3 helper cleanup
4. Phase 4 compiler glue refinement
5. Phase 5 ownership deep water

## Non-Goals For The Next Pass

Do not use the next pass to:

- remove all `ZVal` usage
- remove all `RequestBorrowedZBox` or `RequestOwnedZBox` usage
- hide every class-entry `C.vslim__*_ce` use
- move every root-level runtime file into subdirectories
- refactor PSR-7 persistent storage without lifecycle probes

Those changes would be too broad and too likely to disturb ownership.
