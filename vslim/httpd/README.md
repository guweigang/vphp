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
