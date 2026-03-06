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

$mgr = new VHttpd\VHttpdManager(
    '/path/to/vhttpd',
    '127.0.0.1',
    19881,
    '/tmp/vhttpd.pid',
    '/tmp/vhttpd.events.ndjson',
    '/tmp/vhttpd.stdout.log'
);
```

## Publish workflow (subtree split)

```bash
cd /Users/guweigang/Source/vphpext

git subtree split --prefix=vslim/httpd/php-package -b release/vhttpd-php
# push this branch to a dedicated repo, then connect that repo in Packagist
```
