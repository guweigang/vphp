--TEST--
php-worker maps TypeError to app_contract_error and exposes exception class header
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
define('VSLIM_HTTPD_WORKER_NOAUTO', true);
require __DIR__ . '/../httpd/php-worker.php';

putenv('VSLIM_HTTPD_APP=' . __DIR__ . '/fixtures/type_error_app_fixture.php');
$worker = new PhpWorker('/tmp/vslim_worker_test.sock');
$res = $worker->dispatchRequest([
    'id' => 'req-type-error',
    'method' => 'GET',
    'path' => '/type-error',
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
echo $res['status'] . '|' . $res['headers']['x-worker-error-class'] . '|' . $res['headers']['x-worker-exception'] . PHP_EOL;
?>
--EXPECT--
500|app_contract_error|TypeError
