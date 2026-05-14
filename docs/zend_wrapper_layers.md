# Zend Wrapper Layers

This document defines how `vphp` should isolate direct Zend C calls and expose progressively nicer V APIs above them.

Status: **migration started / not fully implemented**.

The current codebase already has many of these concepts. The `vphp/zend/`
directory now contains both C declarations and the first migrated C-boundary
wrappers, such as runtime, include, and superglobal helpers. The broader
`vphp/zval/`, `vphp/zbox/`, `vphp/scope/`, and `vphp/object/` layout is still a
migration target and is not fully implemented yet.

Current migration checkpoint:

- Direct Zend bridge calls for runtime, include, superglobals, calls, closures,
  class entries, class handlers, objects, arrays, execute data, and zval value
  allocation/conversion helpers have been moved under `vphp/zend/`.
- `vphp/object/` has started as a no-C low-level object wrapper area. It now
  contains object handle, lifecycle, property read-result, vptr root, and object return
  helpers. Root-level `object_binding.v` and generic lifecycle helpers now
  delegate their low-level allocation, roots, runtime-free, and return-object
  operations to `vphp/object/`; generated generic property helpers remain at the
  root because property results and field cleanup still depend on root-level
  `ZVal`/ownership and semantic wrapper types.
- `vphp/execute/` has started as a no-C low-level execute-data wrapper area. It
  now contains execute-data handle, argument access, and active context helpers;
  root-level `ZExData` remains the compatibility facade because argument values
  still need root-level `ZVal`, `PhpArg`, and semantic wrappers.
- `Context` now stores `ZExData` and `PhpReturn` wrappers instead of exposing raw
  Zend fields. The ABI-facing constructor is `Context.from_ptr(ex, ret)`, and
  generated closure glue uses that pointer-shaped entry directly.
- `vphp/scope/` has started as a no-C low-level request scope wrapper area. It
  now contains request mark/enter/leave helpers and autorelease zval
  add/forget/drain helpers; root-level `RequestScope`, `FrameScope`, and
  `PhpScope` remain compatibility facades because frame values still depend on
  root-level ZBox and semantic wrapper types.
- `RequestBorrowedZBox` and `RequestOwnedZBox` now have pointer/handle/zval
  factory helpers. Legacy `from_raw(...)` / `from_raw_zval(...)` aliases have
  been removed from the request ZBox layer.
- `vphp/zval/` has started as a no-C low-level zval wrapper area. It now
  contains zval handle, request/persistent allocation lifecycle, copy/disown,
  runtime counter helpers, low-level array operation helpers, scalar/type
  read/write helpers, reference/resource helpers, call argument packing, scalar
  factory helpers, low-level foreach dispatch, include-file result handling, and
  static class/superglobal helpers; root-level `ZVal` remains the compatibility facade
  because call result ownership and semantic wrapper methods still depend on
  the root-level `ZVal`/ZBox shape.
- Root-level files still contain raw C pointer types only where they are part of
  the current ABI or low-level storage shape, such as `ZVal.raw`, generic object
  handler callbacks, foreach callback trampolines, and adapter functions that
  pass `&C.zval` through to `vphp/zend/`. `PhpReturn`, `ZExData`,
  `ZendObject`, `ZendClassEntry`, and ZBox constructors now use pointer/handle
  shaped facades instead of `from_raw(...)` / `raw_zval()` style public APIs.
- `[]ZVal -> []zval.Handle -> &&C.zval` argument packing is now split between
  `vphp/zval/` and `vphp/zend/`. Root-level call helpers still own result
  adoption because `OwnershipKind` and `ZVal` remain root-level facades.

The rule of thumb:

```text
bridge/*.inc.c + v_bridge.c/h
  -> Zend boundary in V
  -> no-C low-level V wrapper
  -> abstract V semantic wrapper
```

The goal is not to hide Zend completely. The goal is to keep `C.xxx`, raw `&C.zval`, `&&C.zval`, `&C.zend_object`, and similar details inside a small, reviewable boundary.

`vphp/bridge/` is the C implementation side. It contains C fragments included by `v_bridge.c`. It is not a V wrapper layer.

## Layer Map

| Layer | Allows | Avoids | Typical files | Typical API |
| --- | --- | --- | --- | --- |
| C implementation | C code, Zend macros, PHP headers | V APIs | `vphp/bridge/*.inc.c`, `vphp/v_bridge.c`, `vphp/v_bridge.h` | `vphp_call_method(...)` |
| 1. Zend C declarations | `C.zval`, `C.zend_object`, `C.vphp_call_*`, `C.ZVAL_COPY` declarations | V semantic objects | `vphp/zend/types.v`, `vphp/zend/bridge_api.v`, `vphp/zend/native_api.v`, `vphp/zend/constants.v` | `pub fn C.vphp_call_method(...)` |
| 2. Low-level C-boundary wrapper | Direct `C.xxx`, `&C.zval`, `&&C.zval`, retval allocation/release/adopt | Public semantic APIs | Target: `vphp/zend/call.v`, `vphp/zend/value.v`, `vphp/zend/object.v`, `vphp/zend/property.v`, `vphp/zend/array.v` | `call_function_zval(...)`, `raw_read_property(...)` |
| 3. No-C low-level V wrapper | `ZVal`, `ZExData`, `ZendObject`, `OwnershipKind`, `RequestScope`, `*ZBox` | Direct `C.xxx` in signatures or normal call paths | Target: `vphp/zval/`, `vphp/zbox/`, `vphp/scope/`, `vphp/object/`, `vphp/execute/` | `ZVal.method_owned_request(...)` |
| 4. Abstract V semantic wrapper | `PhpValue`, `PhpInt`, `PhpString`, `PhpArray`, `PhpObject`, `PhpFunction`, `PhpArgInput`, `PhpArg`, `PhpReturn` | Raw Zend types except explicit escape hatches | `php_*_type.v` | `PhpFunction.named(...).call[T](...)` |

