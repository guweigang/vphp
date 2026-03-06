--TEST--
ai stream demo app returns stable text and sse stream contracts
--FILE--
<?php
declare(strict_types=1);

define('VSLIM_HTTPD_WORKER_NOAUTO', true);
$autoload = dirname(__DIR__) . '/vendor/autoload.php';
if (!is_file($autoload)) { echo "autoload_missing\n"; exit; }
require_once $autoload;

$app = require __DIR__ . '/../../vhttpd/examples/ai-stream-app.php';

$text = $app([
    'method' => 'GET',
    'path' => '/ai/stream?prompt=demo',
    'query' => ['prompt' => 'demo'],
]);
echo ($text instanceof \VHttpd\PhpWorker\StreamResponse ? "text_stream\n" : "text_not_stream\n");
echo $text->streamType . "\n";
echo implode('', iterator_to_array($text->chunks, false));

$sse = $app([
    'method' => 'GET',
    'path' => '/ai/sse?prompt=demo',
    'query' => ['prompt' => 'demo'],
]);
echo ($sse instanceof \VHttpd\PhpWorker\StreamResponse ? "sse_stream\n" : "sse_not_stream\n");
echo $sse->streamType . "\n";
$events = iterator_to_array($sse->chunks, false);
echo ($events[0]['event'] ?? '') . '|' . ($events[0]['data'] ?? '') . "\n";
echo ($events[4]['event'] ?? '') . '|' . ($events[4]['data'] ?? '') . "\n";

$notFound = $app([
    'method' => 'GET',
    'path' => '/missing',
    'query' => [],
]);
echo $notFound['status'] . "\n";
?>
--EXPECT--
text_stream
text
AI token stream for: demo
sse_stream
sse
token|AI
token|demo
404
