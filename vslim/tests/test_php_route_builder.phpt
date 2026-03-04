--TEST--
VSlimApp can register PHP route handlers and dispatch them
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlimApp();
$app->middleware(function (VSlimRequest $req) {
    if ($req->path === '/blocked') {
        return new VSlimResponse(403, 'blocked', 'text/plain; charset=utf-8');
    }
    return null;
});
$app->middleware(function (VSlimRequest $req) {
    if ($req->path === '/submit' && $req->query('trace_id') === 'mw') {
        return [
            'status' => 202,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'middleware:' . $req->body,
        ];
    }
    return null;
});
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
$api = $app->group('/api');
$api->get('/users/:id', function (VSlimRequest $req) {
    return 'user:' . $req->param('id');
});
$api->group('/v1')->get('/ping', function (VSlimRequest $req) {
    return [
        'status' => 200,
        'content_type' => 'application/json; charset=utf-8',
        'body' => json_encode(['pong' => true, 'path' => $req->path]),
    ];
});

echo $app->dispatch('GET', '/hello/codex')->body . PHP_EOL;
$req = new VSlimRequest('POST', '/submit?trace_id=builder', 'payload');
$res = $app->dispatch_request($req);
echo $res->status . '|' . $res->body . '|' . $res->header('x-mode') . PHP_EOL;
echo $app->dispatch('GET', '/api/users/9')->body . PHP_EOL;
echo $app->dispatch('GET', '/api/v1/ping')->body . PHP_EOL;
echo $app->dispatch('GET', '/blocked')->status . '|' . $app->dispatch('GET', '/blocked')->body . PHP_EOL;
echo $app->dispatch('POST', '/submit?trace_id=mw')->status . '|' . $app->dispatch('POST', '/submit?trace_id=mw')->body . PHP_EOL;
?>
--EXPECT--
Hello, codex
201|{"body":"payload","trace":"builder"}|builder
user:9
{"pong":true,"path":"\/api\/v1\/ping"}
403|blocked
202|middleware:
