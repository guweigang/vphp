--TEST--
vhttpd passes [worker.env] from TOML into php-worker getenv
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

$port = 19890 + random_int(0, 60);
$tmp = sys_get_temp_dir() . '/vhttpd_toml_env_' . getmypid() . '_' . $port;
@mkdir($tmp, 0777, true);

$pidFile = $tmp . '/vhttpd.pid';
$eventLog = $tmp . '/events.ndjson';
$stdoutLog = $tmp . '/stdout.log';
$socket = $tmp . '/worker.sock';
$configPath = $tmp . '/vhttpd.toml';
$appPath = $tmp . '/app.php';

$appPhp = <<<'PHP'
<?php
return static function (array $envelope): array {
    $path = (string) ($envelope['path'] ?? '/');
    $base = (string) (parse_url($path, PHP_URL_PATH) ?? '/');
    if ($base !== '/env') {
        return ['status' => 404, 'content_type' => 'text/plain; charset=utf-8', 'body' => 'Not Found'];
    }
    return [
        'status' => 200,
        'content_type' => 'text/plain; charset=utf-8',
        'body' => (string) getenv('TEST_FLAG'),
    ];
};
PHP;
file_put_contents($appPath, $appPhp);

$toml = <<<TOML
[server]
host = "127.0.0.1"
port = {$port}

[files]
pid_file = "{$pidFile}"
event_log = "{$eventLog}"

[worker]
autostart = true
read_timeout_ms = 3000
socket = "{$socket}"
cmd = "php -d extension={$root}/vslim.so {$root}/httpd/php-worker.php --socket {$socket}"

[worker.env]
VSLIM_HTTPD_APP = "{$appPath}"
TEST_FLAG = "from_toml_env"
TOML;
file_put_contents($configPath, $toml);

$cmd = sprintf('%s --config %s >> %s 2>&1 &', escapeshellarg($bin), escapeshellarg($configPath), escapeshellarg($stdoutLog));
exec($cmd);

$ready = false;
$deadline = microtime(true) + 8.0;
while (microtime(true) < $deadline) {
    $ctx = stream_context_create(['http' => ['timeout' => 0.2]]);
    $health = @file_get_contents('http://127.0.0.1:' . $port . '/health', false, $ctx);
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

$body = @file_get_contents('http://127.0.0.1:' . $port . '/env');
echo trim((string) $body) . "\n";

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
from_toml_env
stopped
