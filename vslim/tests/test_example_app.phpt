--TEST--
VSlim example app shows named routes and redirects
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
putenv('VSLIM_HTTPD_APP=' . dirname(__DIR__) . '/../vhttpd/examples/hello-app.php');
define('VSLIM_HTTPD_WORKER_NOAUTO', true);
$autoload = dirname(__DIR__) . '/vendor/autoload.php';
if (!is_file($autoload)) { echo "autoload_missing\n"; exit; }
require_once $autoload;

$worker = new \VHttpd\PhpWorker\Server('/tmp/vslim_worker_test.sock');

$hello = $worker->dispatchRequest([
    'id' => 'hello',
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
echo $hello['status'] . '|' . $hello['body'] . '|' . $hello['headers']['x-runtime'] . PHP_EOL;

$go = $worker->dispatchRequest([
    'id' => 'go',
    'method' => 'GET',
    'path' => '/go/nova',
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
echo $go['status'] . '|' . $go['headers']['location'] . '|' . $go['headers']['x-runtime'] . PHP_EOL;

$meta = $worker->dispatchRequest([
    'id' => 'meta',
    'method' => 'GET',
    'path' => '/api/meta',
    'query' => [],
    'headers' => [],
    'cookies' => [],
    'attributes' => [],
    'body' => '',
    'scheme' => 'https',
    'host' => 'demo.local',
    'port' => '443',
    'protocol_version' => '1.1',
    'remote_addr' => '127.0.0.1',
    'server' => [],
    'uploaded_files' => [],
]);
echo $meta['status'] . '|' . $meta['body'] . '|' . $meta['headers']['x-runtime'] . PHP_EOL;
?>
--EXPECT--
200|Hello, codex|vslim
302|/hello/nova|vslim
200|{"path":"\/api\/meta","secure":true,"host":"demo.local","hello_url":"\/hello\/codex"}|vslim
