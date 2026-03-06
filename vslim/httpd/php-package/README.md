# vhttpd PHP Package

Composer package root for publishing to Packagist.

## Install

```bash
composer require vphpext/vhttpd-php
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

Compatibility aliases are provided for legacy names:

- `VHttpd\\VHttpdManager`, `VHttpdManager`
- `VHttpd\\VHttpdPsr7Bridge`, `VHttpdPsr7Bridge`
- `VHttpd\\VSlimPsr7Adapter`, `VSlimPsr7Adapter`

## Publish workflow (subtree split)

```bash
cd /Users/guweigang/Source/vphpext

git subtree split --prefix=vslim/httpd/php-package -b release/vhttpd-php
# push this branch to a dedicated repo, then connect that repo in Packagist
```
