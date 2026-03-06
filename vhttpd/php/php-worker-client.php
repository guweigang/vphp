<?php

declare(strict_types=1);

require_once __DIR__ . '/package/src/PhpWorker/Client.php';

/**
 * Example client for php-worker.php
 *
 * Usage:
 *   php php/php-worker-client.php --socket /tmp/vphp_worker.sock --method GET --path /health
 */

function arg(array $argv, string $key, string $default): string
{
    for ($i = 1; $i < count($argv); $i++) {
        if ($argv[$i] === $key && isset($argv[$i + 1])) {
            return (string)$argv[$i + 1];
        }
        if (str_starts_with((string)$argv[$i], $key . '=')) {
            return substr((string)$argv[$i], strlen($key) + 1);
        }
    }
    return $default;
}

$argv = $_SERVER['argv'] ?? [];
$socket = arg($argv, '--socket', '/tmp/vphp_worker.sock');
$method = strtoupper(arg($argv, '--method', 'GET'));
$path = arg($argv, '--path', '/health');
$body = arg($argv, '--body', '');

$req = [
    'id' => 'cli-1',
    'method' => $method,
    'path' => $path,
    'query' => [],
    'headers' => [],
    'body' => $body,
];
try {
    $client = new \VHttpd\PhpWorker\Client($socket);
    $resp = $client->request($req);
    echo json_encode($resp, JSON_UNESCAPED_UNICODE) . PHP_EOL;
} catch (Throwable $e) {
    fwrite(STDERR, $e->getMessage() . PHP_EOL);
    exit(1);
}
