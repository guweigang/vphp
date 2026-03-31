# VPHP Compiler Docs

This directory contains the VPHP compiler implementation and its design documents.

Project overview:

- [../docs/OVERVIEW.md](/Users/guweigang/Source/vphpx/vphp/docs/OVERVIEW.md)

## Start Here

If you are new to the compiler, read these in order:

1. [architecture.md](/Users/guweigang/Source/vphpx/vphp/compiler/architecture.md)
2. [repr.md](/Users/guweigang/Source/vphpx/vphp/compiler/repr.md)
3. [class_shadows.md](/Users/guweigang/Source/vphpx/vphp/compiler/class_shadows.md)
4. [builder.md](/Users/guweigang/Source/vphpx/vphp/compiler/builder.md)
5. [emission_pipeline.md](/Users/guweigang/Source/vphpx/vphp/compiler/emission_pipeline.md)

## Implementation Layout

```text
vphp/compiler/
  mod.v                 # compile pipeline entry
  export.v              # export assembly and file emission
  c_emitter.v           # C wrapper emission
  v_glue.v              # V bridge emission
  types.v               # shared type/runtime helpers
  repr/                 # compiler representations
  parser/               # AST -> repr
  linker/               # post-parse linking
  builder/              # repr -> export fragments
```

## Quick Map

### Core pipeline

- [mod.v](/Users/guweigang/Source/vphpx/vphp/compiler/mod.v)
- [export.v](/Users/guweigang/Source/vphpx/vphp/compiler/export.v)
- [c_emitter.v](/Users/guweigang/Source/vphpx/vphp/compiler/c_emitter.v)
- [v_glue.v](/Users/guweigang/Source/vphpx/vphp/compiler/v_glue.v)

### Submodules

- `repr`
  - internal compiler representations

- `parser`
  - V AST parsing into reprs

- `linker`
  - post-parse reconciliation such as class shadow linking

- `builder`
  - reusable export/code fragment builders

## Recommended Reading By Task

### I want to understand the whole compiler

Read:

1. [architecture.md](/Users/guweigang/Source/vphpx/vphp/compiler/architecture.md)
2. [emission_pipeline.md](/Users/guweigang/Source/vphpx/vphp/compiler/emission_pipeline.md)

### I want to add a new parsed feature

Read:

1. [repr.md](/Users/guweigang/Source/vphpx/vphp/compiler/repr.md)
2. `parser/`
3. [architecture.md](/Users/guweigang/Source/vphpx/vphp/compiler/architecture.md)

### I want to change class static/class const shadow behavior

Read:

1. [class_shadows.md](/Users/guweigang/Source/vphpx/vphp/compiler/class_shadows.md)
2. [v_glue.v](/Users/guweigang/Source/vphpx/vphp/compiler/v_glue.v)
3. [c_emitter.v](/Users/guweigang/Source/vphpx/vphp/compiler/c_emitter.v)

### I want to change export/code generation

Read:

1. [builder.md](/Users/guweigang/Source/vphpx/vphp/compiler/builder.md)
2. [emission_pipeline.md](/Users/guweigang/Source/vphpx/vphp/compiler/emission_pipeline.md)

Important:

- `emission_pipeline.md` now documents return-shape classification for
  `@[php_method]`, including container returns like `map[string]string` and
  `[]string`

## PHP Signature Attributes

The compiler supports a small set of explicit attributes for PHP-facing
signatures. Prefer these over parameter-name heuristics.

- `@[php_arg_type: 'request=Psr\\Http\\Message\\RequestInterface']`
  overrides the PHP arginfo type for a specific parameter.
- `@[php_arg_type: 'a=array,b=Traversable']`
  supports multiple `name=type` entries in one attribute.
- `@[php_optional_args: 'default_status,default_reason_phrase']`
  marks trailing PHP-optional parameters explicitly.

Notes:

- `php_optional_args` only changes PHP required-arg counts / arginfo shape.
  It does not synthesize V default-value behavior.
- `php_arg_type` is most useful for interface/object/array/iterable contracts
  that V cannot express directly in PHP arginfo.
- Be conservative with scalar narrowing (`string`, `int`, `bool`) on exported
  interfaces. If compatibility matters, prefer runtime validation over
  over-constrained arginfo.

## Guiding Idea

The compiler is organized around this progression:

```text
AST -> repr -> linker -> builder fragments -> emitted C/V bridge code
```

When making changes, try to keep responsibilities in the right layer:

- parsing in `parser`
- semantic data in `repr`
- relationship reconciliation in `linker`
- reusable export assembly in `builder`
- concrete output generation in `export`, `c_emitter`, and `v_glue`
