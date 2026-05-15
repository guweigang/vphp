# PHP Compatibility Inventory

This document tracks PHP 8 minor-version compatibility points for VPHP's C
bridge.

VPHP supports PHP 8.2 and newer:

```c
#if PHP_VERSION_ID < 80200
# error "vphp requires PHP 8.2 or newer"
#endif
```

Keep PHP 8.2 as the minimum unless a concrete Zend C API change makes the
compatibility shim impractical. As of the PHP 8.2 through PHP 8.5
`UPGRADING.INTERNALS` audit, the known changes are compatible with a Layer 0
shim strategy:

- PHP 8.2 introduced object-handler return type changes and callable
  deprecation behavior, but VPHP targets PHP 8.2 as the baseline and does not
  need to support pre-8.2 handler signatures.
- PHP 8.3 changed several return types to `zend_result`, including
  `zend_execute_scripts`; VPHP should treat `zend_result` as the baseline.
- PHP 8.4 changed `zend_register_module_ex`, iterator handler signatures,
  `zend_is_true`, object-property access recommendations, and several memory
  manager APIs. VPHP currently does not depend on most of these directly; where
  it does, keep the call behind Layer 0 or official Zend helpers.
- PHP 8.5 changed constant registration return values,
  `zend_check_user_type_slow`, attribute validation, some globals, and several
  legacy aliases. For `zend_check_user_type_slow`, PHP 8.2-8.4 use the
  five-argument form with a cache slot while PHP 8.5 uses the four-argument
  form without it. These are shim-worthy but do not justify dropping PHP 8.2.

The practical policy is: maintain PHP 8.2+ support while 8.2 remains officially
supported by PHP, and revisit the minimum after PHP 8.2 reaches end-of-life.

`vphp-ci.yml` must keep a PHP 8.2, 8.3, 8.4, and 8.5 matrix for `vphptest`.
Local development may only have one PHP minor installed, so CI is the required
cross-version confirmation for compatibility shims.

## Source Of Truth

Compatibility information should come from primary PHP sources:

- php-src `UPGRADING.INTERNALS` for extension-facing C API, Zend API, ABI,
  module, opcode, and SAPI changes
- php-src `UPGRADING` and the PHP Manual migration guides for userland
  backward-incompatible behavior
- php-src release branch headers and implementation files:
  - `PHP-8.2`
  - `PHP-8.3`
  - `PHP-8.4`
  - `PHP-8.5`
  - `master` only as a forward-looking signal
- the local headers used by the active build, for example `php-config --include-dir`
- php-src `NEWS`, RFCs, and migration notes as supporting context

Do not rely on `master` alone. The latest source often contains only the newest
API shape; it may not keep `#if PHP_VERSION_ID` branches for older supported
minors. Compatibility should be inferred by comparing the supported release
branches, not by assuming the newest branch documents all historical shapes.

For VPHP, the one-truth order is:

1. `UPGRADING.INTERNALS` for deciding whether a C/Zend API compatibility shim is
   required.
2. The matching release branch headers and implementations for exact signatures,
   ownership, return values, struct fields, and handler contracts.
3. Local installed headers for the active build's current API shape.
4. PHP Manual migration pages for PHP userland behavior and generated stubs.
5. `UPGRADING`, `NEWS`, and RFCs for supporting explanation.

Local installed PHP 8.5 headers are useful for confirming the current build API,
but they do not encode all historical PHP 8.2/8.3/8.4 API shapes. For example,
Homebrew PHP 8.5.6 has `main/php_compat.h`, but that file mainly handles
platform/build and bundled-library symbol compatibility such as PCRE/libxml. A
local header scan only finds `PHP_VERSION_ID` as the version constant, generated
constant registration, and mysqlnd version forwarding; it does not provide
version branches for the Zend APIs VPHP wraps. Treat local 8.5 headers as the
current API source, then compare php-src release branches for historical
compatibility.

## Rule

Prefer PHP/Zend's public extension macros when they already provide a stable
extension-facing API:

- `REGISTER_*_CONSTANT`
- `PHP_FUNCTION`
- `PHP_MINIT_FUNCTION`
- `ZEND_BEGIN_ARG_*`
- `ZEND_ARG_*`
- `ZVAL_*`
- `Z_TYPE_P`, `Z_OBJ_P`, `Z_ARRVAL_P`, and related accessor macros
- `ZEND_HASH_FOREACH_*`

Add `vphp_zend_*` helpers in `vphp/bridge/compat.h` when VPHP directly calls a
lower-level Zend C function whose signature, return type, ownership contract, or
struct layout differs across supported PHP 8 minors.

## Current Boundary

`vphp/bridge/compat.h` already owns these direct Zend API wrappers:

