# vslim

`vslim` 是一个独立于 `v_php_ext` 的示例扩展，用来验证一条更清晰的路线：

- `vphp` 提供 Zend binding、编译器和 runtime
- `vslim` 提供面向 PHP 开发者的 Slim-inspired 框架 API
- `vhttpd` 提供 HTTP runtime，并且**尽量直接复用 `veb`**

一句话说：

> `vslim` 不是运行原版 Slim，而是做一个让 PHP 开发者心智熟悉的 V 微框架扩展。

## 三层边界

这条线现在有一个明确边界，我们后面也会继续守住：

- `vphp`
  - 只做 PHP <-> V bridge、编译器和 runtime
  - 不承载 HTTP 通用能力

- `vhttpd`
  - 尽量直接站在 `veb` 上
  - 优先使用 `veb.Context`、`http.Request`、`urllib`、`http.Cookie`
  - 不重复实现 HTTP 解析和 server lifecycle

- `vslim`
  - 只做 framework layer
  - 路由、middleware、request/response facade、reverse routing
  - 不把自己做成第二个 runtime

## 四层结构

```mermaid
flowchart LR
    A["veb"] --> B["vhttpd"]
    B --> C["php-worker"]
    C --> D["vslim"]
    D --> E["vphp"]
```

- `veb`
  - HTTP/runtime 源头
- `vhttpd`
  - 贴着 `veb` 做 transport 和 worker forwarding
- `php-worker`
  - PHP userland 与 PSR-7 边界
- `vslim`
  - runtime framework layer
- `vphp`
  - bridge/compiler/runtime

## 为什么不直接复用 veb 的 route 定义

这里我们刻意没有把 `vslim` 做成 `veb` 的语法薄封装，原因不是要绕开 `veb`，而是两层职责不同：

- `veb`
  - 更适合 V 原生应用
  - 路由和 middleware 主要是 compile-time 生成
  - `App` 结构和 handler 关系在 V 编译阶段就确定

- `vslim`
  - 需要让 PHP userland 在运行时 builder 路由
  - 例如：
    - `$app->get(...)`
    - `$app->group(...)`
    - `$app->middleware(...)`
  - 这些能力天然是 runtime registration，不是 compile-time route scanning

所以第一版的原则是：

- `veb` 负责 HTTP 输入、连接生命周期、请求原始数据
- `vslim` 负责运行时路由、middleware、response facade

换句话说：

> `vslim` 复用 `veb` 作为 HTTP 源头，而不是重复实现 server；
> 但它保留自己的 runtime router，因为 PHP-side app builder 本质上不是 `veb` 的 compile-time 模式。

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
  - 以 `veb` 作为 HTTP 源头
  - 接收网络请求
  - 利用 `veb.Context` / `http.Request` 提取 method/path/query/body/header/cookie
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
    'scheme' => 'https',
    'host' => 'example.test',
    'port' => '443',
    'protocol_version' => '1.1',
    'remote_addr' => '127.0.0.1',
    'headers' => ['x-request-id' => 'demo'],
    'cookies' => ['sid' => 'cookie-7'],
    'query' => ['trace_id' => 'worker'],
    'attributes' => [],
    'server' => ['host' => 'example.test'],
    'uploaded_files' => [],
]
```

`vhttpd` 或 PHP worker 可以把它直接交给：

```php
$response = vslim_handle_request($requestEnvelope);
```

这里的关键原则是：

- request 采集尽量来自 `veb`
- worker envelope 只是 transport 边界
- `vslim` 只消费归一化后的 request 语义

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
$req->scheme = 'https';
$req->host = 'demo.local';
$req->remote_addr = '127.0.0.1';
$req->set_headers(['x-trace-id' => 'from-header']);
$req->set_cookies(['sid' => 'cookie-7']);
$req->set_attributes(['actor' => 'tester']);
$req->set_query(['trace_id' => 'from-json']);

echo $req->query('trace_id');
echo $req->header('x-trace-id');
echo $req->attribute('actor');
echo $req->content_type();
echo $req->server_value('server_name');
echo $req->uploaded_file_count();
var_dump($req->is_secure());

$res = $app->dispatch_request($req);
echo $req->param('id');
echo $req->cookie('sid');
```

响应对象也提供了基础 helper：

```php
$res = new VSlimResponse(200, 'hello', 'text/plain; charset=utf-8');
$res->set_header('x-demo', 'yes')
    ->with_status(202)
    ->json('{"ok":true}');

$res->html('<b>ok</b>');
echo $res->content_length();
echo $res->content_type;

$res->set_content_type('application/xml');

$res->set_cookie('sid', 'cookie-202');
$res->set_cookie_full('sid', 'cookie-303', '/', 'demo.local', 60, true, true, 'lax');
echo $res->cookie_header();

echo $res->header('x-demo');
echo $res->content_type;
```

也可以在 PHP 侧直接 builder 路由、group 和 middleware：

```php
$app = new VSlimApp();

$app->middleware(function (VSlimRequest $req) {
    if ($req->path === '/blocked') {
        return new VSlimResponse(403, 'blocked', 'text/plain; charset=utf-8');
    }
    return null;
});

$api = $app->group('/api');
$api->get_named('api.users.show', '/users/:id', function (VSlimRequest $req) {
    return 'user:' . $req->param('id');
});
$api->put_named('api.users.update', '/users/:id', function (VSlimRequest $req) {
    return 'updated:' . $req->param('id');
});
$api->any('/echo/:id', function (VSlimRequest $req) {
    return $req->method . ':' . $req->param('id');
});

$app->set_base_path('/v1');

echo $app->url_for('api.users.show', ['id' => '42']);
// /v1/api/users/42

echo $app->url_for_query('api.users.show', ['id' => '42'], ['tab' => 'profile']);
// /v1/api/users/42?tab=profile

echo $app->url_for_abs('api.users.show', ['id' => '42'], 'https', 'demo.local');
// https://demo.local/v1/api/users/42

$redirect = $app->redirect_to('api.users.show', ['id' => '42']);
echo $redirect->status;
echo $redirect->header('location');
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
make vhttpd
make serve
make test
```

HTTP runtime 相关文件现在在：

- [/Users/guweigang/Source/vphpext/vslim/psr7_bridge.md](/Users/guweigang/Source/vphpext/vslim/psr7_bridge.md)
- [/Users/guweigang/Source/vphpext/vslim/httpd/main.v](/Users/guweigang/Source/vphpext/vslim/httpd/main.v)
- [/Users/guweigang/Source/vphpext/vslim/httpd/php-worker.php](/Users/guweigang/Source/vphpext/vslim/httpd/php-worker.php)
- [/Users/guweigang/Source/vphpext/vslim/httpd/README.md](/Users/guweigang/Source/vphpext/vslim/httpd/README.md)

开发时最顺手的入口是：

- `make vhttpd`：重新编译 `vhttpd`
- `make serve`：用 managed worker 模式直接拉起 `vhttpd + php-worker + vslim`

## 下一步建议

1. 把 demo app 提升成可配置 app builder
2. 给 request envelope 增加更结构化的 headers/cookies 表达
3. 补 `VSlimRequest` 的 path param / header collection helper
4. 再考虑是否导出更完整的 PHP 面向对象 API
