# vhttpd PHP Package

Composer package root for publishing to Packagist.

## Install

```bash
composer require vphpext/vhttpd
```

## Usage

```php
<?php

declare(strict_types=1);

require __DIR__ . '/vendor/autoload.php';

$mgr = new VHttpd\Manager(
    '/path/to/vhttpd',
    '127.0.0.1',
    19881,
    '/tmp/vhttpd.pid',
    '/tmp/vhttpd.events.ndjson',
    '/tmp/vhttpd.stdout.log'
);
```

Primary classes:

- `VHttpd\\Manager`
- `VHttpd\\Psr7Bridge`
- `VHttpd\\SlimPsr7Adapter`
- `VHttpd\\PhpWorker\\Server`
- `VHttpd\\PhpWorker\\Client`
- `VHttpd\\PhpWorker\\StreamResponse`
- `VHttpd\\DbGateway\\PDO` (experimental)
- `VHttpd\\DbGateway\\PDOStatement` (experimental)
- `VSlim\\Container` (PSR-11, provided by `vslim.so` when `psr` extension is enabled)
- `VSlim\\Container\\NotFoundException` (provided by `vslim.so`)
- `VSlim\\Container\\ContainerException` (provided by `vslim.so`)

Composer bin entrypoints:

- `vendor/bin/php-worker`
- `vendor/bin/php-worker-client`

Compatibility aliases are provided for legacy names:

- `VHttpd\\VHttpdManager`, `VHttpdManager`
- `VHttpd\\VHttpdPsr7Bridge`, `VHttpdPsr7Bridge`
- `VHttpd\\VSlimPsr7Adapter`, `VSlimPsr7Adapter`
- `VHttpd\\PhpWorker\\PhpWorker`, `PhpWorker`
- `VHttpd\\PhpWorker\\WorkerStreamResponse`, `WorkerStreamResponse`

## StreamResponse quick examples

`StreamResponse` is the common streaming contract for any PHP app behind `vhttpd`.

### Plain PHP handler

```php
<?php

declare(strict_types=1);

use VHttpd\PhpWorker\StreamResponse;

return function (array $envelope) {
    $prompt = (string)($envelope['query']['prompt'] ?? 'hello');
    $events = (function () use ($prompt) {
        foreach (preg_split('//u', $prompt, -1, PREG_SPLIT_NO_EMPTY) as $i => $token) {
            yield [
                'event' => 'token',
                'id' => 'tok-' . ($i + 1),
                'data' => $token,
            ];
        }
    })();
    return StreamResponse::sse($events);
};
```

### Laravel-style endpoint return

```php
<?php

declare(strict_types=1);

use Illuminate\Http\Request;
use VHttpd\PhpWorker\StreamResponse;

Route::get('/ai/stream', function (Request $request) {
    $prompt = (string)$request->query('prompt', 'hello');
    $chunks = (function () use ($prompt) {
        foreach (str_split($prompt) as $ch) {
            yield $ch;
        }
    })();
    return StreamResponse::text($chunks, 200, 'text/plain; charset=utf-8', [
        'content-type' => 'text/plain; charset=utf-8',
    ]);
});
```

## Experimental DB gateway client

```php
<?php

declare(strict_types=1);

use VHttpd\DbGateway\PDO;

$db = new PDO('/tmp/vhttpd_db.sock');
$db->ping();

$stmt = $db->prepare('SELECT id, name FROM users WHERE id = ?');
$stmt->execute([123]);
$row = $stmt->fetch();

$db->beginTransaction();
try {
    $db->execute('UPDATE accounts SET balance = balance - ? WHERE id = ?', [100, 1]);
    $db->execute('UPDATE accounts SET balance = balance + ? WHERE id = ?', [100, 2]);
    $db->commit();
} catch (Throwable $e) {
    $db->rollBack();
    throw $e;
}
```

## VSlim global container (PSR-11)

```php
<?php

declare(strict_types=1);

use VSlim\Container;

$container = new Container();
$container->set('app.name', 'vslim-demo');
$container->factory('clock', fn () => new DateTimeImmutable('now'));

Container::setGlobal($container);

$global = Container::requireGlobal();
echo $global->get('app.name') . PHP_EOL;
```

## Publish workflow (subtree split)

```bash
cd /Users/guweigang/Source/vphpext

git subtree split --prefix=vhttpd/php/package -b release/vhttpd
# push this branch to a dedicated repo, then connect that repo in Packagist
```