## C Implementation: bridge/

`vphp/bridge/` contains C implementation fragments, not V wrappers.

Current homes:

- `vphp/bridge/call.inc.c`
- `vphp/bridge/object.inc.c`
- `vphp/bridge/runtime.inc.c`
- `vphp/bridge/values.inc.c`
- `vphp/bridge/compat.h`
- `vphp/v_bridge.c`
- `vphp/v_bridge.h`

The relationship is:

```text
bridge/*.inc.c
  -> compiled into v_bridge.c / v_bridge.h
  -> declared to V in vphp/zend/
  -> wrapped by V helpers in vphp/zend/
  -> exposed as ZVal/ZBox/scope/object methods
  -> surfaced as PhpValue/PhpObject/PhpFunction APIs
```

Do not move `.inc.c` files into the V wrapper directories. `bridge/` should stay the C implementation home.

## Layer 1: Zend C Declarations

This layer is the declaration and C implementation boundary.

It can expose raw Zend and vphp bridge symbols:

```v
pub fn C.vphp_call_method(
	obj &C.zval,
	method &char,
	len int,
	retval &C.zval,
	p_count int,
	params &&C.zval
) int
```

This layer does not optimize for V ergonomics. It exists to keep C declarations complete, explicit, and close to the C implementation.

Current homes:

- `vphp/zend/types.v`
- `vphp/zend/bridge_api.v`
- `vphp/zend/native_api.v`
- `vphp/zend/constants.v`

Layer 1 and Layer 2 share the `vphp/zend/` directory because both are Zend-facing boundary code. The distinction is file-level:

```text
vphp/zend/types.v       -> declarations
vphp/zend/bridge_api.v  -> declarations
vphp/zend/native_api.v  -> declarations
vphp/zend/constants.v   -> declarations

target:
  vphp/zend/runtime.v   -> C-boundary wrapper
  vphp/zend/include.v   -> C-boundary wrapper
  vphp/zend/superglobals.v -> C-boundary wrapper
  vphp/zend/call.v      -> C-boundary wrapper
  vphp/zend/closure.v   -> C-boundary wrapper
  vphp/zend/class_entry.v -> C-boundary wrapper
  vphp/zend/class_handlers.v -> C-boundary wrapper
  vphp/zend/value.v     -> C-boundary wrapper
  vphp/zend/object.v    -> C-boundary wrapper
  vphp/zend/array.v     -> C-boundary wrapper
  vphp/zend/execute.v   -> C-boundary wrapper
  vphp/zend/property.v  -> C-boundary wrapper target
```

## Layer 2: Low-Level C-Boundary Wrapper

This is the only V implementation layer where direct `C.xxx` usage should be common.

It owns the repetitive and error-prone patterns:

- constructing `[]&C.zval`
- producing `&&C.zval`
- allocating retval zvals
- releasing retval on failure
- adopting retval into `ZVal` with `OwnershipKind`
- handling `rv != res` read-property semantics
- converting V strings to `&char + len`

This layer should normally stay private to `vphp` implementation files. It should not become a public concept for extension authors.

For example, prefer private helpers like:

```v
fn call_function_zval(name string, args []ZVal, ownership OwnershipKind) ZVal
fn call_method_zval(receiver ZVal, method string, args []ZVal, ownership OwnershipKind) ZVal
fn call_callable_zval(callable ZVal, args []ZVal, ownership OwnershipKind) ZVal
fn new_instance_zval(class_name string, args []ZVal, ownership OwnershipKind) ZVal
```

These helper signatures still use only `ZVal`, `string`, and `OwnershipKind`. The raw `&C.zval` and `&&C.zval` details stay one level deeper:

```v
fn call_with_args_and_ret(
	args []ZVal,
	ownership OwnershipKind,
	run fn (&C.zval, int, &&C.zval) int
) ZVal
```

This helper is intentionally an implementation detail. It is not a public API.

## Layer 3: No-C Low-Level V Wrapper

This layer still speaks low-level vphp, but it should not expose raw C types in normal APIs.

Allowed concepts:

