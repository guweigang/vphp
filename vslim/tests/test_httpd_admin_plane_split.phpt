--TEST--
vhttpd splits data plane and admin plane ports with optional token auth
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

$dataPort = 19700 + random_int(0, 80);
$adminPort = $dataPort + 300;
$tmp = sys_get_temp_dir() . '/vhttpd_admin_split_' . getmypid() . '_' . $dataPort;
@mkdir($tmp, 0777, true);

$pidFile = $tmp . '/vhttpd.pid';
$eventLog = $tmp . '/events.ndjson';
$stdoutLog = $tmp . '/stdout.log';
$token = 'test-token';

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

$ctx = stream_context_create(['http' => ['timeout' => 1.0, 'ignore_errors' => true]]);
$dataRaw = @file_get_contents('http://127.0.0.1:' . $dataPort . '/admin/workers', false, $ctx);
$dataCode = 0;
if (isset($http_response_header[0]) && preg_match('/\s(\d{3})\s/', $http_response_header[0], $m) === 1) {
    $dataCode = (int) $m[1];
}
echo $dataCode === 404 ? "data_404\n" : "data_bad\n";

$adminNoToken = @file_get_contents('http://127.0.0.1:' . $adminPort . '/admin/workers', false, $ctx);
$adminCode = 0;
if (isset($http_response_header[0]) && preg_match('/\s(\d{3})\s/', $http_response_header[0], $m) === 1) {
    $adminCode = (int) $m[1];
}
echo $adminCode === 403 ? "admin_403\n" : "admin_bad\n";

$ctxToken = stream_context_create([
    'http' => [
        'timeout' => 1.0,
        'ignore_errors' => true,
        'header' => "x-vhttpd-admin-token: {$token}\r\n",
    ],
]);
$adminRaw = @file_get_contents('http://127.0.0.1:' . $adminPort . '/admin/workers', false, $ctxToken);
$adminOkCode = 0;
if (isset($http_response_header[0]) && preg_match('/\s(\d{3})\s/', $http_response_header[0], $m) === 1) {
    $adminOkCode = (int) $m[1];
}
$payload = is_string($adminRaw) ? json_decode($adminRaw, true) : null;
$ok = $adminOkCode === 200 && is_array($payload) && array_key_exists('workers', $payload);
echo $ok ? "admin_200\n" : "admin_parse_bad\n";

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
data_404
admin_403
admin_200
stopped
