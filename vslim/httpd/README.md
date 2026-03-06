# VHTTPD (CLI + Userland Scheduler)

This is the **Scheme 2** prototype:

- HTTP server runs as a standalone V CLI process built directly on `veb`.
- PHP Userland controls lifecycle and reads events.
- `vphp` stays generic; framework/server logic now lives with `vslim`.

The design rule is:

- `veb` is the HTTP source of truth
- `vhttpd` should stay thin and reuse `veb` / `http` / `urllib`
- `vslim` should stay at the framework layer
- `vphp` should not become an HTTP helper bag

## Specs

- PSR-7/15 support matrix: [psr_support.md](/Users/guweigang/Source/vphpext/vslim/httpd/psr_support.md)
- Failure/timeout model: [failure_model.md](/Users/guweigang/Source/vphpext/vslim/httpd/failure_model.md)
- Worker transport contract: [transport_contract.md](/Users/guweigang/Source/vphpext/vslim/httpd/transport_contract.md)

## Why vhttpd uses veb but vslim keeps its own router

This split is intentional.

- `vhttpd`
  - should stay as close to `veb` as possible
  - `veb.Context`, `http.Request`, `urllib`, and `http.Cookie` are the source of truth
  - this is where we want to benefit from V's HTTP/runtime stack

- `vslim`
  - is not trying to replace `veb`
  - it exists to expose a runtime app builder to PHP userland
  - PHP-side APIs like:
    - `VSlim\App->get(...)`
    - `VSlim\App->group(...)`
    - `VSlim\App->middleware(...)`
    require runtime route registration, which does not fit `veb`'s compile-time route generation model

So the rule for the first release is:

- `veb` is the HTTP/runtime source
- `vslim` is the runtime framework layer built on top of that transport boundary
- request id is handled by `veb.request_id` middleware
- SSE stream formatting/headers are handled by `veb.sse`

```mermaid
flowchart LR
    A["Client"] --> B["vhttpd (veb)"]
    B --> C["php-worker"]
    C --> D["vslim"]
    D --> E["vphp"]
```

## Why this matters in PHP (vs nginx + PHP-FPM)

`nginx + PHP-FPM` can stream too, but stream behavior is often sensitive to buffering and timeout settings across layers.
`vhttpd + php-worker` focuses on a unified streaming contract for PHP apps.

| Dimension | nginx + PHP-FPM | vhttpd + php-worker |
|---|---|---|
| Streaming support | Possible, often infra-tuning heavy | First-class via worker stream frames |
| App API shape | Framework/flush specific | Unified `WorkerStreamResponse` (`text`/`sse`) |
| Transport semantics | Indirect through proxy/FPM behavior | Explicit `start/chunk/error/end` contract |
| AI token streaming path | Often ad-hoc per project | Reusable runtime pattern |
| Debug surface | Split across multiple components | Concentrated at worker boundary |

This does not replace nginx by itself.
It gives PHP applications a consistent runtime transport for request/response plus token streaming workloads.

## Build

```bash
cd vslim/httpd
v -o vhttpd .
```

## Run

```bash
./vhttpd --host 127.0.0.1 --port 18081 \
  --pid-file /tmp/vhttpd.pid \
  --event-log /tmp/vhttpd.events.ndjson \
  --worker-read-timeout-ms 3000
```

### Managed worker mode

`vhttpd` can also supervise the PHP worker directly:

```bash
./vhttpd --host 127.0.0.1 --port 19880 \
  --pid-file /tmp/vhttpd.pid \
  --event-log /tmp/vhttpd.events.ndjson \
  --worker-socket /tmp/vslim_worker.sock \
  --worker-autostart 1 \
  --worker-cmd 'php -d extension=/Users/guweigang/Source/vphpext/vslim/vslim.so /Users/guweigang/Source/vphpext/vslim/httpd/php-worker.php --socket /tmp/vslim_worker.sock'
```

This gives you a single command that boots:

- `vhttpd`
- `php-worker.php`
- `vslim` through the worker's loaded extension

### Managed worker pool (MVP)

`vhttpd` now supports a basic `1:N` managed worker mode.

Key flags:

- `--worker-pool-size N`
- `--worker-socket-prefix /tmp/vslim_worker` (final sockets become `/tmp/vslim_worker_0.sock`, ...)
- `--worker-sockets /tmp/a.sock,/tmp/b.sock` (explicit list, overrides pool-size generation)
- `--worker-max-requests N` (restart each worker after N served requests)
- `--worker-restart-backoff-ms 500`
- `--worker-restart-backoff-max-ms 8000`

When `--worker-pool-size > 1`, use `{socket}` placeholder in `--worker-cmd`:

```bash
./vhttpd --host 127.0.0.1 --port 19880 \
  --pid-file /tmp/vhttpd.pid \
  --event-log /tmp/vhttpd.events.ndjson \
  --worker-pool-size 4 \
  --worker-socket-prefix /tmp/vslim_worker \
  --worker-autostart 1 \
  --worker-max-requests 5000 \
  --worker-cmd 'php -d extension=/Users/guweigang/Source/vphpext/vslim/vslim.so /Users/guweigang/Source/vphpext/vslim/httpd/php-worker.php --socket {socket}'
```

