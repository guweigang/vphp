--TEST--
vhttpd admin exposes runtime stats counters
--SKIPIF--
<?php
if (!extension_loaded("vslim")) print "skip";
if (getenv("CODEX_SANDBOX_NETWORK_DISABLED") === "1") print "skip";
?>
--FILE--
<?php
$root = dirname(__DIR__);
$src = $root . '/httpd';
$bin = $root . '/../vhttpd/vhttpd';

$out = [];
$code = 0;
exec('v -o ' . escapeshellarg($bin) . ' ' . escapeshellarg($src) . ' 2>&1', $out, $code);
if ($code !== 0) {
    echo "build_failed\n";
    echo implode("\n", $out) . "\n";
    exit;
}

$dataPort = 19830 + random_int(0, 50);
$adminPort = $dataPort + 200;
$tmp = sys_get_temp_dir() . '/vhttpd_admin_stats_' . getmypid() . '_' . $dataPort;
@mkdir($tmp, 0777, true);

$pidFile = $tmp . '/vhttpd.pid';
$eventLog = $tmp . '/events.ndjson';
$stdoutLog = $tmp . '/stdout.log';
$token = 'admin-token';

$cmd = sprintf(
    '%s --host 127.0.0.1 --port %d --pid-file %s --event-log %s --admin-host 127.0.0.1 --admin-port %d --admin-token %s >> %s 2>&1 &',
    escapeshellarg($bin),
    $dataPort,
    escapeshellarg($pidFile),
    escapeshellarg($eventLog),
    $adminPort,
    escapeshellarg($token),
    escapeshellarg($stdoutLog),
);
exec($cmd);

$ready = false;
$deadline = microtime(true) + 8.0;
while (microtime(true) < $deadline) {
    $ctx = stream_context_create(['http' => ['timeout' => 0.2]]);
    $health = @file_get_contents('http://127.0.0.1:' . $dataPort . '/health', false, $ctx);
    if ($health !== false && trim($health) === 'OK') {
        $ready = true;
        break;
    }
    usleep(100000);
}
echo $ready ? "ready\n" : "not_ready\n";
if (!$ready) {
    exit;
}

@file_get_contents('http://127.0.0.1:' . $dataPort . '/dispatch?method=GET&path=/users/1');
@file_get_contents('http://127.0.0.1:' . $dataPort . '/dispatch?method=GET&path=/panic');

$ctxToken = stream_context_create([
    'http' => [
        'timeout' => 1.0,
        'ignore_errors' => true,
        'header' => "x-vhttpd-admin-token: {$token}\r\n",
    ],
]);
$raw = @file_get_contents('http://127.0.0.1:' . $adminPort . '/admin/stats', false, $ctxToken);
$stats = is_string($raw) ? json_decode($raw, true) : null;
$ok = is_array($stats)
    && ((int) ($stats['http_requests_total'] ?? 0)) >= 2
    && ((int) ($stats['http_errors_total'] ?? 0)) >= 1
    && array_key_exists('http_streams_total', $stats)
    && array_key_exists('admin_actions_total', $stats);
echo $ok ? "stats_ok\n" : "stats_bad\n";

$pid = is_file($pidFile) ? (int) trim((string) file_get_contents($pidFile)) : 0;
if ($pid > 0) {
    exec(sprintf('kill %d >/dev/null 2>&1', $pid));
    usleep(200000);
    exec(sprintf('kill -0 %d >/dev/null 2>&1', $pid), $noop, $alive);
    echo $alive === 0 ? "still_running\n" : "stopped\n";
} else {
    echo "stopped\n";
}
?>
--EXPECT--
ready
stats_ok
stopped