| Helper | Direct Zend API | Current status |
| --- | --- | --- |
| `vphp_zend_get_called_scope` | `zend_get_called_scope` | wrapped |
| `vphp_zend_lookup_class` | `zend_lookup_class` | wrapped |
| `vphp_zend_lookup_class_ex` | `zend_lookup_class_ex` | wrapped |
| `vphp_zend_verify_scalar_type_hint` | `zend_verify_scalar_type_hint` | wrapped |
| `vphp_zend_wrong_parameters_count_error` | `zend_wrong_parameters_count_error` | wrapped |
| `vphp_zend_verify_arg_error` | `zend_verify_arg_error` | wrapped |
| `vphp_zend_verify_return_error` | `zend_verify_return_error` | wrapped |
| `vphp_zend_verify_never_error` | `zend_verify_never_error` | wrapped |
| `vphp_zend_check_user_type_slow` | `zend_check_user_type_slow` | wrapped |
| `vphp_zend_is_true` | `zend_is_true` | wrapped |
| `vphp_zend_execute_scripts` | `zend_execute_scripts` | wrapped |
| `vphp_zend_fcall_info_init` | `zend_fcall_info_init` | wrapped |
| `vphp_zend_call_function` | `zend_call_function` | wrapped |
| `vphp_zend_create_closure` | `zend_create_closure` | wrapped |
| `vphp_zend_add_class_attribute` | `zend_add_class_attribute` | wrapped |
| `vphp_zend_add_parameter_attribute` | `zend_add_parameter_attribute` | wrapped |
| `vphp_zend_throw_exception` | `zend_throw_exception` | wrapped |
| `vphp_zend_throw_exception_object` | `zend_throw_exception_object` | wrapped |
| `vphp_zend_clear_exception` | `zend_clear_exception` | wrapped |
| `vphp_zend_register_list_destructors_ex` | `zend_register_list_destructors_ex` | wrapped |
| `vphp_zend_register_resource` | `zend_register_resource` | wrapped |
| `vphp_zend_fetch_resource` | `zend_fetch_resource` | wrapped |
| `vphp_zend_is_callable` | `zend_is_callable` | wrapped |
| `vphp_zend_is_iterable` | `zend_is_iterable` | wrapped |
| `vphp_zend_class_implements_interface` | `zend_class_implements_interface` | wrapped |
| `vphp_zend_do_implement_interface` | `zend_do_implement_interface` | wrapped |
| `vphp_zend_read_static_property` | `zend_read_static_property` | wrapped |
| `vphp_zend_read_property` | `zend_read_property` | wrapped |
| `vphp_zend_update_static_property` | `zend_update_static_property` | wrapped |
| `vphp_zend_update_static_property_long` | `zend_update_static_property_long` | wrapped |
| `vphp_zend_update_static_property_string` | `zend_update_static_property_stringl` | wrapped |
| `vphp_zend_update_static_property_bool` | `zend_update_static_property_bool` | wrapped |
| `vphp_zend_get_class_constant` | `zend_get_class_constant_ex` | wrapped |
| `vphp_zend_readonly_property_modification_error` | `zend_readonly_property_modification_error_ex` | wrapped |

## Inventory

| Area | Direct Zend APIs / contracts | Current risk | Action |
| --- | --- | --- | --- |
| Global constants | `REGISTER_*_CONSTANT` macros in generated `php_bridge.c` | low | Keep official macros. They are extension-facing APIs used by php-src generated arginfo. Do not replace just to normalize naming. |
| Callable invocation | `zend_fcall_info_init`, `zend_call_function`, `call_user_function` | medium | Direct `zend_fcall_info_init` and `zend_call_function` calls now go through Layer 0. `call_user_function` remains an official extension-facing helper; wrap later only if a branch comparison proves a signature or ownership difference. |
| Closure creation | `zend_create_closure`, manual `zend_internal_function` setup, `arg_info` layout | high | Direct `zend_create_closure` calls now go through Layer 0. The manual `zend_internal_function` layout and closure arginfo remain ABI-sensitive and need focused PHP-8.2..PHP-8.5 branch checks before deeper closure work. |
| Include execution | `zend_stream_init_filename`, `zend_resolve_path`, `zend_execute_scripts`, `EG(included_files)` | medium | `zend_execute_scripts` now goes through Layer 0. Continue auditing ownership of `opened_path`/`resolved_path` across supported minors. |
| Attributes | `zend_add_class_attribute`, `zend_add_parameter_attribute`, `zend_attribute`, internal attribute validators | medium | Generated class and parameter attributes now go through Layer 0. VPHP does not currently register internal attribute validators, so PHP 8.5's validator-return change does not affect existing code. |
| Object handlers | `read_property`, `write_property`, `has_property`, `unset_property`, `get_properties`, `zend_object_alloc`, `zend_object_std_init` | high | Initial branch check shows the property handler signatures VPHP implements are stable across PHP 8.2-8.5. PHP 8.4 adds property-hook and offset semantics, so VPHP must keep avoiding direct `zend_object.properties` or property offset assumptions. |
| Object/property metadata | `zend_get_property_info`, readonly property error helpers | medium | Partly wrapped. Continue comparing PHP-8.2..PHP-8.5 because readonly/protected(set) behavior moved recently. |
| Runtime type verification | `ZEND_TYPE_*`, `ZEND_CALL_*`, `zend_verify_*`, `zend_check_user_type_slow` | high | Partly wrapped. Keep checking `zend_type` and `zend_arg_info` layout across supported minors. |
| Runtime interface binding | `zend_do_implement_interface`, `zend_class_implements_interface`, `CG(class_table)` access | high | Direct `zend_class_implements_interface` and `zend_do_implement_interface` calls now go through Layer 0. `CG(class_table)` reads remain direct because there is no better public accessor for this runtime binding path. |
| Resources | `zend_register_list_destructors_ex`, `zend_register_resource`, `zend_fetch_resource` | medium | Direct resource registration/fetch calls now go through Layer 0. Continue branch checks before adding richer resource wrappers. |
| Exceptions | `zend_throw_exception`, `zend_throw_exception_object`, `zend_read_property(EG(exception), ...)`, `zend_clear_exception` | medium | Throwing, clearing, and exception-message property reads now go through Layer 0. |
| HashTable helpers | `zend_hash_*`, `ZEND_HASH_FOREACH_*` | low-medium | Prefer official macros/functions; wrap only if a direct function contract changes. |
| Strings | `zend_string_init`, `zend_string_release`, `zend_string_tolower`, `zend_string_equals_*` | low | Stable-looking extension-facing APIs; keep direct unless a branch comparison proves otherwise. |

