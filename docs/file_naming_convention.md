# VPHP File Naming Convention

This document defines the naming conventions for files in the `vphp/` module.

## Directory Structure

The `vphp/` module is organized into two layers:

### 1. Subdirectory Layer (Low-Level Wrappers)

These directories contain low-level wrappers that isolate specific concerns:

| Directory | Purpose | Dependencies |
|-----------|---------|--------------|
| `zend/` | Zend C API bridge (direct C interop) | None |
| `zval/` | Safe value handle layer (Handle abstraction) | `zend/` |
| `object/` | Low-level object lifecycle (no-C wrappers) | `zend/`, `zval/` |
| `execute/` | Low-level execute data wrappers | `zend/` |
| `scope/` | Low-level request scope wrappers | `zend/` |
| `compiler/` | Code generation pipeline | None |

### 2. Root Layer (High-Level APIs)

Files at the root level provide high-level APIs and semantic types. They depend on the subdirectory layer but are not depended upon by it.

## Naming Patterns

### PHP Semantic Types (`php_*.v`)

Files prefixed with `php_` define PHP semantic types and operations:

- `php_array_*.v` - PhpArray type and operations
- `php_object_*.v` - PhpObject type and operations
- `php_callable_*.v` - PhpCallable type and operations
- `php_closure_*.v` - PhpClosure type and operations
- `php_class_*.v` - PhpClass type and operations
- `php_function_*.v` - PhpFunction type and operations
- `php_value_*.v` - PhpValue type and operations
- `php_scalar_*.v` - Scalar types (PhpInt, PhpString, etc.)

### ZVal Operations (`zval_*.v`)

Files prefixed with `zval_` provide high-level ZVal operations:

- `zval_conversion.v` - Type conversion
- `zval_factory_iter.v` - Factory and iteration
- `zval_lifecycle_interop.v` - Lifecycle interop
- `zval_call_dispatch.v` - Call dispatch (method, static, callable, constructor)
- `zval_object_*.v` - Object metadata and properties
- `zval_reference.v` - Reference handling
- `zval_resource.v` - Resource handling
- `zval_scalar.v` - Scalar operations
- `zval_stream.v` - Stream operations
- `zval_stringify.v` - String conversion
- `zval_type.v` - Type checking
- `zval_typed_interop.v` - Typed interop
- `zval_view_state.v` - View state
- `zval_array.v` - Array operations
- `zval_class_interop.v` - Class interop

### Dynamic Values (`dyn_value_*.v`)

Files prefixed with `dyn_value_` handle dynamic PHP values:

- `dyn_value.v` - Type definitions and constructors
- `dyn_value_ops.v` - Lifecycle, accessors, queries
- `dyn_value_zval.v` - ZVal conversion
- `dyn_value_zbox.v` - ZBox conversion

### Persistent ZBox (`persistent_zbox_*.v`)

Files prefixed with `persistent_zbox_` manage persistent ZBox:

- `persistent_zbox.v` - Core operations
- `persistent_zbox_factory.v` - Factory
- `persistent_zbox_predicate.v` - Validation
- `persistent_zbox_view.v` - View operations

### Object Operations (`object_*.v`)

Files prefixed with `object_` provide high-level object operations:

- `object_binding.v` - Object binding (depends on ZVal, ZendObject)
- `object_generic_lifecycle.v` - Generic lifecycle
- `object_generic_props.v` - Generic properties
- `object_interface_binding.v` - Interface binding
- `object_vptr_registry.v` - VPtr registry

### Context (`context*.v`)

Files prefixed with `context` manage PHP function call context:

- `context.v` - Context struct (uses ZendExecuteData, PhpReturn)
- `context_args.v` - Argument helpers
- `context_return.v` - Return helpers

### Lifecycle (`lifecycle*.v`)

Files prefixed with `lifecycle` manage lifecycle:

- `lifecycle.v` - Lifecycle management
- `lifecycle_scope.v` - Lifecycle scope

### Execute Data (`execute_data_*.v`)

Files prefixed with `execute_data_` provide high-level execute data facades:

- `execute_data_facade.v` - High-level facade (wraps execute.Handle, returns ZVal)

### OOP Export (`oop_*.v`)

Files prefixed with `oop_` handle OOP export:

- `oop_export.v` - OOP export (uses ZendClassEntry, ZVal, etc.)

### Other Root Files

- `extension.v` - Extension configuration
- `hooks.v` - Debug hooks
- `request_zbox.v` - Request ZBox operations
- `retained_object.v` - Retained object
- `retained_callable.v` - Retained callable
- `v_scalar_value.v` - V scalar value
- `zbox_factory.v` - ZBox factory
- `zbox_types.v` - ZBox types
- `zval.v` - Core ZVal type

## Key Principles

1. **Subdirectory files are low-level**: They wrap C APIs or provide safe abstractions without depending on root-level types.

2. **Root files are high-level**: They provide semantic types and operations that depend on subdirectory types.

3. **Prefix indicates domain**: The prefix (`php_`, `zval_`, `object_`, etc.) indicates the primary domain of the file.

4. **No circular dependencies**: Subdirectory files never import root-level files.

5. **Renamed for clarity**: Files that were confusingly named have been renamed:
   - `zend_call.v` → `zval_call_dispatch.v` (it's about dispatching ZVal calls, not low-level Zend)
   - `zend_execute.v` → `execute_data_facade.v` (it's a high-level facade, not low-level Zend)
   - `zend_oop_export.v` → `oop_export.v` (it's about OOP export, not Zend-specific)

## Migration Status

The migration to this structure is ongoing. See `docs/zend_wrapper_layers.md` for the current status and remaining work.
