# Compiler Repr Semantics

## Goal

The `repr` layer defines the compiler's internal data model.

Its job is simple:

- store parsed export metadata
- remain stable across parser and builder changes
- provide a common language for the compiler pipeline

It should be read as:

**AST has already been interpreted, but final code has not been generated yet.**

## Files

```text
vphp/compiler/repr/
  common.v
  class.v
  interface.v
  enum.v
  function.v
  constant.v
  globals.v
  task.v
```

## Base Repr

### `PhpRepr`

Defined in [common.v](/Users/guweigang/Source/vphpext/vphp/compiler/repr/common.v).

This is the common sum-like umbrella interface used by the compiler pipeline:

- `Compiler.elements []PhpRepr`
- linker passes
- export collection

It is intentionally empty.

Its value is only in allowing heterogeneous compiler elements to be stored in one slice.

## Class Repr

Defined in [class.v](/Users/guweigang/Source/vphpext/vphp/compiler/repr/class.v).

### `PhpClassRepr`

Represents one PHP-visible class exported from a V struct.

Fields:

- `name`
  - Original V struct name
  - Example: `Article`

- `php_name`
  - Final PHP-visible class name
  - May include namespace segments
  - Example: `VPhp\\Task`

- `parent`
  - PHP parent class name used for inheritance export
  - Empty string means no parent

- `is_final`
  - Whether the class should be emitted as final
  - Currently mostly reserved for future expansion

- `is_abstract`
  - Whether the class should be emitted as abstract
  - Consumed by the builder/emitter layer to set Zend flags

- `implements_v`
  - Explicit V-side `implements` declarations as parsed from the struct
  - This preserves the V-side source-of-truth relationship

- `implements`
  - Resolved PHP-visible interface names after linker reconciliation
  - This is the nominal PHP-side relationship list used by emission

- `shadow_const_name`
  - Name of the V-side shadow constant binding
  - Example: `article_consts`
  - This is a lookup key, not the type

- `shadow_static_name`
  - Name of the V-side shadow static binding
  - Example: `article_statics`
  - Also a lookup key, not the type

- `shadow_const_type`
  - Resolved V type name behind `shadow_const_name`
  - Filled during linking, not during initial parse

- `shadow_static_type`
  - Resolved V type name behind `shadow_static_name`
  - Filled during linking

- `constants`
  - Class constants that should exist on the emitted PHP class
  - Contains both directly declared constants and linked shadow constants

- `properties`
  - PHP-visible class properties
  - Includes instance properties
  - May also include linked static properties derived from shadow statics

- `methods`
  - PHP-visible method metadata

### `PhpClassConst`

Represents one PHP class constant.

Fields:

- `name`
  - PHP constant name
  - Example: `MAX_TITLE_LEN`

- `v_field_name`
  - Original V field name if the constant came from a shadow struct
  - Useful for traceability

- `value`
  - Literal string form used during code generation

- `const_type`
  - Semantic type used by builder/emitter
  - Common values:
    - `int`
    - `long`
    - `double`
    - `string`
    - `bool`

### `PhpClassProp`

Represents one PHP property.

Fields:

- `name`
  - Final PHP property name

- `v_type`
  - Original V-side type name
  - Used for bridge code generation and runtime conversion

- `visibility`
  - One of:
    - `public`
    - `protected`
    - `private`

- `is_static`
  - Whether this property should be declared as a PHP static property
  - For shadow statics, this is filled during linking

### `PhpMethodRepr`

Represents one PHP-visible method.

Fields:

- `name`
  - Final PHP method name
  - Example: `create`, `save`, `__construct`

- `v_name`
  - Original V method/function name
  - Needed because PHP and V method names may diverge

- `v_c_func`
  - Underlying exported V C symbol name
  - Useful when wrapper generation needs stable symbol mapping

- `is_static`
  - Whether the method is a PHP static method

- `return_type`
  - Return type in V terms
  - Examples:
    - `void`
    - `bool`
    - `string`
    - `&Article`

- `args`
  - Ordered argument metadata

- `has_export`
  - Whether this method already has a custom export path
  - Used to skip generating default wrappers in some cases

- `visibility`
  - PHP visibility string

- `is_abstract`
  - Whether the method should be emitted as abstract

### `PhpArg`

Used by both functions and methods.

Fields:

- `name`
  - Parameter name

- `v_type`
  - Original V-side parameter type

## Interface Repr

Defined in [interface.v](/Users/guweigang/Source/vphpext/vphp/compiler/repr/interface.v).

### `PhpInterfaceRepr`

Represents one PHP-visible interface.

Fields:

- `name`
  - Original V interface name

- `php_name`
  - Final PHP-visible interface name

- `methods`
  - Interface method contracts

Notes:

- Interface methods reuse `PhpMethodRepr`
- At this stage, methods are contracts, not implementations

## Enum Repr

Defined in [enum.v](/Users/guweigang/Source/vphpext/vphp/compiler/repr/enum.v).

### `PhpEnumRepr`

Represents one PHP-visible enum-style export.

Fields:

- `name`
  - Original V enum name

- `php_name`
  - PHP-visible enum class name

- `cases`
  - Enum cases, stored as `PhpEnumCase`

- `parse_err`
  - Deferred parse error slot
  - Used when enum syntax is discovered but cannot be safely exported

### `PhpEnumCase`

Fields:

- `name`
  - Final exported case name

- `value`
  - Literal string value used by code generation

## Function Repr

Defined in [function.v](/Users/guweigang/Source/vphpext/vphp/compiler/repr/function.v).

### `PhpFuncRepr`

Represents one PHP global function export.

Fields:

- `name`
  - Final PHP-visible function name

- `original_name`
  - Original V function name when PHP export name differs

- `return_type`
  - V-side return type

- `args`
  - Ordered argument metadata

- `is_internal`
  - Internal-use flag
  - Mostly a policy/control field

- `uses_php_function`
  - Whether this came from the `@[php_function]` path
  - Used to distinguish wrapper strategy

## Constant Repr

Defined in [constant.v](/Users/guweigang/Source/vphpext/vphp/compiler/repr/constant.v).

### `PhpConstRepr`

Represents one global constant-like export or one shadow constant carrier.

Fields:

- `name`
  - Exported name or shadow lookup name

- `value`
  - Literal string value
  - Mainly used for scalar constants

- `const_type`
  - Semantic constant type
  - Examples:
    - `int`
    - `f64`
    - `string`
    - `bool`
    - `struct`

- `v_type`
  - Original V-side type name
  - Especially important when `const_type == 'struct'`

- `has_php_const`
  - Whether this constant should become a PHP global constant
  - Shadow carriers may intentionally be false

- `fields`
  - Nested sub-constants when the constant represents a struct-like constant carrier
  - Used by class shadow constant linking

Important nuance:

- A `PhpConstRepr` can represent either:
  - a real PHP global constant
  - a shadow constant carrier used only for later linking

## Globals Repr

Defined in [globals.v](/Users/guweigang/Source/vphpext/vphp/compiler/repr/globals.v).

### `PhpGlobalsRepr`

Represents the extension's Zend globals definition.

Fields:

- `name`
  - Globals struct name

- `fields`
  - Global field list

### `PhpGlobalField`

Fields:

- `name`
  - Global field name

- `v_type`
  - Original V-side type

## Task Repr

Defined in [task.v](/Users/guweigang/Source/vphpext/vphp/compiler/repr/task.v).

### `PhpTaskRepr`

Represents one task export in the VPHP task subsystem.

Fields:

- `task_name`
  - PHP-visible registration name

- `v_name`
  - Original V struct name

- `parameters`
  - Ordered task argument metadata

### `PhpTaskArg`

Fields:

- `name`
  - Parameter name

- `v_type`
  - Parameter V type

## Repr Invariants

These are the practical rules the rest of the compiler expects.

1. `repr` values should be structurally valid before code generation starts
2. parser may leave some derived fields unresolved
3. linker is allowed to enrich reprs after parse
4. builder/emitter should treat repr as the source of truth
5. `repr` should not contain AST nodes

## Parse vs Link vs Emit

A good mental model:

- parser fills direct facts
- linker fills relationship-derived facts
- builder/emitter consume finalized facts

Examples:

- `methods` are parser facts
- `shadow_static_type` is a linker fact
- `render_minit()` output is an emitter concern

## Summary

`repr` is the compiler's stable middle language.

It should remain:

- explicit
- boring
- predictable

If a future change feels like "repr should start doing work", that work probably belongs in `parser`, `linker`, or `builder` instead.
