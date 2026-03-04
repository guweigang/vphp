# VSlim Release V1

这份文档定义 `vslim` 第一版的范围边界。

目标不是“尽可能多做”，而是把：

- `veb`
- `vhttpd`
- `php-worker`
- `vslim`
- `vphp`

这五层的职责一次性定稳，避免后续在未发布前就把边界做散。

## 定位

`vslim` 第一版是一个：

- 运行在 `vphp` 之上的独立 PHP 扩展
- 面向 PHP userland 的 runtime app builder
- 站在 `vhttpd + veb` 之后的 framework layer

它不是：

- 原版 Slim 的兼容实现
- `veb` 的替代品
- 一个新的 PHP runtime

## 分层

```mermaid
flowchart LR
    A["veb"] --> B["vhttpd"]
    B --> C["php-worker"]
    C --> D["vslim"]
    D --> E["vphp"]
```

### `veb`

- HTTP/runtime 源头
- 请求生命周期
- 网络监听
- 原始 request 数据

### `vhttpd`

- 直接站在 `veb` 上
- 负责 transport envelope
- 负责 worker forwarding / managed worker
- 应尽量复用：
  - `veb.Context`
  - `net.http.Request`
  - `urllib`
  - `http.read_cookies`

### `php-worker`

- worker 边界
- 可选 PSR-7 request 构建
- app bootstrap 加载
- response 归一化

### `vslim`

- framework layer
- runtime route registration
- route groups
- before/after hooks
- request/response facade
- reverse routing

### `vphp`

- Zend binding
- compiler
- runtime bridge
- 值模型 / 对象模型 / interop

## V1 In Scope

第一版明确支持：

### Runtime app builder

- `VSlimApp`
- `VSlimRouteGroup`
- `get/post/put/patch/delete/any`
- named routes
- `url_for()` / `redirect_to()`
- `base_path`

### Request / response facade

- `VSlimRequest`
- `VSlimResponse`
- query / header / cookie / param / attribute 访问
- content type / response headers / cookie helpers

### Lifecycle hooks

- app-level `before()`
- app-level `after()`
- group-level `before()`
- group-level `after()`
- `middleware()` 作为 `before()` 的兼容别名

### HTTP integration

- `vhttpd` 基于 `veb`
- structured array request envelope
- managed worker mode
- `vslim_handle_request(...)`
- `vslim_demo_dispatch(...)`

### PHP worker bridges

- app bootstrap 返回 callable
- app bootstrap 返回 `VSlimApp`
- 可选 PSR-7 bridge
- worker response 归一化

## V1 Out of Scope

第一版明确不做：

### 不做原版 Slim 兼容

- 不承诺运行现有 Slim 项目
- 不承诺兼容原版 Slim middleware / container / internals

### 不做完整 PSR-7 内核

- `VSlimRequest` / `VSlimResponse` 不追求 immutable core
- PSR-7 只放在 worker edge / adapter layer

### 不让 `vphp` 背 HTTP helper

- `vphp` 不提供 HTTP 请求解析工具
- `vphp` 不做 URL / query / header helper bag

### 不把 `vslim` 做成第二个 server runtime

- `vslim` 不替代 `veb`
- `vslim` 不自己管理网络监听
- `vslim` 不重写 HTTP 生命周期

### 不强引网络/TLS栈进扩展核心

- 避免把会拖入 `net.mbedtls` 的重量级依赖塞进 `vslim` 扩展核心
- 网络/TLS 复杂度留给 `veb` / `vhttpd`

## 为什么保留自己的 router

`veb` 的 route 系统很强，但它更适合：

- V 原生应用
- compile-time 路由生成
- handler 在编译阶段就固定

而 `vslim` 面向的是 PHP userland runtime builder：

- `$app->get(...)`
- `$app->group(...)`
- `$app->before(...)`
- `$app->after(...)`

这类 API 天然是 runtime registration，不适合强塞进 `veb` 的 compile-time routing 模型。

所以第一版的决定是：

- HTTP 输入、连接生命周期复用 `veb`
- runtime 路由组织由 `vslim` 自己承担

## 稳定契约

第一版要尽量稳定的是：

1. `vhttpd -> php-worker` request envelope
2. `php-worker -> vslim_handle_request(...)` request envelope
3. `VSlimApp` 的 PHP-facing builder API
4. `VSlimRequest` / `VSlimResponse` 的基础 helper 语义

这些一旦发出去，就尽量不要大改。

## 未来再做的

这些方向值得做，但不属于第一版承诺：

- 更完整的 `after()` / response pipeline 能力
- 更强的 route metadata
- 更系统的 app bootstrap 约定
- 更深的 PSR-7 / PSR-15 适配
- 更丰富的 worker supervision / reload 模型

## 一句话

`vslim` 第一版的价值不是“重做整个 Web 生态”，而是：

> 在 `veb` 作为 HTTP 源头、`vphp` 作为 bridge 的前提下，
> 给 PHP userland 一个 runtime-friendly、Slim-inspired 的 V 框架层。
