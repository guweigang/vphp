--TEST--
VSlimApp can register PHP route handlers and dispatch them
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlimApp();
$app->get('/hello/:name', function (VSlimRequest $req) {
    return new VSlimResponse(200, 'Hello, ' . $req->param('name'), 'text/plain; charset=utf-8');
});
$app->post('/submit', function (VSlimRequest $req) {
    return [
        'status' => 201,
        'content_type' => 'application/json; charset=utf-8',
        'headers' => ['x-mode' => 'builder'],
        'body' => json_encode(['body' => $req->body, 'trace' => $req->query('trace_id') ?: 'none']),
    ];
});

echo $app->dispatch('GET', '/hello/codex')->body . PHP_EOL;
$req = new VSlimRequest('POST', '/submit?trace_id=builder', 'payload');
$res = $app->dispatch_request($req);
echo $res->status . '|' . $res->body . '|' . $res->header('x-mode') . PHP_EOL;
?>
--EXPECT--
Hello, codex
201|{"body":"payload","trace":"builder"}|builder