- `ZVal`
- `ZExData`
- `ZendObject`
- `OwnershipKind`
- `RequestBorrowedZBox`
- `RequestOwnedZBox`
- `PersistentOwnedZBox`
- `RequestScope`
- `FrameScope`

Layer 3 should not be represented by a single `zval/` directory. `ZVal` is only one part of this layer. The no-C low-level layer should be split by domain:

```text
vphp/zval/
  type.v
  scalar.v
  array.v
  call.v
  class.v
  object_props.v
  conversion.v
  lifecycle.v

vphp/zbox/
  types.v
  factory.v
  lifecycle.v
  predicate.v

vphp/scope/
  request.v
  frame.v

vphp/execute/
  data.v
  args.v

vphp/object/
  binding.v
  generic_lifecycle.v
  generic_props.v
  vptr_registry.v
```

This document describes the target shape. The current repository still has many Layer 3 files at the root while migration is not implemented.

Typical APIs:

```v
pub fn (v ZVal) call_owned_request(args []ZVal) ZVal {
	return call_function_zval(v.to_string(), args, .owned_request)
}

pub fn (v ZVal) method_owned_request(method string, args []ZVal) ZVal {
	return call_method_zval(v, method, args, .owned_request)
}
```

This layer is an escape hatch for vphp internals and advanced code. It is not the preferred user-facing layer, but it should already feel like V code rather than Zend C code.

## Layer 4: Abstract V Semantic Wrapper

This is the layer extension and framework code should prefer.

Typical concepts:

- `PhpValue`
- `PhpNull`
- `PhpBool`
- `PhpInt`
- `PhpDouble`
- `PhpString`
- `PhpArray`
- `PhpObject`
- `PhpCallable`
- `PhpClosure`
- `PhpFunction`
- `PhpClass`
- `PhpArgInput`
- `PhpArg`
- `PhpAttribute`
- `PhpReturn`

Typical APIs:

```v
result := vphp.PhpFunction.named('strlen').call[i64](
	vphp.PhpString.of('hello')
)!

obj.with_method_result[vphp.PhpValue]('handle', fn (value vphp.PhpValue) string {
	return value.to_json()
}, vphp.PhpString.of('payload'))!
```

This layer can expose explicit escape hatches:

```v
value.to_zval()
obj.to_zval()
ret.raw_ptr()
```

But normal code should not need those escape hatches.

`PhpReturn` is a special boundary wrapper: it represents Zend's callback
`return_value` slot. It stores a zval handle internally, and normal callers
should write through receiver methods such as `ret.string_value(...)`,
`ret.value(...)`, `ret.zval(...)`, `ret.owned_object(...)`, or
`ctx.return().v(result)`. `ret.raw_ptr()` is only for bridge code that must pass
the return slot to another Zend-facing helper. Normal code should not create
`&C.zval` views of the return slot.

## Compiler Projection

The compiler has its own internal layers, but generated code should still follow
the runtime wrapper layers above.

The compiler question is slightly different:

```text
Which runtime layer should this generated code target?
```

That question matters more than whether a compiler file itself lives in
`parser/`, `builder/`, or `v_glue/`.

### Compiler Layer Map

| Compiler area | Runtime layer it may target | Should know about Zend C? | Responsibility |
| --- | --- | --- | --- |
| `repr/` | none directly | no | Plain data that describes PHP/V export semantics |
| `parser/` | none directly | no | Convert V AST and attributes into `repr` |
| `linker/` | none directly | no | Resolve relationships between repr values |
| `php_types/` | Layer 3 and Layer 4 facts | no C macros | Centralize type mapping, defaults, arg decoding, return facts |
| `arg_binding.v` / `params_struct_binding.v` | Layer 3 or Layer 4 V glue | no direct Zend C | Generate parameter decoding through `Context`, `PhpArg`, semantic wrappers, and ZBox wrappers |
| `return_binding.v` | Layer 3 or Layer 4 V glue | no direct Zend C | Generate return handling through `PhpReturn`, semantic wrappers, and explicit low-level escape hatches |
| `class_method_binding.v` / `class_property_binding.v` | Layer 3 V glue, sometimes C-boundary bridge glue | limited | Generate object method/property glue; prefer wrappers where available |
| `v_glue*.v` | Layer 3 or Layer 4 V glue | limited | Connect PHP-visible C wrappers to exported V functions/classes |
| `builder/` | C implementation / Zend registration code | yes, as generated text | Generate arginfo, class/function tables, module registration, attributes, properties |
| `c_emitter.v` / `c_templates.v` | C implementation / Zend registration code | yes, as generated text | Generate PHP wrapper bodies and C glue that cannot be expressed as reusable builder fragments |
| `export.v` | assembly only | no new Zend logic | Assemble fragments into `php_bridge.c`, `php_bridge.h`, and `bridge.v` |

### Repr And Parser

`repr/` and `parser/` should describe intent, not Zend implementation.

Good repr fields:

- PHP name
- V type
- PHP type hint
- optional/default metadata
- attributes
- visibility
- return shape
- ownership intent

Poor repr fields:

- `zend_long`
- `ZEND_ACC_PUBLIC`
- `ZEND_ARG_TYPE_INFO`
- raw `&C.zval`
- pre-rendered C lines

