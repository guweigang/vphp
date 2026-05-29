# VPHP Module Analysis & Optimization Roadmap

> Generated: 2026-05-29
> Branch: `improvement/vphp-module-optimization`
> Scope: `vphp/` core module

---

## 1. Project Overview

`vphp` is the V-language to PHP/Zend binding layer — a dual-direction bridge that:

- Exports V functions, classes, interfaces, traits, and enums to PHP
- Calls PHP functions, methods, constructors, and reads/writes Zend values from V

### Scale Metrics

| Metric | Value |
|---|---|
| Total V code | ~35k lines |
| `.v` files | 204 |
| Module declarations | 220 |
| Public API surface (`pub fn/struct/interface/enum`) | 2,308 |
| `unsafe` blocks | 203 |
| `voidptr`/`byteptr` usages | 339 |
| C bridge files (`.inc.c`) | 4 |
| Integration tests (`.phpt`) | 85 |
| CI matrix | PHP 8.2–8.5 × Ubuntu/macOS |

### Module Distribution

| Directory | Files | Responsibility |
|---|---|---|
| `compiler/` | 69 | Code generation pipeline (parse, build, link, emit) |
| `zend/` | 16 | Low-level Zend C API wrappers |
| `zval/` | 15 | ZVal handle and operations |
| `object/` | 6 | Object lifecycle and binding |
| `execute/` | 3 | Execution context |
| `bridge/` | 4 `.inc.c` | C bridge shims |

### Largest Files

| File | Lines | Notes |
|---|---|---|
| `compiler/parser/class_parser.v` | 1,143 | God-object: attribute parsing, method parsing, inheritance, property mapping |
| `dyn_value.v` | 786 | Mixed-value representation + all conversions |
| `compiler/builder/class.v` | 640 | Class code generation |
| `php_return_binding.v` | 440 | Return value binding |
| `zval_to_v.v` | 361 | ZVal-to-V conversion |

---

## 2. Key Findings

### 2.1 Safety & Memory Safety (Critical)

**`unsafe` density is high.** 203 `unsafe` blocks across 35k lines = ~1 per 172 lines. For a project whose value proposition is safety over raw C, this is elevated.

**`voidptr` proliferation.** 339 raw pointer usages throughout the public API. `Handle.raw` is `voidptr`. `bind_object` takes `voidptr`. Type safety is effectively absent at the boundary.

**C bridge code duplication.** All 4 `.inc.c` files (`call.inc.c`, `object.inc.c`, `values.inc.c`, `runtime.inc.c`) contain **identical debug logging functions** (`vphp_bridge_*_debug_enabled`, `vphp_bridge_*_debug_log`). Copy-paste maintenance risk.

**Fixed buffer risks.** `snprintf` with 512-byte `debug_buf[512]` in bridge code. While used for debug output, uncontrolled input could truncate.

### 2.2 Architecture & Module Boundaries (High)

**`zval/` vs `zend/` overlap.** Both operate on `zval`. `zval/class.v` calls `zend.read_static_property_named` directly, meaning `zval/` is not independent — it depends on `zend/`. The boundary between "low-level Zend wrapper" and "user-facing value handle" is blurred.

**Compiler complexity.** `compiler/parser/class_parser.v` at 1,143 lines handles too many responsibilities in a single file. The compiler pipeline has 69 files total, but only 1 test file (`boundary_scan_test.v`).

**`dyn_value.v` god-object tendency.** 786 lines mixing data representation, conversion logic, and lifecycle management.

### 2.3 Code Quality & Consistency (Medium)

**Naming inconsistency.** Root-level files mix prefixes: `zend_oop_export.v`, `zval_to_v.v`, `php_return_binding.v`, `object_binding.v`. The prefix convention (`zend_` = low-level, `php_` = semantic, `zval_` = value-layer) is not consistently applied.