Endpoints:

- `GET /health` -> `OK`
- direct requests are proxied to the PHP worker as-is:
  - `GET /hello/codex`
  - `GET /go/nova`
  - `GET /api/meta`
- `GET /events/stream` returns SSE ping events for observability/debug:
  - `/events/stream?count=3&interval_ms=150`
  - `/events/stream?request_id=req-demo`
- `GET /admin/workers` returns runtime worker pool status (alive/draining/inflight/restarts)
- `/dispatch` is kept as a debug bridge endpoint (this one uses query `method/path` on purpose):
  - `GET /dispatch?method=GET&path=/users/42`
  - `HEAD /dispatch?method=GET&path=/go/nova`
  - `GET /dispatch?method=POST&path=/health`
  - `GET /dispatch?method=GET&path=/panic`

For local smoke tests, prefer bypassing shell/system proxies:

```bash
curl --noproxy '*' -i http://127.0.0.1:19881/hello/codex
curl --noproxy '*' -i http://127.0.0.1:19881/go/nova
curl --noproxy '*' -i -H 'Host: demo.local' http://127.0.0.1:19881/api/meta
curl --noproxy '*' -N "http://127.0.0.1:19881/events/stream?count=2&interval_ms=0&request_id=req-demo"
```

## Request ID contract

- every response includes `x-request-id`
- request id resolve order:
  - query `request_id`
  - header `x-request-id`
  - auto-generated `req-<unix_micro>`
- `x-request-id` is also copied into event log rows for correlation

## PHP Userland scheduling

Use `manager.php`:

```php
<?php
require __DIR__ . '/manager.php';

$mgr = new VHttpdManager(
    __DIR__ . '/vhttpd',
    '127.0.0.1',
    18081,
    '/tmp/vhttpd.pid',
    '/tmp/vhttpd.events.ndjson',
    '/tmp/vhttpd.stdout.log'
);

$mgr->start();
if ($mgr->waitUntilReady()) {
    echo file_get_contents($mgr->baseUrl() . '/health');
}
print_r($mgr->events(20));
$mgr->stop();
```

## Current direction

The active integration path is:

```text
vhttpd -> php-worker.php -> vslim_handle_request(...)
```

That keeps:

- `vhttpd` as the `veb`-based network/runtime layer
- `php-worker.php` as the PHP worker boundary
- `vslim` as the framework dispatch layer

## Worker streaming modes

`php-worker.php` now supports stream frames, not just one-shot JSON responses:

- `stream_type=sse`: forwarded as true SSE over `veb.sse`
- `stream_type=text` (or others): passthrough mode, chunk-by-chunk to client (not buffered/aggregated)

This enables AI/token streaming style workloads in addition to normal request/response handlers.

## Final request envelope

`vhttpd` now forwards a single structured request shape derived from `veb.Context`
and `net.http.Request`. This is the transport contract for:

- `vhttpd -> php-worker.php`
- `php-worker.php -> vslim_handle_request(...)`
- `VSlimPsr7Adapter::toWorkerEnvelope(...)`

Current envelope shape:

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
    'headers' => [
        'content-type' => 'application/json',
        'x-request-id' => 'abc',
    ],
    'cookies' => [
        'sid' => 'cookie-7',
    ],
    'query' => [
        'trace_id' => 'worker',
    ],
    'attributes' => [],
    'server' => [
        'host' => 'example.test',
        'port' => '443',
        'remote_addr' => '127.0.0.1',
        'method' => 'GET',
        'url' => '/users/42?trace_id=worker',
    ],
    'uploaded_files' => [],
]
```

Field notes:

- `path` is still the canonical request target.
- `query` is carried separately to avoid reparsing downstream.
- `headers` are normalized to lower-case names at the worker boundary.
- `cookies` are derived from the original `http.Request` headers via `http.read_cookies(...)`.
- `server` is lightweight metadata copied from the `veb/http` request layer.
- `uploaded_files` is reserved for future worker-side hydration; it stays structured even when empty.

Compatibility note:

- older `*_json` fields are intentionally removed
- first release uses the array envelope only
- if a caller still sends the old shape, it is now considered invalid input

## Optional PSR-7 bridge

`php-worker.php` now includes `psr7_bridge.php`.

If the runtime detects a supported PSR-17 style factory implementation, it can build a real
PSR-7-style server request from the request envelope before dispatching deeper into userland.

Current built-in factory detection covers:

- `Nyholm\\Psr7\\Factory\\Psr17Factory`
- `GuzzleHttp\\Psr7\\HttpFactory`
- `Laminas\\Diactoros\\RequestFactory` + `Laminas\\Diactoros\\StreamFactory`

This keeps `vhttpd` transport-generic while letting the worker boundary move toward PSR-7.

If `php-worker.php` finds an app bootstrap file (`VSLIM_HTTPD_APP` or `httpd/app.php`), it will:

- load the returned callable
- build a PSR-7 request when a supported PSR-17 factory is available
- dispatch the request into that app callable
- normalize a PSR-7-style response back into the worker transport envelope

## VSlim adapter

`vslim_psr7_adapter.php` provides a small PHP-side bridge that can:

- convert a PSR-7 style request object into `VSlim\Request`
- dispatch that request through `VSlim\App`
- keep `vslim` native while letting `php-worker.php` speak PSR-7 at the edge

`app.php` uses this adapter by default when the worker receives a PSR-7 request object.

## Writing your own `app.php`

`php-worker.php` looks for an app bootstrap in this order:

1. `VSLIM_HTTPD_APP`
2. `vslim/httpd/app.php`

The bootstrap file should `return` a callable. The worker will call it like this:

- with a PSR-7 request object and the raw envelope when a supported PSR-17 factory is available
- with the raw envelope only when no PSR-7 factory is available

It may also return a `VSlim\App` instance directly. In that case, the worker will:

- dispatch through `VSlimPsr7Adapter::dispatch(...)` when a PSR-7 request is available
- otherwise hydrate a `VSlim\Request` from the envelope and call `VSlim\App->dispatch_request(...)`

### Simplest `vslim` app

```php
<?php
declare(strict_types=1);