Those details belong in `builder/`, `c_emitter.v`, or lower runtime wrappers.

### php_types As Type Semantics

`php_types/` should be the compiler's type facts center.

It should answer questions like:

- Which PHP type hint does this V type imply?
- Is this argument optional?
- Which `PhpArg` method decodes this semantic wrapper?
- Which default literal is valid for this type?
- Which return path should be used for this type?

It should not render Zend C macros directly. For example, `php_types/` may say
that `PhpArray` maps to PHP `array`, but `builder/arginfo.v` should decide how
that becomes `ZEND_ARG_TYPE_INFO(...)`.

### Builder And C Emitter

`builder/` and `c_emitter.v` are allowed to generate Zend C API usage.

They are the compiler-side equivalent of the C implementation and Zend
registration boundary:

```text
builder/arginfo.v
builder/class.v
builder/function.v
builder/module.v
c_emitter.v
c_templates.v
```

These files may generate:

- `ZEND_BEGIN_ARG_*`
- `ZEND_ARG_*`
- `zend_register_internal_class`
- `zend_declare_property_*`
- `zend_add_class_attribute`
- `zend_add_parameter_attribute`
- `PHP_FUNCTION`
- `PHP_METHOD`

The important rule is that Zend C details should stay concentrated here. If
multiple builder files need the same Zend pattern, prefer a small builder helper
over duplicating generated C strings.

### V Glue

Generated `bridge.v` should prefer no-C or semantic wrappers.

Preferred generated forms:

```v
ctx := vphp.Context.from_ptr(ex, ret)
php_args := ctx.args_with_meta([...])
name := php_args.at_named_or_index(0, 'name').string_value() or { ... }
ctx.return().string_value(result)
```

Acceptable low-level forms:

```v
raw := ctx.arg[vphp.ZVal](0)
box := ctx.arg[vphp.RequestBorrowedZBox](0)
```

Less desirable forms:

```v
mut rv := C.zval{}
C.vphp_read_property_compat(...)
C.vphp_write_property_compat(...)
```

These are still sometimes necessary today, especially in class/object glue, but
they should be treated as migration targets. When the generated V glue needs
direct `C.xxx`, that usually means one of these wrappers is missing:

- `ZExData`
- `PhpReturn`
- `ZendObject` / object property helper
- class/object lifecycle helper
- `ZVal`/`ZBox` conversion helper

### Generated Code Review Rules

When reviewing compiler changes, ask:

1. Does parser/repr contain generated C details?
2. Is a type mapping duplicated outside `php_types/`?
3. Does `builder/` duplicate a Zend registration pattern that should be a helper?
4. Does generated `bridge.v` use `C.xxx` where `Context`, `PhpArg`, `PhpReturn`, `ZVal`, or `ZBox` would be enough?
5. Does generated user-facing glue force extension authors down to `ZVal` when a semantic wrapper exists?
6. Is a new compiler concept just mirroring a runtime semantic type with a worse name?

### Migration Priority

This compiler projection is also a migration plan.

Near-term, low-risk cleanup:

- keep adding argument and return behavior to `arg_binding.v` and
  `return_binding.v`
- keep PHP-facing type facts in `php_types/`
- move repeated attribute, arginfo, property, and class registration snippets
  into builder helpers
- make generated glue prefer `PhpArg`, `PhpReturn`, and semantic wrappers

Medium-term cleanup:

- reduce direct `C.xxx` in `v_glue_class.v` and `class_property_binding.v`
- introduce missing `ZExData` and object property wrappers before changing
  generated glue shape
- split large C templates only when a repeated pattern has a clear owner

Non-goals for now:

- a large compiler directory reshuffle
- forcing every generated glue path to avoid `ZVal`
- hiding all Zend concepts from `builder/` and `c_emitter.v`
- inventing new public runtime types only to make generated code look nicer

## Deep-Water Checklist

The next migration stage is risky because it touches both runtime ownership and
compiler-generated glue. Before moving files or changing public names, keep
these boundaries explicit.

### What Can Move First

These are good next targets because they can be improved without changing the
extension author API:

- `ZVal` object property helpers can delegate through `ZendObject`, so property
  read/write semantics have one owner.
- static property and class constant reads can keep sharing
  ownership-parametrized private helpers.
- call helpers can keep the current `call_zval_target(...)` shape while
  progressively gaining clearer private target wrappers like
  `call_callable_zval(...)`, `call_method_zval(...)`, and `construct_zval(...)`.
- compiler-generated code should continue moving from raw return helpers toward
  `Context.from_ptr(...)`, `ctx.return()`, `ZExData`, `ZendObject`,
  `ZendClassEntry`, and semantic wrappers.

### What Should Not Move Yet

These areas should not be moved into submodules until the dependency direction
is solved:

- Layer 2 helpers that need `ZVal`, `OwnershipKind`, or `ZBox` cannot simply
  move into `vphp/zend/` today, because `vphp.zend` is already imported by the
  parent `vphp` module for C declarations. Importing parent runtime types back
  from `vphp.zend` would create the wrong dependency direction.
