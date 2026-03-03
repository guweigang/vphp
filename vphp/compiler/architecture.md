# VPHP Compiler Architecture

## Goal

`vphp.compiler` is responsible for turning V source annotated with VPHP metadata into:

- `php_bridge.h`
- `php_bridge.c`
- `bridge.v`

The compiler is intentionally split into a few small layers so that parsing, linking, and code generation can evolve independently.

## Top-Level Layout

```text
vphp/compiler/
  mod.v          # Compiler entry and compile pipeline
  export.v       # export assembly and final file emission
  c_emitter.v    # C-side wrapper and glue emission
  v_glue.v       # V-side bridge/glue emission
  types.v        # shared runtime/type mapping helpers
  repr/          # compiler representations
  parser/        # AST -> repr
  linker/        # repr -> linked repr
  builder/       # repr -> export/code fragments
```

## Layer Responsibilities

### 1. `repr`

Module: `vphp.compiler.repr`

Purpose:

- Define the compiler's internal representations
- Hold normalized export metadata
- Stay as close as possible to "plain data"

Examples:

- `PhpClassRepr`
- `PhpInterfaceRepr`
- `PhpEnumRepr`
- `PhpFuncRepr`
- `PhpConstRepr`
- `PhpTaskRepr`
- `PhpGlobalsRepr`

Non-goals:

- No AST walking
- No builder logic
- No final code emission

### 2. `parser`

Module: `vphp.compiler.parser`

Purpose:

- Parse V AST nodes into `repr` values
- Own all "how do we read this V syntax?" logic

Examples:

- `parse_class_decl(...)`
- `parse_interface_decl(...)`
- `parse_enum_decl(...)`
- `parse_function_decl(...)`
- `parse_constant_decl(...)`
- `add_class_method(...)`
- `add_class_static_method(...)`

Input:

- `v.ast` nodes

Output:

- `repr.Php*Repr`

### 3. `linker`

Module: `vphp.compiler.linker`

Purpose:

- Resolve relationships that are not fully known during the initial parse
- Perform post-parse enrichment on `repr`

Current responsibility:

- Class shadow linking:
  - shadow static properties
  - shadow constants

Current entry:

- `link_class_shadows(mut elements, table)`

This layer exists to keep `mod.v` from becoming a second parser.

### 4. `builder`

Module: `vphp.compiler.builder`

Purpose:

- Convert `repr` into reusable export/code fragments
- Encapsulate repetitive Zend/C boilerplate assembly

Key types:

- `ClassBuilder`
- `FuncBuilder`
- `ConstantBuilder`
- `ModuleBuilder`
- `ExportFragments`

This layer should answer:

- "What should this symbol export?"
- "What declarations / registrations / tables does it contribute?"

It should not answer:

- "How do I parse V syntax?"

### 5. `export`

File: `vphp/compiler/export.v`

Purpose:

- Orchestrate all export fragments
- Emit final `php_bridge.h` and `php_bridge.c`
- Coordinate `builder`, `c_emitter`, and `v_glue`

This file is not a parser and not a low-level emitter.
It is the assembly layer.

### 6. `c_emitter`

File: `vphp/compiler/c_emitter.v`

Purpose:

- Generate concrete C wrappers and method glue
- Emit C function bodies that cannot be expressed as simple builder fragments

Typical examples:

- `PHP_METHOD(...)` wrappers
- object construction wrappers
- instance/static method bridge templates

### 7. `v_glue`

File: `vphp/compiler/v_glue.v`

Purpose:

- Generate the V-side bridge layer in `bridge.v`
- Connect PHP-visible wrappers to real V logic

Typical examples:

- `@[export: 'vphp_wrap_xxx']`
- task registration glue
- object property sync helpers

## Compile Pipeline

The current pipeline in [mod.v](/Users/guweigang/Source/vphpext/vphp/compiler/mod.v) is:

```mermaid
flowchart TD
    A["Parse V files into AST"] --> B["Scan type declarations"]
    B --> C["Scan functions / constants / tasks"]
    C --> D["Link shadow statics and constants"]
    D --> E["Collect export fragments"]
    E --> F["Emit php_bridge.h / php_bridge.c"]
    D --> G["Emit bridge.v"]
```

