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
- `VHttpd\\DbGateway\\PdoLikeClient` (experimental)
- `VHttpd\\DbGateway\\Statement` (experimental)

Composer bin entrypoints:

- `vendor/bin/php-worker`
- `vendor/bin/php-worker-client`

Compatibility aliases are provided for legacy names:

- `VHttpd\\VHttpdManager`, `VHttpdManager`
- `VHttpd\\VHttpdPsr7Bridge`, `VHttpdPsr7Bridge`
- `VHttpd\\VSlimPsr7Adapter`, `VSlimPsr7Adapter`
- `VHttpd\\PhpWorker\\PhpWorker`, `PhpWorker`
- `VHttpd\\PhpWorker\\WorkerStreamResponse`, `WorkerStreamResponse`

## Experimental DB gateway client

```php
<?php

declare(strict_types=1);

use VHttpd\DbGateway\PdoLikeClient;

$db = new PdoLikeClient('/tmp/vhttpd_db.sock');
$db->ping();

$stmt = $db->query('SELECT id, name FROM users WHERE id = ?', [123]);
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

## Publish workflow (subtree split)

```bash
cd /Users/guweigang/Source/vphpext

git subtree split --prefix=vhttpd/php/package -b release/vhttpd
# push this branch to a dedicated repo, then connect that repo in Packagist
```