require_once __DIR__ . '/vslim_psr7_adapter.php';

return static function (mixed $request, array $envelope = []): VSlim\Response|array {
    $app = VSlim\App::demo();

    if (is_object($request)) {
        return VSlimPsr7Adapter::dispatch($app, $request);
    }

    if (is_array($request)) {
        return vslim_handle_request($request);
    }

    return [
        'status' => 500,
        'content_type' => 'text/plain; charset=utf-8',
        'body' => 'No request payload available',
    ];
};
```

### Returning a `VSlim\App` directly

```php
<?php
declare(strict_types=1);

$app = new VSlim\App();

$app->get('/hello/:name', function (VSlim\Request $req) {
    return new VSlim\Response(
        200,
        'Hello, ' . $req->param('name'),
        'text/plain; charset=utf-8'
    );
});

return $app;
```

This is the recommended first-release shape:

- `vhttpd` stays close to `veb`
- `php-worker.php` loads your bootstrap
- your bootstrap returns a `VSlim\App`
- `VSlim\App` owns runtime routing and hooks

### Lifecycle semantics

When your bootstrap returns a `VSlim\App`, request flow is:

```text
before hooks -> route handler -> after hooks
```

Return contract:

- `before()` returns `null`
  - continue dispatch
- `before()` returns `VSlim\Response` / `array` / `string`
  - short-circuit route dispatch
  - still flows into `after()`
- `after()` returns `null`
  - keep current response
- `after()` returns `VSlim\Response` / `array` / `string`
  - replace current response
- `before()/route/after()` throws
  - the PHP exception is not swallowed
  - it bubbles to the worker boundary
- invalid return values
  - normalize to `500 Invalid route response`

Execution order:

```text
app before -> matching group before -> route -> app after -> matching group after
```

This ordering is covered by:

- [/Users/guweigang/Source/vphpext/vslim/tests/test_php_hook_order.phpt](/Users/guweigang/Source/vphpext/vslim/tests/test_php_hook_order.phpt)

### Minimal custom app

```php
<?php
declare(strict_types=1);

$app = new VSlim\App();

$app->before(function (VSlim\Request $req) {
    if ($req->path === '/blocked') {
        return new VSlim\Response(403, 'blocked', 'text/plain; charset=utf-8');
    }
    return null;
});

$app->get('/hello/:name', function (VSlim\Request $req) {
    return new VSlim\Response(
        200,
        'Hello, ' . $req->param('name'),
        'text/plain; charset=utf-8'
    );
});

$app->after(function (VSlim\Request $req, VSlim\Response $res) {
    $res->set_header('x-runtime', 'vslim');
    return $res;
});

return $app;
```

There is also a ready-to-run example at:

- [/Users/guweigang/Source/vphpext/vslim/examples/hello-app.php](/Users/guweigang/Source/vphpext/vslim/examples/hello-app.php)

You can point the worker at it with:

```bash
export VSLIM_HTTPD_APP=/Users/guweigang/Source/vphpext/vslim/examples/hello-app.php
```

This example also demonstrates:

- named routes
- `url_for(...)`
- `redirect_to(...)`
- app-level `before()` / `after()`

### Returning a PSR-7-style response object

If your callable returns an object with:

- `getStatusCode()`
- `getHeaders()`
- `getBody()`

the worker will normalize it back into the transport envelope.

This means you can place a PSR-7-oriented app behind `vhttpd` without changing `vhttpd` itself.

### Returning an array directly

You can also skip response objects and return:

```php
[
    'status' => 200,
    'content_type' => 'application/json; charset=utf-8',
    'headers' => ['x-demo' => 'yes'],
    'body' => '{"ok":true}',
]
```

or just return a plain string:

```php
return 'hello from php-worker';
```

The worker will normalize these into the same wire format used by `vhttpd`.