- generated Zend callback signatures still need raw `&C.zend_execute_data`,
  `&C.zval`, `&C.zend_object`, and similar types at the ABI edge. The important
  cleanup is to wrap them immediately inside the generated function body.
- The former `raw_zval()`, `raw_ex()`, `from_raw(...)`, `return_*_raw(...)`,
  and object binding raw helper surface has been narrowed or removed. Do not
  reintroduce public raw aliases unless the caller is an unavoidable ABI edge;
  prefer `from_ptr(...)`, `from_handle(...)`, `raw_ptr()`, or semantic wrappers.

### Allowed Raw Boundaries

The remaining raw C types are intentional and should stay small and reviewable:

- `ZVal.raw` and lifecycle helpers in `zval.v` / `zval_lifecycle_interop.v`,
  because they own allocation, copy, release, disown, and adoption semantics.
- `zval.Handle.raw_ptr()`, `object.Handle.raw_ptr()`, and
  `execute.Handle.raw_ptr()`, because Layer 3 needs one narrow pointer exit to
  call Layer 2.
- Generated or generic Zend callback signatures, such as
  `object_generic_props.v` and `zval_factory_iter.v`, because Zend calls into V
  with `&C.zval`/callback context pointers. These functions should wrap raw
  inputs immediately with `ZVal.from_ptr(...)`, `PhpReturn.from_ptr(...)`, or
  handle wrappers.
- `vphp/zend/**`, because it is the explicit C-boundary wrapper layer.

Outside those areas, new raw `&C.zval`, `&C.zend_object`, `C.xxx`, or public
`from_raw(...)` style APIs should be treated as a design smell.

### Ownership-Sensitive Areas

Treat these as high-risk until each change has a focused lifecycle test:

- `adopt_read_result(rv, res, ownership)`, because Zend property reads may
  return either the scratch `rv` or another zval pointer.
- `prop_borrowed(...)`, because the name is easy to misuse if the returned value
  escapes beyond the immediate read/copy path.
- persistent/request conversion on `PhpValue`, `PhpArray`, `PhpObject`, and
  `DynValue`.
- closure binding and callable invocation, because a captured V function may
  outlive the request frame that created the PHP callable wrapper.
- object binding and retained object/callable roots, because those paths decide
  who releases V-side payloads.

### Test Gate For Deep Edits

For code changes in the areas above, run at least:

```text
vphptest make build
vphptest ./run_tests.sh
LIBRARY_PATH=/opt/homebrew/opt/libsodium/lib make -C /Users/guweigang/Source/vphpx/vslim build
```

If ownership changes, also run the lifecycle/probe scripts under
`vphptest/tests/` and any relevant VSlim request-loop probes before committing.

## Review Rules

When reviewing new vphp code, ask:

1. Which layer does this file belong to?
2. Does this file expose a lower-layer concept in its public API?
3. Does a semantic wrapper directly call `C.xxx` when a lower layer should own that call?
4. Does compiler-generated code emit `C.xxx` where a no-C wrapper would be clearer?
5. Is a new public type being introduced for an implementation detail that could stay private?

The most important smell:

```text
Layer 4 code directly using Layer 1/2 C boundary calls.
```

That is usually a sign that a Layer 2 or Layer 3 helper is missing.

## Migration Strategy

