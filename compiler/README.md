# VPHP Compiler Docs

This directory contains the VPHP compiler implementation and its design documents.

Project overview:

- [../docs/OVERVIEW.md](../docs/OVERVIEW.md)

## Start Here

If you are new to the compiler, read these in order:

1. [architecture.md](architecture.md)
2. [repr.md](repr.md)
3. [class_shadows.md](class_shadows.md)
4. [builder.md](builder.md)
5. [emission_pipeline.md](emission_pipeline.md)

## Implementation Layout

```text
vphp/compiler/
  entry.v               # compile pipeline entry
  export.v              # export assembly and file emission
  c_emitter.v           # C wrapper emission
  v_glue.v              # V bridge emission
  php_types/            # shared PHP-facing type/spec mapping
  repr/                 # compiler representations
  parser/               # AST -> repr
  linker/               # post-parse linking
  builder/              # repr -> export fragments
```

## Quick Map

### Core pipeline

- [entry.v](entry.v)
- [export.v](export.v)
- [c_emitter.v](c_emitter.v)
- [v_glue.v](v_glue.v)

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

1. [architecture.md](architecture.md)
2. [emission_pipeline.md](emission_pipeline.md)

### I want to add a new parsed feature

Read:

1. [repr.md](repr.md)
2. `parser/`
3. [architecture.md](architecture.md)

### I want to change class static/class const shadow behavior

Read:

1. [class_shadows.md](class_shadows.md)
2. [v_glue.v](v_glue.v)
3. [c_emitter.v](c_emitter.v)

### I want to change export/code generation

Read:

1. [builder.md](builder.md)
2. [emission_pipeline.md](emission_pipeline.md)

Important:

- `emission_pipeline.md` now documents return-shape classification for
  `@[php_method]`, including container returns like `map[string]string` and
  `[]string`

## Ownership-facing Defaults

For new exported APIs, prefer ownership-aware wrapper types in signatures:

- `RequestBorrowedZBox`
- `RequestOwnedZBox`
- `PersistentOwnedZBox`

Treat these as the compiler-facing default vocabulary.

In practice:

- parameter signatures should prefer `RequestBorrowedZBox`
- temporary owned results inside glue should prefer `RequestOwnedZBox`
- long-lived stored values should prefer `PersistentOwnedZBox`

## Exported Function Parameter Forms

Exported V functions and methods should use one of five parameter forms. Pick
the narrowest form that matches the API surface you want PHP users to see.

### 1. `vphp.Context`

Use `Context` when the implementation needs the full PHP call frame:

```v
@[php_function]
fn handle(ctx vphp.Context) {
	args := ctx.args([
		vphp.PhpInArgMeta{ index: 0, name: 'payload' },
	])
	value := args.at(0).value
	ctx.return().string(value.type_name())
}
```

`Context` is hidden from PHP arginfo. It is the escape hatch for dynamic
argument handling, manual return writes, or direct access to request state.

Do not combine `Context` with `PhpInArgs`; `PhpInArgs` is derived from `Context`.

### 2. V Native Values

Use plain V types when the function wants business values:

```v
@[php_function]
fn add(foo int, bar string, active bool, ratio f64) string {
	return '${foo}:${bar}:${active}:${ratio}'
}
```

The generated glue reads PHP arguments, converts them to V values, and calls the
function with those decoded values.

### 3. PHP Semantic Wrappers

Use semantic wrappers when the implementation wants PHP value semantics without
working at raw `ZVal` level:

```v
@[php_function]
fn inspect(value vphp.PhpValue, obj vphp.PhpObject, arr vphp.PhpArray, cb vphp.PhpCallable) string {
	return '${value.type_name()}:${obj.class_name()}:${arr.count()}:${cb.is_valid()}'
}
```

Supported wrapper parameters include:

- `vphp.PhpValue`
- `vphp.PhpNull`
- `vphp.PhpBool`
- `vphp.PhpInt`
- `vphp.PhpDouble`
- `vphp.PhpString`
- `vphp.PhpScalar`
- `vphp.PhpArray`
- `vphp.PhpObject`
- `vphp.PhpCallable`
- `vphp.PhpResource`
- `vphp.PhpReference`
- `vphp.PhpIterable`
- `vphp.PhpThrowable`
- `vphp.PhpEnumCase`

Optional wrappers are supported:

```v
@[php_function]
fn maybe(obj ?vphp.PhpObject, value ?vphp.PhpValue) string {
	// ?PhpObject is a narrowing wrapper: null/non-object becomes none.
	// ?PhpValue preserves PHP null as some(PhpValue(null)); none means missing.
	return '${obj == none}:${value == none}'
}
```

### 4. Lifecycle / Raw Value Escape Hatches

Use these when ownership or raw Zend interop is the point of the API:

```v
@[php_function]
fn low_level(raw vphp.ZVal, borrowed vphp.RequestBorrowedZBox) vphp.RequestOwnedZBox {
	return vphp.RequestOwnedZBox.of(raw)
}
```

Supported low-level forms include:

- `vphp.ZVal`
- `vphp.RequestBorrowedZBox`
- `vphp.RequestOwnedZBox`
- `vphp.PersistentOwnedZBox`

These are useful for infrastructure and compatibility code. Prefer semantic
wrappers for application-facing APIs.

