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
| 3. No-C low-level V wrapper | `ZVal`, `ZExData`, `OwnershipKind`, `RequestScope`, `*ZBox` | Direct `C.xxx` in signatures or normal call paths | Target: `vphp/zval/`, `vphp/zbox/`, `vphp/scope/`, `vphp/object/` | `ZVal.method_owned_request(...)` |
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

Status: **not implemented yet**. Do this incrementally when the migration starts.

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
