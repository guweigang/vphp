# Builder Layer Semantics

## Goal

The `builder` layer converts finalized `repr` data into reusable export fragments.

This layer sits between:

- parser/linker-owned semantic data
- compiler root / emitters that need concrete output pieces

Its purpose is not to fully generate all code.
Its purpose is to answer:

- what does this symbol contribute?
- which declarations should exist?
- which `MINIT` lines should be emitted?
- which function table entries should be registered?

## Location

```text
vphp/compiler/builder/
  class.v
  function.v
  constant.v
  module.v
  fragments.v
```

## Design Principle

The builder layer should prefer:

- normalized inputs
- small reusable outputs
- low policy

That means:

- parser decides what a class means
- linker resolves relationships
- builder turns those facts into export-ready parts

If a builder needs to understand raw AST, something is in the wrong layer.

## Main Builders

### `ClassBuilder`

Defined in [class.v](/Users/guweigang/Source/vphpext/vphp/compiler/builder/class.v).

This is the central type export builder.

It is used for:

- PHP classes
- PHP interfaces
- enum-style class exports

### `ClassType`

`ClassBuilder` is parameterized by:

- `.class_`
- `.interface_`
- `.enum_`

This allows one builder to share:

- class entry declaration
- method table generation
- arginfo generation
- `MINIT` registration

while still branching in the few places where PHP type behavior differs.

### Internal Data Model

`ClassBuilder` stores:

- `type`
  - class/interface/enum classification

- `php_name`
  - final PHP-visible symbol name

- `c_name`
  - C-safe name used in generated code

- `parent`
  - parent class if any

- `create_object`
  - whether Zend object creation handler should be installed

- `class_flags`
  - low-level Zend class flags

- `interfaces`
  - explicit interfaces to attach

- `properties`
  - normalized class properties ready for declaration

- `constants`
  - normalized class constants ready for declaration

- `methods`
  - normalized methods ready for arginfo and method table emission

### Mutating API

`ClassBuilder` is intentionally incremental.

Callers build it step-by-step:

- `set_parent(...)`
- `set_create_object(...)`
- `add_class_flag(...)`
- `add_interface(...)`
- `add_property(...)`
- `add_constant(...)`
- `add_method(...)`
- `add_abstract_method(...)`

This lets `c_emitter.v` translate `repr` into a builder without directly formatting C strings everywhere.

### Render Methods

`ClassBuilder` currently produces:

- `render_ce_declaration()`
- `render_ce_extern_declaration()`
- `render_arginfo_defs()`
- `render_methods_array()`
- `render_minit()`
- `render_impl_prelude()`
- `render_impl_postlude()`

These methods are intentionally lower-level than full-file generation.

They return partial artifacts that can be assembled elsewhere.

### `export_fragments()`

This is the most important builder-facing contract.

For `ClassBuilder`, the exported fragments currently include:

- declarations
  - class entry extern declaration

- `minit_lines`
  - class/interface/enum registration block

Implementations are still partly supplied later by `c_emitter.v`, because wrapper bodies are not fully generic yet.

## `FuncBuilder`

Defined in [function.v](/Users/guweigang/Source/vphpext/vphp/compiler/builder/function.v).

Purpose:

- represent one PHP global function export in builder form

Stored data:

- `php_name`
- `c_func`

Rendered outputs:

- `render_declaration()`
- `render_arginfo()`
- `render_fe()`

`export_fragments()` contributes:

- function declaration
- function table entry

It does not produce full function implementations.
Those are still completed in `c_emitter.v`.

## `ConstantBuilder`

Defined in [constant.v](/Users/guweigang/Source/vphpext/vphp/compiler/builder/constant.v).

Purpose:

- represent one PHP global constant registration

Stored data:

- `name`
- `type_`
- `value`

Rendered output:

- `render_register()`

`export_fragments()` contributes:

- `MINIT` registration lines

This builder is intentionally small and focused.

## `ModuleBuilder`

Defined in [module.v](/Users/guweigang/Source/vphpext/vphp/compiler/builder/module.v).

Purpose:

- assemble the final extension-level C scaffolding

This is the only builder that operates at the module level rather than the symbol level.

It owns:

- function table assembly
- `MINIT`
- `MSHUTDOWN`
- `MINFO`
- globals struct/ginit generation
- module entry generation

### Stored Data

- `ext_name`
- `version`
- `description`
- `functions`
- `minit_content`
- `ini_entries`
- `globals`

### Important Distinction

`ModuleBuilder` is not a replacement for `ExportFragments`.

Instead:

- symbol builders produce fragments
- `export.v` aggregates fragments
- `ModuleBuilder` consumes some of those fragments to build extension-level output

So `ModuleBuilder` is downstream from the symbol builders.

## `ExportFragments`

Defined in [fragments.v](/Users/guweigang/Source/vphpext/vphp/compiler/builder/fragments.v).

This is the transport object for the builder layer.

Fields:

- `declarations`
- `implementations`
- `minit_lines`
- `function_table`

### Why it exists

Without `ExportFragments`, the compiler root would need to know too much about each symbol category:

- where declarations go
- which lines belong to `MINIT`
- how functions enter the function table

With fragments:

- each builder/export path contributes partial output
- assembly becomes a merge operation

### `merge(...)`

`merge(...)` is intentionally simple concatenation.

Ordering decisions are made by the caller.

This is important because:

- interfaces must currently be collected before classes that implement them
- function and type exports are sometimes collected in separate passes

`ExportFragments` does not enforce ordering policy.
It only carries pieces.

## Builder Boundaries

The builder layer should handle:

- Zend declaration boilerplate
- class/property/constant registration fragments
- reusable function table pieces
- module-level C scaffolding

The builder layer should not handle:

- AST parsing
- linker reconciliation
- large wrapper body templates
- V-side runtime glue

## Current Collaboration Pattern

The current pattern is:

1. parser builds `repr`
2. linker enriches `repr`
3. `c_emitter.v` maps `repr -> builder`
4. builders emit fragments
5. `export.v` assembles fragments
6. `ModuleBuilder` renders the final module-level blocks

This means the builder layer is both:

- a normalization boundary
- a reuse boundary

## Current Limitations

These are known and acceptable for now.

1. `ClassBuilder.export_fragments()` does not yet carry full class implementations
2. `FuncBuilder` still relies on `c_emitter.v` for wrapper bodies
3. `ModuleBuilder` is string-heavy and still fairly C-specific

These are not design failures.
They simply show which parts of the pipeline are fully generic today and which are still emitter-owned.

## Good Future Evolutions

Examples of healthy builder growth:

1. richer arginfo modeling
2. more reusable property/constant declaration helpers
3. more implementation scaffolding moving from `c_emitter.v` into builders
4. specialized builders for future features such as exceptions or traits

Examples of unhealthy builder growth:

1. directly walking AST
2. embedding parser policy
3. embedding runtime sync logic

## Summary

The builder layer is the compiler's export normalization layer.

It takes stable semantic data and turns it into reusable code fragments that the rest of the compiler can assemble predictably.

If `repr` is the compiler's middle language, `builder` is the compiler's export language.
