--TEST--
VHTTPD worker preserves map envelope headers for request and trace ids
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
putenv('VSLIM_HTTPD_APP=' . __DIR__ . '/fixtures/vslim_envelope_map_fixture.php');
define('VSLIM_HTTPD_WORKER_NOAUTO', true);
$autoload = dirname(__DIR__) . '/vendor/autoload.php';
if (!is_file($autoload)) {
    $autoload = dirname(__DIR__) . '/examples/vendor/autoload.php';
}
if (!is_file($autoload)) { echo "autoload_missing\n"; exit; }
require_once $autoload;

$worker = new \VHttpd\PhpWorker\Server('/tmp/vslim_worker_test.sock');
$res = $worker->dispatchRequest([
    'id' => 'map-req-1',
    'method' => 'GET',
    'path' => '/hello/codex',
    'query' => [],
    'headers' => [
        'x-request-id' => 'rid-map-1',
        'x-trace-id' => 'trace-map-1',
    ],
    'cookies' => [],
    'attributes' => [],
    'body' => '',
    'scheme' => 'http',
    'host' => 'demo.local',
    'port' => '80',
    'protocol_version' => '1.1',
    'remote_addr' => '127.0.0.1',
    'server' => [],
    'uploaded_files' => [],
]);
echo $res['id'] . PHP_EOL;
echo $res['status'] . '|' . $res['content_type'] . '|' . $res['body'] . PHP_EOL;
echo $res['headers']['x-app'] . '|' . $res['headers']['x-request-id'] . '|' . $res['headers']['x-trace-id'] . '|' . $res['headers']['x-vhttpd-trace-id'] . PHP_EOL;
?>
--EXPECT--
map-req-1
200|text/plain; charset=utf-8|Hello, codex
map-fixture|rid-map-1|trace-map-1|trace-map-1