## Audited Direct Uses

Not every `zend_*` call should be hidden behind `compat.h`. Keep these direct
unless a supported PHP branch proves a real signature, ownership, return-value,
or struct-layout difference:

- Generated function/class declaration macros:
  - `PHP_FUNCTION`, `PHP_ME`, `PHP_MINIT_FUNCTION`
  - `ZEND_BEGIN_ARG_*`, `ZEND_ARG_*`, `ZEND_END_ARG_INFO`
  - `INIT_CLASS_ENTRY`
- Generated class, interface, enum, property, and constant registration APIs:
  - `zend_register_internal_class`, `zend_register_internal_class_ex`
  - `zend_register_internal_interface`
  - `zend_register_internal_enum`, `zend_enum_add_case_cstr`
  - `zend_class_implements`
  - `zend_declare_property_*`
  - `zend_declare_class_constant_*`
- Generated global constants:
  - `REGISTER_*_CONSTANT`
- zval, HashTable, string, and GC accessors/macros:
  - `ZVAL_*`
  - `Z_TYPE_P`, `Z_OBJ_P`, `Z_OBJCE_P`, `Z_ARRVAL_P`, `Z_STRVAL_P`,
    `Z_STRLEN_P`, and related accessor macros
  - `zend_hash_*`, `ZEND_HASH_FOREACH_*`
  - `zend_string_*`
  - `GC_*`
- Executor/class globals and hook assignments that are inherently Zend bridge
  code:
  - `EG(...)`
  - `CG(class_table)` and `CG(function_table)` reads used for runtime binding
  - `zend_execute_ex` and `zend_execute_internal` hook install/restore

Keep watching these direct uses, but do not wrap them preemptively:

- `call_user_function`: official extension helper; wrap only if branch
  comparison shows a signature or ownership split.
- `zend_stream_init_filename`, `zend_resolve_path`, `EG(included_files)`:
  include-path ownership and request lifetime deserve focused tests.
- `zend_get_property_info`, standard object handlers, `zend_object_alloc`,
  `zend_object_std_init`, `object_properties_init`: object internals are stable
  enough for current PHP 8.2+ use, but PHP 8.4 property hooks make this area
  worth re-auditing before deeper object-layer changes.
- Manual `zend_internal_function` allocation for V closures: the direct
  `zend_create_closure` call is wrapped, but the function/arginfo layout is
  still ABI-sensitive and should be checked before future closure rewrites.

## Audit Workflow

For each candidate:

1. Locate all VPHP call sites with `rg`.
2. Compare php-src `PHP-8.2`, `PHP-8.3`, `PHP-8.4`, and `PHP-8.5` headers and
   implementations for the exact function, macro, struct field, or handler
   signature.
3. Record whether it is:
   - official stable extension macro: keep direct
   - direct API but stable across supported minors: optional wrapper for
     ownership/clarity only
   - direct API with version difference: add `compat.h` helper
4. Run at least:
   - `make -C vphptest build`
   - `bash vphptest/run_tests.sh`
   - `make -C vslim build`
5. Add or update CI matrix coverage for PHP 8.2, 8.3, 8.4, and 8.5 whenever a
   compatibility boundary changes.

## Notes

The goal is not to hide all Zend usage. The goal is to ensure PHP minor-version
differences are handled in one explicit layer and do not leak into generated
glue, V low-level wrappers, or semantic wrappers.
