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
vphp.PhpFunction.named('array_values').request_owned(value)
vphp.PhpObject.borrowed(obj).method_request_owned('getBody')
vphp.PhpCallable.borrowed(callable).fn_request_owned(args...)
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
- added VSlim boundary scan checks to block common semantic-to-zval roundtrip
  regressions in handwritten VSlim code
- remaining root-level `zend_*` helpers are explicit runtime/request hooks,
  object lifecycle adapters, superglobal enum conversion, and raw `ZVal`
  ownership boundaries

### Phase 4: Compiler Glue Refinement

Goal:

- reduce repeated low-level patterns in generated glue
- keep ABI signatures raw, but move generated bodies toward `Context`,
  `PhpReturn`, `ZendObject`, and `php_types`

Scope:

- compiler emitters
- generated `bridge.v` shape

Risk: medium to high.

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
