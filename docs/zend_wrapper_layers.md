# Zend Wrapper Layers

This document defines how `vphp` should isolate direct Zend C calls and expose progressively nicer V APIs above them.

Status: **design target / not fully implemented**.

The current codebase already has many of these concepts, but the directory layout and C-boundary isolation described here are migration targets. In particular, the proposed `vphp/zend/call.v`, `vphp/zval/`, `vphp/zbox/`, `vphp/scope/`, and `vphp/object/` layout is not fully implemented yet.

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
| 3. No-C low-level V wrapper | `ZVal`, `ZExData`, `ZendObject`, `OwnershipKind`, `RequestScope`, `*ZBox` | Direct `C.xxx` in signatures or normal call paths | Target: `vphp/zval/`, `vphp/zbox/`, `vphp/scope/`, `vphp/object/` | `ZVal.method_owned_request(...)` |
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
  vphp/zend/call.v      -> C-boundary wrapper
  vphp/zend/value.v     -> C-boundary wrapper
  vphp/zend/object.v    -> C-boundary wrapper
  vphp/zend/property.v  -> C-boundary wrapper
  vphp/zend/array.v     -> C-boundary wrapper
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
ret.raw_zval()
```

But normal code should not need those escape hatches.

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
ctx := vphp.Context.from_entry(ex, ret)
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
`PhpReturn` and `ZVal.from_raw(...)` instead of direct return/raw-zval helpers
inside the generated body, and inherited object property sync goes through
`ZendObject` instead of direct `vphp_read/write_property_compat` calls in the
generated body. Inherited property reads now use
`ZendObject.prop_owned_request(...)`, so generated V glue no longer emits
`C.zval{}` scratch values for that path. Generated class handler exports now
use `ZendClassHandlers.new(...)` instead of constructing `C.vphp_class_handlers`
directly in generated `bridge.v`. ZVal call/construct/static-method paths now
share a private `call_with_zval_args(...)` helper, so retval allocation,
argv conversion, Zend result handling, and ownership adoption live in one
place. Inherited scalar property loading uses `ZendObject.prop_*_or(...)`
helpers that borrow only inside the wrapper and immediately copy into V scalar
values; generated code no longer needs `prop_owned_request(...)` for that path.
`PhpIncludeFile` now shares the same request-owned adoption path as other
retval-producing helpers, and static property/class constant reads share
ownership-parametrized helpers. Generic property handlers use `PhpReturn` and
`ZVal.from_raw(...)` instead of older raw helper forms. `PhpReturn` and object
property convenience paths also prefer `ZVal.from_raw(...)` and scalar receiver
methods over direct raw field construction where no ownership semantics change.
The broader layer migration is still not implemented and should continue
incrementally.

### First: Call Paths

Not implemented yet.

Start with:

- `vphp/zval_call_interop.v`
- `vphp/zval_class_interop.v`
- callers in `vphp/php_function_type.v`
- callers in `vphp/php_object_type.v`

Target:

- remove repeated `argv/p_args` construction
- remove repeated `retval/release/adopt` logic
- keep public APIs unchanged
- do not introduce public `ZendCallArgs` or `ZendCallResult`

Preferred shape:

```text
PhpFunction.call(...)
  -> php_arg_inputs_to_zvals(...)
  -> ZVal.call_owned_request(...)
  -> call_function_zval(...)
  -> private C-boundary helper
  -> C.vphp_call_php_func(...)
```

### Second: Property And Class Reads

Not implemented yet.

Then handle:

- `vphp/zval_object_props.v`
- static property helpers
- class constant helpers
- compiler-generated property glue

Be careful with `rv` and `res` ownership. Existing helper `adopt_read_result()` handles the important boundary where the returned pointer may or may not be the temporary `rv`.

### Third: Compiler Output

Not implemented yet.

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
vphp/zend/object.v
vphp/zend/property.v
vphp/zend/array.v
```

The name should make it obvious that direct `C.xxx` is expected inside that file and suspicious elsewhere.

## 中文说明

这份文档定义 `vphp` 如何隔离 Zend C 调用，并在其上逐层提供更适合 V 的 API。

状态：**目标设计 / 尚未完整实现**。

当前代码已经有不少相关概念，但这里描述的目录布局和 C 边界隔离仍然是迁移目标。尤其是 `vphp/zend/call.v`、`vphp/zval/`、`vphp/zbox/`、`vphp/scope/`、`vphp/object/` 这些目标目录并未完整落地。

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
- Layer 3：按领域拆成 `vphp/zval/`、`vphp/zbox/`、`vphp/scope/`、`vphp/object/`，不在签名和常规调用路径里暴露 `C.xxx`。
- Layer 4：扩展作者优先使用的语义层，即 `PhpValue`、`PhpString`、`PhpArray`、`PhpObject`、`PhpFunction`、`PhpArgInput`、`PhpArg`、`PhpReturn` 等。

review 时最重要的问题是：

> 这个文件属于哪一层？有没有越层暴露低层概念？

最明显的坏味道是：

```text
Layer 4 semantic wrapper 直接调用 Layer 1/2 C boundary API。
```

这通常说明缺一个 Layer 2 或 Layer 3 helper。
