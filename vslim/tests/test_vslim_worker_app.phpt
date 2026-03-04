--TEST--
VHTTPD worker dispatches directly through a VSlimApp bootstrap
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
putenv('VSLIM_HTTPD_APP=' . __DIR__ . '/fixtures/vslim_builder_app_fixture.php');
define('VSLIM_HTTPD_WORKER_NOAUTO', true);
require __DIR__ . '/../httpd/php-worker.php';

$worker = new PhpWorker('/tmp/vslim_worker_test.sock');

$res = $worker->dispatchRequest([
    'id' => 'req-a',
    'method' => 'GET',
    'path' => '/hello/codex',
    'query' => [],
    'headers' => [],
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
echo $res['status'] . '|' . $res['content_type'] . '|' . $res['headers']['x-app'] . '|' . $res['body'] . PHP_EOL;

$res = $worker->dispatchRequest([
    'id' => 'req-b',
    'method' => 'POST',
    'path' => '/submit?trace_id=worker-app',
    'query' => ['trace_id' => 'worker-app'],
    'headers' => ['content-type' => 'application/json'],
    'cookies' => [],
    'attributes' => [],
    'body' => 'payload',
    'scheme' => 'https',
    'host' => 'demo.local',
    'port' => '443',
    'protocol_version' => '2',
    'remote_addr' => '127.0.0.1',
    'server' => [],
    'uploaded_files' => [],
]);
echo $res['id'] . PHP_EOL;
echo $res['status'] . '|' . $res['content_type'] . '|' . $res['headers']['x-app'] . '|' . $res['body'] . PHP_EOL;
?>
--EXPECT--
req-a
200|text/plain; charset=utf-8|builder-object|Hello, codex
req-b
202|application/json; charset=utf-8|builder-object|{"body":"payload","trace":"worker-app"}
