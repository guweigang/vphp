--TEST--
vhttpd event log includes duration_ms for http.request events
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

$port = 19580 + random_int(0, 200);
$tmp = sys_get_temp_dir() . '/vhttpd_obs_' . getmypid() . '_' . $port;
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

@file_get_contents($mgr->baseUrl() . '/dispatch?method=GET&path=/users/7');
usleep(150000);

$events = $mgr->events(200);
$hasDuration = false;
foreach ($events as $event) {
    if (($event['type'] ?? '') !== 'http.request') {
        continue;
    }
    if (($event['path'] ?? '') !== '/users/7') {
        continue;
    }
    if (isset($event['duration_ms']) && is_string($event['duration_ms']) && $event['duration_ms'] !== '') {
        $hasDuration = true;
        break;
    }
}
echo $hasDuration ? "duration_ok\n" : "duration_missing\n";

$mgr->stop();
usleep(200000);
echo $mgr->status() ? "still_running\n" : "stopped\n";
?>
--EXPECT--
ready
duration_ok
stopped