**Documentation gap.** `docs/ownership.md` defines `RequestBorrowedZBox`, `RequestOwnedZBox`, `PersistentOwnedZBox` concepts, but the public API still exposes `voidptr` in many places instead of these semantic wrappers.

**No `// SAFETY:` comments.** None of the 203 `unsafe` blocks document why `unsafe` is necessary or what invariants guarantee safety.

### 2.4 Testing (Medium)

**Integration test coverage looks good.** 85 `.phpt` files covering real PHP extension scenarios.

**Missing: unit tests for C bridge.** The `.inc.c` files have no unit tests. String handling, type matching, and object registry logic rely solely on integration tests.

**Missing: compiler unit tests.** Only `boundary_scan_test.v` exists for 69 compiler files.

---

## 3. Optimization Roadmap

### P0 — Critical (Safety & Stability)

#### P0-1: Extract shared C bridge debug utilities

**Problem:** 4 `.inc.c` files each contain ~30 lines of identical debug logging code.

**Action:**
- Create `bridge/debug.inc.c` with unified `vphp_bridge_debug_enabled()` and `vphp_bridge_debug_log()`
- Create `bridge/debug.h` with declarations
- Remove duplicated functions from `call.inc.c`, `object.inc.c`, `values.inc.c`, `runtime.inc.c`

**Files affected:** `vphp/bridge/*.inc.c`

#### P0-2: Reduce `voidptr` exposure in public API

**Problem:** `Handle.raw` is `voidptr`, `bind_object` takes `voidptr`, type safety is zero at boundaries.

**Action:**
- Introduce typed internal handles (e.g., `struct ZendObjPtr { voidptr _raw }`)
- Restrict `voidptr` to `zend/` internal usage only
- Public API should use typed wrappers

**Files affected:** `vphp/zval/handle.v`, `vphp/object_binding.v`, `vphp/context_return.v`, `vphp/php_arg_type.v`

#### P0-3: Add unit tests for C bridge

**Problem:** C bridge code (string handling, type matching, object registry) has no unit test coverage.

**Action:**
- Add minimal C test framework or use CMocka
- Test `runtime.inc.c` pure C functions
- Test `object.inc.c` registry operations

**Files affected:** New `vphp/bridge/tests/` directory

### P1 — High (Architecture & Maintainability)

#### P1-1: Split `compiler/parser/class_parser.v`

**Problem:** 1,143 lines, too many responsibilities.

**Action:**
- Split into `class_parser.v` (entry point)
- `method_parser.v` (method parsing)
- `property_parser.v` (property parsing)
- `inheritance_parser.v` (inheritance handling)

**Files affected:** `vphp/compiler/parser/class_parser.v`

#### P1-2: Split `dyn_value.v`

**Problem:** 786-line god-object mixing representation, conversion, and lifecycle.

**Action:**
- `dyn_value_types.v` (type definitions, enums)
- `dyn_value_constructors.v` (factory methods)
- `dyn_value_converters.v` (conversion logic)

**Files affected:** `vphp/dyn_value.v`

#### P1-3: Clarify `zval/` vs `zend/` boundary

**Problem:** Responsibilities overlap; `zval/` directly calls `zend/` functions.

**Action:**
- `zend/` should only contain direct Zend C API mappings
- `zval/` should provide user-facing, lifecycle-aware safe wrappers
- `zval/` should not call `zend/` named functions directly; use an internal interface

**Files affected:** `vphp/zval/*.v`, `vphp/zend/*.v`

#### P1-4: Standardize file naming conventions

**Problem:** Root-level files mix `zend_`, `php_`, `zval_`, `object_` prefixes inconsistently.

**Action:**
- Define rules: `zend_*` = low-level C API wrapper; `php_*` = PHP semantic export; `zval_*` = value-layer operations
- Move misplaced files into correct subdirectories

**Files affected:** Root-level `.v` files in `vphp/`

### P2 — Medium (Quality & Engineering)

#### P2-1: Reduce `unsafe` density

**Problem:** 203 `unsafe` blocks for 35k lines is high.