Status: **partially started**. The first low-risk compiler/runtime cleanup makes
generated return glue prefer `ctx.return().*` / `PhpReturn` over older
`Context.return_*` convenience calls. `ZExData` now owns the low-level argument
read helpers that `Context` delegates to. Generated property glue now uses
`PhpReturn` and `ZVal.from_ptr(...)` instead of direct return/raw-zval helpers
inside the generated body, and inherited object property sync goes through
`ZendObject` instead of direct `vphp_read/write_property_compat` calls in the
generated body. Inherited property reads now use
`ZendObject.prop_owned_request(...)`, so generated V glue no longer emits
`C.zval{}` scratch values for that path. Generated class handler exports now
use `ZendClassHandlers.new(...)` instead of constructing `C.vphp_class_handlers`
directly in generated `bridge.v`. ZVal call/construct/static-method paths now
share a private `call_zval_target(...)` helper, so retval allocation,
argv conversion, Zend result handling, and ownership adoption live in one
place. Call intent is represented by a private `ZendCallTarget`, keeping raw
`&C.zval` / `&&C.zval` argv details inside the innermost call boundary.
Inherited scalar property loading uses `ZendObject.prop_*_or(...)`
helpers that borrow only inside the wrapper and immediately copy into V scalar
values; generated code no longer needs `prop_owned_request(...)` for that path.
`PhpIncludeFile` now shares the same request-owned adoption path as other
retval-producing helpers, and static property/class constant reads share
ownership-parametrized helpers. Generic property handlers use `PhpReturn` and
`ZVal.from_ptr(...)` instead of older raw helper forms. `PhpReturn` and object
property convenience paths also prefer `ZVal.from_ptr(...)` and scalar receiver
methods over direct raw field construction where no ownership semantics change.
Array/object write helpers such as associative zval insertion, next-value
insertion, object initialization, and string property updates are also exposed as
`ZVal` receiver methods, so semantic wrappers can avoid direct `C.vphp_array_*`
and `C.vphp_object_*` calls for those paths. Request-scope autorelease calls,
active extension globals access, object metadata reads, and ZVal callable/class
invocation bridge calls are now routed through private Zend wrapper helpers.
The previously declared-but-unimplemented
`vphp_allocate_contiguous_object(...)` C bridge now has a real declaration and
implementation, with V access routed through `zend_allocate_contiguous_object`.
Direct PHP allocator usage for saved closures and task handles is now routed
through private `zend_emalloc` / `zend_efree` helpers. ZVal release and disown
paths now use private `zend_release_zval*` / `zend_disown_zval` helpers, so
failure cleanup in include/call/read helpers no longer calls the release C API
directly. ZVal allocation paths now use private `zend_new_zval*` helpers.
`RetainedObject` now stores a `ZendObject` wrapper instead of a raw
`&C.zend_object`, keeping refcount operations behind `ZendObject` receiver
methods. DynValue array/list encoding and `PhpReturn.list(...)` struct encoding
now keep their temporary stack `C.zval{}` values inside `ZVal` helpers, instead
of leaking scratch-zval construction into semantic wrapper code. Generic object
payload release now calls a private V-runtime free helper instead of directly
calling `C.builtin___v_free(...)`. ZVal object initialization and scalar
property insertion now delegate through private Zend object helpers instead of
calling Zend property APIs directly from `zval_object_props.v`. Closure creation
helpers now accept `PhpReturn`, so closure binding code no longer has to pass
raw return slots down manually. `ZExData` receiver methods now delegate
through private Zend execute-data helpers for argument count, argument lookup,
active class lookup, and `$this` object lookup. Compiler-generated static
property sync now uses `ctx.active_class_entry()` and `ZendClassEntry` receiver
methods directly; the old global `set_static_prop(...)` / `get_static_prop(...)`
voidptr helpers have been removed. ZVal array and scalar receiver methods now
delegate through private `zend_array_*` and `zend_zval_*` helpers, keeping
bridge calls grouped inside the low-level wrapper files instead of spread across
each public receiver method. ZVal reference, resource, and type/callable
receiver methods follow the same pattern through private Zend helpers. ZVal
factory and foreach helpers also route creation and iteration bridge calls
through private helpers, leaving the callback wrappers as the explicit ABI edge.
ZVal copy/adoption paths now use a private `zend_copy_zval(...)` helper instead
of spelling `ZVAL_COPY` at each copy site. The old V-side
`return_*_object_raw(...)` helpers have been removed; object return paths now
flow through `PhpReturn` receiver methods and private object-return helpers that
accept `PhpReturn` directly. `ZendClassEntry` static-property receiver methods,
include-file helpers, and superglobal helpers now also route their bridge calls
through narrower private helpers, keeping each public wrapper method focused on
V-facing behavior. Unused global object-binding aliases were removed in favor
of `ZVal` receiver methods, and `ZendObject` receiver methods now delegate
refcount, handler binding, wrapper lookup, and existing-object wrapping through
private Zend object helpers. Runtime task entrypoints now write returns through
`ctx.return()` / `PhpReturn` receiver methods instead of the older
`ctx.return_*` convenience API. Unused receiver helpers that returned
`&C.vphp_object_wrapper` were removed from `object_binding.v`; binding remains
available through the higher-level `ZVal.bind_object(...)` receiver API.
Runtime, include-file, and superglobal C-boundary implementations have started
moving into `vphp/zend/`, with parent-module files kept as thin adapters where
they still need `ZVal`, `ZBox`, or semantic wrapper types. The broader layer
migration should continue incrementally.
`Context.from_entry(...)`, `Context.from_raw(...)`, `ZExData.new(...)`,
`ZExData.raw_ex()`, `PhpReturn.raw_zval()`, `ZVal.from_raw(...)`,
`ZendObject.from_raw(...)`, `ZendClassEntry.from_raw(...)`, and request-ZBox
`from_raw(...)` compatibility aliases have been removed; pointer and handle
constructors are now the supported low-level shape.

### First: Call Paths

Status: **partially started**.

`ZVal` call, method, construct, and static-method paths now share
`call_zval_target(...)`, so argv conversion, retval allocation, Zend call
result handling, and ownership adoption are no longer repeated in every method.
The previous raw callback shape has been replaced by a private
`ZendCallTarget`, and `&C.zval` / `&&C.zval` argv details are confined to
`call_zval_target(...)` and `zend_invoke_call_target(...)`.
The direct `C.vphp_call_*`, `C.vphp_new_instance(...)`, and static
property/class-constant bridge calls are routed through private Zend wrapper
helpers. The remaining work is to move the helper file into the eventual
`vphp/zend/` layout when dependency direction allows it.

Start with:

