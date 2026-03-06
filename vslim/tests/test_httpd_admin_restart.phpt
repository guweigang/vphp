--TEST--
vhttpd admin supports single and all worker restart operations
--SKIPIF--
<?php
if (!extension_loaded("vslim")) print "skip";
if (getenv("CODEX_SANDBOX_NETWORK_DISABLED") === "1") print "skip";
$probe = sys_get_temp_dir() . '/vhttpd_unix_probe_' . getmypid() . '.sock';
@unlink($probe);
$errno = 0;
$errstr = '';
$server = @stream_socket_server('unix://' . $probe, $errno, $errstr);
if (!is_resource($server)) {
    print 'skip';
}
if (is_resource($server)) {
    fclose($server);
}
if (is_file($probe)) {
    @unlink($probe);
}
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

$dataPort = 19800 + random_int(0, 50);
$adminPort = $dataPort + 200;
$tmp = sys_get_temp_dir() . '/vhttpd_admin_restart_' . getmypid() . '_' . $dataPort;
@mkdir($tmp, 0777, true);

$pidFile = $tmp . '/vhttpd.pid';
$eventLog = $tmp . '/events.ndjson';
$stdoutLog = $tmp . '/stdout.log';
$socketPrefix = $tmp . '/worker';
$workerPhp = $root . '/httpd/php-worker.php';
$extSo = $root . '/vslim.so';
$app = $root . '/examples/hello-app.php';
$token = 'admin-token';

$workerCmd = sprintf(
    'VSLIM_HTTPD_APP=%s php -d extension=%s %s --socket {socket}',
    escapeshellarg($app),
    escapeshellarg($extSo),
    escapeshellarg($workerPhp),
);

$cmd = sprintf(
    '%s --host 127.0.0.1 --port %d --pid-file %s --event-log %s --admin-host 127.0.0.1 --admin-port %d --admin-token %s --worker-autostart 1 --worker-pool-size 2 --worker-socket-prefix %s --worker-cmd %s >> %s 2>&1 &',
    escapeshellarg($bin),
    $dataPort,
    escapeshellarg($pidFile),
    escapeshellarg($eventLog),
    $adminPort,
    escapeshellarg($token),
    escapeshellarg($socketPrefix),
    escapeshellarg($workerCmd),
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

$ctxToken = stream_context_create([
    'http' => [
        'method' => 'POST',
        'timeout' => 2.0,
        'ignore_errors' => true,
        'header' => "x-vhttpd-admin-token: {$token}\r\n",
    ],
]);

$singleRaw = @file_get_contents('http://127.0.0.1:' . $adminPort . '/admin/workers/restart?id=0', false, $ctxToken);
$single = is_string($singleRaw) ? json_decode($singleRaw, true) : null;
$singleOk = is_array($single)
    && ($single['ok'] ?? false) === true
    && ($single['mode'] ?? '') === 'single'
    && is_array($single['worker'] ?? null);
echo $singleOk ? "single_ok\n" : "single_bad\n";

$allRaw = @file_get_contents('http://127.0.0.1:' . $adminPort . '/admin/workers/restart/all', false, $ctxToken);
$all = is_string($allRaw) ? json_decode($allRaw, true) : null;
$allOk = is_array($all)
    && ($all['ok'] ?? false) === true
    && ($all['mode'] ?? '') === 'all'
    && ((int) ($all['restarted'] ?? 0)) >= 2;
echo $allOk ? "all_ok\n" : "all_bad\n";

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
single_ok
all_ok
stopped
