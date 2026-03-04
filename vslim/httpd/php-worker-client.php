<?php

declare(strict_types=1);

/**
 * Example client for php-worker.php
 *
 * Usage:
 *   php httpd/php-worker-client.php --socket /tmp/vphp_worker.sock --method GET --path /health
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

function writeFrame($conn, string $payload): void
{
    fwrite($conn, pack('N', strlen($payload)) . $payload);
}

function readExactly($conn, int $len): ?string
{
    $buf = '';
    while (strlen($buf) < $len) {
        $chunk = fread($conn, $len - strlen($buf));
        if ($chunk === '' || $chunk === false) {
            return null;
        }
        $buf .= $chunk;
    }
    return $buf;
}

function readFrame($conn): ?string
{
    $header = readExactly($conn, 4);
    if ($header === null) {
        return null;
    }
    $len = unpack('Nlen', $header);
    $size = (int)($len['len'] ?? 0);
    if ($size <= 0) {
        return null;
    }
    return readExactly($conn, $size);
}

$argv = $_SERVER['argv'] ?? [];
$socket = arg($argv, '--socket', '/tmp/vphp_worker.sock');
$method = strtoupper(arg($argv, '--method', 'GET'));
$path = arg($argv, '--path', '/health');
$body = arg($argv, '--body', '');

$uri = 'unix://' . $socket;
$errno = 0;
$errstr = '';
$conn = @stream_socket_client($uri, $errno, $errstr, 2.0);
if (!is_resource($conn)) {
    fwrite(STDERR, "connect_failed: {$errstr} ({$errno})\n");
    exit(1);
}

$req = [
    'id' => 'cli-1',
    'method' => $method,
    'path' => $path,
    'query' => [],
    'headers' => [],
    'body' => $body,
];

writeFrame($conn, json_encode($req, JSON_UNESCAPED_UNICODE));
$resp = readFrame($conn);
fclose($conn);

if ($resp === null) {
    fwrite(STDERR, "empty_response\n");
    exit(2);
}

echo $resp . PHP_EOL;

