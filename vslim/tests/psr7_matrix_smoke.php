<?php

declare(strict_types=1);

$autoload = getenv('MATRIX_AUTOLOAD');
$case = getenv('MATRIX_CASE') ?: '';

if (!is_string($autoload) || $autoload === '' || !is_file($autoload)) {
    fwrite(STDERR, "missing MATRIX_AUTOLOAD\n");
    exit(2);
}
if ($case === '') {
    fwrite(STDERR, "missing MATRIX_CASE\n");
    exit(2);
}

require_once $autoload;

$req = VHttpdPsr7Bridge::buildServerRequest([
    'method' => 'PATCH',
    'path' => '/matrix/check?trace_id=' . $case,
    'body' => '{"ok":true}',
    'scheme' => 'https',
    'host' => 'demo.local',
    'port' => '443',
    'protocol_version' => '2',
    'remote_addr' => '127.0.0.1',
    'headers' => ['content-type' => 'application/json', 'x-matrix' => $case],
    'cookies' => ['sid' => 'cookie-' . $case],
    'query' => ['trace_id' => $case],
    'attributes' => ['source' => 'matrix-' . $case],
    'server' => ['REQUEST_TIME_FLOAT' => '1.23'],
    'uploaded_files' => [],
]);

if (!is_object($req)) {
    fwrite(STDERR, "bridge returned null for case {$case}\n");
    exit(1);
}

$class = get_class($req);
$expectPrefix = match ($case) {
    'nyholm' => 'Nyholm\\Psr7\\',
    'guzzle' => 'GuzzleHttp\\Psr7\\',
    'laminas' => 'Laminas\\Diactoros\\',
    default => '',
};
if ($expectPrefix === '' || !str_starts_with($class, $expectPrefix)) {
    fwrite(STDERR, "unexpected request class {$class} for case {$case}\n");
    exit(1);
}

if (!method_exists($req, 'getMethod') || !method_exists($req, 'getUri') || !method_exists($req, 'getProtocolVersion')) {
    fwrite(STDERR, "request object missing PSR-7 methods for case {$case}\n");
    exit(1);
}

$method = (string) $req->getMethod();
$uri = (string) $req->getUri();
$protocolVersion = (string) $req->getProtocolVersion();
$trace = '';
$header = '';
$cookie = '';
$attr = '';

if (method_exists($req, 'getQueryParams')) {
    $query = (array) $req->getQueryParams();
    $trace = (string) ($query['trace_id'] ?? '');
}
if (method_exists($req, 'getHeaderLine')) {
    $header = (string) $req->getHeaderLine('x-matrix');
}
if (method_exists($req, 'getCookieParams')) {
    $cookies = (array) $req->getCookieParams();
    $cookie = (string) ($cookies['sid'] ?? '');
}
if (method_exists($req, 'getAttribute')) {
    $attr = (string) $req->getAttribute('source', '');
}

if ($method !== 'PATCH' || $protocolVersion !== '2' || !str_contains($uri, '/matrix/check?trace_id=' . $case)) {
    fwrite(STDERR, "basic request fields mismatch for case {$case}\n");
    exit(1);
}
if ($trace !== $case || $header !== $case || $cookie !== 'cookie-' . $case || $attr !== 'matrix-' . $case) {
    fwrite(STDERR, "request payload mapping mismatch for case {$case}\n");
    exit(1);
}

echo "case={$case}\n";
echo "class={$class}\n";
echo "ok\n";
