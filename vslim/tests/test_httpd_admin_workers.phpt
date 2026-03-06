--TEST--
vhttpd exposes /admin/workers runtime status endpoint
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
$mgrFile = $root . '/httpd/manager.php';

$out = [];
$code = 0;
exec('v -o ' . escapeshellarg($bin) . ' ' . escapeshellarg($src) . ' 2>&1', $out, $code);
if ($code !== 0) {
    echo "build_failed\n";
    echo implode("\n", $out) . "\n";
    exit;
}

require $mgrFile;

$port = 19690 + random_int(0, 100);
$tmp = sys_get_temp_dir() . '/vhttpd_admin_' . getmypid() . '_' . $port;
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

$raw = @file_get_contents($mgr->baseUrl() . '/admin/workers');
$payload = is_string($raw) ? json_decode($raw, true) : null;

$ok = is_array($payload)
    && array_key_exists('worker_autostart', $payload)
    && array_key_exists('worker_pool_size', $payload)
    && array_key_exists('workers', $payload)
    && is_array($payload['workers']);

echo $ok ? "admin_ok\n" : "admin_bad\n";

$mgr->stop();
usleep(200000);
echo $mgr->status() ? "still_running\n" : "stopped\n";
?>
--EXPECT--
ready
admin_ok
stopped
