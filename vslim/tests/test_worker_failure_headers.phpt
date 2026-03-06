--TEST--
php-worker failure responses include stable error class headers
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
define('VSLIM_HTTPD_WORKER_NOAUTO', true);
$autoload = dirname(__DIR__) . '/vendor/autoload.php';
if (!is_file($autoload)) { echo "autoload_missing\n"; exit; }
require_once $autoload;

putenv('VSLIM_HTTPD_APP=' . __DIR__ . '/fixtures/throwing_app_fixture.php');
$worker = new \VHttpd\PhpWorker\Server('/tmp/vslim_worker_test.sock');
$panic = $worker->dispatchRequest([
    'id' => 'req-panic',
    'method' => 'GET',
    'path' => '/any',
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
echo $panic['status'] . '|' . $panic['headers']['x-worker-error-class'] . PHP_EOL;

putenv('VSLIM_HTTPD_APP=' . __DIR__ . '/fixtures/invalid_app_fixture.php');
$worker2 = new \VHttpd\PhpWorker\Server('/tmp/vslim_worker_test.sock');
$bad = $worker2->dispatchRequest([
    'id' => 'req-contract',
    'method' => 'GET',
    'path' => '/anything',
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
echo $bad['status'] . '|' . $bad['headers']['x-worker-error-class'] . PHP_EOL;
?>
--EXPECT--
500|worker_runtime_error
500|app_contract_error
