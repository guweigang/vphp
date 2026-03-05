--TEST--
vhttpd worker supports streaming responses for SSE and text modes
--SKIPIF--
<?php
if (!extension_loaded("vslim")) print "skip";
if (getenv("CODEX_SANDBOX_NETWORK_DISABLED") === "1") print "skip";
?>
--FILE--
<?php
$root = dirname(__DIR__);
$src = $root . '/httpd/main.v';
$bin = $root . '/httpd/vhttpd';

$out = [];
$code = 0;
exec('v -o ' . escapeshellarg($bin) . ' ' . escapeshellarg($src) . ' 2>&1', $out, $code);
if ($code !== 0) {
    echo "build_failed\n";
    echo implode("\n", $out) . "\n";
    exit;
}

$port = 19620 + random_int(0, 200);
$tmp = sys_get_temp_dir() . '/vhttpd_stream_' . getmypid() . '_' . $port;
@mkdir($tmp, 0777, true);

$pidFile = $tmp . '/vhttpd.pid';
$eventLog = $tmp . '/events.ndjson';
$stdoutLog = $tmp . '/stdout.log';
$workerSock = $tmp . '/worker.sock';
$workerPhp = $root . '/httpd/php-worker.php';
$extSo = $root . '/vslim.so';
$streamApp = $root . '/tests/fixtures/streaming_app_fixture.php';

$workerCmd = sprintf(
    'VSLIM_HTTPD_APP=%s php -d extension=%s %s --socket %s',
    escapeshellarg($streamApp),
    escapeshellarg($extSo),
    escapeshellarg($workerPhp),
    escapeshellarg($workerSock),
);

$cmd = sprintf(
    '%s --host %s --port %d --pid-file %s --event-log %s --worker-socket %s --worker-autostart 1 --worker-read-timeout-ms 2000 --worker-cmd %s >> %s 2>&1 &',
    escapeshellarg($bin),
    escapeshellarg('127.0.0.1'),
    $port,
    escapeshellarg($pidFile),
    escapeshellarg($eventLog),
    escapeshellarg($workerSock),
    escapeshellarg($workerCmd),
    escapeshellarg($stdoutLog),
);
exec($cmd);

$base = 'http://127.0.0.1:' . $port;
$ready = false;
$deadline = microtime(true) + 8.0;
while (microtime(true) < $deadline) {
    $ctx = stream_context_create(['http' => ['timeout' => 0.2]]);
    $health = @file_get_contents($base . '/health', false, $ctx);
    if ($health !== false && trim($health) === 'OK') {
        $ready = true;
        break;
    }
    usleep(100_000);
}
echo $ready ? "ready\n" : "not_ready\n";
if (!$ready) {
    exit;
}

$sseCtx = stream_context_create([
    'http' => [
        'timeout' => 3.0,
        'ignore_errors' => true,
        'header' => "X-Request-Id: sse-rid-7\r\n",
    ],
]);
$sseBody = @file_get_contents($base . '/stream/sse', false, $sseCtx);
$sseHeaders = $http_response_header ?? [];
$sseStatus = $sseHeaders[0] ?? '';
echo (str_contains($sseStatus, '200') ? "sse_200\n" : "sse_bad\n");
echo (is_string($sseBody) && str_contains($sseBody, 'event: ping') ? "sse_event\n" : "sse_no_event\n");
echo (is_string($sseBody) && str_contains($sseBody, '"request_id":"sse-rid-7"') ? "sse_rid\n" : "sse_no_rid\n");

$txtCtx = stream_context_create([
    'http' => [
        'timeout' => 3.0,
        'ignore_errors' => true,
    ],
]);
$txtBody = @file_get_contents($base . '/stream/text', false, $txtCtx);
$txtHeaders = $http_response_header ?? [];
$txtStatus = $txtHeaders[0] ?? '';
echo (str_contains($txtStatus, '200') ? "txt_200\n" : "txt_bad\n");
echo (trim((string) $txtBody) === "chunk-a\nchunk-b" ? "txt_ok\n" : "txt_bad_body\n");

$pid = is_file($pidFile) ? (int) trim((string) file_get_contents($pidFile)) : 0;
if ($pid > 0) {
    exec(sprintf('kill %d >/dev/null 2>&1', $pid));
    usleep(200_000);
    exec(sprintf('kill -0 %d >/dev/null 2>&1', $pid), $noop, $alive);
    echo $alive === 0 ? "still_running\n" : "stopped\n";
} else {
    echo "stopped\n";
}
?>
--EXPECT--
ready
sse_200
sse_event
sse_rid
txt_200
txt_ok
stopped

