# vslim

`vslim` 是一个独立于 `v_php_ext` 的示例扩展，用来验证一条更清晰的路线：

- `vphp` 提供 Zend binding、编译器和 runtime
- `vslim` 提供面向 PHP 开发者的 Slim-inspired 框架 API
- `vhttpd` 提供 HTTP runtime

一句话说：

> `vslim` 不是运行原版 Slim，而是做一个让 PHP 开发者心智熟悉的 V 微框架扩展。

## 当前目标

这版 `vslim` 已经把早期在 `v_php_ext/slim.v` 里验证过的 MVP 核心迁了过来，并保留独立扩展形态。

当前包括：

- `SlimApp` 路由核心（纯 V）
- middleware chain
- 路由参数匹配
- `VSlimRequest` 请求包装
- `VSlimApp` / `VSlimResponse` 作为 PHP-facing façade
- `vslim_handle_request()` / `vslim_demo_dispatch()` 作为稳定函数入口

## 与 vhttpd 的交互模型

推荐的交互边界是：

```text
Client -> vhttpd -> PHP worker -> vslim -> PHP worker -> vhttpd -> Client
```

分工：

- `vhttpd`
  - 接收网络请求
  - 解析 method/path/query/body
  - 做连接管理、日志和可观测性

- PHP worker
  - 负责加载业务代码和 Composer 生态
  - 调用 `vslim_handle_request(...)` 或 `VSlimApp`

- `vslim`
  - 负责路由匹配、middleware、请求分发、响应封装
  - 输出稳定的 `{status, body, content_type}` 结构

当前推荐的 worker 协议是一个 request envelope：

```php
[
    'method' => 'GET',
    'path' => '/users/42?trace_id=worker',
    'body' => '',
]
```

`vhttpd` 或 PHP worker 可以把它直接交给：

```php
$response = vslim_handle_request($requestEnvelope);
```

## 为什么这样分层

这样做的价值在于：

1. 不强行兼容原版 Slim 内部实现
2. 可以保留 PHP 生态和 userland 开发体验
3. `vhttpd` 不需要嵌入 PHP 解释器
4. `vslim` 可以逐步长成一个真正的 framework extension

说明：

- 当前第一版先使用 plain PHP class 名，优先把独立扩展骨架跑通
- 后面如果需要更强的 namespaced class 体验，可以再专门收编译器对“namespaced return object”的支持

## 当前示例路由

- `GET /health`
- `GET /users/:id`
- `GET /private`
- `GET /panic`
- `GET /meta`

中间件：

- `with_trace_id`
- `auth_guard`

## 当前 PHP 面

```php
$app = VSlimApp::demo();
$res = $app->dispatch('GET', '/users/42');

echo $res->status;
echo $res->body;
```

也可以显式构建请求对象：

```php
$req = new VSlimRequest('GET', '/users/7?trace_id=from-php', '');
$res = $app->dispatch_request($req);
```

也可以直接用函数入口：

```php
$r = vslim_demo_dispatch('GET', '/private?token=ok');
```

或者用更适合 `vhttpd` 的 envelope 入口：

```php
$r = vslim_handle_request([
    'method' => 'GET',
    'path' => '/private?token=ok',
    'body' => '',
]);
```

## 构建与测试

```bash
cd /Users/guweigang/Source/vphpext/vslim
make build
make ext
make test
```

## 下一步建议

1. 给 request envelope 增加 headers / remote addr / scheme 等字段
2. 把 demo app 提升成可配置 app builder
3. 补 `VSlimRequest` 的 query/header helper
4. 再考虑是否导出更完整的 PHP 面向对象 API