### 5. `@[params]` Structs

Use a params struct when PHP arguments should map to a named/default parameter
object:

```v
@[params]
struct CreateResponseParams {
	status        int    = 200
	reason_phrase string = ''
}

@[php_function]
fn create_response(params CreateResponseParams) string {
	return '${params.status}:${params.reason_phrase}'
}
```

The compiler expands the final `@[params]` struct into PHP-visible arguments,
builds `PhpInArgs` in glue, applies V defaults when arguments are omitted, and
then calls the V function with the constructed params struct.

Generated params struct bindings read arguments by PHP parameter name first and
fall back to position. This allows PHP callers to skip optional parameters with
named arguments:

```php
create_response(reasonPhrase: 'Accepted');
```

Params struct fields may use plain V scalar types or semantic PHP wrappers such
as `vphp.PhpString`, `vphp.PhpBool`, and `vphp.PhpArray`. Wrapper fields get
semantic empty defaults and still validate the PHP value when it is supplied.

Do not expose `vphp.PhpInArgs` directly as a function parameter. `PhpInArgs` is a
glue/runtime model and is available from `Context` via `ctx.args(...)` when a
function intentionally enters the low-level `Context` mode.

## Exported Function Return Forms

Exported V functions and methods should return through one of five forms. Match
the return form to the same semantic layer used by the implementation.

### 1. `vphp.Context` Manual Return

Use `ctx.return()` when the function is already in explicit `Context` mode and
needs to write the PHP return slot manually:

```v
@[php_function]
fn dynamic(ctx vphp.Context) {
	args := ctx.args([
		vphp.PhpInArgMeta{ index: 0, name: 'payload' },
	])
	ctx.return().string_value(args.at(0).value.type_name())
}
```

`ctx.return()` returns `vphp.PhpReturn`. It supports direct methods such as
`null()`, `bool_value(...)`, `int_value(...)`, `double_value(...)`,
`string_value(...)`, `value(...)`, `dyn_value(...)`, `request_owned(...)`, and
`zval(...)`.

### 2. V Native Values

Return plain V values when the PHP API should receive decoded business data:

```v
@[php_function]
fn add(foo int, bar int) int {
	return foo + bar
}
```

Supported scalar returns include `string`, `bool`, `int`, `i64`, and `f64`.
Options and results keep their bridge semantics: `?T` maps `none` to PHP `null`,
and `!T` maps errors to PHP exceptions.

### 3. V Containers And Structs

Return V arrays, maps, or structs when the function intentionally returns a PHP
array built from V data:

```v
struct UserPayload {
	name string
	age  int
}

@[php_function]
fn user_payload() UserPayload {
	return UserPayload{ name: 'codex', age: 7 }
}
```

This is a serialization path. It is appropriate for plain V data, not for PHP
semantic wrappers.

### 4. PHP Semantic Wrappers

Return semantic wrappers when the implementation wants to preserve the original
PHP value semantics:

```v
@[php_function]
fn same_object(obj vphp.PhpObject) vphp.PhpObject {
	return obj
}

@[php_function]
fn same_array(arr vphp.PhpArray) vphp.PhpArray {
	return arr
}
```

Supported wrapper returns include the parameter wrappers listed above, plus
`vphp.PhpClass`, `vphp.PhpFunction`, `vphp.PhpClosure`, and persistent wrapper
forms such as `vphp.PersistentPhpValue`, `vphp.PersistentPhpArray`,
`vphp.PersistentPhpObject`, and `vphp.PersistentPhpClosure`.

Semantic wrapper returns preserve the wrapped PHP value. They are not serialized
as V structs.

### 5. Lifecycle / Raw Value Returns

Return lifecycle boxes or raw values when ownership is part of the API:

```v
@[php_function]
fn low_level(raw vphp.ZVal) vphp.RequestOwnedZBox {
	return vphp.RequestOwnedZBox.of(raw)
}
```

Supported low-level returns include `vphp.ZVal`, `vphp.RequestBorrowedZBox`,
`vphp.RequestOwnedZBox`, and `vphp.PersistentOwnedZBox`.

Prefer semantic wrappers for application-facing APIs. Use lifecycle/raw returns
for infrastructure code, compiler tests, and places where ownership is the
actual behavior being exposed.

## PHP Signature Attributes

The compiler supports a small set of explicit attributes for PHP-facing
signatures. Prefer these over parameter-name heuristics.

- `@[php_arg_type: 'request=Psr\\Http\\Message\\RequestInterface']`
  overrides the PHP arginfo type for a specific parameter.
- `@[php_arg_type: 'a=array,b=Traversable']`
  supports multiple `name=type` entries in one attribute.
- `@[php_arg_default: 'default_status=200,default_reason_phrase=""']`
  records PHP reflection default values for optional parameters.
- `@[php_arg_optional: 'default_status,default_reason_phrase']`
  marks trailing PHP-optional parameters explicitly.

Notes:

- `php_arg_optional` only changes PHP required-arg counts / arginfo shape.
  For ordinary parameters with a supported default literal, the generated glue
  also applies the default when PHP omits the argument.
- `php_arg_default` records PHP arginfo / reflection defaults and, for supported
  ordinary parameter forms, provides the value used by glue when omitted.
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
