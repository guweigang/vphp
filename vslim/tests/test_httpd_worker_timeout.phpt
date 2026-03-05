--TEST--
vhttpd returns 504 and timeout headers when worker read timeout is exceeded
--SKIPIF--
<?php
if (!extension_loaded("vslim")) print "skip";
if (getenv("CODEX_SANDBOX_NETWORK_DISABLED") === "1") print "skip";
?>
--FILE--
<?php
$root = dirname(__DIR__);
$src = $root . '/httpd';
$bin = $root . '/httpd/vhttpd';

$out = [];
$code = 0;
exec('v -o ' . escapeshellarg($bin) . ' ' . escapeshellarg($src) . ' 2>&1', $out, $code);
if ($code !== 0) {
    echo "build_failed\n";
    echo implode("\n", $out) . "\n";
    exit;
}

$port = 19480 + random_int(0, 300);
$tmp = sys_get_temp_dir() . '/vhttpd_timeout_' . getmypid() . '_' . $port;
@mkdir($tmp, 0777, true);

$pidFile = $tmp . '/vhttpd.pid';
$eventLog = $tmp . '/events.ndjson';
$stdoutLog = $tmp . '/stdout.log';
$workerSock = $tmp . '/worker.sock';
$workerPhp = $root . '/httpd/php-worker.php';
$extSo = $root . '/vslim.so';
$slowApp = $root . '/tests/fixtures/slow_app_fixture.php';

$workerCmd = sprintf(
    'VSLIM_HTTPD_APP=%s php -d extension=%s %s --socket %s',
    escapeshellarg($slowApp),
    escapeshellarg($extSo),
    escapeshellarg($workerPhp),
    escapeshellarg($workerSock),
);

$cmd = sprintf(
    '%s --host %s --port %d --pid-file %s --event-log %s --worker-socket %s --worker-autostart 1 --worker-read-timeout-ms 50 --worker-cmd %s >> %s 2>&1 &',
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

$ctx = stream_context_create(['http' => ['timeout' => 2.0, 'ignore_errors' => true]]);
@file_get_contents($base . '/slow?trace_id=t-out', false, $ctx);
$headers = $http_response_header ?? [];

$statusLine = $headers[0] ?? '';
preg_match('/\s(\d{3})\s/', $statusLine, $m);
echo ($m[1] ?? '000') . "\n";

$errClass = '';
$traceId = '';
foreach ($headers as $h) {
    $line = strtolower((string) $h);
    if (str_starts_with($line, 'x-vhttpd-error-class:')) {
        $errClass = trim(substr($h, strlen('x-vhttpd-error-class:')));
    }
    if (str_starts_with($line, 'x-vhttpd-trace-id:')) {
        $traceId = trim(substr($h, strlen('x-vhttpd-trace-id:')));
    }
}
echo $errClass . "\n";
echo ($traceId !== '' ? 'trace' : 'no-trace') . "\n";

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
504
timeout
trace
stopped
