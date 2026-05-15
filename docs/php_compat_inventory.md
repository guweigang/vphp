# PHP Compatibility Inventory

This document tracks PHP 8 minor-version compatibility points for VPHP's C
bridge.

VPHP supports PHP 8.2 and newer:

```c
#if PHP_VERSION_ID < 80200
# error "vphp requires PHP 8.2 or newer"
#endif
```

## Source Of Truth

Compatibility information should come from primary PHP sources:

- the local headers used by the active build, for example `php-config --include-dir`
- php-src release branch headers and implementation files:
  - `PHP-8.2`
  - `PHP-8.3`
  - `PHP-8.4`
  - `PHP-8.5`
  - `master` only as a forward-looking signal
- php-src `UPGRADING`, `NEWS`, and migration notes as supporting context

Do not rely on `master` alone. The latest source often contains only the newest
API shape; it may not keep `#if PHP_VERSION_ID` branches for older supported
minors. Compatibility should be inferred by comparing the supported release
branches, not by assuming the newest branch documents all historical shapes.

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
| `vphp_zend_is_callable` | `zend_is_callable` | wrapped |
| `vphp_zend_is_iterable` | `zend_is_iterable` | wrapped |
| `vphp_zend_class_implements_interface` | `zend_class_implements_interface` | wrapped |
| `vphp_zend_read_static_property` | `zend_read_static_property` | wrapped |
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
| Callable invocation | `zend_fcall_info_init`, `zend_call_function`, `call_user_function` | medium | Compare PHP-8.2..PHP-8.5 signatures before wrapping. Initial check shows `zend_fcall_info_init` signature stable across PHP 8.2-8.5, but FCC surrounding APIs changed. |
| Closure creation | `zend_create_closure`, manual `zend_internal_function` setup, `arg_info` layout | high | Audit against PHP-8.2..PHP-8.5 `zend_closures.h`, `zend_API.h`, and `zend_compile.h`. This is ABI-sensitive and should get a compat helper if any branch differs. |
| Include execution | `zend_stream_init_filename`, `zend_resolve_path`, `zend_execute_scripts`, `EG(included_files)` | medium | Audit signatures and ownership of `opened_path`/`resolved_path` across supported minors. |
| Object handlers | `read_property`, `write_property`, `has_property`, `unset_property`, `get_properties`, `zend_object_alloc`, `zend_object_std_init` | high | Audit handler signatures and return contracts across supported minors before further object-layer work. |
| Object/property metadata | `zend_get_property_info`, readonly property error helpers | medium | Partly wrapped. Continue comparing PHP-8.2..PHP-8.5 because readonly/protected(set) behavior moved recently. |
| Runtime type verification | `ZEND_TYPE_*`, `ZEND_CALL_*`, `zend_verify_*`, `zend_check_user_type_slow` | high | Partly wrapped. Keep checking `zend_type` and `zend_arg_info` layout across supported minors. |
| Runtime interface binding | `zend_do_implement_interface`, `zend_class_implements_interface`, `CG(class_table)` access | high | `zend_class_implements_interface` wrapped; direct `zend_do_implement_interface` still needs audit. |
| Resources | `zend_register_list_destructors_ex`, `zend_register_resource`, `zend_fetch_resource` | medium | Audit signatures and return contracts. |
| Exceptions | `zend_throw_exception`, `zend_throw_exception_object`, `zend_read_property(EG(exception), ...)`, `zend_clear_exception` | medium | Audit signatures and object/message access contracts. |
| HashTable helpers | `zend_hash_*`, `ZEND_HASH_FOREACH_*` | low-medium | Prefer official macros/functions; wrap only if a direct function contract changes. |
| Strings | `zend_string_init`, `zend_string_release`, `zend_string_tolower`, `zend_string_equals_*` | low | Stable-looking extension-facing APIs; keep direct unless a branch comparison proves otherwise. |

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
5. Add or update CI matrix coverage for PHP 8.2, 8.3, 8.4, and 8.5 when
   available.

## Notes

The goal is not to hide all Zend usage. The goal is to ensure PHP minor-version
differences are handled in one explicit layer and do not leak into generated
glue, V low-level wrappers, or semantic wrappers.
