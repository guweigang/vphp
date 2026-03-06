<?php

declare(strict_types=1);

require_once __DIR__ . '/php-package/src/Psr7Bridge.php';
require_once __DIR__ . '/php-package/src/SlimPsr7Adapter.php';
require_once __DIR__ . '/php-package/src/PhpWorker/StreamResponse.php';
require_once __DIR__ . '/php-package/src/PhpWorker/Server.php';
require_once __DIR__ . '/php-package/src/legacy_aliases.php';

if (!function_exists('vhttpd_stream_sse')) {
    function vhttpd_stream_sse(
        iterable $events,
        int $status = 200,
        array $headers = [],
    ): \VHttpd\PhpWorker\StreamResponse {
        return \VHttpd\PhpWorker\StreamResponse::sse($events, $status, $headers);
    }
}

if (!function_exists('vhttpd_stream_text')) {
    function vhttpd_stream_text(
        iterable $chunks,
        int $status = 200,
        string $contentType = 'text/plain; charset=utf-8',
        array $headers = [],
    ): \VHttpd\PhpWorker\StreamResponse {
        return \VHttpd\PhpWorker\StreamResponse::text($chunks, $status, $contentType, $headers);
    }
}

$argv = $_SERVER['argv'] ?? [];
$socket = \VHttpd\PhpWorker\parseSocketFromArgv($argv);
$worker = new \VHttpd\PhpWorker\Server($socket);
$worker->run();
