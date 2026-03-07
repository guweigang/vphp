# VPHP Lifecycle Model (Zend-first)

## Goal

Stop incremental leak-fixes and move to one consistent model:

1. Explicit ownership (`borrowed` vs `owned`)
2. Request arena boundaries (nestable)
3. Zend-managed memory as first choice for cross-boundary runtime state

This follows the same philosophy used by `ext-php-rs` (`ZBox` + request lifecycle), while keeping V ergonomics.

## Core Rules

1. Any value crossing V/PHP boundary must declare ownership.
2. Borrowed values are never released by V.
3. Owned values are released once, at scope end or explicit handoff.
4. Request-dispatch code runs inside `RequestScope`.
5. Long-lived bridge pools/registries use Zend allocator APIs.

## V Primitives

`vphp/lifecycle.v` introduces:

- `OwnershipKind`
- `BorrowedValue`
- `OwnedValue`
- `RequestScope`
- `with_request_scope(...)`

These are the canonical APIs for framework authors.

## Migration Plan

### Phase 1 (Foundation)

- Keep behavior unchanged.
- Replace ad-hoc mark/drain calls with `RequestScope`.
- Keep runtime counters enabled for observability.

### Phase 2 (Bridge Convergence)

- Convert bridge return paths to explicit `BorrowedValue` / `OwnedValue`.
- Remove implicit ownership transfer in helper paths.
- Restrict `dup_persistent()` usage to explicit ownership handoff points.

### Phase 3 (Zend-first Object Backing)

- Move long-lived wrapper pools/metadata to Zend allocator lifecycle.
- Reduce native-side deep clones in request object construction.
- Keep V objects as logical model; Zend owns lifecycle-critical memory blocks.

### Phase 4 (Validation Gates)

- A/B compare on `hello` route:
  - worker RSS slope
  - `runtime_counters` stability
  - throughput regression guard

If RSS still climbs while counters remain flat, treat as allocator residency and optimize allocation patterns rather than release semantics.

## Why this model

- Eliminates hidden ownership bugs.
- Makes nested dispatch safe by construction.
- Aligns with proven extension runtime patterns.
- Keeps V-side API simple and explicit.