- `vphp/zval_call_interop.v`
- `vphp/zval_class_interop.v`
- callers in `vphp/php_function_type.v`
- callers in `vphp/php_object_type.v`

Target:

- keep repeated `argv/p_args` construction centralized
- keep repeated `retval/release/adopt` logic centralized
- keep `ZendCallTarget` private
- keep public APIs unchanged
- do not introduce public `ZendCallArgs` or `ZendCallResult`

Preferred shape:

```text
PhpFunction.call(...)
  -> php_arg_inputs_to_zvals(...)
  -> ZVal.call_owned_request(...)
  -> call_function_zval(...)
  -> call_zval_target(...)
  -> zend_invoke_call_target(...)
  -> C.vphp_call_php_func(...)
```

### Second: Property And Class Reads

Status: **partially started**.

`ZendObject` now owns inherited object property reads for generated glue, and
static property/class constant reads share ownership-parametrized private
helpers. ZVal object class-name, parent-class-name, and internal/user-class
metadata reads now delegate to private Zend object helpers. The remaining work
is to make older `ZVal` object-property helpers delegate through `ZendObject`
where that does not change ownership semantics.

Then handle:

- `vphp/zval_object_props.v`
- static property helpers
- class constant helpers
- compiler-generated property glue

Be careful with `rv` and `res` ownership. Existing helper `adopt_read_result()` handles the important boundary where the returned pointer may or may not be the temporary `rv`.

### Third: Compiler Output

Status: **partially started**.

Generated return glue now prefers `ctx.return()` / `PhpReturn`, and generated
argument reads increasingly flow through `Context`, `ZExData`, `PhpArg`, and
semantic wrappers. Direct C signatures still exist at Zend callback edges,
especially exported function/method wrappers, closure bridges, and generated
class property handlers. Those signatures are still necessary boundary points
until a dedicated compiler-boundary abstraction exists.

Only after runtime helpers are stable should compiler output change.

The compiler should eventually prefer V wrappers over direct `C.vphp_*` calls where possible, but generated glue may still need explicit C types for Zend callback signatures.

## Naming Guidance

Avoid naming private implementation helpers as new public concepts.

For example, avoid public types like:

```text
ZendCallArgs
ZendCallResult
```

unless extension authors genuinely need to use them.

Prefer private helpers named after what they do:

```v
fn call_function_zval(...)
fn call_method_zval(...)
fn call_with_args_and_ret(...)
fn read_property_zval(...)
```

If a file intentionally owns the C boundary, name it plainly:

```text
vphp/zend/call.v
vphp/zend/closure.v
vphp/zend/class_entry.v
vphp/zend/object.v
vphp/zend/property.v
vphp/zend/array.v
```

The name should make it obvious that direct `C.xxx` is expected inside that file and suspicious elsewhere.

## 中文说明

这份文档定义 `vphp` 如何隔离 Zend C 调用，并在其上逐层提供更适合 V 的 API。

状态：**迁移已开始 / 尚未完整实现**。

当前代码已经有不少相关概念，`vphp/zend/` 也已经开始承载 C-boundary wrapper，例如 `runtime.v`、`include.v`、`superglobals.v`、`call.v`、`closure.v`、`class_entry.v`、`class_handlers.v`、`object.v`、`array.v`、`value.v`、`execute.v`。但 `vphp/zval/`、`vphp/zbox/`、`vphp/scope/`、`vphp/object/` 这些目标目录仍未完整落地。

当前迁移检查点：

- runtime、include、superglobals、call、closure、class entry、class handlers、object、array、execute data、zval value 分配/转换相关的直接 Zend bridge 调用已经迁入 `vphp/zend/`。
- `vphp/object/` 已经作为 no-C low-level object wrapper 区域开始落地。目前包含 object handle、lifecycle、property read-result、vptr root 与 object return helper；根层 `object_binding.v` 和 generic lifecycle helper 已把低层 allocation、roots、runtime-free、return-object 操作委托给 `vphp/object/`；generated generic property helper 仍保留在根层，因为 property result 与 field cleanup 仍依赖根层 `ZVal`/ownership 和语义 wrapper 类型。
- `vphp/execute/` 已经作为 no-C low-level execute-data wrapper 区域开始落地。目前包含 execute-data handle、argument access 与 active context helper；根层 `ZExData` 仍作为兼容 facade 保留，因为 argument value 仍需要根层 `ZVal`、`PhpArg` 与语义 wrapper。
- `Context` 现在持有 `ZExData` 与 `PhpReturn` wrapper，不再暴露 raw Zend 字段。ABI-facing constructor 是 `Context.from_ptr(ex, ret)`，generated closure glue 也直接使用这个 pointer 形态入口。
- `vphp/scope/` 已经作为 no-C low-level request scope wrapper 区域开始落地。目前包含 request mark/enter/leave helper 与 autorelease zval add/forget/drain helper；根层 `RequestScope`、`FrameScope`、`PhpScope` 仍作为兼容 facade 保留，因为 frame value 仍依赖根层 ZBox 与语义 wrapper 类型。
- `RequestBorrowedZBox` 与 `RequestOwnedZBox` 现在提供 pointer/handle/zval factory helper。旧的 `from_raw(...)` / `from_raw_zval(...)` alias 已从 request ZBox 层移除。
- `vphp/zval/` 已经作为 no-C low-level zval wrapper 区域开始落地。目前包含 zval handle、request/persistent allocation lifecycle、copy/disown、runtime counter helper、低层 array operation helper、scalar/type read/write helper、reference/resource helper、call argument packing、scalar factory helper、低层 foreach dispatch、include-file result handling、static class helper 与 superglobal helper；根层 `ZVal` 仍作为兼容 facade 保留，因为 call result ownership 与语义 wrapper 方法仍依赖根层 `ZVal`/ZBox 形态。
- 根层文件仍会保留一部分 raw C pointer 类型，但只应出现在 ABI 或低层存储形态中，例如 `ZVal.raw`、generic object handler callback、foreach callback trampoline，以及透传 `&C.zval` 到 `vphp/zend/` 的 adapter。`PhpReturn`、`ZExData`、`ZendObject`、`ZendClassEntry` 与 ZBox constructor 已统一走 pointer/handle 形态，不再提供 `from_raw(...)` / `raw_zval()` 风格的公开 API。
- `[]ZVal -> []zval.Handle -> &&C.zval` 的参数打包现在已经拆到 `vphp/zval/` 与 `vphp/zend/` 之间。根层 call helper 仍负责 result adoption，因为 `OwnershipKind` 与 `ZVal` 仍是根层 facade。

