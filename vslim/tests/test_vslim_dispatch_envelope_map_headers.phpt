--TEST--
VSlim dispatch_envelope_map returns propagated trace/request headers
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->get('/hello/:name', function (VSlim\Request $req) {
    return 'hello ' . $req->param('name');
});

$map = $app->dispatch_envelope_map([
    'method' => 'GET',
    'path' => '/hello/codex',
    'query' => [],
    'headers' => [
        'x-request-id' => 'rid-100',
        'x-trace-id' => 'trace-100',
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

echo $map['status'] . '|' . $map['body'] . '|' . $map['content_type'] . PHP_EOL;
echo $map['headers_x-request-id'] . '|' . $map['headers_x-trace-id'] . '|' . $map['headers_x-vhttpd-trace-id'] . PHP_EOL;
?>
--EXPECT--
200|hello codex|text/plain; charset=utf-8
rid-100|trace-100|trace-100
