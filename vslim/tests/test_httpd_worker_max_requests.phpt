--TEST--
vhttpd restarts managed worker when worker-max-requests threshold is reached
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
$bin = $root . '/../vhttpd/vhttpd';

$out = [];
$code = 0;
exec('v -o ' . escapeshellarg($bin) . ' ' . escapeshellarg($src) . ' 2>&1', $out, $code);
if ($code !== 0) {
    echo "build_failed\n";
    echo implode("\n", $out) . "\n";
    exit;
}

$port = 19680 + random_int(0, 150);
$tmp = sys_get_temp_dir() . '/vhttpd_maxreq_' . getmypid() . '_' . $port;
@mkdir($tmp, 0777, true);

$pidFile = $tmp . '/vhttpd.pid';
$eventLog = $tmp . '/events.ndjson';
$stdoutLog = $tmp . '/stdout.log';
$workerSock = $tmp . '/worker.sock';
$workerPhp = $root . '/../vhttpd/php/php-worker.php';
$extSo = $root . '/vslim.so';
$app = $root . '/../vhttpd/examples/hello-app.php';

$workerCmd = sprintf(
    'VSLIM_HTTPD_APP=%s php -d extension=%s %s --socket %s',
    escapeshellarg($app),
    escapeshellarg($extSo),
    escapeshellarg($workerPhp),
    escapeshellarg($workerSock),
);

$cmd = sprintf(
    '%s --host %s --port %d --pid-file %s --event-log %s --worker-socket %s --worker-autostart 1 --worker-max-requests 1 --worker-cmd %s >> %s 2>&1 &',
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

@file_get_contents($base . '/hello/a');
@file_get_contents($base . '/hello/b');
usleep(250_000);

$lines = is_file($eventLog) ? file($eventLog, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) : [];
$hasThreshold = false;
$hasRestart = false;
foreach ($lines as $line) {
    $row = json_decode((string) $line, true);
    if (!is_array($row)) {
        continue;
    }
    if (($row['type'] ?? '') === 'worker.max_requests_reached') {
        $hasThreshold = true;
    }
    if (($row['type'] ?? '') === 'worker.restarted') {
        $hasRestart = true;
    }
}
echo $hasThreshold ? "threshold_ok\n" : "threshold_missing\n";
echo $hasRestart ? "restart_ok\n" : "restart_missing\n";

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
threshold_ok
restart_ok
stopped