**Action:**
- Identify safe-able patterns (e.g., repeated `unsafe { &C.zval(ptr) }`)
- Extract safe wrapper functions with `unsafe` internal implementation
- Target: reduce to <100 `unsafe` blocks

**Files affected:** Multiple files with `unsafe` blocks

#### P2-2: Add `// SAFETY:` comments to all `unsafe` blocks

**Problem:** No documentation of why `unsafe` is necessary or what invariants guarantee safety.

**Action:**
- Add `// SAFETY: ...` comment to every `unsafe` block
- Document the invariant that makes the operation safe

**Files affected:** 42 files containing `unsafe` blocks

#### P2-3: Add static analysis / lint to CI

**Problem:** No enforced formatting or vet checks.

**Action:**
- Add `v fmt -verify` step to CI
- Add `v vet` step to CI

**Files affected:** `.github/workflows/vphp-ci.yml`

#### P2-4: Measure test coverage

**Problem:** 85 `.phpt` tests exist but coverage of public API is unknown.

**Action:**
- Use `kcov` or PHP `pcov` to measure C-layer and PHP-layer coverage
- Identify untested boundary paths

**Files affected:** CI configuration, new coverage reporting

### P3 — Long-term (Design Evolution)

#### P3-1: Explore borrow-checking patterns

**Problem:** `RequestBorrowedZBox` and `RequestOwnedZBox` are manual naming conventions, easy to misuse.

**Action:**
- Research whether V's `&T` reference semantics can express borrow relationships
- Reduce runtime errors from misuse

#### P3-2: Improve compiler testability

**Problem:** 69 compiler files, only 1 test file.

**Action:**
- Add unit tests for parser and builder
- Focus on `class_parser.v` attribute parsing edge cases

#### P3-3: Unify error handling

**Problem:** Mixed error patterns at C boundary (bool returns, int returns, output parameter mutation).

**Action:**
- Use V's `!T` and `?T` consistently in `zend/` layer
- Convert to C-style returns only at the final bridge boundary

---

## 4. Health Assessment

### Strongest Areas

- **Test strategy:** 85 `.phpt` integration tests covering real scenarios
- **CI matrix:** PHP 8.2–8.5 × Ubuntu/macOS
- **Documentation:** Ownership, lifecycle, interop all have dedicated docs

### Highest Risk Areas

1. **C bridge layer:** Duplicated code, potential memory safety issues
2. **Compiler core files:** Oversized, hard to maintain
3. **`unsafe`/`voidptr` overuse:** Undermines V's safety advantage

### Recommended First Three Actions

1. Extract `bridge/debug.inc.c` to eliminate C code duplication
2. Split `class_parser.v` into 3–4 files
3. Add `// SAFETY:` comments to all `unsafe` blocks and catalog which patterns can be extracted as safe wrappers

---

## 5. Progress Tracking

| ID | Task | Status | Notes |
|---|---|---|---|
| P0-1 | Extract C bridge debug utilities | 🔲 Pending | |
| P0-2 | Reduce `voidptr` in public API | 🔲 Pending | |
| P0-3 | Add C bridge unit tests | 🔲 Pending | |
| P1-1 | Split `class_parser.v` | 🔲 Pending | |
| P1-2 | Split `dyn_value.v` | 🔲 Pending | |
| P1-3 | Clarify `zval/` vs `zend/` boundary | 🔲 Pending | |
| P1-4 | Standardize file naming | 🔲 Pending | |
| P2-1 | Reduce `unsafe` density | 🔲 Pending | |
| P2-2 | Add `// SAFETY:` comments | 🔲 Pending | |
| P2-3 | Add lint to CI | 🔲 Pending | |
| P2-4 | Measure test coverage | 🔲 Pending | |
| P3-1 | Explore borrow-checking patterns | 🔲 Pending | |
| P3-2 | Improve compiler testability | 🔲 Pending | |
| P3-3 | Unify error handling | 🔲 Pending | |
