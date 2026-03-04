# VHTTPD (CLI + Userland Scheduler)

This is the **Scheme 2** prototype:

- HTTP server runs as a standalone V CLI process (`veb`).
- PHP Userland controls lifecycle and reads events.
- `vphp` stays generic; framework/server logic now lives with `vslim`.

## Build

```bash
cd vslim/httpd
v -o vhttpd main.v
```

## Run

```bash
./vhttpd --host 127.0.0.1 --port 18081 \
  --pid-file /tmp/vhttpd.pid \
  --event-log /tmp/vhttpd.events.ndjson
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

Endpoints:

- `GET /health` -> `OK`
- `GET /dispatch?method=GET&path=/users/42` -> `{"user":"42"}`
- `GET /dispatch?method=POST&path=/health` -> `405 Method Not Allowed`
- `GET /dispatch?method=GET&path=/panic` -> `500 Internal Server Error`

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

- `vhttpd` as the network/runtime layer
- `php-worker.php` as the PHP worker boundary
- `vslim` as the framework dispatch layer

## Optional PSR-7 bridge

`php-worker.php` now includes `psr7_bridge.php`.

If the runtime detects a supported PSR-17 style factory implementation, it can build a real
PSR-7-style server request from the request envelope before dispatching deeper into userland.

Current built-in factory detection covers:

- `Nyholm\\Psr7\\Factory\\Psr17Factory`
- `GuzzleHttp\\Psr7\\HttpFactory`

This keeps `vhttpd` transport-generic while letting the worker boundary move toward PSR-7.

If `php-worker.php` finds an app bootstrap file (`VSLIM_HTTPD_APP` or `httpd/app.php`), it will:

- load the returned callable
- build a PSR-7 request when a supported PSR-17 factory is available
- dispatch the request into that app callable
- normalize a PSR-7-style response back into the worker transport envelope

## VSlim adapter

`vslim_psr7_adapter.php` provides a small PHP-side bridge that can:

- convert a PSR-7 style request object into `VSlimRequest`
- dispatch that request through `VSlimApp`
- keep `vslim` native while letting `php-worker.php` speak PSR-7 at the edge

`app.php` uses this adapter by default when the worker receives a PSR-7 request object.
