--TEST--
HTTPD CLI Tool + PHP Userland Scheduler
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

$port = 19180 + random_int(0, 300);
$tmp = sys_get_temp_dir() . '/vhttpd_' . getmypid() . '_' . $port;
@mkdir($tmp, 0777, true);

$pidFile = $tmp . '/vhttpd.pid';
$eventLog = $tmp . '/events.ndjson';
$stdoutLog = $tmp . '/stdout.log';

$mgr = new VHttpdManager($bin, '127.0.0.1', $port, $pidFile, $eventLog, $stdoutLog);
$mgr->start();

register_shutdown_function(function () use ($mgr) {
    $mgr->stop();
});

$ready = $mgr->waitUntilReady(6.0);
echo $ready ? "ready\n" : "not_ready\n";
if (!$ready) {
    exit;
}

$health = @file_get_contents($mgr->baseUrl() . '/health');
echo trim((string) $health) . "\n";

$dispatch = @file_get_contents($mgr->baseUrl() . '/dispatch?method=GET&path=/users/7');
echo trim((string) $dispatch) . "\n";

$events = $mgr->events(200);
$types = [];
foreach ($events as $e) {
    if (isset($e['type']) && is_string($e['type'])) {
        $types[] = $e['type'];
    }
}

echo in_array('server.started', $types, true) ? "started_event\n" : "no_started_event\n";
echo in_array('http.request', $types, true) ? "request_event\n" : "no_request_event\n";

$mgr->stop();
usleep(200000);
echo $mgr->status() ? "still_running\n" : "stopped\n";
?>
--EXPECT--
ready
OK
{"user":"7"}
started_event
request_event
stopped