核心规则：

```text
bridge/*.inc.c + v_bridge.c/h
  -> V 侧 Zend boundary
  -> no-C low-level V wrapper
  -> abstract V semantic wrapper
```

目标不是完全隐藏 Zend，而是让 `C.xxx`、`&C.zval`、`&&C.zval`、`&C.zend_object` 这些细节只出现在少数可审计的边界文件里。

四层含义：

- C implementation：`vphp/bridge/` 和 `v_bridge.c/h`，负责 C bridge 实现碎片，不属于 V wrapper 层。
- Layer 1：`vphp/zend/` 里的 C 声明文件，如 `types.v`、`bridge_api.v`、`native_api.v`、`constants.v`。
- Layer 2：同样位于 `vphp/zend/`，但文件是 wrapper，如 `call.v`、`object.v`、`property.v`、`array.v`。这是唯一集中接触 `C.xxx` 的 V 实现层。
- Layer 3：按领域拆成 `vphp/zval/`、`vphp/zbox/`、`vphp/scope/`、`vphp/object/`、`vphp/execute/`，不在签名和常规调用路径里暴露 `C.xxx`。
- Layer 4：扩展作者优先使用的语义层，即 `PhpValue`、`PhpString`、`PhpArray`、`PhpObject`、`PhpFunction`、`PhpArgInput`、`PhpArg`、`PhpReturn` 等。

review 时最重要的问题是：

> 这个文件属于哪一层？有没有越层暴露低层概念？

最明显的坏味道是：

```text
Layer 4 semantic wrapper 直接调用 Layer 1/2 C boundary API。
```

这通常说明缺一个 Layer 2 或 Layer 3 helper。

允许保留的 raw 边界要保持很小：

- `zval.v` / `zval_lifecycle_interop.v` 里的 `ZVal.raw` 与生命周期 helper，因为它们负责 allocation、copy、release、disown、adoption 语义。
- `zval.Handle.raw_ptr()`、`object.Handle.raw_ptr()`、`execute.Handle.raw_ptr()`，因为 Layer 3 需要一个窄出口调用 Layer 2。
- Zend callback signature，例如 `object_generic_props.v` 与 `zval_factory_iter.v`，因为 Zend 调进 V 时天然传入 `&C.zval` / callback context pointer。这些函数体内必须立即包成 `ZVal.from_ptr(...)`、`PhpReturn.from_ptr(...)` 或 handle wrapper。
- `vphp/zend/**`，因为它就是显式 C-boundary wrapper 层。

这些区域之外，如果新增 `&C.zval`、`&C.zend_object`、`C.xxx` 或公开 `from_raw(...)` 风格 API，默认应视为设计坏味道。

深水区迁移时尤其要注意：

- `ZVal` 对象属性读写可以继续收口到 `ZendObject`，这是低风险方向。
- `call_zval_target(...)` 已经把调用路径里的 argv、retval、ownership adoption 集中了，调用意图由私有 `ZendCallTarget` 表达；下一步重点是边界归属，而不是发明公开的 `ZendCallArgs`。
- 需要 `ZVal`、`OwnershipKind`、`ZBox` 的 Layer 2 helper 现在不能直接搬进 `vphp/zend/` 子模块，因为 `vphp.zend` 已经是 parent module 的 C 声明依赖，反向引用 runtime 类型会制造依赖方向问题。
- `prop_borrowed(...)`、`adopt_read_result(...)`、persistent/request 转换、closure binding、retained object/callable roots 都属于 ownership 敏感区，每次修改都要跑完整 vphptest 和相关生命周期探针。
