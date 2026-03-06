--TEST--
vhttpd exposes request_id header and SSE stream endpoint
--SKIPIF--
<?php
if (!extension_loaded("vslim")) print "skip";
if (getenv("CODEX_SANDBOX_NETWORK_DISABLED") === "1") print "skip";
?>
--FILE--
<?php
$root = dirname(__DIR__);
$src = $root . '/../vhttpd/src';
$bin = $root . '/../vhttpd/vhttpd';
$autoload = $root . '/vendor/autoload.php';

$out = [];
$code = 0;
exec('v -o ' . escapeshellarg($bin) . ' ' . escapeshellarg($src) . ' 2>&1', $out, $code);
if ($code !== 0) {
    echo "build_failed\n";
    echo implode("\n", $out) . "\n";
    exit;
}

if (!is_file($autoload)) {
    echo "autoload_missing\n";
    exit;
}
require_once $autoload;

$port = 19590 + random_int(0, 200);
$tmp = sys_get_temp_dir() . '/vhttpd_sse_' . getmypid() . '_' . $port;
@mkdir($tmp, 0777, true);

$pidFile = $tmp . '/vhttpd.pid';
$eventLog = $tmp . '/events.ndjson';
$stdoutLog = $tmp . '/stdout.log';

$mgr = new VHttpdManager($bin, '127.0.0.1', $port, $pidFile, $eventLog, $stdoutLog);
$mgr->start();
register_shutdown_function(function () use ($mgr) { $mgr->stop(); });

$ready = $mgr->waitUntilReady(6.0);
echo $ready ? "ready\n" : "not_ready\n";
if (!$ready) {
    exit;
}

$ctx = stream_context_create([
    'http' => [
        'timeout' => 2.0,
        'ignore_errors' => true,
        'header' => "X-Request-Id: req-from-header\r\n",
    ],
]);
$body = @file_get_contents(
    $mgr->baseUrl() . '/events/stream?count=2&interval_ms=0&request_id=req-from-query',
    false,
    $ctx
);
$headers = $http_response_header ?? [];

$statusLine = $headers[0] ?? '';
preg_match('/\s(\d{3})\s/', $statusLine, $m);
echo ($m[1] ?? '000') . "\n";

$requestId = '';
$contentType = '';
foreach ($headers as $h) {
    $line = strtolower((string) $h);
    if (str_starts_with($line, 'x-request-id:')) {
        $requestId = trim(substr($h, strlen('x-request-id:')));
    }
    if (str_starts_with($line, 'content-type:')) {
        $contentType = trim(substr($h, strlen('content-type:')));
    }
}
echo $requestId . "\n";
echo (str_starts_with(strtolower($contentType), 'text/event-stream') ? 'text/event-stream' : 'not-sse') . "\n";

$ok = is_string($body)
    && str_contains($body, 'event: ping')
    && str_contains($body, "id: req-from-query-1")
    && str_contains($body, '"request_id":"req-from-query"');
echo $ok ? "sse_ok\n" : "sse_bad\n";

usleep(150000);
$events = $mgr->events(200);
$seen = false;
foreach ($events as $event) {
    if (($event['type'] ?? '') !== 'http.request') {
        continue;
    }
    if (($event['path'] ?? '') !== '/events/stream') {
        continue;
    }
    if (($event['request_id'] ?? '') === 'req-from-query') {
        $seen = true;
        break;
    }
}
echo $seen ? "event_ok\n" : "event_missing\n";

$mgr->stop();
usleep(200000);
echo $mgr->status() ? "still_running\n" : "stopped\n";
?>
--EXPECT--
ready
200
req-from-query
text/event-stream
sse_ok
event_ok
stopped