### Phase 0: Source parsing

For each input file:

- parse V source into AST
- extract extension metadata:
  - `name`
  - `version`
  - `description`
  - `ini_entries`

### Phase 1: Type scan

First pass over AST statements:

- interfaces
- enums
- globals struct
- classes

Why a separate type scan exists:

- methods and static methods need the class index to already exist

### Phase 2: Function scan

Second pass over AST statements:

- instance methods
- static methods
- global functions
- constants
- tasks

### Phase 3: Link

After parsing is complete:

- resolve class shadow statics
- resolve class shadow constants

This step mutates class reprs to append derived PHP-visible properties/constants.

## Export Pipeline

After `compile()` succeeds, generation is driven from [export.v](/Users/guweigang/Source/vphpext/vphp/compiler/export.v).

There are two main fragment collections:

1. non-type fragments
2. type fragments

These are merged into:

- declarations
- implementations
- `MINIT` lines
- function table entries

`ExportFragments` is the common transport object for this stage.

## Data Flow

The intended dependency direction is:

```mermaid
flowchart LR
    A["repr"] --> B["parser"]
    A --> C["linker"]
    A --> D["builder"]
    A --> E["compiler root"]
    B --> E
    C --> E
    D --> E
```

Rules:

- `repr` should not depend on `parser`, `linker`, or `builder`
- `parser` should not depend on `builder`
- `builder` should not depend on `parser`
- root `compiler` coordinates everything

## Naming Conventions

### Files

Prefer role-oriented file names:

- `export.v`
- `c_emitter.v`
- `v_glue.v`

Submodules use domain names:

- `repr/`
- `parser/`
- `linker/`
- `builder/`

### Builder types

Prefer:

- file name is the domain
- type name is `*Builder`
- constructor is `new_xxx_builder(...)`

Examples:

- `builder/class.v` -> `ClassBuilder`
- `builder/function.v` -> `FuncBuilder`
- `builder/constant.v` -> `ConstantBuilder`

### Repr types

Repr types should stay explicit and stable:

- `PhpClassRepr`
- `PhpFuncRepr`
- `PhpEnumRepr`

These are part of the compiler's internal language and should avoid clever renames.

## Extension Guidance

When adding a new PHP-visible capability, use this checklist.

### If the feature is new V syntax / annotation parsing

Change:

- `parser/`
- maybe `repr/`

Examples:

- trait parsing
- interface property parsing
- new export annotations

### If the feature is a post-parse relationship

Change:

- `linker/`

Examples:

- explicit V `implements` to PHP interface linking
- trait flattening/linking
- parent/child metadata reconciliation

### If the feature is mostly export boilerplate

Change:

- `builder/`
- maybe `export.v`

Examples:

- new constant registration style
- new class registration flags
- reusable arginfo/table fragments

### If the feature needs concrete wrapper bodies

Change:

- `c_emitter.v`
- or `v_glue.v`

Examples:

- new object/method wrapper shape
- special result/exception bridge logic
- task glue runtime behavior

## Current Pain Points

These are known areas that can still improve:

1. `export.v` still knows a fair amount about fragment grouping
2. `c_emitter.v` still contains large template-heavy logic
3. `v_glue.v` still mixes object glue, task glue, and function glue in one file
4. shadow-linking is isolated now, and future relationship passes may continue to grow `linker/`

## Recommended Near-Term Next Steps

1. Add a short doc for `repr` field semantics
2. Split `v_glue.v` later by domain:
   - function glue
   - class glue
   - task glue
3. Continue splitting linker responsibilities by relationship type when new passes are added
4. Keep resisting the urge to move `export/c_emitter/v_glue` into a `gen/` submodule until their boundaries are even more stable

## Summary

The current architecture is:

- `repr` for data
- `parser` for AST parsing
- `linker` for post-parse reconciliation
- `builder` for reusable export fragments
- `export` for assembly
- `c_emitter` for concrete C wrapper emission
- `v_glue` for V bridge generation

That split keeps the compiler understandable while still leaving room for more advanced PHP features later.
